const std = @import("std");
const clap = @import("clap");
const meduza = @import("meduza.zig");

const PARAMS = clap.parseParamsComptime(
    \\-r, --remote <STR>   Remote source directory path.
    \\-l, --local <STR>    Local source directory path.
    \\-t, --title <STR>    Title of the Zig codebase.
    \\-o, --out <STR>      Output directory path.
    \\-e, --ext <EXT>      Output file extension.
    \\-h, --help           Help menu.
    \\
);

const PARSERS = .{
    .EXT = clap.parsers.enumeration(meduza.Ext),
    .STR = clap.parsers.string,
};

const Error = meduza.Error || std.process.ArgIterator.InitError;

pub fn main() Error!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa.deinit() == .leak) {
        @panic("PANIC: Memory leak has occurred!");
    };

    var arena = std.heap.ArenaAllocator.init(gpa.allocator());
    defer arena.deinit();
    var allocator = arena.allocator();

    var res = clap.parse(clap.Help, &PARAMS, PARSERS, .{}) catch unreachable;
    defer res.deinit();

    var remote_src_dir_path: []const u8 = "https://github.com/tensorush/meduza/blob/main/src";
    var codebase_title: []const u8 = "Meduza codebase graph generator";
    var local_src_dir_path: []const u8 = "src";
    var out_dir_path: []const u8 = "out";
    var extension = meduza.Ext.md;

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

    if (res.args.help != 0) {
        return clap.help(std.io.getStdErr().writer(), clap.Help, &PARAMS, .{});
    }

    try meduza.generate(allocator, remote_src_dir_path, local_src_dir_path, codebase_title, out_dir_path, extension);
}
