const std = @import("std");

const MAX_NUM_ARGS: usize = 1 << 4;
const MAX_NUM_DECLS: usize = 1 << 8;
const MAX_NUM_FUNCS: usize = 1 << 8;
const MAX_NUM_TYPES: usize = 1 << 8;
const MAX_FILE_SIZE: usize = 1 << 22;

pub const Error = error{
    Overflow,
} || std.mem.Allocator.Error || std.fmt.BufPrintError || std.fs.Dir.DeleteTreeError || std.fs.File.WriteError || std.fs.File.OpenError || std.fs.Dir.OpenError || std.os.PReadError || std.os.MakeDirError;

pub const Ext = enum {
    html,
    mmd,
    md,
};

const Container = struct {
    start: std.zig.Ast.ByteOffset,
    end: std.zig.Ast.ByteOffset,
    tag: Tag,

    const Tag = enum {
        @"struct",
        @"opaque",
        @"union",
        @"error",
        @"enum",
    };
};

const FnProto = struct {
    args: std.BoundedArray(struct { start: std.zig.Ast.ByteOffset, end: std.zig.Ast.ByteOffset }, MAX_NUM_ARGS),
    rt_start: std.zig.Ast.ByteOffset,
    rt_end: std.zig.Ast.ByteOffset,
    is_pub: bool,

    pub fn print(self: FnProto, src: []const u8, writer: anytype) (@TypeOf(writer).Error)!void {
        try writer.writeAll("    ");
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

const Decl = struct {
    start: std.zig.Ast.ByteOffset,
    end: std.zig.Ast.ByteOffset,
    is_test: bool,

    fn print(self: Decl, is_pub: bool, src: []const u8, writer: anytype) (@TypeOf(writer).Error)!void {
        try writer.writeAll("    ");
        if (self.is_test) {
            try writer.print("{s}()\n", .{src[self.start..self.end]});
        } else if (is_pub) {
            try writer.print("+{s}\n", .{src[self.start..self.end]});
        } else {
            try writer.print("-{s}\n", .{src[self.start..self.end]});
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
) Error!void {
    const cur_dir = std.fs.cwd();

    try cur_dir.makePath(out_dir_path);

    const stdout = std.io.getStdOut();
    var buf_stdout_writer = std.io.bufferedWriter(stdout.writer());
    const stdout_writer = buf_stdout_writer.writer();

    try stdout_writer.writeAll("Tips for improving code readability:\n");

    var src_dir = try cur_dir.openDir(local_src_dir_path, .{});
    defer src_dir.close();

    var src_dir_iter = try cur_dir.openIterableDir(local_src_dir_path, .{});
    defer src_dir_iter.close();

    var walker = try src_dir_iter.walk(allocator);
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
                if (std.mem.eql(u8, ".zig", std.fs.path.extension(entry.basename))) {
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

        var nested_container_fn_protos = std.BoundedArray(FnProto, MAX_NUM_FUNCS){};
        var nested_container_decls = std.BoundedArray(Decl, MAX_NUM_DECLS){};
        var nested_containers = std.BoundedArray(Container, MAX_NUM_TYPES){};

        var nested_fn_protos = std.BoundedArray(FnProto, MAX_NUM_FUNCS){};
        var nested_decls = std.BoundedArray(Decl, MAX_NUM_DECLS){};

        var file_containers = std.BoundedArray(Container, MAX_NUM_TYPES){};
        var file_fn_protos = std.BoundedArray(FnProto, MAX_NUM_FUNCS){};
        var file_decls = std.BoundedArray(Decl, MAX_NUM_DECLS){};

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
                    if (start > 0 and src[start - 1] == ' ') {
                        if (std.mem.eql(u8, "     ", src[start - 5 .. start])) {
                            if (std.mem.eql(u8, "         ", src[start - 9 .. start])) {
                                continue;
                            }
                            nested_container_decls.appendAssumeCapacity(.{ .is_test = true, .start = start, .end = end });
                        } else {
                            nested_decls.appendAssumeCapacity(.{ .is_test = true, .start = start, .end = end });
                        }
                    } else {
                        file_decls.appendAssumeCapacity(.{ .is_test = true, .start = start, .end = end });
                    }
                    try are_files_valid.put(allocator, out_file_basename, true);
                },
                .fn_proto_simple, .fn_proto_multi, .fn_proto_one, .fn_proto => {
                    const start = starts[main_tokens[i] + 1];
                    switch (src[start]) {
                        '(' => continue,
                        else => switch (token_tags[main_tokens[i] - 1]) {
                            .keyword_extern, .string_literal => continue,
                            else => {},
                        },
                    }
                    var end_token_idx: std.zig.Ast.TokenIndex = undefined;
                    var rt_end: std.zig.Ast.ByteOffset = undefined;
                    for (node_tags[i + 1 ..], i + 1..) |tag, j| {
                        if (tag == .fn_decl) {
                            end_token_idx = main_tokens[node_datas[j].rhs];
                            rt_end = starts[end_token_idx] - 1;
                            break;
                        }
                    }
                    var args: std.meta.fieldInfo(FnProto, .args).type = .{};
                    args.appendAssumeCapacity(.{ .start = start, .end = starts[main_tokens[i] + 2] });
                    var rt_start: std.zig.Ast.ByteOffset = undefined;
                    var token_idx = main_tokens[i] + 3;
                    var is_arg = true;
                    while (true) : (token_idx += 1) {
                        switch (token_tags[token_idx]) {
                            .l_brace => token_idx = @intCast(std.mem.indexOfScalarPos(std.zig.Token.Tag, token_tags, token_idx + 1, .r_brace).?),
                            .l_paren => token_idx = @intCast(std.mem.indexOfScalarPos(std.zig.Token.Tag, token_tags, token_idx + 1, .r_paren).?),
                            .colon => if (is_arg) {
                                args.appendAssumeCapacity(.{ .start = starts[token_idx - 1], .end = starts[token_idx] });
                                is_arg = false;
                            },
                            .comma => is_arg = true,
                            .r_paren => {
                                rt_start = starts[token_idx + 1];
                                break;
                            },
                            else => {},
                        }
                    }
                    for (src[rt_start..rt_end], rt_start..rt_end) |*byte, j| {
                        switch (byte.*) {
                            '\n' => {
                                var line_num: usize = 2;
                                for (src[0..j]) |b| {
                                    if (b == '\n') {
                                        line_num += 1;
                                    }
                                }
                                try stdout_writer.print("  - Consider making a single line or referencing a type definition instead: {s}/{s}#L{d}\"\n", .{ remote_src_dir_path, entry.path, line_num });
                                rt_end = @intCast(j - 2);
                                break;
                            },
                            '{' => byte.* = '[',
                            '}' => byte.* = ']',
                            else => {},
                        }
                    }
                    var first_token_idx = main_tokens[i] - 1;
                    var is_pub = false;
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
                    if (node_tags[i - 1] != .root) {
                        if (token_tags[first_token_idx] == .keyword_pub) {
                            if (src[first_token_start - 1] == ' ') {
                                if (std.mem.eql(u8, "     ", src[first_token_start - 5 .. first_token_start])) {
                                    if (std.mem.eql(u8, "         ", src[first_token_start - 9 .. first_token_start])) {
                                        continue;
                                    }
                                    nested_container_fn_protos.appendAssumeCapacity(.{ .is_pub = true, .args = args, .rt_start = rt_start, .rt_end = rt_end });
                                } else {
                                    nested_fn_protos.appendAssumeCapacity(.{ .is_pub = true, .args = args, .rt_start = rt_start, .rt_end = rt_end });
                                }
                            } else {
                                file_fn_protos.appendAssumeCapacity(.{ .is_pub = true, .args = args, .rt_start = rt_start, .rt_end = rt_end });
                            }
                        } else {
                            if (src[first_token_start - 1] == ' ') {
                                if (std.mem.eql(u8, "     ", src[first_token_start - 5 .. first_token_start])) {
                                    if (std.mem.eql(u8, "         ", src[first_token_start - 9 .. first_token_start])) {
                                        continue;
                                    }
                                    nested_container_fn_protos.appendAssumeCapacity(.{ .is_pub = false, .args = args, .rt_start = rt_start, .rt_end = rt_end });
                                } else {
                                    nested_fn_protos.appendAssumeCapacity(.{ .is_pub = false, .args = args, .rt_start = rt_start, .rt_end = rt_end });
                                }
                            } else {
                                file_fn_protos.appendAssumeCapacity(.{ .is_pub = false, .args = args, .rt_start = rt_start, .rt_end = rt_end });
                            }
                        }
                    } else {
                        if (token_tags[first_token_idx] == .keyword_pub) {
                            file_fn_protos.appendAssumeCapacity(.{ .is_pub = true, .args = args, .rt_start = rt_start, .rt_end = rt_end });
                        } else {
                            file_fn_protos.appendAssumeCapacity(.{ .is_pub = false, .args = args, .rt_start = rt_start, .rt_end = rt_end });
                        }
                    }
                    try are_files_valid.put(allocator, out_file_basename, true);
                },
                .error_set_decl => {
                    if (node_tags[i + 1] != .simple_var_decl) {
                        continue;
                    }
                    var first_token_idx = main_tokens[i] - 3;
                    var is_pub = false;
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
                    if (is_not_at_root and std.mem.eql(u8, "     ", src[first_token_start - 5 .. first_token_start])) {
                        continue;
                    }
                    const start = starts[main_tokens[i] - 2];
                    const end = starts[main_tokens[i] - 1] - 1;
                    try writer.print("class {s}[\"{s} [error]\"] {c}\n", .{ src[start..end], src[start..end], '{' });
                    var token_idx = main_tokens[i] + 2;
                    var token_tag = token_tags[token_idx];
                    while (token_tag != .semicolon) : (token_tag = token_tags[token_idx]) {
                        if (token_tag == .identifier) {
                            const val_start = starts[token_idx];
                            token_idx += 1;
                            const val_end = starts[token_idx];
                            if (is_pub) {
                                try writer.print("    +{s}\n", .{src[val_start..val_end]});
                            } else {
                                try writer.print("    -{s}\n", .{src[val_start..val_end]});
                            }
                        }
                        token_idx += 1;
                    }
                    if (is_not_at_root and src[first_token_start - 1] == ' ') {
                        nested_containers.appendAssumeCapacity(.{ .tag = .@"error", .start = start, .end = end });
                    } else {
                        file_containers.appendAssumeCapacity(.{ .tag = .@"error", .start = start, .end = end });
                    }
                    var line_num: usize = 1;
                    for (src[0..start]) |byte| {
                        if (byte == '\n') {
                            line_num += 1;
                        }
                    }
                    try writer.print("{c}\nlink {s} \"{s}/{s}#L{d}\"\n", .{ '}', src[start..end], remote_src_dir_path, entry.path, line_num });
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
                    if (node_tags[i + 1] != .simple_var_decl) {
                        continue;
                    }
                    var name_token_idx = main_tokens[i] - 1;
                    var end = starts[name_token_idx] - 1;
                    name_token_idx -= 1;
                    var start = starts[name_token_idx];
                    switch (token_tags[main_tokens[i] - 1]) {
                        .keyword_extern, .keyword_packed => {
                            end = starts[name_token_idx] - 1;
                            name_token_idx -= 1;
                            start = starts[name_token_idx];
                        },
                        else => {},
                    }
                    const tag: Container.Tag = switch (src[starts[main_tokens[i]]]) {
                        's' => .@"struct",
                        'o' => .@"opaque",
                        'u' => .@"union",
                        'e' => .@"enum",
                        else => unreachable,
                    };
                    var first_token_idx = name_token_idx - 1;
                    var is_pub = false;
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
                    if (is_not_at_root and std.mem.eql(u8, "     ", src[first_token_start - 5 .. first_token_start])) {
                        continue;
                    }
                    try writer.print("class {s}[\"{s} [{s}]\"]", .{ src[start..end], src[start..end], @tagName(tag) });
                    if (is_not_at_root and src[first_token_start - 1] == ' ') {
                        if (nested_container_decls.len > 0 or nested_container_fn_protos.len > 0) {
                            try writer.writeAll(" {\n");
                            for (nested_container_decls.constSlice()) |decl| {
                                try decl.print(is_pub, src, writer);
                            }
                            try nested_container_decls.resize(0);
                            for (nested_container_fn_protos.constSlice()) |fn_proto| {
                                try fn_proto.print(src, writer);
                            }
                            try nested_container_fn_protos.resize(0);
                            try writer.writeAll("}\n");
                        } else {
                            try writer.writeByte('\n');
                        }
                    } else {
                        if (nested_decls.len > 0 or nested_fn_protos.len > 0) {
                            try writer.writeAll(" {\n");
                            for (nested_decls.constSlice()) |decl| {
                                try decl.print(is_pub, src, writer);
                            }
                            try nested_decls.resize(0);
                            for (nested_fn_protos.constSlice()) |fn_proto| {
                                try fn_proto.print(src, writer);
                            }
                            try nested_fn_protos.resize(0);
                            try writer.writeAll("}\n");
                        } else {
                            try writer.writeByte('\n');
                        }
                    }
                    if (is_not_at_root and src[first_token_start - 1] == ' ') {
                        nested_containers.appendAssumeCapacity(.{ .tag = tag, .start = start, .end = end });
                    } else {
                        for (nested_containers.constSlice()) |container| {
                            try writer.print("{s} <-- {s}\n", .{ src[start..end], src[container.start..container.end] });
                        }
                        try nested_containers.resize(0);
                        file_containers.appendAssumeCapacity(.{ .tag = tag, .start = start, .end = end });
                    }
                    var line_num: usize = 1;
                    for (src[0..start]) |byte| {
                        if (byte == '\n') {
                            line_num += 1;
                        }
                    }
                    try writer.print("link {s} \"{s}/{s}#L{d}\"\n", .{ src[start..end], remote_src_dir_path, entry.path, line_num });
                    try are_files_valid.put(allocator, out_file_basename, true);
                },
                .container_field_init, .container_field_align, .container_field => {
                    const start = starts[main_tokens[i]];
                    var end: std.zig.Ast.ByteOffset = @intCast(std.mem.indexOfAnyPos(u8, src, start, "(={,}").?);
                    switch (src[end]) {
                        '(' => end = @intCast(std.mem.indexOfScalarPos(u8, src, end, ')').? + 1),
                        '=', '{', '}' => end -= 1,
                        else => {},
                    }
                    for (node_tags[i..]) |tag| {
                        switch (tag) {
                            .fn_proto_simple, .fn_proto_multi, .fn_proto_one, .fn_proto => break,
                            .fn_decl => continue :outer,
                            else => {},
                        }
                    }
                    std.mem.replaceScalar(u8, src[start..end], '{', '[');
                    std.mem.replaceScalar(u8, src[start..end], '}', ']');
                    if (node_tags[i - 2] != .root and src[start - 1] == ' ') {
                        if (std.mem.eql(u8, "     ", src[start - 5 .. start])) {
                            if (std.mem.eql(u8, "         ", src[start - 9 .. start])) {
                                continue;
                            }
                            nested_container_decls.appendAssumeCapacity(.{ .is_test = false, .start = start, .end = end });
                        } else {
                            nested_decls.appendAssumeCapacity(.{ .is_test = false, .start = start, .end = end });
                        }
                    } else {
                        file_decls.appendAssumeCapacity(.{ .is_test = false, .start = start, .end = end });
                    }
                    try are_files_valid.put(allocator, out_file_basename, true);
                },
                else => {},
            }
        }
        try writer.print("class `{s}`", .{entry.path});
        if (file_decls.len > 0 or file_fn_protos.len > 0) {
            try writer.writeAll(" {\n");
            for (file_decls.constSlice()) |decl| {
                try decl.print(true, src, writer);
            }
            for (file_fn_protos.constSlice()) |fn_proto| {
                try fn_proto.print(src, writer);
            }
            try writer.writeAll("}\n");
        } else {
            try writer.writeByte('\n');
        }
        for (file_containers.constSlice()) |container| {
            try writer.print("`{s}` <-- {s}\n", .{ entry.path, src[container.start..container.end] });
        }
        try writer.print("link `{s}` \"{s}/{s}\"\n", .{ entry.path, remote_src_dir_path, entry.path });
    }

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

    try buf_stdout_writer.flush();
}

inline fn writePrologue(codebase_title: []const u8, out_file_basename: []const u8, extension: Ext, writer: anytype) std.fs.File.WriteError!void {
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

inline fn writeEpilogue(extension: Ext, writer: anytype) std.fs.File.WriteError!void {
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
