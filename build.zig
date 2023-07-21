const std = @import("std");

pub fn build(b: *std.Build) void {
    const root_source_file = std.Build.FileSource.relative("src/main.zig");

    // Meduza codebase layout generator
    const meduza_step = b.step("meduza", "Run Meduza codebase layout generator");

    const meduza = b.addExecutable(.{
        .name = "meduza",
        .root_source_file = root_source_file,
        .target = b.standardTargetOptions(.{}),
        .optimize = .Debug,
        .version = .{ .major = 1, .minor = 0, .patch = 0 },
    });
    b.installArtifact(meduza);

    const meduza_run = b.addRunArtifact(meduza);
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
