const std = @import("std");
const clap = @import("clap");
const meduza = @import("meduza.zig");

const PARAMS = clap.parseParamsComptime(
    \\-r, --remote <STR>   Remote source directory path (required).
    \\-l, --local <STR>    Local source directory path (required).
    \\-n, --name <STR>     Codebase name (required).
    \\-e, --ext <EXT>      File extension: md, mmd, or html (default: md).
    \\-h, --help           Display help.
    \\
);

const Error = meduza.Error || std.process.ArgIterator.InitError;

const PARSERS = .{
    .EXT = clap.parsers.enumeration(meduza.Ext),
    .STR = clap.parsers.string,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa.deinit() == .leak) {
        @panic("PANIC: Memory leak has occurred!");
    };

    var arena = std.heap.ArenaAllocator.init(gpa.allocator());
    defer arena.deinit();
    var allocator = arena.allocator();

    var res = try clap.parse(clap.Help, &PARAMS, PARSERS, .{});
    defer res.deinit();

    var remote_src_dir_path: []const u8 = "https://github.com/tensorush/zigzag/blob/main/src";
    var local_src_dir_path: []const u8 = "zigzag/src";
    var codebase_name: []const u8 = "Zigzag path tracer";
    var extension = meduza.Ext.md;

    if (res.args.remote) |remote| {
        remote_src_dir_path = remote;
    } else {
        return clap.help(std.io.getStdErr().writer(), clap.Help, &PARAMS, .{});
    }

    if (res.args.local) |local| {
        local_src_dir_path = local;
    } else {
        return clap.help(std.io.getStdErr().writer(), clap.Help, &PARAMS, .{});
    }

    if (res.args.name) |name| {
        codebase_name = name;
    } else {
        return clap.help(std.io.getStdErr().writer(), clap.Help, &PARAMS, .{});
    }

    if (res.args.ext) |ext| {
        extension = ext;
    }

    if (res.args.help != 0) {
        return clap.help(std.io.getStdErr().writer(), clap.Help, &PARAMS, .{});
    }

    try meduza.run(allocator, remote_src_dir_path, local_src_dir_path, codebase_name, extension);
}
