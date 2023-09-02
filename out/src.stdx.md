```mermaid
---
title: TigerBeetle database (stdx)
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
class `bounded_array.zig` {
    +BoundedArray(T, capacity) type
}
link `bounded_array.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/stdx/bounded_array.zig"
```
