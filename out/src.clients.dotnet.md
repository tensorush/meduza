```mermaid
---
title: TigerBeetle database (clients/dotnet)
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
class TypeMapping["TypeMapping [str]"] {
    -name: []const u8
    -public
    -internal
    -visibility: enum
    -private_fields: []const []const u8
    -readonly_fields: []const []const u8
    -docs_link: ?[]const u8
    +is_private(self, name) bool
    +is_read_only(self, name) bool
}
link TypeMapping "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/dotnet/dotnet_bindings.zig#L7"
class `dotnet_bindings.zig` {
    test "bindings dotnet"()
    -dotnet_type(Type) []const u8
    -get_mapped_type_name(Type) ?[]const u8
    -to_case(input, case) []const u8
    -emit_enum(buffer, Type, type_info, mapping, int_type, value_fmt) !void
    -emit_struct(buffer, type_info, mapping, size) !void
    -emit_docs(buffer, mapping, field) !void
    +generate_bindings(buffer) !void
    +main() !void
}
`dotnet_bindings.zig` <-- TypeMapping
link `dotnet_bindings.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/dotnet/dotnet_bindings.zig"
class `docs.zig` {
    -current_commit_post_install_hook(arena, sample_directory, root) !void
}
link `docs.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/dotnet/docs.zig"
```
