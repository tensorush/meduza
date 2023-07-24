const std = @import("std");

const MAX_NUM_ARGS: usize = 1 << 4;
const MAX_NUM_DECLS: usize = 1 << 8;
const MAX_NUM_FUNCS: usize = 1 << 8;
const MAX_NUM_TYPES: usize = 1 << 8;
const MAX_FILE_SIZE: usize = 1 << 22;

pub const Error = error{Overflow} || std.mem.Allocator.Error || std.fmt.BufPrintError || std.fs.Dir.DeleteTreeError || std.fs.File.WriteError || std.fs.File.OpenError || std.fs.Dir.OpenError || std.os.PReadError;

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
        Struct,
        Opaque,
        Union,
        Error,
        Enum,
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

pub fn run(
    allocator: std.mem.Allocator,
    remote_src_dir_path: []const u8,
    local_src_dir_path: []const u8,
    codebase_name: []const u8,
    extension: Ext,
) Error!void {
    const cur_dir = std.fs.cwd();

    var buf: [16]u8 = undefined;
    const file_path = try std.fmt.bufPrint(buf[0..], "out/mdz.{s}", .{@tagName(extension)});

    const meduza_file = try cur_dir.createFile(file_path, .{});
    defer meduza_file.close();

    var buf_writer = std.io.bufferedWriter(meduza_file.writer());
    const writer = buf_writer.writer();

    switch (extension) {
        .html => try writer.writeAll("<html>\n\n<body>\n    <pre class=\"mermaid\">\n"),
        .md => try writer.writeAll("```mermaid\n"),
        .mmd => {},
    }

    try writer.print("---\ntitle: {s} codebase\n---\nclassDiagram\n", .{codebase_name});

    var src_dir = try cur_dir.openDir(local_src_dir_path, .{});
    defer src_dir.close();

    var src_dir_iter = try cur_dir.openIterableDir(local_src_dir_path, .{});
    defer src_dir_iter.close();

    var walker = try src_dir_iter.walk(allocator);
    defer walker.deinit();

    while (try walker.next()) |entry| {
        if (entry.kind != .file or !std.mem.eql(u8, ".zig", std.fs.path.extension(entry.basename))) {
            continue;
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

        for (node_tags, 0..) |node_tag, i| {
            switch (node_tag) {
                .test_decl => {
                    const start = starts[main_tokens[i]];
                    const end = starts[main_tokens[i - 1]] - 1;
                    if (start > 0 and src[start - 1] == ' ') {
                        if (std.mem.eql(u8, "     ", src[start - 5 .. start])) {
                            nested_container_decls.appendAssumeCapacity(.{ .is_test = true, .start = start, .end = end });
                        } else {
                            nested_decls.appendAssumeCapacity(.{ .is_test = true, .start = start, .end = end });
                        }
                    } else {
                        file_decls.appendAssumeCapacity(.{ .is_test = true, .start = start, .end = end });
                    }
                },
                .fn_proto_simple, .fn_proto_multi, .fn_proto_one, .fn_proto => {
                    const start = starts[main_tokens[i] + 1];
                    if (src[start] == '(') {
                        continue;
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
                    var rt_start: std.zig.Ast.ByteOffset = undefined;
                    args.appendAssumeCapacity(.{ .start = start, .end = starts[main_tokens[i] + 2] });
                    for (token_tags[main_tokens[i] + 3 .. end_token_idx], main_tokens[i] + 3..end_token_idx) |token_tag, j| {
                        if (token_tag == .colon) {
                            args.appendAssumeCapacity(.{ .start = starts[j - 1], .end = starts[j] });
                        } else if (token_tag == .r_paren) {
                            rt_start = starts[j + 1];
                            break;
                        }
                    }
                    for (src[rt_start..rt_end]) |*byte| {
                        switch (byte.*) {
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
                    if (node_tags[i - 1] != .root) {
                        if (token_tags[first_token_idx] == .keyword_pub) {
                            if (src[starts[first_token_idx] - 1] == ' ') {
                                if (std.mem.eql(u8, "     ", src[starts[first_token_idx] - 5 .. starts[first_token_idx]])) {
                                    nested_container_fn_protos.appendAssumeCapacity(.{ .is_pub = true, .args = args, .rt_start = rt_start, .rt_end = rt_end });
                                } else {
                                    nested_fn_protos.appendAssumeCapacity(.{ .is_pub = true, .args = args, .rt_start = rt_start, .rt_end = rt_end });
                                }
                            } else {
                                file_fn_protos.appendAssumeCapacity(.{ .is_pub = true, .args = args, .rt_start = rt_start, .rt_end = rt_end });
                            }
                        } else {
                            if (src[starts[first_token_idx] - 1] == ' ') {
                                if (std.mem.eql(u8, "     ", src[starts[first_token_idx] - 5 .. starts[first_token_idx]])) {
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
                    const start = starts[main_tokens[i] - 2];
                    const end = starts[main_tokens[i] - 1] - 1;
                    try writer.print("class {s} {c}\n", .{ src[start..end], '{' });
                    var token_idx = main_tokens[i] + 2;
                    var token_tag = token_tags[token_idx];
                    while (token_tag != .r_brace) : (token_tag = token_tags[token_idx]) {
                        if (token_tag == .identifier) {
                            const val_start = starts[token_idx];
                            token_idx += 1;
                            const val_end = starts[token_idx] + 1;
                            if (is_pub) {
                                try writer.print("    +{s}\n", .{src[val_start..val_end]});
                            } else {
                                try writer.print("    -{s}\n", .{src[val_start..val_end]});
                            }
                        }
                        token_idx += 1;
                    }
                    if (src[starts[first_token_idx] - 1] == ' ') {
                        nested_containers.appendAssumeCapacity(.{ .tag = .Error, .start = start, .end = end });
                    } else {
                        file_containers.appendAssumeCapacity(.{ .tag = .Error, .start = start, .end = end });
                    }
                    var line_num: usize = 1;
                    for (src[0..start]) |byte| {
                        if (byte == '\n') {
                            line_num += 1;
                        }
                    }
                    try writer.print("link {s} \"{s}/{s}#L{d}\"\n", .{ src[start..end], remote_src_dir_path, entry.path, line_num });
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
                        's' => .Struct,
                        'o' => .Opaque,
                        'u' => .Union,
                        'e' => .Enum,
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
                    try writer.print("class {s} {c}\n", .{ src[start..end], '{' });
                    if (src[starts[first_token_idx] - 1] == ' ') {
                        for (nested_container_decls.constSlice()) |decl| {
                            try decl.print(is_pub, src, writer);
                        }
                        try nested_container_decls.resize(0);
                        for (nested_container_fn_protos.constSlice()) |fn_proto| {
                            try fn_proto.print(src, writer);
                        }
                        try nested_container_fn_protos.resize(0);
                    } else {
                        for (nested_decls.constSlice()) |decl| {
                            try decl.print(is_pub, src, writer);
                        }
                        try nested_decls.resize(0);
                        for (nested_fn_protos.constSlice()) |fn_proto| {
                            try fn_proto.print(src, writer);
                        }
                        try nested_fn_protos.resize(0);
                    }
                    try writer.writeAll("}\n");
                    for (nested_containers.constSlice()) |container| {
                        try writer.print("{s} <-- {s}\n", .{ src[start..end], src[container.start..container.end] });
                    }
                    try nested_containers.resize(0);
                    if (src[starts[first_token_idx] - 1] == ' ') {
                        nested_containers.appendAssumeCapacity(.{ .tag = tag, .start = start, .end = end });
                    } else {
                        file_containers.appendAssumeCapacity(.{ .tag = tag, .start = start, .end = end });
                    }
                    var line_num: usize = 1;
                    for (src[0..start]) |byte| {
                        if (byte == '\n') {
                            line_num += 1;
                        }
                    }
                    try writer.print("link {s} \"{s}/{s}#L{d}\"\n", .{ src[start..end], remote_src_dir_path, entry.path, line_num });
                },
                .container_field_init, .container_field_align, .container_field => {
                    const start = starts[main_tokens[i]];
                    var end: u32 = @intCast(std.mem.indexOfAnyPos(u8, src, start, "=,}").?);
                    switch (src[end]) {
                        '=', '}' => end -= 1,
                        else => {},
                    }
                    std.mem.replaceScalar(u8, src[start..end], '{', '[');
                    std.mem.replaceScalar(u8, src[start..end], '}', ']');
                    if (node_tags[i - 2] != .root and src[start - 1] == ' ') {
                        if (std.mem.eql(u8, "     ", src[start - 5 .. start])) {
                            nested_container_decls.appendAssumeCapacity(.{ .is_test = false, .start = start, .end = end });
                        } else {
                            nested_decls.appendAssumeCapacity(.{ .is_test = false, .start = start, .end = end });
                        }
                    } else {
                        file_decls.appendAssumeCapacity(.{ .is_test = false, .start = start, .end = end });
                    }
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

    switch (extension) {
        .html => {
            const html_end =
                \\    </pre>
                \\    <script type="module">
                \\        import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10.2.4/dist/mermaid.esm.min.mjs';
                \\        mermaid.initialize({});
                \\    </script>
                \\</body>
                \\
                \\</html>
                \\
            ;
            try writer.writeAll(html_end);
        },
        .md => try writer.writeAll("```\n"),
        .mmd => {},
    }

    try buf_writer.flush();
}
