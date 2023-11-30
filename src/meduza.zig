const std = @import("std");

const MAX_NUM_ARGS: usize = 1 << 4;
const MAX_FILE_SIZE: u32 = 1 << 22;
const MAX_NUM_DECLS: usize = 1 << 8;
const MAX_NUM_FUNCS: usize = 1 << 8;
const MAX_NUM_TYPES: usize = 1 << 8;
const MAX_FILE_PATH_LEN: u16 = 1 << 6;

const SPACE = [1]u8{' '};
const INDENTATION_LEVEL_1 = SPACE ** 4;
const CHECK_INDENTATION_LEVEL_2 = SPACE ** 5;
const CHECK_INDENTATION_LEVEL_3 = SPACE ** 9;

const log = std.log.scoped(.meduza);

pub const Error = error{
    Overflow,
} || std.mem.Allocator.Error || std.fs.Dir.DeleteTreeError || std.fs.File.WriteError || std.fs.File.OpenError || std.fs.Dir.OpenError || std.os.PReadError || std.os.MakeDirError;

/// Output file extension
pub const Ext = enum {
    /// HTML
    html,
    /// Mermaid
    mmd,
    /// Markdown
    md,
};

/// Type declaration
const Type = struct {
    start: std.zig.Ast.ByteOffset,
    end: std.zig.Ast.ByteOffset,
    tag: Tag,

    const Tag = enum {
        /// Struct
        str,
        /// Opaque
        opa,
        /// Union
        uni,
        /// Error
        err,
        /// Enum
        enu,
    };
};

/// Function declaration
const Func = struct {
    args: std.BoundedArray(struct { start: std.zig.Ast.ByteOffset, end: std.zig.Ast.ByteOffset }, MAX_NUM_ARGS),
    rt_start: std.zig.Ast.ByteOffset,
    rt_end: std.zig.Ast.ByteOffset,
    is_pub: bool,

    fn print(self: Func, src: []const u8, writer: anytype) @TypeOf(writer).Error!void {
        try writer.writeAll(INDENTATION_LEVEL_1[0..]);

        const fn_proto_name = src[self.args.get(0).start..self.args.get(0).end];

        if (self.is_pub) {
            try writer.print("+{s}(", .{fn_proto_name});
        } else {
            try writer.print("-{s}(", .{fn_proto_name});
        }

        if (self.args.len > 1) {
            try writer.writeAll(src[self.args.get(1).start..self.args.get(1).end]);
        }

        if (self.args.len > 2) {
            for (self.args.constSlice()[2..]) |arg| {
                try writer.writeAll(", ");
                try writer.print("{s}", .{src[arg.start..arg.end]});
            }
        }

        try writer.print(") {s}\n", .{src[self.rt_start..self.rt_end]});
    }
};

/// Simple declaration
const Decl = struct {
    start: std.zig.Ast.ByteOffset,
    end: std.zig.Ast.ByteOffset,
    tag: Tag,

    const Tag = enum {
        /// Container field
        fld,
        /// Test function
        tst,
    };

    fn print(self: Decl, is_pub: bool, src: []const u8, writer: anytype) @TypeOf(writer).Error!void {
        try writer.writeAll(INDENTATION_LEVEL_1[0..]);

        switch (self.tag) {
            .fld => if (is_pub) {
                try writer.print("+{s}\n", .{src[self.start..self.end]});
            } else {
                try writer.print("-{s}\n", .{src[self.start..self.end]});
            },
            .tst => try writer.print("{s}()\n", .{src[self.start..self.end]}),
        }
    }
};

pub fn generate(
    allocator: std.mem.Allocator,
    remote_src_dir_path: []const u8,
    local_src_dir_path: []const u8,
    codebase_title: []const u8,
    out_dir_path: []const u8,
    extension: Ext,
    do_info_log: bool,
) Error!void {
    const cur_dir = std.fs.cwd();

    try cur_dir.makePath(out_dir_path);

    var src_dir = try cur_dir.openDir(local_src_dir_path, .{ .iterate = true });
    defer src_dir.close();

    var walker = try src_dir.walk(allocator);
    defer walker.deinit();

    var out_dir = try cur_dir.openDir(out_dir_path, .{});
    defer out_dir.close();

    var out_files = std.StringArrayHashMapUnmanaged(std.fs.File){};
    try out_files.ensureTotalCapacity(allocator, 2);
    defer out_files.deinit(allocator);

    var are_files_valid = std.StringArrayHashMapUnmanaged(bool){};
    try are_files_valid.ensureTotalCapacity(allocator, 2);
    defer are_files_valid.deinit(allocator);

    const local_src_dir_basename = std.fs.path.basename(local_src_dir_path);
    var out_file_basename: []u8 = @constCast(local_src_dir_basename);
    var out_file_name = try std.fmt.allocPrint(allocator, "{s}.{s}", .{ local_src_dir_basename, @tagName(extension) });
    var out_file = try out_dir.createFile(out_file_name, .{});
    var writer = out_file.writer();

    try out_files.putNoClobber(allocator, out_file_basename, out_file);
    try are_files_valid.putNoClobber(allocator, out_file_basename, false);

    try writePrologue(codebase_title, local_src_dir_path, extension, writer);

    while (try walker.next()) |entry| {
        switch (entry.kind) {
            .directory => {
                out_file_basename = try std.fmt.allocPrint(allocator, "{s}.{s}", .{ local_src_dir_basename, entry.path });
                for (out_file_basename[local_src_dir_basename.len + 1 ..]) |*byte| {
                    if (std.fs.path.isSep(byte.*)) {
                        byte.* = '.';
                    }
                }

                out_file_name = try std.fmt.allocPrint(allocator, "{s}.{s}", .{ out_file_basename, @tagName(extension) });
                out_file = try out_dir.createFile(out_file_name, .{});
                writer = out_file.writer();

                try out_files.putNoClobber(allocator, out_file_basename, out_file);
                try are_files_valid.putNoClobber(allocator, out_file_basename, false);

                try writePrologue(codebase_title, entry.path, extension, writer);

                continue;
            },
            .file => {
                // Parse only Zig source files
                if (std.mem.eql(u8, ".zig", std.fs.path.extension(entry.basename))) {
                    // Load the previously defined output file
                    if (std.fs.path.dirname(entry.path)) |file_dir_path| {
                        out_file_basename = try std.fmt.allocPrint(allocator, "{s}.{s}", .{ local_src_dir_basename, file_dir_path });
                        for (out_file_basename[local_src_dir_basename.len + 1 ..]) |*byte| {
                            if (std.fs.path.isSep(byte.*)) {
                                byte.* = '.';
                            }
                        }

                        out_file = out_files.get(out_file_basename).?;
                        writer = out_file.writer();
                    } else {
                        out_file_basename = @constCast(local_src_dir_basename);
                        out_file = out_files.get(local_src_dir_basename).?;
                        writer = out_file.writer();
                    }
                } else {
                    continue;
                }
            },
            else => continue,
        }

        var src_buf: [MAX_FILE_SIZE]u8 = undefined;
        var src = try src_dir.readFile(entry.path, src_buf[0..]);
        src_buf[src.len] = 0;

        var nested_type_decls = std.BoundedArray(Decl, MAX_NUM_DECLS){};
        var nested_type_funcs = std.BoundedArray(Func, MAX_NUM_FUNCS){};
        var nested_types = std.BoundedArray(Type, MAX_NUM_TYPES){};

        var top_type_decls = std.BoundedArray(Decl, MAX_NUM_DECLS){};
        var top_type_funcs = std.BoundedArray(Func, MAX_NUM_FUNCS){};
        var top_types = std.BoundedArray(Type, MAX_NUM_TYPES){};

        var file_decls = std.BoundedArray(Decl, MAX_NUM_DECLS){};
        var file_funcs = std.BoundedArray(Func, MAX_NUM_FUNCS){};

        const ast = try std.zig.Ast.parse(allocator, @ptrCast(src), .zig);

        const main_tokens = ast.nodes.items(.main_token);
        const node_datas = ast.nodes.items(.data);
        const node_tags = ast.nodes.items(.tag);

        const token_tags = ast.tokens.items(.tag);
        const starts = ast.tokens.items(.start);

        outer: for (node_tags, 0..) |node_tag, i| {
            switch (node_tag) {
                .test_decl => {
                    const start = starts[main_tokens[i]];
                    const end = starts[main_tokens[i - 1]] - 1;

                    // Parse file and top-level container test declarations
                    if (start > 0 and src[start - 1] == ' ') {
                        // Parse top-level and nested container test declarations
                        if (std.mem.eql(u8, CHECK_INDENTATION_LEVEL_2[0..], src[start - 5 .. start])) {
                            // Skip double-nested container test declarations
                            if (std.mem.eql(u8, CHECK_INDENTATION_LEVEL_3[0..], src[start - 9 .. start])) {
                                continue;
                            }
                            nested_type_decls.appendAssumeCapacity(.{ .tag = .tst, .start = start, .end = end });
                        } else {
                            top_type_decls.appendAssumeCapacity(.{ .tag = .tst, .start = start, .end = end });
                        }
                    } else {
                        file_decls.appendAssumeCapacity(.{ .tag = .tst, .start = start, .end = end });
                    }

                    // Validate output file because it's been written to
                    try are_files_valid.put(allocator, out_file_basename, true);
                },
                .fn_proto_simple, .fn_proto_multi, .fn_proto_one, .fn_proto => {
                    const start = starts[main_tokens[i] + 1];

                    // Parse only function declarations
                    switch (src[start]) {
                        // Skip function types
                        '(' => continue,
                        // Skip extern functions
                        else => switch (token_tags[main_tokens[i] - 1]) {
                            .keyword_extern, .string_literal => continue,
                            else => {},
                        },
                    }

                    var end_token_idx: std.zig.Ast.TokenIndex = undefined;
                    var rt_end: std.zig.Ast.ByteOffset = undefined;

                    // Find return type
                    for (node_tags[i + 1 ..], i + 1..) |tag, j| {
                        if (tag == .fn_decl) {
                            end_token_idx = main_tokens[node_datas[j].rhs];
                            rt_end = starts[end_token_idx] - 1;
                            break;
                        }
                    }

                    var args: std.meta.fieldInfo(Func, .args).type = .{};
                    args.appendAssumeCapacity(.{ .start = start, .end = starts[main_tokens[i] + 2] });
                    var rt_start: std.zig.Ast.ByteOffset = undefined;
                    var token_idx = main_tokens[i] + 3;
                    var is_arg = true;

                    // Parse arguments
                    while (true) : (token_idx += 1) {
                        switch (token_tags[token_idx]) {
                            // Skip type declaration expressions
                            .l_brace => token_idx = @intCast(std.mem.indexOfScalarPos(std.zig.Token.Tag, token_tags, token_idx + 1, .r_brace).?),
                            // Skip function calls
                            .l_paren => token_idx = @intCast(std.mem.indexOfScalarPos(std.zig.Token.Tag, token_tags, token_idx + 1, .r_paren).?),
                            // Parse argument names and remember not to parse argument types
                            .colon => if (is_arg) {
                                args.appendAssumeCapacity(.{ .start = starts[token_idx - 1], .end = starts[token_idx] });
                                is_arg = false;
                            },
                            // Remember to parse argument names
                            .comma => is_arg = true,
                            // Stop argument parsing
                            .r_paren => {
                                rt_start = starts[token_idx + 1];
                                break;
                            },
                            else => {},
                        }
                    }

                    // Parse return type
                    for (src[rt_start..rt_end], rt_start..rt_end) |*byte, j| {
                        switch (byte.*) {
                            // Skip multi-line return type declaration expressions
                            '\n' => {
                                rt_end = @intCast(j - 2);
                                if (do_info_log) {
                                    var line_num: u32 = 2;
                                    for (src[0..j]) |b| {
                                        if (b == '\n') {
                                            line_num += 1;
                                        }
                                    }
                                    log.info("  - Consider making a single line or referencing a type declaration instead: {s}/{s}#L{d}\"", .{ remote_src_dir_path, entry.path, line_num });
                                }
                                break;
                            },
                            // Change left brace to left bracket for Mermaid to render correctly
                            '{' => byte.* = '[',
                            // Change right brace to right bracket for Mermaid to render correctly
                            '}' => byte.* = ']',
                            else => {},
                        }
                    }

                    var first_token_idx = main_tokens[i] - 1;
                    var is_pub = false;

                    // Find first token and determine visibility
                    switch (token_tags[first_token_idx]) {
                        .keyword_export, .keyword_inline, .keyword_noinline => {
                            if (token_tags[first_token_idx - 1] == .keyword_pub) {
                                first_token_idx -= 1;
                                is_pub = true;
                            }
                        },
                        .keyword_pub => is_pub = true,
                        else => first_token_idx += 1,
                    }

                    const first_token_start = starts[first_token_idx];

                    // Parse functions declared on the first line and consequent lines
                    if (node_tags[i - 1] != .root) {
                        var do_skip: bool = undefined;

                        // Parse public and private functions declared on consequent lines
                        if (token_tags[first_token_idx] == .keyword_pub) {
                            const func = Func{ .is_pub = true, .args = args, .rt_start = rt_start, .rt_end = rt_end };
                            do_skip = parseFunc(func, src, first_token_start, &file_funcs, &top_type_funcs, &nested_type_funcs);
                        } else {
                            const func = Func{ .is_pub = false, .args = args, .rt_start = rt_start, .rt_end = rt_end };
                            do_skip = parseFunc(func, src, first_token_start, &file_funcs, &top_type_funcs, &nested_type_funcs);
                        }

                        if (do_skip) {
                            continue;
                        }
                    } else {
                        // Parse public and private functions declared on the first line
                        if (token_tags[first_token_idx] == .keyword_pub) {
                            file_funcs.appendAssumeCapacity(.{ .is_pub = true, .args = args, .rt_start = rt_start, .rt_end = rt_end });
                        } else {
                            file_funcs.appendAssumeCapacity(.{ .is_pub = false, .args = args, .rt_start = rt_start, .rt_end = rt_end });
                        }
                    }

                    // Validate output file because it's been written to
                    try are_files_valid.put(allocator, out_file_basename, true);
                },
                .error_set_decl => {
                    // Skip error set declaration expressions
                    if (i + 1 < node_tags.len and node_tags[i + 1] != .simple_var_decl) {
                        continue;
                    }

                    var first_token_idx = main_tokens[i] - 3;
                    var is_pub = false;

                    // Find first token and determine visibility
                    switch (token_tags[first_token_idx]) {
                        .keyword_const, .keyword_var => {
                            switch (token_tags[first_token_idx - 1]) {
                                .keyword_export => {
                                    first_token_idx -= 1;
                                    if (token_tags[first_token_idx - 1] == .keyword_pub) {
                                        first_token_idx -= 1;
                                        is_pub = true;
                                    }
                                },
                                .keyword_pub => {
                                    first_token_idx -= 1;
                                    is_pub = true;
                                },
                                else => {},
                            }
                        },
                        .keyword_export => {
                            if (token_tags[first_token_idx - 1] == .keyword_pub) {
                                first_token_idx -= 1;
                                is_pub = true;
                            }
                        },
                        .keyword_pub => is_pub = true,
                        else => unreachable,
                    }

                    const first_token_start = starts[first_token_idx];

                    // Skip double-nested error set declarations
                    if (first_token_start > 0 and std.mem.eql(u8, CHECK_INDENTATION_LEVEL_2[0..], src[first_token_start - 5 .. first_token_start])) {
                        continue;
                    }

                    const start = starts[main_tokens[i] - 2];
                    const end = starts[main_tokens[i] - 1] - 1;

                    // Print error set declaration
                    try writer.print("class {s}[\"{s} [err]\"] {c}\n", .{ src[start..end], src[start..end], '{' });

                    var token_idx = main_tokens[i] + 2;
                    var token_tag = token_tags[token_idx];

                    // Print error set values
                    while (token_tag != .semicolon) : (token_tag = token_tags[token_idx]) {
                        if (token_tag == .identifier) {
                            const val_start = starts[token_idx];
                            token_idx += 1;
                            const val_end = starts[token_idx];

                            if (is_pub) {
                                try writer.print(INDENTATION_LEVEL_1[0..] ++ "+{s}\n", .{src[val_start..val_end]});
                            } else {
                                try writer.print(INDENTATION_LEVEL_1[0..] ++ "-{s}\n", .{src[val_start..val_end]});
                            }
                        }

                        token_idx += 1;
                    }

                    // Parse top-level and nested error set declarations
                    if (first_token_start > 0 and src[first_token_start - 1] == ' ') {
                        nested_types.appendAssumeCapacity(.{ .tag = .err, .start = start, .end = end });
                    } else {
                        top_types.appendAssumeCapacity(.{ .tag = .err, .start = start, .end = end });
                    }

                    // Find source line location
                    var line_num: u32 = 1;
                    for (src[0..start]) |byte| {
                        if (byte == '\n') {
                            line_num += 1;
                        }
                    }

                    // Print source line link
                    try writer.print("{c}\nlink {s} \"{s}/{s}#L{d}\"\n", .{ '}', src[start..end], remote_src_dir_path, entry.path, line_num });

                    // Validate output file because it's been written to
                    try are_files_valid.put(allocator, out_file_basename, true);
                },
                .container_decl,
                .container_decl_trailing,
                .container_decl_two,
                .container_decl_two_trailing,
                .container_decl_arg,
                .container_decl_arg_trailing,
                .tagged_union,
                .tagged_union_trailing,
                .tagged_union_two,
                .tagged_union_two_trailing,
                .tagged_union_enum_tag,
                .tagged_union_enum_tag_trailing,
                => {
                    // Skip container declaration expressions
                    if (i + 1 < node_tags.len and node_tags[i + 1] != .simple_var_decl) {
                        continue;
                    }

                    var name_token_idx = main_tokens[i] - 1;
                    var end = starts[name_token_idx] - 1;
                    name_token_idx -= 1;
                    var start = starts[name_token_idx];

                    // Find name token
                    switch (token_tags[main_tokens[i] - 1]) {
                        .keyword_extern, .keyword_packed => {
                            end = starts[name_token_idx] - 1;
                            name_token_idx -= 1;
                            start = starts[name_token_idx];
                        },
                        else => {},
                    }

                    const tag_name = src[starts[main_tokens[i]] .. starts[main_tokens[i]] + 3];
                    const tag = std.meta.stringToEnum(Type.Tag, tag_name).?;
                    var first_token_idx = name_token_idx - 1;
                    var is_pub = false;

                    // Find first token and determine visibility
                    switch (token_tags[first_token_idx]) {
                        .keyword_const, .keyword_var => {
                            switch (token_tags[first_token_idx - 1]) {
                                .keyword_export => {
                                    first_token_idx -= 1;
                                    if (token_tags[first_token_idx - 1] == .keyword_pub) {
                                        first_token_idx -= 1;
                                        is_pub = true;
                                    }
                                },
                                .keyword_pub => {
                                    first_token_idx -= 1;
                                    is_pub = true;
                                },
                                else => {},
                            }
                        },
                        .keyword_export => {
                            if (token_tags[first_token_idx - 1] == .keyword_pub) {
                                first_token_idx -= 1;
                                is_pub = true;
                            }
                        },
                        .keyword_pub => is_pub = true,
                        else => unreachable,
                    }

                    const first_token_start = starts[first_token_idx];
                    const is_not_at_root = first_token_start > 0;

                    // Skip double-nested container declarations
                    if (is_not_at_root and std.mem.eql(u8, CHECK_INDENTATION_LEVEL_2[0..], src[first_token_start - 5 .. first_token_start])) {
                        continue;
                    }

                    // Print top-level or nested container declaration
                    try writer.print("class {s}[\"{s} [{s}]\"]", .{ src[start..end], src[start..end], tag_name });

                    // Print simple and function declarations declared on the first line and consequent lines
                    if (is_not_at_root and src[first_token_start - 1] == ' ') {
                        // Print nested container declarations
                        try printDecls(is_pub, true, src, &nested_type_decls, &nested_type_funcs, writer);
                    } else {
                        // Print top-level container declarations
                        try printDecls(is_pub, true, src, &top_type_decls, &top_type_funcs, writer);
                    }

                    // Parse top-level and nested container declarations
                    if (is_not_at_root and src[first_token_start - 1] == ' ') {
                        nested_types.appendAssumeCapacity(.{ .tag = tag, .start = start, .end = end });
                    } else {
                        // Print "nested to top-level" container relationships
                        for (nested_types.constSlice()) |container| {
                            try writer.print("{s} <-- {s}\n", .{ src[start..end], src[container.start..container.end] });
                        }

                        try nested_types.resize(0);

                        top_types.appendAssumeCapacity(.{ .tag = tag, .start = start, .end = end });
                    }

                    // Find source line location
                    var line_num: u32 = 1;
                    for (src[0..start]) |byte| {
                        if (byte == '\n') {
                            line_num += 1;
                        }
                    }

                    // Print source line link
                    try writer.print("link {s} \"{s}/{s}#L{d}\"\n", .{ src[start..end], remote_src_dir_path, entry.path, line_num });

                    // Validate output file because it's been written to
                    try are_files_valid.put(allocator, out_file_basename, true);
                },
                .container_field_init, .container_field_align, .container_field => {
                    // Skip container field declarations in container declaration expressions
                    for (node_tags[i..]) |tag| {
                        switch (tag) {
                            .fn_proto_simple, .fn_proto_multi, .fn_proto_one, .fn_proto => break,
                            .fn_decl => continue :outer,
                            else => {},
                        }
                    }

                    const start = starts[main_tokens[i]];
                    var end: std.zig.Ast.ByteOffset = @intCast(std.mem.indexOfAnyPos(u8, src, start, "(={,}").?);

                    // Find end token
                    switch (src[end]) {
                        '(' => end = @intCast(std.mem.indexOfScalarPos(u8, src, end, ')').? + 1),
                        '=', '{', '}' => end -= 1,
                        else => {},
                    }

                    // Change left braces to left brackets for Mermaid to render correctly
                    std.mem.replaceScalar(u8, src[start..end], '{', '[');

                    // Change right braces to right brackets for Mermaid to render correctly
                    std.mem.replaceScalar(u8, src[start..end], '}', ']');

                    // Parse file and top-level container field declarations
                    if (node_tags[i - 2] != .root and src[start - 1] == ' ') {
                        // Parse top-level and nested container field declarations
                        if (std.mem.eql(u8, CHECK_INDENTATION_LEVEL_2[0..], src[start - 5 .. start])) {
                            // Skip double-nested container field declarations
                            if (std.mem.eql(u8, CHECK_INDENTATION_LEVEL_3[0..], src[start - 9 .. start])) {
                                continue;
                            }
                            nested_type_decls.appendAssumeCapacity(.{ .tag = .fld, .start = start, .end = end });
                        } else {
                            top_type_decls.appendAssumeCapacity(.{ .tag = .fld, .start = start, .end = end });
                        }
                    } else {
                        file_decls.appendAssumeCapacity(.{ .tag = .fld, .start = start, .end = end });
                    }

                    // Validate output file because it's been written to
                    try are_files_valid.put(allocator, out_file_basename, true);
                },
                else => {},
            }
        }

        const file_name = std.fs.path.basename(entry.path);

        // Print file container declaration
        try writer.print("class `{s}`", .{file_name});

        // Print file container declarations
        try printDecls(true, false, src, &file_decls, &file_funcs, writer);

        // Print "top-level to file" container relationships
        for (top_types.constSlice()) |container| {
            try writer.print("`{s}` <-- {s}\n", .{ file_name, src[container.start..container.end] });
        }

        // Print source file link
        try writer.print("link `{s}` \"{s}/{s}\"\n", .{ file_name, remote_src_dir_path, entry.path });
    }

    // Close valid and delete invalid output files
    for (are_files_valid.keys(), 0..) |basename, i| {
        out_file = out_files.get(basename).?;

        if (are_files_valid.values()[i]) {
            try writeEpilogue(extension, out_file.writer());

            out_file.close();
        } else {
            out_file.close();

            const file_name = try std.fmt.allocPrint(allocator, "{s}.{s}", .{ basename, @tagName(extension) });
            try out_dir.deleteFile(file_name);
        }
    }
}

fn parseFunc(
    func: Func,
    src: []const u8,
    first_token_start: std.zig.Ast.ByteOffset,
    file_funcs: *std.BoundedArray(Func, MAX_NUM_FUNCS),
    top_type_funcs: *std.BoundedArray(Func, MAX_NUM_FUNCS),
    nested_type_funcs: *std.BoundedArray(Func, MAX_NUM_FUNCS),
) bool {
    // Parse top-level and nested function declarations
    if (src[first_token_start - 1] == ' ') {
        // Parse single- and double-nested function declarations
        if (std.mem.eql(u8, CHECK_INDENTATION_LEVEL_2[0..], src[first_token_start - 5 .. first_token_start])) {
            // Skip triple-nested function declarations
            if (std.mem.eql(u8, CHECK_INDENTATION_LEVEL_3[0..], src[first_token_start - 9 .. first_token_start])) {
                return true;
            }
            nested_type_funcs.appendAssumeCapacity(func);
        } else {
            top_type_funcs.appendAssumeCapacity(func);
        }
    } else {
        file_funcs.appendAssumeCapacity(func);
    }
    return false;
}

fn printDecls(
    is_pub: bool,
    do_resize: bool,
    src: []const u8,
    decls: *std.BoundedArray(Decl, MAX_NUM_DECLS),
    funcs: *std.BoundedArray(Func, MAX_NUM_FUNCS),
    writer: anytype,
) (error{Overflow} || @TypeOf(writer).Error)!void {
    if (decls.len > 0 or funcs.len > 0) {
        try writer.writeAll(" {\n");

        // Print simple declarations
        for (decls.constSlice()) |decl| {
            try decl.print(is_pub, src, writer);
        }

        if (do_resize) {
            try decls.resize(0);
        }

        // Print function declarations
        for (funcs.constSlice()) |func| {
            try func.print(src, writer);
        }

        if (do_resize) {
            try funcs.resize(0);
        }

        try writer.writeAll("}\n");
    } else {
        try writer.writeByte('\n');
    }
}

fn writePrologue(
    codebase_title: []const u8,
    out_file_basename: []const u8,
    extension: Ext,
    writer: anytype,
) std.fs.File.WriteError!void {
    switch (extension) {
        .html => {
            try writer.writeAll(
                \\<html>
                \\
                \\<body>
                \\    <script type="module">
                \\        import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10.2.4/dist/mermaid.esm.min.mjs';
                \\        mermaid.initialize({
                \\            'theme': 'base',
                \\            'themeVariables': {
                \\                'fontSize': '18px',
                \\                'fontFamily': 'arial',
                \\                'lineColor': '#F6A516',
                \\                'primaryColor': '#28282B',
                \\                'primaryTextColor': '#F6A516'
                \\            }
                \\        });
                \\    </script>
                \\    <pre class="mermaid">
                \\
            );
            try writer.print("---\ntitle: {s} ({s})\n---\n", .{ codebase_title, out_file_basename });
        },
        .md, .mmd => {
            if (extension == .md) {
                try writer.writeAll("```mermaid\n");
            }
            try writer.print("---\ntitle: {s} ({s})\n---\n", .{ codebase_title, out_file_basename });
            try writer.writeAll(
                \\%%{
                \\    init: {
                \\        'theme': 'base',
                \\        'themeVariables': {
                \\            'fontSize': '18px',
                \\            'fontFamily': 'arial',
                \\            'lineColor': '#F6A516',
                \\            'primaryColor': '#28282B',
                \\            'primaryTextColor': '#F6A516'
                \\        }
                \\    }
                \\}%%
                \\
            );
        },
    }
    try writer.writeAll("classDiagram\n");
}

fn writeEpilogue(extension: Ext, writer: anytype) std.fs.File.WriteError!void {
    switch (extension) {
        .html => {
            try writer.writeAll(
                \\    </pre>
                \\</body>
                \\
                \\</html>
                \\
            );
        },
        .md => try writer.writeAll("```\n"),
        .mmd => {},
    }
}
