```mermaid
---
title: Meduza codebase graph generator (src)
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
class `main.zig` {
    +main() anyerror!void
}
link `main.zig` "https://github.com/tensorush/meduza/blob/main/src/main.zig"
class Ext["Ext [enu]"] {
    +html
    +mmd
    +md
}
link Ext "https://github.com/tensorush/meduza/blob/main/src/meduza.zig#L22"
class Tag["Tag [enu]"] {
    -str
    -opa
    -uni
    -err
    -enu
}
link Tag "https://github.com/tensorush/meduza/blob/main/src/meduza.zig#L37"
class Type["Type [str]"] {
    -start: std.zig.Ast.ByteOffset
    -end: std.zig.Ast.ByteOffset
    -tag: Tag
}
Type <-- Tag
link Type "https://github.com/tensorush/meduza/blob/main/src/meduza.zig#L32"
class Func["Func [str]"] {
    -start: std.zig.Ast.ByteOffset
    -end: std.zig.Ast.ByteOffset
    -args: std.BoundedArray(struct [ start: std.zig.Ast.ByteOffset, end: std.zig.Ast.ByteOffset ], MAX_NUM_ARGS)
    -rt_start: std.zig.Ast.ByteOffset
    -rt_end: std.zig.Ast.ByteOffset
    -is_pub: bool
    -print(self, src, writer) @TypeOf(writer).Error!void
}
link Func "https://github.com/tensorush/meduza/blob/main/src/meduza.zig#L52"
class Tag["Tag [enu]"] {
    -fld
    -tst
}
link Tag "https://github.com/tensorush/meduza/blob/main/src/meduza.zig#L90"
class Decl["Decl [str]"] {
    -start: std.zig.Ast.ByteOffset
    -end: std.zig.Ast.ByteOffset
    -tag: Tag
    -print(self, is_pub, src, writer) @TypeOf(writer).Error!void
}
Decl <-- Tag
link Decl "https://github.com/tensorush/meduza/blob/main/src/meduza.zig#L85"
class `meduza.zig` {
    +generate(allocator, remote_src_dir_path, local_src_dir_path, codebase_title, out_dir_path, extension, do_info_log) Error!void
    -parseFunc(func, src, first_token_start, file_funcs, top_type_funcs, nested_type_funcs) bool
    -printDecls(is_pub, do_resize, src, decls, funcs, writer) (error[Overflow] || @TypeOf(writer).Error)!void
    -writePrologue(codebase_title, out_file_basename, extension, writer) std.fs.File.WriteError!void
    -writeEpilogue(extension, writer) std.fs.File.WriteError!void
}
`meduza.zig` <-- Ext
`meduza.zig` <-- Type
`meduza.zig` <-- Func
`meduza.zig` <-- Decl
link `meduza.zig` "https://github.com/tensorush/meduza/blob/main/src/meduza.zig"
```
