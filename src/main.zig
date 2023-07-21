const std = @import("std");

const SRC_DIR_PATH = "zigzag/src";
const MAX_NUM_DECLS: usize = 1 << 8;
const MAX_FILE_SIZE: usize = 1 << 20;
const REPO_LINK = "https://github.com/tensorush/zigzag";

const MainError = error{
    Overflow,
} || std.mem.Allocator.Error || std.fs.Dir.DeleteTreeError || std.fs.File.WriteError || std.fs.File.OpenError || std.fs.Dir.OpenError || std.os.PReadError;

const Declaration = struct {
    tag: DeclarationTag,
    start: usize,
    end: usize,

    fn print(self: Declaration, src: []const u8, writer: anytype) (@TypeOf(writer).Error)!void {
        try writer.writeAll("        ");
        switch (self.tag) {
            .test_func => try writer.print("{s}()\n", .{src[self.start..self.end]}),
            .pub_func => try writer.print("+{s}\n", .{src[self.start..self.end]}),
            .func => try writer.print("-{s}\n", .{src[self.start..self.end]}),
            else => try writer.print("{s}\n", .{src[self.start..self.end]}),
        }
    }
};

const DeclarationTag = enum {
    container_field,
    test_func,
    pub_func,
    func,
};

pub fn main() MainError!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa.deinit() == .leak) {
        @panic("PANIC: Memory leak has occurred!");
    };

    var arena = std.heap.ArenaAllocator.init(gpa.allocator());
    defer arena.deinit();
    var allocator = arena.allocator();

    const cur_dir = std.fs.cwd();

    const meduza_file = try cur_dir.createFile("MEDUZA.md", .{});
    defer meduza_file.close();

    var buf_writer = std.io.bufferedWriter(meduza_file.writer());
    const writer = buf_writer.writer();

    try writer.writeAll("```mermaid\nclassDiagram\n");

    var src_dir = try cur_dir.openDir(SRC_DIR_PATH, .{});
    defer src_dir.close();

    var src_dir_iter = try cur_dir.openIterableDir(SRC_DIR_PATH, .{});
    defer src_dir_iter.close();

    var walker = try src_dir_iter.walk(allocator);
    defer walker.deinit();

    while (try walker.next()) |entry| {
        if (entry.kind != .file or !std.mem.eql(u8, ".zig", std.fs.path.extension(entry.basename))) {
            continue;
        }

        try writer.writeAll("namespace ");

        if (std.fs.path.dirname(entry.path)) |path| {
            for (path) |byte| {
                if (std.fs.path.isSep(byte)) {
                    try writer.writeByte('_');
                } else {
                    try writer.writeByte(byte);
                }
            }
            try writer.writeByte('_');
        }

        try writer.print("{s} {c}\n", .{ std.fs.path.stem(entry.path), '{' });

        var src_buf: [MAX_FILE_SIZE]u8 = undefined;
        var src = try src_dir.readFile(entry.path, src_buf[0..]);
        src_buf[src.len] = 0;

        var nested_decls = std.BoundedArray(Declaration, MAX_NUM_DECLS){};
        var file_decls = std.BoundedArray(Declaration, MAX_NUM_DECLS){};

        const ast = try std.zig.Ast.parse(allocator, @ptrCast(src), .zig);

        const main_tokens = ast.nodes.items(.main_token);
        const node_datas = ast.nodes.items(.data);
        const node_tags = ast.nodes.items(.tag);

        const token_tags = ast.tokens.items(.tag);
        const starts = ast.tokens.items(.start);

        for (node_tags, 0..) |node_tag, i| {
            switch (node_tag) {
                .test_decl => {
                    const start = starts[main_tokens[i]];
                    const end = starts[main_tokens[i - 1]] - 1;
                    if (start > 0 and src[start - 1] == ' ') {
                        nested_decls.appendAssumeCapacity(.{ .tag = .test_func, .start = start, .end = end });
                    } else {
                        file_decls.appendAssumeCapacity(.{ .tag = .test_func, .start = start, .end = end });
                    }
                },
                .fn_proto_simple, .fn_proto_multi, .fn_proto_one, .fn_proto => {
                    const start = starts[main_tokens[i] + 1];
                    if (src[start] == '(') {
                        continue;
                    }
                    var end: usize = undefined;
                    for (node_tags[i + 1 ..], i + 1..) |tag, j| {
                        if (tag == .fn_decl) {
                            end = starts[main_tokens[node_datas[j].rhs]];
                            break;
                        }
                    }
                    for (src[start..end]) |*byte| {
                        if (byte.* == '\n') {
                            byte.* = ' ';
                        } else if (byte.* == '{') {
                            byte.* = '[';
                        } else if (byte.* == '}') {
                            byte.* = ']';
                        }
                    }
                    const pub_token_idx = main_tokens[i] - 1;
                    if (node_tags[i - 1] != .root) {
                        if (token_tags[pub_token_idx] == .keyword_pub) {
                            if (src[starts[pub_token_idx] - 1] == ' ') {
                                nested_decls.appendAssumeCapacity(.{ .tag = .pub_func, .start = start, .end = end });
                            } else {
                                file_decls.appendAssumeCapacity(.{ .tag = .pub_func, .start = start, .end = end });
                            }
                        } else {
                            if (src[starts[pub_token_idx] - 1] == ' ') {
                                nested_decls.appendAssumeCapacity(.{ .tag = .func, .start = start, .end = end });
                            } else {
                                file_decls.appendAssumeCapacity(.{ .tag = .func, .start = start, .end = end });
                            }
                        }
                    } else {
                        if (token_tags[pub_token_idx] == .keyword_pub) {
                            file_decls.appendAssumeCapacity(.{ .tag = .pub_func, .start = start, .end = end });
                        } else {
                            file_decls.appendAssumeCapacity(.{ .tag = .func, .start = start, .end = end });
                        }
                    }
                },
                .error_set_decl => {
                    if (node_tags[i + 1] != .simple_var_decl) {
                        continue;
                    }
                    const start = starts[main_tokens[i] - 2];
                    const end = starts[main_tokens[i] - 1] - 1;
                    try writer.print("    class {s} {c}\n        <<error>>\n", .{ src[start..end], '{' });
                    var token_idx = main_tokens[i] + 2;
                    var token_tag = token_tags[token_idx];
                    while (token_tag != .r_brace) : (token_tag = token_tags[token_idx]) {
                        if (token_tag == .identifier) {
                            const val_start = starts[token_idx];
                            token_idx += 1;
                            const val_end = starts[token_idx] + 1;
                            try writer.print("        {s}\n", .{src[val_start..val_end]});
                        }
                        token_idx += 1;
                    }
                    try writer.writeAll("    }\n");
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
                    var main_token = main_tokens[i] - 2;
                    var start = starts[main_token];
                    var end = starts[main_tokens[i] - 1] - 1;
                    switch (token_tags[main_tokens[i] - 1]) {
                        .keyword_extern, .keyword_packed => {
                            main_token -= 1;
                            start = starts[main_token];
                            end = starts[main_tokens[i] - 2] - 1;
                        },
                        else => {},
                    }
                    try writer.print("    class {s} {c}\n        ", .{ src[start..end], '{' });
                    switch (src[starts[main_tokens[i]]]) {
                        'e' => try writer.writeAll("<<enum>>\n"),
                        'u' => try writer.writeAll("<<union>>\n"),
                        'o' => try writer.writeAll("<<opaque>>\n"),
                        's' => try writer.writeAll("<<struct>>\n"),
                        else => {},
                    }
                    for (nested_decls.constSlice()) |decl| {
                        try decl.print(src, writer);
                    }
                    try nested_decls.resize(0);
                    try writer.writeAll("    }\n");
                },
                .container_field_init, .container_field_align, .container_field => {
                    const start = starts[main_tokens[i]];
                    var end = std.mem.indexOfAnyPos(u8, src, start, "=,}").?;
                    switch (src[end]) {
                        '=', '}' => src[end - 1] = ',',
                        ',' => end += 1,
                        else => {},
                    }
                    std.mem.replaceScalar(u8, src[start..end], '{', '[');
                    std.mem.replaceScalar(u8, src[start..end], '}', ']');
                    if (node_tags[i - 2] != .root and src[start - 1] == ' ') {
                        nested_decls.appendAssumeCapacity(.{ .tag = .container_field, .start = start, .end = end });
                    } else {
                        file_decls.appendAssumeCapacity(.{ .tag = .container_field, .start = start, .end = end });
                    }
                },
                else => {},
            }
        }
        try writer.writeAll("    class file {\n        <<file>>\n");
        for (file_decls.constSlice()) |decl| {
            try decl.print(src, writer);
        }
        try writer.writeAll("    }\n}\n");
    }

    try writer.writeAll("```\n");

    try buf_writer.flush();
}
