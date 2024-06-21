const std = @import("std");

pub fn build(b: *std.Build) void {
    // Dependencies
    const clap_dep = b.dependency("clap", .{});
    const clap_mod = clap_dep.module("clap");

    // Executable
    const exe_step = b.step("exe", "Run executable");

    const exe = b.addExecutable(.{
        .name = "meduza",
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
        .root_source_file = b.path("src/main.zig"),
        .version = .{ .major = 1, .minor = 10, .patch = 0 },
    });
    exe.root_module.addImport("clap", clap_mod);
    b.installArtifact(exe);

    const exe_run = b.addRunArtifact(exe);
    if (b.args) |args| {
        exe_run.addArgs(args);
    }

    exe_step.dependOn(&exe_run.step);
    b.default_step.dependOn(exe_step);

    // Formatting checks
    const fmt_step = b.step("fmt", "Run formatting checks");

    const fmt = b.addFmt(.{
        .paths = &.{
            "src/",
            "build.zig",
        },
        .check = true,
    });
    fmt_step.dependOn(&fmt.step);
    b.default_step.dependOn(fmt_step);
}
