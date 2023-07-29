```mermaid
---
title: Tigerbeetle database (tigerbeetle/src)
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
class AOFEntryMetadata["AOFEntryMetadata [str]"] {
    +primary: u64
    +replica: u64
    +reserved: [4064]u8
}
link AOFEntryMetadata "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/aof.zig#L26"
class AOFEntry["AOFEntry [str]"] {
    +magic_number: u128
    +metadata: AOFEntryMetadata
    +message: [constants.message_size_max]u8 align(constants.sector_size)
    +calculate_disk_size(self) u64
    +header(self) *Header
    +to_message(self, target) void
    +from_message(self, message, options, last_checksum) void
}
link AOFEntry "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/aof.zig#L37"
class AOF["AOF [str]"] {
    +fd: os.fd_t
    +last_checksum: ?u128
    +from_absolute_path(absolute_path) !AOF
    -init(dir_fd, relative_path) !AOF
    +close(self) void
    +write(self, message, options) !void
    +IteratorType(File) type
    +iterator(path) !Iterator
}
link AOF "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/aof.zig#L120"
class AOFReplayClient["AOFReplayClient [str]"] {
    +client: *Client
    +io: *IO
    +message_pool: *MessagePool
    +inflight_message: ?*Message
    +init(allocator, raw_addresses) !Self
    +deinit(self, allocator) void
    +replay(self, aof) !void
    -replay_callback(user_data, operation, result) void
}
link AOFReplayClient "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/aof.zig#L288"
class EntryInfo["EntryInfo [str]"] {
    -aof: *AOF.Iterator
    -index: u64
    -size: u64
    -checksum: u128
    -parent: u128
}
link EntryInfo "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/aof.zig#L411"
class `aof.zig` {
    test "aof write / read"()
    test "aof merge"()
    +aof_merge(allocator, input_paths, output_path) !void
    +main() !void
}
`aof.zig` <-- AOFEntryMetadata
`aof.zig` <-- AOFEntry
`aof.zig` <-- AOF
`aof.zig` <-- AOFReplayClient
link `aof.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/aof.zig"
class CliArgs["CliArgs [uni]"] {
    -bytes: u32
    -memcpy: struct
    -funcsize
}
link CliArgs "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/copyhound.zig#L40"
class T["T [str]"] {
    -check(line, want) !void
}
link T "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/copyhound.zig#L170"
class `copyhound.zig` {
    test "extract_function_name"()
    test "extract_memcpy_size"()
    +main() !void
    -extract_function_name(define, buf) ?[]const u8
    -extract_memcpy_size(memcpy_call) ?u32
    +fatal(fmt_string, args) noreturn
}
`copyhound.zig` <-- CliArgs
link `copyhound.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/copyhound.zig"
class `iops.zig` {
    test "IOPS"()
    +IOPS(T, size) type
}
link `iops.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/iops.zig"
class BuildOptions["BuildOptions [str]"] {
    -config_base: ConfigBase
    -config_log_level: std.log.Level
    -tracer_backend: TracerBackend
    -hash_log_mode: HashLogMode
    -config_aof_record: bool
    -config_aof_recovery: bool
}
link BuildOptions "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/config.zig#L15"
class Config["Config [str]"] {
    +cluster: ConfigCluster
    +process: ConfigProcess
}
link Config "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/config.zig#L58"
class ConfigProcess["ConfigProcess [str]"] {
    -log_level: std.log.Level
    -tracer_backend: TracerBackend
    -hash_log_mode: HashLogMode
    -verify: bool
    -port: u16
    -address: []const u8
    -memory_size_max_default: u64
    -cache_accounts_size_default: usize
    -cache_transfers_size_default: usize
    -cache_transfers_posted_size_default: usize
    -client_request_queue_max: usize
    -lsm_manifest_node_size: usize
    -connection_delay_min_ms: u64
    -connection_delay_max_ms: u64
    -tcp_backlog: u31
    -tcp_rcvbuf: c_int
    -tcp_keepalive: bool
    -tcp_keepidle: c_int
    -tcp_keepintvl: c_int
    -tcp_keepcnt: c_int
    -tcp_nodelay: bool
    -direct_io: bool
    -direct_io_required: bool
    -journal_iops_read_max: usize
    -journal_iops_write_max: usize
    -client_replies_iops_read_max: usize
    -client_replies_iops_write_max: usize
    -tick_ms: u63
    -rtt_ms: u64
    -rtt_multiple: u8
    -backoff_min_ms: u64
    -backoff_max_ms: u64
    -clock_offset_tolerance_max_ms: u64
    -clock_epoch_max_ms: u64
    -clock_synchronization_window_min_ms: u64
    -clock_synchronization_window_max_ms: u64
    -grid_iops_read_max: u64
    -grid_iops_write_max: u64
    -grid_repair_request_max: usize
    -grid_repair_reads_max: usize
    -grid_repair_writes_max: usize
    -grid_cache_size_default: u64
    -aof_record: bool
    -aof_recovery: bool
    -sync_trailer_message_body_size_max: ?usize
}
link ConfigProcess "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/config.zig#L73"
class ConfigCluster["ConfigCluster [str]"] {
    -cache_line_size: comptime_int
    -clients_max: usize
    -pipeline_prepare_queue_max: usize
    -view_change_headers_suffix_max: usize
    -quorum_replication_max: u8
    -journal_slot_count: usize
    -message_size_max: usize
    -superblock_copies: comptime_int
    -storage_size_max: u64
    -block_size: comptime_int
    -lsm_levels: u7
    -lsm_growth_factor: u32
    -lsm_batch_multiple: comptime_int
    -lsm_snapshots_max: usize
    -lsm_value_to_key_layout_ratio_min: comptime_int
    +message_size_max_min(clients_max) usize
    +checksum(config) u128
}
link ConfigCluster "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/config.zig#L129"
class ConfigBase["ConfigBase [enu]"] {
    +production
    +development
    +test_min
    +default
}
link ConfigBase "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/config.zig#L182"
class TracerBackend["TracerBackend [enu]"] {
    +none
    +tracy
}
link TracerBackend "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/config.zig#L189"
class HashLogMode["HashLogMode [enu]"] {
    +none
    +create
    +check
}
link HashLogMode "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/config.zig#L195"
class configs["configs [str]"]
link configs "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/config.zig#L201"
class `config.zig` {
    -launder_type(T, value) T
}
`config.zig` <-- BuildOptions
`config.zig` <-- Config
`config.zig` <-- ConfigProcess
`config.zig` <-- ConfigCluster
`config.zig` <-- ConfigBase
`config.zig` <-- TracerBackend
`config.zig` <-- HashLogMode
`config.zig` <-- configs
link `config.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/config.zig"
class `tidy.zig` {
    test "tidy: lines are under 100 characters long"()
    -is_naughty(path) bool
    -find_long_line(file_text) !?usize
    -is_url(line) bool
    -parse_multiline_string(line) ?[]const u8
}
link `tidy.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tidy.zig"
class `io.zig` {
    test "I/O"()
    +buffer_limit(buffer_len) usize
}
link `io.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/io.zig"
class `ewah.zig` {
    test "ewah encode→decode cycle"()
    test "ewah Word=u8"()
    test "ewah Word=u16"()
    +ewah(Word) type
    -test_decode_with_word(Word) !void
    -test_decode(Word, encoded_expect_words) !void
}
link `ewah.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/ewah.zig"
class Time["Time [str]"] {
    +monotonic_guard: u64
    +monotonic(self) u64
    +realtime(_) i64
    +tick(_) void
}
link Time "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/time.zig#L9"
class `time.zig`
`time.zig` <-- Time
link `time.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/time.zig"
class State["State [enu]"] {
    -init
    -static
    -deinit
}
link State "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/static_allocator.zig#L14"
class `static_allocator.zig` {
    +parent_allocator: mem.Allocator
    +state: State
    +init(parent_allocator) Self
    +deinit(self) void
    +transition_from_init_to_static(self) void
    +transition_from_static_to_deinit(self) void
    +allocator(self) mem.Allocator
    -alloc(self, len, ptr_align, len_align, ret_addr) error[OutOfMemory]![]u8
    -resize(self, buf, buf_align, new_len, len_align, ret_addr) ?usize
    -free(self, buf, buf_align, ret_addr) void
}
`static_allocator.zig` <-- State
link `static_allocator.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/static_allocator.zig"
class ProcessType["ProcessType [enu]"] {
    +replica
    +client
}
link ProcessType "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L55"
class Zone["Zone [enu]"] {
    +superblock
    +wal_headers
    +wal_prepares
    +client_replies
    +grid
    +offset(zone, offset_logical) u64
    +start(zone) u64
    +size(zone) ?u64
}
link Zone "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L57"
class Command["Command [enu]"] {
    +reserved
    +ping
    +pong
    +ping_client
    +pong_client
    +request
    +prepare
    +prepare_ok
    +reply
    +commit
    +start_view_change
    +do_view_change
    +start_view
    +request_start_view
    +request_headers
    +request_prepare
    +request_reply
    +headers
    +eviction
    +request_blocks
    +block
    +request_sync_manifest
    +request_sync_free_set
    +request_sync_client_sessions
    +sync_manifest
    +sync_free_set
    +sync_client_sessions
}
link Command "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L109"
class Operation["Operation [enu]"] {
    +reserved
    +root
    +register
    +reconfigure
    +_
    +from(StateMachine, op) Operation
    +cast(self, StateMachine) StateMachine.Operation
    +valid(self, StateMachine) bool
    +vsr_reserved(self) bool
    +tag_name(self, StateMachine) []const u8
    -check_state_machine_operations(Op) void
}
link Operation "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L156"
class Header["Header [str]"] {
    test "empty checksum"()
    +checksum: u128
    +checksum_body: u128
    +parent: u128
    +client: u128
    +context: u128
    +request: u32
    +cluster: u32
    +epoch: u32
    +view: u32
    +op: u64
    +commit: u64
    +timestamp: u64
    +size: u32
    +replica: u8
    +command: Command
    +operation: Operation
    +version: u8
    +calculate_checksum(self) u128
    +calculate_checksum_body(self, body) u128
    +set_checksum(self) void
    +set_checksum_body(self, body) void
    +valid_checksum(self) bool
    +valid_checksum_body(self, body) bool
    +invalid(self) ?[]const u8
    -invalid_reserved(self) ?[]const u8
    -invalid_ping(self) ?[]const u8
    -invalid_pong(self) ?[]const u8
    -invalid_ping_client(self) ?[]const u8
    -invalid_pong_client(self) ?[]const u8
    -invalid_request(self) ?[]const u8
    -invalid_prepare(self) ?[]const u8
    -invalid_prepare_ok(self) ?[]const u8
    -invalid_reply(self) ?[]const u8
    -invalid_commit(self) ?[]const u8
    -invalid_start_view_change(self) ?[]const u8
    -invalid_do_view_change(self) ?[]const u8
    -invalid_start_view(self) ?[]const u8
    -invalid_request_start_view(self) ?[]const u8
    -invalid_request_headers(self) ?[]const u8
    -invalid_request_prepare(self) ?[]const u8
    -invalid_request_reply(self) ?[]const u8
    -invalid_request_blocks(self) ?[]const u8
    -invalid_headers(self) ?[]const u8
    -invalid_eviction(self) ?[]const u8
    -invalid_block(self) ?[]const u8
    -invalid_request_sync_manifest(self) ?[]const u8
    -invalid_request_sync_free_set(self) ?[]const u8
    -invalid_request_sync_client_sessions(self) ?[]const u8
    -invalid_sync_manifest(self) ?[]const u8
    -invalid_sync_free_set(self) ?[]const u8
    -invalid_sync_client_sessions(self) ?[]const u8
    +peer_type(self) enum [ unknown, replica, client ]
    +reserved(cluster, slot) Header
    +root_prepare(cluster) Header
}
link Header "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L232"
class BlockRequest["BlockRequest [str]"] {
    +block_checksum: u128
    +block_address: u64
    +reserved: [8]u8
}
link BlockRequest "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L936"
class ReconfigurationRequest["ReconfigurationRequest [str]"] {
    +members: Members
    +epoch: u32
    +replica_count: u8
    +standby_count: u8
    +reserved: [54]u8
    +result: ReconfigurationResult
    +validate(request, current) ReconfigurationResult
}
link ReconfigurationRequest "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L948"
class ReconfigurationResult["ReconfigurationResult [enu]"] {
    +reserved
    +ok
    +replica_count_zero
    +replica_count_max_exceeded
    +standby_count_max_exceeded
    +members_invalid
    +members_count_invalid
    +reserved_field
    +result_must_be_reserved
    +epoch_in_the_past
    +epoch_in_the_future
    +different_replica_count
    +different_standby_count
    +different_member_set
    +configuration_applied
    +configuration_conflict
    +configuration_is_no_op
}
link ReconfigurationResult "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L1037"
class Test["Test [str]"] {
    -members: Members
    -epoch: u32
    -replica_count: u8
    -standby_count: u8
    -tested: ResultSet
    -check(t, request, expected) !void
    -to_members(m) Members
}
link Test "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L1091"
class Timeout["Timeout [str]"] {
    +name: []const u8
    +id: u128
    +after: u64
    +attempts: u8
    +rtt: u64
    +rtt_multiple: u8
    +ticks: u64
    +ticking: bool
    +backoff(self, random) void
    +fired(self) bool
    +reset(self) void
    +set_after_for_rtt_and_attempts(self, random) void
    +set_rtt(self, rtt_ticks) void
    +start(self) void
    +stop(self) void
    +tick(self) void
}
Timeout <-- Test
link Timeout "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L1194"
class IdSeed["IdSeed [str]"] {
    -raw: []const u8
    -addresses: []const std.net.Address
    -raw: []const u8
    -err: anyerror![]std.net.Address
    -cluster_config_checksum: u128 align(1)
    -cluster: u32 align(1)
    -replica: u8 align(1)
}
link IdSeed "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L1594"
class Headers["Headers [str]"] {
    -dvc_blank(op) Header
    +dvc_header_type(header) enum [ blank, valid ]
}
Headers <-- IdSeed
link Headers "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L1641"
class ViewChangeCommand["ViewChangeCommand [enu]"] {
    +do_view_change
    +start_view
}
link ViewChangeCommand "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L1669"
class ViewRange["ViewRange [str]"] {
    -min: u32
    -max: u32
    +contains(range, view) bool
}
link ViewRange "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L1733"
class ViewChangeHeadersSlice["ViewChangeHeadersSlice [str]"] {
    -command: ViewChangeCommand
    -slice: []const Header
    +init(command, slice) ViewChangeHeadersSlice
    +verify(headers) void
    +view_for_op(headers, op, log_view) ViewRange
}
ViewChangeHeadersSlice <-- ViewRange
link ViewChangeHeadersSlice "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L1671"
class ViewChangeHeadersArray["ViewChangeHeadersArray [str]"] {
    -command: ViewChangeCommand
    -array: Headers.Array
    +root(cluster) ViewChangeHeadersArray
    +init_from_slice(command, slice) ViewChangeHeadersArray
    -init_from_array(command, array) ViewChangeHeadersArray
    +verify(headers) void
    +start_view_into_do_view_change(headers) void
    +replace(headers, command, slice) void
    +append(headers, header) void
    +append_blank(headers, op) void
}
link ViewChangeHeadersArray "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L1832"
class `vsr.zig` {
    test "ReconfigurationRequest"()
    test "exponential_backoff_with_jitter"()
    test "parse_addresses"()
    test "quorums"()
    test "Headers.ViewChangeSlice.view_for_op"()
    +exponential_backoff_with_jitter(random, min, max, attempt) u64
    +parse_addresses(allocator, raw, address_limit) ![]std.net.Address
    +parse_address(raw) !std.net.Address
    +sector_floor(offset) u64
    +sector_ceil(offset) u64
    +quorums(replica_count) struct
    +root_members(cluster) Members
    +valid_members(members) bool
    -member_count(members) u8
    +assert_valid_member(members, replica_id) void
}
`vsr.zig` <-- ProcessType
`vsr.zig` <-- Zone
`vsr.zig` <-- Command
`vsr.zig` <-- Operation
`vsr.zig` <-- Header
`vsr.zig` <-- BlockRequest
`vsr.zig` <-- ReconfigurationRequest
`vsr.zig` <-- ReconfigurationResult
`vsr.zig` <-- Timeout
`vsr.zig` <-- Headers
`vsr.zig` <-- ViewChangeCommand
`vsr.zig` <-- ViewChangeHeadersSlice
`vsr.zig` <-- ViewChangeHeadersArray
link `vsr.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig"
class T["T [str]"] {
    -check(cmd, args, want) !void
}
link T "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/shell.zig#L285"
class `shell.zig` {
    +gpa: std.mem.Allocator
    +arena: std.heap.ArenaAllocator
    test "shell: expand_argv"()
    +create(allocator) !*Shell
    +destroy(shell) void
    +echo(shell, fmt, fmt_args) void
    +dir_exists(shell, path) !bool
    +find(shell, options) ![]const []const u8
    +exec(shell, cmd, cmd_args) !void
    +exec_status_ok(shell, cmd, cmd_args) !bool
    +exec_stdout(shell, cmd, cmd_args) ![]const u8
    +git_commit(shell) ![40]u8
    +git_tag(shell) ![]const u8
    -expand_argv(argv, cmd, cmd_args) !void
}
link `shell.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/shell.zig"
class `ewah_fuzz.zig` {
    +main() !void
    +fuzz_encode_decode(Word, allocator, decoded) !void
    -generate_bits(random, data, bits_set_total) void
    -ContextType(Word) type
}
link `ewah_fuzz.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/ewah_fuzz.zig"
class Event["Event [uni]"] {
    +commit: struct
    +checkpoint
    +state_machine_prefetch
    +state_machine_commit
    +state_machine_compact
    +tree_compaction_beat: struct
    +tree_compaction: struct
    +tree_compaction_iter: struct
    +tree_compaction_merge: struct
    +grid_read_iop: struct
    +grid_write_iop: struct
    +io_flush
    +io_callback
    +format(event, fmt, options, writer) !void
    -fiber(event) Fiber
}
link Event "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tracer.zig#L48"
class Fiber["Fiber [uni]"] {
    -main
    -tree: struct
    -tree_compaction: struct
    -grid_read_iop: struct
    -grid_write_iop: struct
    -io
    +format(fiber, fmt, options, writer) !void
}
link Fiber "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tracer.zig#L178"
class LevelA["LevelA [str]"] {
    -level_b: u8
    +format(level_a, fmt, options, writer) !void
}
link LevelA "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tracer.zig#L228"
class PlotId["PlotId [uni]"] {
    +queue_count: struct
    +cache_hits: struct
    +cache_misses: struct
    +filter_block_hits: struct
    +filter_block_misses: struct
    +format(plot_id, fmt, options, writer) !void
}
link PlotId "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tracer.zig#L246"
class TracerNone["TracerNone [str]"] {
    +init(allocator) !void
    +deinit(allocator) void
    +start(slot, event, src) void
    +end(slot, event) void
    +plot(plot_id, value) void
}
link TracerNone "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tracer.zig#L286"
class TracedAllocator["TracedAllocator [str]"] {
    +op: u64
    +tree_name: []const u8
    +tree_name: []const u8
    +level_b: u8
    +tree_name: []const u8
    +level_b: u8
    +tree_name: []const u8
    +level_b: u8
    +index: usize
    +index: usize
    +tree_name: []const u8
    +tree_name: []const u8
    +level_b: u8
    +index: usize
    +index: usize
    +queue_name: []const u8
    +cache_name: []const u8
    +cache_name: []const u8
    +tree_name: []const u8
    +tree_name: []const u8
    +parent_allocator: std.mem.Allocator
    +init(parent_allocator) TracedAllocator
    +allocator(self) std.mem.Allocator
    -allocFn(self, len, ptr_align, len_align, ret_addr) std.mem.Allocator.Error![]u8
    -resizeFn(self, buf, buf_align, new_len, len_align, ret_addr) ?usize
    -freeFn(self, buf, buf_align, ret_addr) void
}
link TracedAllocator "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tracer.zig#L464"
class TracerTracy["TracerTracy [str]"] {
    +Interns(Key) type
    +init(allocator_) !void
    +deinit(allocator_) void
    -intern_name(item) [:0]const u8
    +start(slot, event, src) void
    +end(slot, event) void
    +plot(plot_id, value) void
    +log_fn(level, scope, format, args) void
}
TracerTracy <-- TracedAllocator
link TracerTracy "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tracer.zig#L313"
class `tracer.zig`
`tracer.zig` <-- Event
`tracer.zig` <-- Fiber
`tracer.zig` <-- LevelA
`tracer.zig` <-- PlotId
`tracer.zig` <-- TracerNone
`tracer.zig` <-- TracerTracy
link `tracer.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tracer.zig"
class Account["Account [str]"] {
    +id: u128
    +user_data: u128
    +reserved: [48]u8
    +ledger: u32
    +code: u16
    +flags: AccountFlags
    +debits_pending: u64
    +debits_posted: u64
    +credits_pending: u64
    +credits_posted: u64
    +timestamp: u64
    +debits_exceed_credits(self, amount) bool
    +credits_exceed_debits(self, amount) bool
}
link Account "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tigerbeetle.zig#L7"
class AccountFlags["AccountFlags [str]"] {
    +linked: bool
    +debits_must_not_exceed_credits: bool
    +credits_must_not_exceed_debits: bool
    +padding: u13
}
link AccountFlags "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tigerbeetle.zig#L40"
class Transfer["Transfer [str]"] {
    +id: u128
    +debit_account_id: u128
    +credit_account_id: u128
    +user_data: u128
    +reserved: u128
    +pending_id: u128
    +timeout: u64
    +ledger: u32
    +code: u16
    +flags: TransferFlags
    +amount: u64
    +timestamp: u64
}
link Transfer "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tigerbeetle.zig#L62"
class TransferFlags["TransferFlags [str]"] {
    +linked: bool
    +pending: bool
    +post_pending_transfer: bool
    +void_pending_transfer: bool
    +balancing_debit: bool
    +balancing_credit: bool
    +padding: u10
}
link TransferFlags "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tigerbeetle.zig#L87"
class CreateAccountResult["CreateAccountResult [enu]"] {
    +ok
    +linked_event_failed
    +linked_event_chain_open
    +timestamp_must_be_zero
    +reserved_flag
    +reserved_field
    +id_must_not_be_zero
    +id_must_not_be_int_max
    +flags_are_mutually_exclusive
    +ledger_must_not_be_zero
    +code_must_not_be_zero
    +debits_pending_must_be_zero
    +debits_posted_must_be_zero
    +credits_pending_must_be_zero
    +credits_posted_must_be_zero
    +exists_with_different_flags
    +exists_with_different_user_data
    +exists_with_different_ledger
    +exists_with_different_code
    +exists
}
link CreateAccountResult "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tigerbeetle.zig#L105"
class CreateTransferResult["CreateTransferResult [enu]"] {
    +ok
    +linked_event_failed
    +linked_event_chain_open
    +timestamp_must_be_zero
    +reserved_flag
    +reserved_field
    +id_must_not_be_zero
    +id_must_not_be_int_max
    +flags_are_mutually_exclusive
    +debit_account_id_must_not_be_zero
    +debit_account_id_must_not_be_int_max
    +credit_account_id_must_not_be_zero
    +credit_account_id_must_not_be_int_max
    +accounts_must_be_different
    +pending_id_must_be_zero
    +pending_id_must_not_be_zero
    +pending_id_must_not_be_int_max
    +pending_id_must_be_different
    +timeout_reserved_for_pending_transfer
    +ledger_must_not_be_zero
    +code_must_not_be_zero
    +amount_must_not_be_zero
    +debit_account_not_found
    +credit_account_not_found
    +accounts_must_have_the_same_ledger
    +transfer_must_have_the_same_ledger_as_accounts
    +pending_transfer_not_found
    +pending_transfer_not_pending
    +pending_transfer_has_different_debit_account_id
    +pending_transfer_has_different_credit_account_id
    +pending_transfer_has_different_ledger
    +pending_transfer_has_different_code
    +exceeds_pending_transfer_amount
    +pending_transfer_has_different_amount
    +pending_transfer_already_posted
    +pending_transfer_already_voided
    +pending_transfer_expired
    +exists_with_different_flags
    +exists_with_different_debit_account_id
    +exists_with_different_credit_account_id
    +exists_with_different_pending_id
    +exists_with_different_user_data
    +exists_with_different_timeout
    +exists_with_different_code
    +exists_with_different_amount
    +exists
    +overflows_debits_pending
    +overflows_credits_pending
    +overflows_debits_posted
    +overflows_credits_posted
    +overflows_debits
    +overflows_credits
    +overflows_timeout
    +exceeds_credits
    +exceeds_debits
}
link CreateTransferResult "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tigerbeetle.zig#L142"
class CreateAccountsResult["CreateAccountsResult [str]"] {
    +index: u32
    +result: CreateAccountResult
}
link CreateAccountsResult "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tigerbeetle.zig#L222"
class CreateTransfersResult["CreateTransfersResult [str]"] {
    +index: u32
    +result: CreateTransferResult
}
link CreateTransfersResult "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tigerbeetle.zig#L232"
class `tigerbeetle.zig`
`tigerbeetle.zig` <-- Account
`tigerbeetle.zig` <-- AccountFlags
`tigerbeetle.zig` <-- Transfer
`tigerbeetle.zig` <-- TransferFlags
`tigerbeetle.zig` <-- CreateAccountResult
`tigerbeetle.zig` <-- CreateTransferResult
`tigerbeetle.zig` <-- CreateAccountsResult
`tigerbeetle.zig` <-- CreateTransfersResult
link `tigerbeetle.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tigerbeetle.zig"
class Message["Message [str]"] {
    +header: *Header
    +buffer: *align(constants.sector_size)
    +references: u32
    +next: ?*Message
    +ref(message) *Message
    +body(message) []align(@sizeOf(Header)) u8
}
link Message "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/message_pool.zig#L65"
class MessagePool["MessagePool [str]"] {
    +free_list: ?*Message
    +messages_max: usize
    +init(allocator, process_type) error[OutOfMemory]!MessagePool
    +init_capacity(allocator, messages_max) error[OutOfMemory]!MessagePool
    +deinit(pool, allocator) void
    +get_message(pool) *Message
    +unref(pool, message) void
}
MessagePool <-- Message
link MessagePool "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/message_pool.zig#L64"
class `message_pool.zig`
`message_pool.zig` <-- MessagePool
link `message_pool.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/message_pool.zig"
class Options["Options [str]"] {
    +cluster: Cluster.Options
    +workload: StateMachine.Workload.Options
    +replica_crash_probability: f64
    +replica_crash_stability: u32
    +replica_restart_probability: f64
    +replica_restart_stability: u32
    +requests_max: usize
    +request_probability: u8
    +request_idle_on_probability: u8
    +request_idle_off_probability: u8
}
link Options "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/simulator.zig#L313"
class Simulator["Simulator [str]"] {
    +random: std.rand.Random
    +options: Options
    +cluster: *Cluster
    +workload: StateMachine.Workload
    +replica_stability: []usize
    +reply_sequence: ReplySequence
    +core: Core
    +requests_sent: usize
    +requests_replied: usize
    +requests_idle: bool
    +init(allocator, random, options) !Simulator
    +deinit(simulator, allocator) void
    +done(simulator) bool
    +tick(simulator) void
    +transition_to_liveness_mode(simulator) void
    +core_missing_primary(simulator) bool
    +core_missing_quorum(simulator) bool
    +core_missing_prepare(simulator) ?vsr.Header
    +core_missing_blocks(simulator) ?usize
    -on_cluster_reply(cluster, reply_client, request, reply) void
    -tick_requests(simulator) void
    -tick_crash(simulator) void
    -restart_replica(simulator, replica_index, fault) void
}
Simulator <-- Options
link Simulator "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/simulator.zig#L312"
class `simulator.zig` {
    +main() !void
    -fatal(failure, fmt_string, args) noreturn
    -chance(random, p) bool
    -chance_f64(random, p) bool
    -random_partition_mode(random) PartitionMode
    -random_partition_symmetry(random) PartitionSymmetry
    -random_core(random, replica_count, standby_count) Core
    +parse_seed(bytes) u64
    +log(level, scope, format, args) void
}
`simulator.zig` <-- Simulator
link `simulator.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/simulator.zig"
class Process["Process [uni]"] {
    -replica: u8
    -client: u128
}
link Process "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/message_bus.zig#L36"
class `message_bus.zig` {
    -MessageBusType(process_type) type
}
link `message_bus.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/message_bus.zig"
class BufferCompletion["BufferCompletion [str]"] {
    -next: ?*BufferCompletion
    -buffer: [256]u8
    -completion: IO.Completion
}
link BufferCompletion "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/statsd.zig#L6"
class StatsD["StatsD [str]"] {
    +socket: std.os.socket_t
    +io: *IO
    +buffer_completions: []BufferCompletion
    +buffer_completions_fifo: FIFO(BufferCompletion)
    +init(allocator, io, address) !StatsD
    +deinit(self, allocator) void
    +gauge(self, stat, value) !void
    +timing(self, stat, ms) !void
    +send_callback(context, completion, result) void
}
link StatsD "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/statsd.zig#L12"
class `statsd.zig`
`statsd.zig` <-- BufferCompletion
`statsd.zig` <-- StatsD
link `statsd.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/statsd.zig"
class `ring_buffer.zig` {
    test "RingBuffer: low level interface"()
    test "RingBuffer: push/pop high level interface"()
    test "RingBuffer: pop_tail"()
    test "RingBuffer: count_max=0"()
    +RingBuffer(T, count_max_, buffer_type) type
    -test_iterator(T, ring, values) !void
    -test_low_level_interface(Ring, ring) !void
}
link `ring_buffer.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/ring_buffer.zig"
class `flags.zig` {
    test field_to_flag()
    +fatal(fmt_string, args) noreturn
    +parse_commands(args, Commands) Commands
    +parse_flags(args, Flags) Flags
    -parse_flag(T, flag, arg) T
    -parse_flag_value(flag, arg) [:0]const u8
    -parse_flag_value_int(T, flag, value) T
    -field_to_flag(field) []const u8
    -default_value(field) ?field.field_type
}
link `flags.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/flags.zig"
class Foo["Foo [str]"] {
    -in: ?*T
    -out: ?*T
    -count: u64
    -name: ?[]const u8
    +push(self, elem) void
    +pop(self) ?*T
    +peek(self) ?*T
    +empty(self) bool
    +remove(self, to_remove) void
    +reset(self) void
    -plot(self) void
}
link Foo "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/fifo.zig#L89"
class `fifo.zig` {
    test "push/pop/peek/remove/empty"()
    +FIFO(T) type
}
link `fifo.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/fifo.zig"
class CopyPrecision["CopyPrecision [enu]"] {
    +exact
    +inexact
}
link CopyPrecision "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/stdx.zig#L51"
class Cut["Cut [str]"] {
    -prefix: []const u8
    -suffix: []const u8
}
link Cut "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/stdx.zig#L157"
class TimeIt["TimeIt [str]"] {
    -inner: std.time.Timer
    +lap(self, label) void
}
link TimeIt "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/stdx.zig#L208"
class U["U [uni]"] {
    -a: u32
    -b: u128
    -c: void
    +scoped(scope) type
}
link U "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/stdx.zig#L457"
class `stdx.zig` {
    test "div_ceil"()
    test "copy_left"()
    test "copy_right"()
    test "disjoint_slices"()
    test no_padding()
    test "hash_inline"()
    test "union_field_parent_ptr"()
    +div_ceil(numerator, denominator) @TypeOf(numerator, denominator)
    +copy_left(precision, T, target, source) void
    +copy_right(precision, T, target, source) void
    +copy_disjoint(precision, T, target, source) void
    +disjoint_slices(A, B, a, b) bool
    +zeroed(bytes) bool
    +cut(haystack, needle) ?Cut
    +maybe(ok) void
    +unimplemented(message) noreturn
    +timeit() TimeIt
    +equal_bytes(T, a, b) bool
    -has_pointers(T) bool
    +no_padding(T) bool
    +hash_inline(value) u64
    -low_level_hash(seed, input) u64
    +update(base, diff) @TypeOf(base)
    +union_field_parent_ptr(Union, field, child) *Union
}
`stdx.zig` <-- CopyPrecision
`stdx.zig` <-- Cut
`stdx.zig` <-- TimeIt
link `stdx.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/stdx.zig"
class BitSetConfig["BitSetConfig [str]"] {
    -words: usize
    -run_length_e: usize
    -literals_length_e: usize
}
link BitSetConfig "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/ewah_benchmark.zig#L5"
class `ewah_benchmark.zig` {
    +main() !void
    -make_bitset(allocator, config) ![]usize
}
`ewah_benchmark.zig` <-- BitSetConfig
link `ewah_benchmark.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/ewah_benchmark.zig"
class Read["Read [str]"] {
    +always_synchronous
    +always_asynchronous
    +completion: IO.Completion
    +callback: *const fn (read: *Storage.Read)
    +buffer: []u8
    +offset: u64
    +target_max: u64
    -target(read) []u8
}
link Read "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/storage.zig#L19"
class Write["Write [str]"] {
    +completion: IO.Completion
    +callback: *const fn (write: *Storage.Write)
    +buffer: []const u8
    +offset: u64
}
link Write "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/storage.zig#L64"
class NextTick["NextTick [str]"] {
    +next: ?*NextTick
    +source: NextTickSource
    +callback: *const fn (next_tick: *NextTick)
}
link NextTick "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/storage.zig#L71"
class NextTickSource["NextTickSource [enu]"]
link NextTickSource "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/storage.zig#L77"
class Storage["Storage [str]"] {
    +lsm
    +vsr
    +io: *IO
    +fd: os.fd_t
    +next_tick_queue: FIFO(NextTick)
    +next_tick_completion_scheduled: bool
    +next_tick_completion: IO.Completion
    +init(io, fd) !Storage
    +deinit(storage) void
    +tick(storage) void
    +on_next_tick(storage, source, callback, next_tick) void
    +reset_next_tick_lsm(storage) void
    -timeout_callback(storage, completion, result) void
    +read_sectors(self, callback, read, buffer, zone, offset_in_zone) void
    -start_read(self, read, bytes_read) void
    -on_read(self, completion, result) void
    +write_sectors(self, callback, write, buffer, zone, offset_in_zone) void
    -start_write(self, write) void
    -on_write(self, completion, result) void
    -assert_alignment(buffer, offset) void
    -assert_bounds(self, buffer, offset) void
}
Storage <-- Read
Storage <-- Write
Storage <-- NextTick
Storage <-- NextTickSource
link Storage "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/storage.zig#L12"
class `storage.zig`
`storage.zig` <-- Storage
link `storage.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/storage.zig"
class Report["Report [str]"] {
    -checksum: [16]u8
    -bug: u8
    -seed: [8]u8
    -commit: [20]u8
}
link Report "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vopr.zig#L61"
class Flags["Flags [str]"] {
    -seed: ?u64
    -send_address: ?net.Address
    -build_mode: std.builtin.Mode
    -simulations: u32
}
link Flags "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vopr.zig#L68"
class Bug["Bug [enu]"] {
    -crash
    -liveness
    -correctness
}
link Bug "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vopr.zig#L75"
class `vopr.zig` {
    +main() void
    -build_simulator(allocator, mode) void
    -run_simulator(allocator, seed, mode, send_address) ?Bug
    -run_child_process(allocator, argv) u8
    -check_git_status(allocator) void
    -send_report(report, address) void
    -create_report(allocator, bug, seed) Report
    -fatal(fmt_string, args) noreturn
    -parse_flag(flag, arg) [:0]const u8
    -parse_args(allocator) !Flags
}
`vopr.zig` <-- Report
`vopr.zig` <-- Flags
`vopr.zig` <-- Bug
link `vopr.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vopr.zig"
class CliArgs["CliArgs [str]"] {
    -account_count: usize
    -transfer_count: usize
    -transfer_count_per_second: usize
    -print_batch_timings: bool
    -enable_statsd: bool
    -addresses: []const u8
}
link CliArgs "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/benchmark.zig#L56"
class Benchmark["Benchmark [str]"] {
    -io: *IO
    -message_pool: *MessagePool
    -client: *Client
    -batch_accounts: std.ArrayListUnmanaged(tb.Account)
    -account_count: usize
    -account_index: usize
    -rng: std.rand.DefaultPrng
    -timer: std.time.Timer
    -batch_latency_ns: std.ArrayListUnmanaged(u64)
    -transfer_latency_ns: std.ArrayListUnmanaged(u64)
    -batch_transfers: std.ArrayListUnmanaged(tb.Transfer)
    -batch_start_ns: usize
    -transfers_sent: usize
    -tranfer_index: usize
    -transfer_count: usize
    -transfer_count_per_second: usize
    -transfer_arrival_rate_ns: usize
    -transfer_start_ns: std.ArrayListUnmanaged(u64)
    -batch_index: usize
    -transfer_index: usize
    -transfer_next_arrival_ns: usize
    -message: ?*MessagePool.Message
    -callback: ?*const fn (*Benchmark)
    -done: bool
    -statsd: ?*StatsD
    -print_batch_timings: bool
    -create_accounts(b) void
    -create_transfers(b) void
    -create_transfers_finish(b) void
    -finish(b) void
    -send(b, callback, operation, payload) void
    -send_complete(user_data, operation, result) void
}
link Benchmark "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/benchmark.zig#L229"
class `benchmark.zig` {
    +main() !void
    -parse_arg_addresses(allocator, args, arg, arg_name, arg_value) !bool
    -parse_arg_usize(args, arg, arg_name, arg_value) !bool
    -parse_arg_bool(args, arg, arg_name, arg_value) !bool
    -print_deciles(stdout, label, latencies) void
}
`benchmark.zig` <-- CliArgs
`benchmark.zig` <-- Benchmark
link `benchmark.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/benchmark.zig"
class StateMachineConfig["StateMachineConfig [str]"] {
    +message_body_size_max: comptime_int
    +lsm_batch_multiple: comptime_int
    +vsr_operations_reserved: u8
}
link StateMachineConfig "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/constants.zig#L542"
class `constants.zig`
`constants.zig` <-- StateMachineConfig
link `constants.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/constants.zig"
class StringContext["StringContext [str]"] {
    +hash(self, s) u64
    +eql(self, a, b) bool
}
link StringContext "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/hash_map.zig#L79"
class StringIndexContext["StringIndexContext [str]"] {
    +bytes: *std.ArrayListUnmanaged(u8)
    +eql(self, a, b) bool
    +hash(self, x) u64
}
link StringIndexContext "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/hash_map.zig#L98"
class StringIndexAdapter["StringIndexAdapter [str]"] {
    +bytes: *std.ArrayListUnmanaged(u8)
    +eql(self, a_slice, b) bool
    +hash(self, adapted_key) u64
}
link StringIndexAdapter "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/hash_map.zig#L112"
class AdaptedContext["AdaptedContext [str]"] {
    -unmanaged: Unmanaged
    -allocator: Allocator
    -ctx: Context
    -metadata: ?[*]Metadata
    -size: Size
    -available: Size
    -hash(ctx, key) u64
    -eql(ctx, a, b) bool
    +init(allocator) Self
    +initContext(allocator, ctx) Self
    +deinit(self) void
    +clearRetainingCapacity(self) void
    +clearAndFree(self) void
    +count(self) Size
    +iterator(self) Iterator
    +keyIterator(self) KeyIterator
    +valueIterator(self) ValueIterator
    +getOrPut(self, key) Allocator.Error!GetOrPutResult
    +getOrPutAdapted(self, key, ctx) Allocator.Error!GetOrPutResult
    +getOrPutAssumeCapacity(self, key) GetOrPutResult
    +getOrPutAssumeCapacityAdapted(self, key, ctx) GetOrPutResult
    +getOrPutValue(self, key, value) Allocator.Error!Entry
    +ensureTotalCapacity(self, expected_count) Allocator.Error!void
    +ensureUnusedCapacity(self, additional_count) Allocator.Error!void
    +capacity(self) Size
    +put(self, key, value) Allocator.Error!void
    +putNoClobber(self, key, value) Allocator.Error!void
    +putAssumeCapacity(self, key, value) void
    +putAssumeCapacityNoClobber(self, key, value) void
    +fetchPut(self, key, value) Allocator.Error!?KV
    +fetchPutAssumeCapacity(self, key, value) ?KV
    +fetchRemove(self, key) ?KV
    +fetchRemoveAdapted(self, key, ctx) ?KV
    +get(self, key) ?V
    +getAdapted(self, key, ctx) ?V
    +getPtr(self, key) ?*V
    +getPtrAdapted(self, key, ctx) ?*V
    +getKey(self, key) ?K
    +getKeyAdapted(self, key, ctx) ?K
    +getKeyPtr(self, key) ?*K
    +getKeyPtrAdapted(self, key, ctx) ?*K
    +getEntry(self, key) ?Entry
    +getEntryAdapted(self, key, ctx) ?Entry
    +contains(self, key) bool
    +containsAdapted(self, key, ctx) bool
    +remove(self, key) bool
    +removeAdapted(self, key, ctx) bool
    +removeByPtr(self, keyPtr) void
    +clone(self) Allocator.Error!Self
    +cloneWithAllocator(self, new_allocator) Allocator.Error!Self
    +cloneWithContext(self, new_ctx) Allocator.Error!HashMap(K, V, @TypeOf(new_ctx), max_load_percentage)
    +cloneWithAllocatorAndContext(self, new_allocator, new_ctx) Allocator.Error!HashMap(K, V, @TypeOf(new_ctx), max_load_percentage)
    -FieldIterator(T) type
    +promote(self, allocator) Managed
    +promoteContext(self, allocator, ctx) Managed
    -isUnderMaxLoadPercentage(size, cap) bool
    +deinit(self, allocator) void
    -capacityForSize(size) Size
    +ensureTotalCapacity(self, allocator, new_size) Allocator.Error!void
    +ensureTotalCapacityContext(self, allocator, new_size, ctx) Allocator.Error!void
    +ensureUnusedCapacity(self, allocator, additional_size) Allocator.Error!void
    +ensureUnusedCapacityContext(self, allocator, additional_size, ctx) Allocator.Error!void
    +clearRetainingCapacity(self) void
    +clearAndFree(self, allocator) void
    +count(self) Size
    -header(self) *Header
    -keys(self) [*]K
    -values(self) [*]V
    +capacity(self) Size
    +iterator(self) Iterator
    +keyIterator(self) KeyIterator
    +valueIterator(self) ValueIterator
    +putNoClobber(self, allocator, key, value) Allocator.Error!void
    +putNoClobberContext(self, allocator, key, value, ctx) Allocator.Error!void
    +putAssumeCapacity(self, key, value) void
    +putAssumeCapacityContext(self, key, value, ctx) void
    +putAssumeCapacityNoClobber(self, key, value) void
    +putAssumeCapacityNoClobberContext(self, key, value, ctx) void
    +fetchPut(self, allocator, key, value) Allocator.Error!?KV
    +fetchPutContext(self, allocator, key, value, ctx) Allocator.Error!?KV
    +fetchPutAssumeCapacity(self, key, value) ?KV
    +fetchPutAssumeCapacityContext(self, key, value, ctx) ?KV
    +fetchRemove(self, key) ?KV
    +fetchRemoveContext(self, key, ctx) ?KV
    +fetchRemoveAdapted(self, key, ctx) ?KV
    -getIndex(self, key, ctx) ?usize
    +getEntry(self, key) ?Entry
    +getEntryContext(self, key, ctx) ?Entry
    +getEntryAdapted(self, key, ctx) ?Entry
    +put(self, allocator, key, value) Allocator.Error!void
    +putContext(self, allocator, key, value, ctx) Allocator.Error!void
    +getKeyPtr(self, key) ?*K
    +getKeyPtrContext(self, key, ctx) ?*K
    +getKeyPtrAdapted(self, key, ctx) ?*K
    +getKey(self, key) ?K
    +getKeyContext(self, key, ctx) ?K
    +getKeyAdapted(self, key, ctx) ?K
    +getPtr(self, key) ?*V
    +getPtrContext(self, key, ctx) ?*V
    +getPtrAdapted(self, key, ctx) ?*V
    +get(self, key) ?V
    +getContext(self, key, ctx) ?V
    +getAdapted(self, key, ctx) ?V
    +getOrPut(self, allocator, key) Allocator.Error!GetOrPutResult
    +getOrPutContext(self, allocator, key, ctx) Allocator.Error!GetOrPutResult
    +getOrPutAdapted(self, allocator, key, key_ctx) Allocator.Error!GetOrPutResult
    +getOrPutContextAdapted(self, allocator, key, key_ctx, ctx) Allocator.Error!GetOrPutResult
    +getOrPutAssumeCapacity(self, key) GetOrPutResult
    +getOrPutAssumeCapacityContext(self, key, ctx) GetOrPutResult
    +getOrPutAssumeCapacityAdapted(self, key, ctx) GetOrPutResult
    +getOrPutValue(self, allocator, key, value) Allocator.Error!Entry
    +getOrPutValueContext(self, allocator, key, value, ctx) Allocator.Error!Entry
    +contains(self, key) bool
    +containsContext(self, key, ctx) bool
    +containsAdapted(self, key, ctx) bool
    -removeByIndex(self, idx) void
    +remove(self, key) bool
    +removeContext(self, key, ctx) bool
    +removeAdapted(self, key, ctx) bool
    +removeByPtr(self, keyPtr) void
    -initMetadatas(self) void
    -load(self) Size
    -growIfNeeded(self, allocator, new_count, ctx) Allocator.Error!void
    +clone(self, allocator) Allocator.Error!Self
    +cloneContext(self, allocator, new_ctx) Allocator.Error!HashMapUnmanaged(K, V, @TypeOf(new_ctx), max_load_percentage)
    -grow(self, allocator, new_capacity, ctx) Allocator.Error!void
    -allocate(self, allocator, new_capacity) Allocator.Error!void
    -deallocate(self, allocator) void
    -gdbHelper(self, hdr) void
    -eql(self, adapted_key, test_key) bool
    -hash(self, adapted_key) u64
}
link AdaptedContext "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/hash_map.zig#L2081"
class `hash_map.zig` {
    test "std.hash_map basic usage"()
    test "std.hash_map ensureTotalCapacity"()
    test "std.hash_map ensureUnusedCapacity with tombstones"()
    test "std.hash_map clearRetainingCapacity"()
    test "std.hash_map grow"()
    test "std.hash_map clone"()
    test "std.hash_map ensureTotalCapacity with existing elements"()
    test "std.hash_map ensureTotalCapacity satisfies max load factor"()
    test "std.hash_map remove"()
    test "std.hash_map reverse removes"()
    test "std.hash_map multiple removes on same metadata"()
    test "std.hash_map put and remove loop in random order"()
    test "std.hash_map remove one million elements in random order"()
    test "std.hash_map put"()
    test "std.hash_map putAssumeCapacity"()
    test "std.hash_map repeat putAssumeCapacity/remove"()
    test "std.hash_map getOrPut"()
    test "std.hash_map basic hash map usage"()
    test "std.hash_map clone"()
    test "std.hash_map getOrPutAdapted"()
    test "std.hash_map ensureUnusedCapacity"()
    test "std.hash_map removeByPtr"()
    test "std.hash_map removeByPtr 0 sized key"()
    test "std.hash_map repeat fetchRemove"()
    +getAutoHashFn(K, Context) (fn (Context, K) u64)
    +getAutoEqlFn(K, Context) (fn (Context, K, K) bool)
    +AutoHashMap(K, V) type
    +AutoHashMapUnmanaged(K, V) type
    +AutoContext(K) type
    +StringHashMap(V) type
    +StringHashMapUnmanaged(V) type
    +eqlString(a, b) bool
    +hashString(s) u64
    +verifyContext(RawContext, PseudoKey, Key, Hash, is_array) void
    +HashMap(K, V, Context, max_load_percentage) type
    +HashMapUnmanaged(K, V, Context, max_load_percentage) type
}
`hash_map.zig` <-- StringContext
`hash_map.zig` <-- StringIndexContext
`hash_map.zig` <-- StringIndexAdapter
link `hash_map.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/hash_map.zig"
class TestContext["TestContext [str]"] {
    -storage: Storage
    -superblock: SuperBlock
    -grid: Grid
    -state_machine: StateMachine
    -init(ctx, allocator) !void
    -deinit(ctx, allocator) void
}
link TestContext "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/state_machine.zig#L1446"
class TestAction["TestAction [uni]"] {
    -setup: struct
    -commit: TestContext.StateMachine.Operation
    -account: TestCreateAccount
    -transfer: TestCreateTransfer
    -lookup_account: struct
    -lookup_transfer: struct
}
link TestAction "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/state_machine.zig#L1510"
class TestCreateAccount["TestCreateAccount [str]"] {
    -id: u128
    -user_data: u128
    -@"0"
    -@"1"
    -reserved: enum
    -ledger: u32
    -code: u16
    -LNK
    -flags_linked: ?enum
    -@"D<C"
    -flags_debits_must_not_exceed_credits: ?enum
    -@"C<D"
    -flags_credits_must_not_exceed_debits: ?enum
    -flags_padding: u13
    -debits_pending: u64
    -debits_posted: u64
    -credits_pending: u64
    -credits_posted: u64
    -timestamp: u64
    -result: CreateAccountResult
    -event(a) Account
}
link TestCreateAccount "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/state_machine.zig#L1542"
class TestCreateTransfer["TestCreateTransfer [str]"] {
    -id: u128
    -debit_account_id: u128
    -credit_account_id: u128
    -user_data: u128
    -reserved: u128
    -pending_id: u128
    -timeout: u64
    -ledger: u32
    -code: u16
    -LNK
    -flags_linked: ?enum
    -PEN
    -flags_pending: ?enum
    -POS
    -flags_post_pending_transfer: ?enum
    -VOI
    -flags_void_pending_transfer: ?enum
    -BDR
    -flags_balancing_debit: ?enum
    -BCR
    -flags_balancing_credit: ?enum
    -flags_padding: u10
    -amount: u64
    -timestamp: u64
    -result: CreateTransferResult
    -event(t) Transfer
}
link TestCreateTransfer "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/state_machine.zig#L1584"
class `state_machine.zig` {
    test "sum_overflows"()
    test "create_accounts"()
    test "create_accounts: empty"()
    test "linked accounts"()
    test "linked_event_chain_open"()
    test "linked_event_chain_open for an already failed batch"()
    test "linked_event_chain_open for a batch of 1"()
    test "create_transfers/lookup_transfers"()
    test "create/lookup 2-phase transfers"()
    test "create_transfers: empty"()
    test "create_transfers/lookup_transfers: failed transfer does not exist"()
    test "create_transfers: failed linked-chains are undone"()
    test "create_transfers: failed linked-chains are undone within a commit"()
    test "create_transfers: balancing_debit | balancing_credit (*_must_not_exceed_*)"()
    test "create_transfers: balancing_debit | balancing_credit (¬*_must_not_exceed_*)"()
    test "create_transfers: balancing_debit | balancing_credit (amount=0)"()
    test "create_transfers: balancing_debit & balancing_credit"()
    test "create_transfers: balancing_debit/balancing_credit + pending"()
    test "zeroed_32_bytes"()
    test "zeroed_48_bytes"()
    test "equal_32_bytes"()
    test "equal_48_bytes"()
    test "StateMachine: ref all decls"()
    +StateMachineType(Storage, config) type
    -sum_overflows(a, b) bool
    -zeroed_16_bytes(a) bool
    -zeroed_32_bytes(a) bool
    -zeroed_48_bytes(a) bool
    -equal_32_bytes(a, b) bool
    -equal_48_bytes(a, b) bool
    -check(test_table) !void
    -print_results(label, operation, reply) void
    -test_zeroed_n_bytes(n) !void
    -test_equal_n_bytes(n) !void
}
`state_machine.zig` <-- TestContext
`state_machine.zig` <-- TestAction
`state_machine.zig` <-- TestCreateAccount
`state_machine.zig` <-- TestCreateTransfer
link `state_machine.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/state_machine.zig"
class `unit_tests.zig` {
    test()
}
link `unit_tests.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/unit_tests.zig"
```
