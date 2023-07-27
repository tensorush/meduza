```mermaid
---
title: Tigerbeetle database (clients/c/tb_client)
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
class Signal["Signal [struct]"] {
    +io: *IO
    +server_socket: os.socket_t
    +accept_socket: os.socket_t
    +connect_socket: os.socket_t
    +completion: IO.Completion
    +recv_buffer: [1]u8
    +send_buffer: [1]u8
    +on_signal_fn: *const fn (*Signal)
    +state: Atomic(enum(u8)
    +init(self, io, on_signal_fn) !void
    +deinit(self) void
    +notify(self) void
    -wake(self) void
    -wait(self) void
    -on_recv(self, completion, result) void
    -on_timeout(self, completion, result) void
    -on_signal(self) void
}
link Signal "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/c/tb_client/signal.zig#L15"
class `clients/c/tb_client/signal.zig`
`clients/c/tb_client/signal.zig` <-- Signal
link `clients/c/tb_client/signal.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/c/tb_client/signal.zig"
class `clients/c/tb_client/echo_client.zig` {
    +EchoClient(StateMachine_, MessageBus) type
}
link `clients/c/tb_client/echo_client.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/c/tb_client/echo_client.zig"
class `clients/c/tb_client/thread.zig` {
    +ThreadType(Context) type
}
link `clients/c/tb_client/thread.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/c/tb_client/thread.zig"
class Status["Status [enum]"] {
    +ok
    +too_much_data
    +invalid_operation
    +invalid_data_size
}
link Status "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/c/tb_client/packet.zig#L13"
class SubmissionStack["SubmissionStack [struct]"] {
    +pushed: Atomic(?*Packet)
    +popped: ?*Packet
    +push(self, packet) void
    +pop(self) ?*Packet
}
link SubmissionStack "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/c/tb_client/packet.zig#L22"
class ConcurrentStack["ConcurrentStack [struct]"] {
    +mutex: std.Thread.Mutex
    +head: ?*Packet
    +push(self, packet) void
    +pop(self) ?*Packet
}
link ConcurrentStack "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/c/tb_client/packet.zig#L49"
class Packet["Packet [struct]"] {
    +next: ?*Packet
    +user_data: ?*anyopaque
    +operation: u8
    +status: Status
    +data_size: u32
    +data: ?*anyopaque
}
Packet <-- Status
Packet <-- SubmissionStack
Packet <-- ConcurrentStack
link Packet "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/c/tb_client/packet.zig#L5"
class `clients/c/tb_client/packet.zig`
`clients/c/tb_client/packet.zig` <-- Packet
link `clients/c/tb_client/packet.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/c/tb_client/packet.zig"
class ContextImplementation["ContextImplementation [struct]"] {
    +acquire_packet_fn: *const fn (*ContextImplementation, out: *?*Packet)
    +release_packet_fn: *const fn (*ContextImplementation, *Packet)
    +submit_fn: *const fn (*ContextImplementation, *Packet)
    +deinit_fn: *const fn (*ContextImplementation)
}
link ContextImplementation "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/c/tb_client/context.zig#L29"
class PacketAcquireStatus["PacketAcquireStatus [enum]"] {
    +ok
    +concurrency_max_exceeded
    +shutdown
}
link PacketAcquireStatus "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/c/tb_client/context.zig#L45"
class `clients/c/tb_client/context.zig` {
    +ContextType(Client) type
}
`clients/c/tb_client/context.zig` <-- ContextImplementation
`clients/c/tb_client/context.zig` <-- PacketAcquireStatus
link `clients/c/tb_client/context.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/c/tb_client/context.zig"
```
