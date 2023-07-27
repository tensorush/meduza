const std = @import("std");

pub fn build(b: *std.Build) void {
    const root_source_file = std.Build.FileSource.relative("src/main.zig");

    // Dependencies
    const clap_dep = b.dependency("clap", .{});
    const clap_mod = clap_dep.module("clap");

    // Meduza codebase graph generator
    const meduza_step = b.step("meduza", "Run Meduza codebase graph generator");

    const meduza = b.addExecutable(.{
        .name = "meduza",
        .root_source_file = root_source_file,
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
        .version = .{ .major = 1, .minor = 6, .patch = 0 },
    });
    meduza.addModule("clap", clap_mod);
    b.installArtifact(meduza);

    const meduza_run = b.addRunArtifact(meduza);
    if (b.args) |args| {
        meduza_run.addArgs(args);
    }

    meduza_step.dependOn(&meduza_run.step);
    b.default_step.dependOn(meduza_step);

    // Lints
    const lints_step = b.step("lint", "Run lints");

    const lints = b.addFmt(.{
        .paths = &[_][]const u8{ "src", "build.zig" },
        .check = true,
    });

    lints_step.dependOn(&lints.step);
    b.default_step.dependOn(lints_step);
}
