const std = @import("std");
const clap = @import("clap");
const meduza = @import("meduza.zig");

const PARAMS = clap.parseParamsComptime(
    \\-r, --remote <str>   Remote source directory path (required).
    \\-l, --local <str>    Local source directory path (required).
    \\-t, --title <str>    Title of the Zig codebase (required).
    \\-o, --out <str>      Output file path (def: ./out/mdz.md).
    \\-h, --help           Help menu.
    \\
);

const Error = meduza.Error || std.process.ArgIterator.InitError;

pub fn main() Error!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa.deinit() == .leak) {
        @panic("PANIC: Memory leak has occurred!");
    };

    var arena = std.heap.ArenaAllocator.init(gpa.allocator());
    defer arena.deinit();
    var allocator = arena.allocator();

    var res = clap.parse(clap.Help, &PARAMS, clap.parsers.default, .{}) catch unreachable;
    defer res.deinit();

    var remote_src_dir_path: []const u8 = undefined;
    var local_src_dir_path: []const u8 = undefined;
    var codebase_title: []const u8 = undefined;
    var out_file_path: []const u8 = "./out/mdz.md";

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

    if (res.args.title) |title| {
        codebase_title = title;
    } else {
        return clap.help(std.io.getStdErr().writer(), clap.Help, &PARAMS, .{});
    }

    if (res.args.out) |out| {
        out_file_path = out;
    }

    if (res.args.help != 0) {
        return clap.help(std.io.getStdErr().writer(), clap.Help, &PARAMS, .{});
    }

    try meduza.generate(allocator, remote_src_dir_path, local_src_dir_path, codebase_title, out_file_path);
}
