```mermaid
---
title: Tigerbeetle database (clients)
---
%%{
    init: {
        'theme': 'base',
        'themeVariables': {
            'fontSize': '18px',
            'fontFamily': 'arial',
            'lineColor': '#F6A516',
            'primaryColor': '#28282B',
            'primaryTextColor': '#F6A516'
        }
    }
}%%
classDiagram
class `clients/docs_samples.zig`
link `clients/docs_samples.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/docs_samples.zig"
class Docs["Docs [struct]"] {
    +directory: String
    +name: String
    +markdown_name: String
    +extension: String
    +proper_name: String
    +description: Markdown
    +prerequisites: Markdown
    +project_file_name: String
    +project_file: Code
    +test_file_name: String
    +install_prereqs: Code
    +current_commit_pre_install_hook: ?*const fn (*std.heap.ArenaAllocator, []const u8, []const u8)
    +current_commit_post_install_hook: ?*const fn (*std.heap.ArenaAllocator, []const u8, []const u8)
    +install_commands: Code
    +install_sample_file: Code
    +build_commands: Code
    +run_commands: Code
    +current_commit_install_commands_hook: ?*const fn (*std.heap.ArenaAllocator, Code)
    +current_commit_build_commands_hook: ?*const fn (*std.heap.ArenaAllocator, Code)
    +current_commit_run_commands_hook: ?*const fn (*std.heap.ArenaAllocator, Code)
    +install_documentation: Markdown
    +examples: Markdown
    +client_object_example: Code
    +client_object_documentation: Markdown
    +create_accounts_example: Code
    +create_accounts_documentation: Markdown
    +create_accounts_errors_example: Code
    +create_accounts_errors_documentation: Markdown
    +account_flags_example: Code
    +account_flags_documentation: Markdown
    +lookup_accounts_example: Code
    +create_transfers_example: Code
    +create_transfers_documentation: Markdown
    +create_transfers_errors_example: Code
    +create_transfers_errors_documentation: Markdown
    +batch_example: Code
    +no_batch_example: Code
    +transfer_flags_documentation: Markdown
    +transfer_flags_link_example: Code
    +transfer_flags_post_example: Code
    +transfer_flags_void_example: Code
    +lookup_transfers_example: Code
    +linked_events_example: Code
    +developer_setup_documentation: Markdown
    +developer_setup_sh_commands: Code
    +developer_setup_pwsh_commands: Code
    +test_source_path: String
    +test_main_prefix: Code
    +test_main_suffix: Code
}
link Docs "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/docs_types.zig#L13"
class Sample["Sample [struct]"] {
    +proper_name: String
    +directory: String
    +short_description: String
    +long_description: String
}
link Sample "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/docs_types.zig#L129"
class `clients/docs_types.zig`
`clients/docs_types.zig` <-- Docs
`clients/docs_types.zig` <-- Sample
link `clients/docs_types.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/docs_types.zig"
class `clients/run_with_tb.zig` {
    -free_port() !u16
    +run_with_tb(arena, commands, cwd) !void
    -error_main() !void
    +main() !void
}
link `clients/run_with_tb.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/run_with_tb.zig"
class MarkdownWriter["MarkdownWriter [struct]"] {
    -buf: *std.ArrayList(u8)
    -writer: std.ArrayList(u8)
    -init(buf) MarkdownWriter
    -header(mw, n, content) void
    -paragraph(mw, content) void
    -code(mw, language, content) void
    -commands(mw, content) void
    -print(mw, fmt, args) void
    -reset(mw) void
    -diffOnDisk(mw, filename) !bool
    -save(mw, filename) !void
}
link MarkdownWriter "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/docs_generate.zig#L22"
class Generator["Generator [struct]"] {
    -arena: *std.heap.ArenaAllocator
    -language: Docs
    -test_file_name: []const u8
    -init(arena, language) !Generator
    -ensure_path(self, path) !void
    -build_file_within_project(self, tmp_dir, file, run_setup_tests) !void
    -print(self, msg) void
    -printf(self, msg, obj) void
    -sprintf(self, msg, obj) []const u8
    -validate_minimal(self, keepTmp) !void
    -validate_aggregate(self, keepTmp) !void
    -make_aggregate_sample(self) ![]const u8
    -generate_language_setup_steps(self, mw, directory_info, include_project_file) void
    -generate_main_readme(self, mw) !void
    -generate_sample_readmes(self, mw) !void
}
link Generator "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/docs_generate.zig#L215"
class `clients/docs_generate.zig` {
    +prepare_directory(arena, language, dir) !void
    +integrate(arena, language, dir, run) !void
    +main() !void
}
`clients/docs_generate.zig` <-- MarkdownWriter
`clients/docs_generate.zig` <-- Generator
link `clients/docs_generate.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/docs_generate.zig"
class TmpDir["TmpDir [struct]"] {
    +dir: std.testing.TmpDir
    +path: []const u8
    +init(arena) !TmpDir
    +deinit(self) void
}
link TmpDir "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/shutil.zig#L129"
class `clients/shutil.zig` {
    +exec(arena, cmd) !std.ChildProcess.ExecResult
    +run_with_env(arena, cmd, env) !void
    +shell_wrap(arena, cmd) ![]const []const u8
    +run_shell_with_env(arena, cmd, env) !void
    +run(arena, cmd) !void
    +run_shell(arena, cmd) !void
    +git_root(arena) ![]const u8
    +script_filename(arena, parts) ![]const u8
    +binary_filename(arena, parts) ![]const u8
    +file_or_directory_exists(f_or_d) bool
    +write_shell_newlines_into_single_line(into, from) !void
}
`clients/shutil.zig` <-- TmpDir
link `clients/shutil.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/shutil.zig"
class `clients/integration.zig` {
    -error_main() !void
    +main() !void
}
link `clients/integration.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/integration.zig"
```
