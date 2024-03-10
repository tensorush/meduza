const std = @import("std");
const clap = @import("clap");
const meduza = @import("meduza.zig");

const PARAMS = clap.parseParamsComptime(
    \\-e, --ext <EXT>      Output file extension.
    \\-i, --info           Enable info logging.
    \\-h, --help           Display help menu.
    \\<STR>                Remote source directory path.
    \\<STR>                Local source directory path.
    \\<STR>                Title of the Zig codebase.
    \\<STR>                Output directory path.
    \\
);

const PARSERS = .{
    .EXT = clap.parsers.enumeration(meduza.Ext),
    .STR = clap.parsers.string,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa.deinit() == .leak) {
        @panic("Memory leak has occurred!");
    };

    var arena = std.heap.ArenaAllocator.init(gpa.allocator());
    defer arena.deinit();
    const allocator = arena.allocator();

    var diag = clap.Diagnostic{};
    var res = clap.parse(clap.Help, &PARAMS, PARSERS, .{ .allocator = allocator, .diagnostic = &diag }) catch |err| {
        diag.report(std.io.getStdErr().writer(), err) catch {};
        return err;
    };
    defer res.deinit();

    var remote_src_dir_path: []const u8 = "https://github.com/tensorush/meduza/blob/main/src";
    var codebase_title: []const u8 = "Meduza codebase graph generator";
    var local_src_dir_path: []const u8 = "src";
    var out_dir_path: []const u8 = "out";
    var extension = meduza.Ext.md;
    var do_log = false;

    if (res.positionals.len > 0) {
        remote_src_dir_path = res.positionals[0];
        codebase_title = res.positionals[1];
        local_src_dir_path = res.positionals[2];
        out_dir_path = res.positionals[3];
    }

    if (res.args.ext) |ext| {
        extension = ext;
    }

    if (res.args.info != 0) {
        do_log = true;
    }

    if (res.args.help != 0) {
        return clap.help(std.io.getStdErr().writer(), clap.Help, &PARAMS, .{});
    }

    try meduza.generate(allocator, remote_src_dir_path, local_src_dir_path, codebase_title, out_dir_path, extension, do_log);
}
