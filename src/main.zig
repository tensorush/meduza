const std = @import("std");
const clap = @import("clap");
const meduza = @import("meduza.zig");

const PARAMS = clap.parseParamsComptime(
    \\-r, --remote <STR>   Remote source directory path.
    \\-l, --local <STR>    Local source directory path.
    \\-t, --title <STR>    Title of the Zig codebase.
    \\-o, --out <STR>      Output directory path.
    \\-e, --ext <EXT>      Output file extension.
    \\-i, --info           Log info-level tips.
    \\-h, --help           Print help menu.
    \\
);

const PARSERS = .{
    .EXT = clap.parsers.enumeration(meduza.Ext),
    .STR = clap.parsers.string,
};

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa.deinit() == .leak) {
        @panic("PANIC: Memory leak has occurred!");
    };

    var arena = std.heap.ArenaAllocator.init(gpa.allocator());
    defer arena.deinit();
    const allocator = arena.allocator();

    var diag = clap.Diagnostic{};
    var res = clap.parse(clap.Help, &PARAMS, PARSERS, .{ .diagnostic = &diag }) catch |err| {
        diag.report(std.io.getStdErr().writer(), err) catch {};
        return err;
    };
    defer res.deinit();

    var remote_src_dir_path: []const u8 = "https://github.com/tensorush/meduza/blob/main/src";
    var codebase_title: []const u8 = "Meduza codebase graph generator";
    var local_src_dir_path: []const u8 = "src";
    var out_dir_path: []const u8 = "out";
    var extension = meduza.Ext.md;
    var do_info_log = false;

    if (res.args.remote) |remote| {
        remote_src_dir_path = remote;
    }

    if (res.args.local) |local| {
        local_src_dir_path = local;
    }

    if (res.args.title) |title| {
        codebase_title = title;
    }

    if (res.args.out) |out| {
        out_dir_path = out;
    }

    if (res.args.ext) |ext| {
        extension = ext;
    }

    if (res.args.info != 0) {
        do_info_log = true;
    }

    if (res.args.help != 0) {
        return clap.help(std.io.getStdErr().writer(), clap.Help, &PARAMS, .{});
    }

    try meduza.generate(allocator, remote_src_dir_path, local_src_dir_path, codebase_title, out_dir_path, extension, do_info_log);
}
