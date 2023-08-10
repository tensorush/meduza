```mermaid
---
title: Tigerbeetle database (vsr)
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
class Status["Status [enu]"] {
    +normal
    +view_change
    +recovering
    +recovering_head
}
link Status "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica.zig#L33"
class CommitStage["CommitStage [enu]"] {
    -idle
    -next
    -next_journal
    -next_pipeline
    -prefetch_state_machine
    -setup_client_replies
    -compact_state_machine
    -checkpoint_state_machine
    -checkpoint_client_replies
    -checkpoint_superblock
    -cleanup
}
link CommitStage "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica.zig#L49"
class ReplicaEvent["ReplicaEvent [uni]"] {
    +message_sent: *const Message
    +committed
    +compaction_completed
    +checkpoint_commenced
    +checkpoint_completed
    +replica: u8
    +checkpoint_divergence_detected: struct
    +sync_stage_changed
}
link ReplicaEvent "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica.zig#L67"
class Prepare["Prepare [str]"] {
    -message: *Message
    -ok_from_all_replicas: QuorumCounter
    -ok_quorum_received: bool
}
link Prepare "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica.zig#L91"
class Request["Request [str]"] {
    -message: *Message
    -realtime: i64
}
link Request "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica.zig#L102"
class HeaderIterator["HeaderIterator [str]"] {
    -static_allocator: StaticAllocator
    -cluster: u32
    -replica_count: u8
    -standby_count: u8
    -node_count: u8
    -replica: u8
    -quorum_replication: u8
    -quorum_view_change: u8
    -quorum_nack_prepare: u8
    -quorum_majority: u8
    -nonce: Nonce
    -time: Time
    -clock: Clock
    -journal: Journal
    -client_replies: ClientReplies
    -message_bus: MessageBus
    -state_machine: StateMachine
    -state_machine_opened: bool
    -superblock: SuperBlock
    -superblock_context: SuperBlock.Context
    -superblock_context_view_change: SuperBlock.Context
    -grid: Grid
    -grid_reads: IOPS(BlockRead, constants.grid_repair_reads_max)
    -grid_writes: IOPS(BlockWrite, constants.grid_repair_writes_max)
    -grid_write_blocks: [constants.grid_repair_writes_max]Grid.BlockPtr
    -grid_read_fault_next_tick: Grid.NextTick
    -opened: bool
    -syncing: SyncStage
    -sync_target_max: ?SyncTarget
    -sync_target_quorum: SyncTargetQuorum
    -view: u32
    -log_view: u32
    -status: Status
    -op: u64
    -commit_min: u64
    -commit_max: u64
    -commit_stage: CommitStage
    -pipeline_repairing: bool
    -pipeline: union(enum)
    -view_headers: vsr.Headers.ViewChangeArray
    -loopback_queue: ?*Message
    -heartbeat_timestamp: u64
    -primary_abdicating: bool
    -start_view_change_from_all_replicas: QuorumCounter
    -do_view_change_from_all_replicas: QuorumMessages
    -do_view_change_quorum: bool
    -ping_timeout: Timeout
    -prepare_timeout: Timeout
    -primary_abdicate_timeout: Timeout
    -commit_message_timeout: Timeout
    -normal_heartbeat_timeout: Timeout
    -start_view_change_window_timeout: Timeout
    -start_view_change_message_timeout: Timeout
    -view_change_status_timeout: Timeout
    -do_view_change_message_timeout: Timeout
    -request_start_view_message_timeout: Timeout
    -repair_timeout: Timeout
    -repair_sync_timeout: Timeout
    -grid_repair_message_timeout: Timeout
    -sync_message_timeout: Timeout
    -prng: std.rand.DefaultPrng
    -test_context: ?*anyopaque
    -event_callback: ?*const fn (replica: *const Self, event: ReplicaEvent)
    -commit_prepare: ?*Message
    -tracer_slot_commit: ?tracer.SpanStart
    -tracer_slot_checkpoint: ?tracer.SpanStart
    -aof: *AOF
    -dvcs: DVCArray
    -op_max: u64
    -op_min: u64
    -child_op: ?u64
    -child_parent: ?u128
    +open(self, parent_allocator, options) !void
    -superblock_open_callback(superblock_context) void
    -journal_recover_callback(journal) void
    -state_machine_open_callback(state_machine) void
    -init(self, allocator, options) !void
    +deinit(self, allocator) void
    -client_sessions(self) *ClientSessions
    +tick(self) void
    -on_message_from_bus(message_bus, message) void
    +on_message(self, message) void
    -on_ping(self, message) void
    -on_pong(self, message) void
    -on_ping_client(self, message) void
    -on_request(self, message) void
    -on_prepare(self, message) void
    -on_prepare_ok(self, message) void
    -on_reply(self, message) void
    -on_commit(self, message) void
    -on_repair(self, message) void
    -on_start_view_change(self, message) void
    -on_do_view_change(self, message) void
    -on_start_view(self, message) void
    -on_request_start_view(self, message) void
    -on_request_prepare(self, message) void
    -on_request_prepare_read(self, prepare, destination_replica) void
    -on_request_headers(self, message) void
    -on_request_reply(self, message) void
    -on_request_reply_read_callback(client_replies, reply_header, reply_, destination_replica) void
    -on_headers(self, message) void
    -on_request_blocks(self, message) void
    -on_request_blocks_read_repair(grid_read, result) void
    -on_block(self, message) void
    -on_block_write_repair(grid_write) void
    -on_request_sync_trailer(self, message) void
    -on_sync_trailer(self, trailer, message) void
    -on_ping_timeout(self) void
    -on_prepare_timeout(self) void
    -on_primary_abdicate_timeout(self) void
    -on_commit_message_timeout(self) void
    -on_normal_heartbeat_timeout(self) void
    -on_start_view_change_window_timeout(self) void
    -on_start_view_change_message_timeout(self) void
    -on_view_change_status_timeout(self) void
    -on_do_view_change_message_timeout(self) void
    -on_request_start_view_message_timeout(self) void
    -on_repair_timeout(self) void
    -on_repair_sync_timeout(self) void
    -on_grid_repair_message_timeout(self) void
    -on_sync_message_timeout(self) void
    -primary_receive_do_view_change(self, message) void
    -count_message_and_receive_quorum_exactly_once(self, counter, message, threshold) ?usize
    -append(self, message) void
    -ascending_viewstamps(a, b) bool
    -choose_any_other_replica(self) u8
    -commit_dispatch(self, stage_new) void
    -commit_journal(self, commit) void
    -commit_journal_next(self) void
    -commit_journal_next_callback(self, prepare, destination_replica) void
    -commit_pipeline(self) void
    -commit_pipeline_next(self) void
    -commit_op_prefetch(self) void
    -commit_op_prefetch_callback(state_machine) void
    -commit_op_client_replies_ready_callback(client_replies) void
    -commit_op_compact_callback(state_machine) void
    -commit_op_checkpoint_state_machine_callback(state_machine) void
    -commit_op_checkpoint_client_replies_callback(client_replies) void
    -commit_op_checkpoint_superblock(self) void
    -commit_op_checkpoint_superblock_callback(superblock_context) void
    -commit_op_cleanup(self) void
    -commit_op(self, prepare) void
    -commit_reconfiguration(self, prepare, output_buffer) usize
    -client_table_entry_create(self, reply) void
    -client_table_entry_update(self, reply) void
    -create_view_change_message(self, command, nonce) *Message
    -primary_update_view_headers(self) void
    -create_message_from_header(self, header) *Message
    -primary_discard_uncommitted_ops_from(self, op, checksum) void
    -flush_loopback_queue(self) void
    -ignore_ping_client(self, message) bool
    -ignore_prepare_ok(self, message) bool
    -ignore_repair_message(self, message) bool
    -ignore_repair_message_during_view_change(self, message) bool
    -ignore_request_message(self, message) bool
    -ignore_request_message_duplicate(self, message) bool
    -on_request_repeat_reply(self, message, entry) void
    -on_request_repeat_reply_callback(client_replies, reply_header, reply_, destination_replica) void
    -ignore_request_message_backup(self, message) bool
    -ignore_request_message_preparing(self, message) bool
    -ignore_start_view_change_message(self, message) bool
    -ignore_view_change_message(self, message) bool
    -ignore_sync_request_message(self, message) bool
    -ignore_sync_response_message(self, message) bool
    -is_repair(self, message) bool
    +primary_index(self, view) u8
    +primary(self) bool
    -backup(self) bool
    +solo(self) bool
    +standby(self) bool
    -jump_to_newer_op_in_normal_status(self, header) void
    -op_head_certain(self) bool
    +op_checkpoint(self) u64
    -op_checkpoint_next(self) u64
    -op_checkpoint_trigger(self) u64
    -checkpoint_id_for_op(self, op) ?u128
    -op_repair_min(self) u64
    -op_repair_max(self) u64
    -panic_if_hash_chain_would_break_in_the_same_view(self, a, b) void
    -primary_pipeline_prepare(self, request) void
    -primary_prepare_reconfiguration(self, request) void
    -primary_pipeline_pending(self) ?*const Prepare
    -pipeline_prepare_by_op_and_checksum(self, op, checksum) ?*Message
    -repair(self) void
    -repair_header(self, header) bool
    -repair_header_would_connect_hash_chain(self, header) bool
    -primary_repair_pipeline(self) enum [ done, busy ]
    -primary_repair_pipeline_done(self) PipelineQueue
    -primary_repair_pipeline_op(self) ?u64
    -primary_repair_pipeline_read(self) void
    -repair_pipeline_read_callback(self, prepare, destination_replica) void
    -repair_prepares(self) void
    -repair_prepare(self, op) bool
    -repairs_allowed(self) bool
    -replace_header(self, header) void
    -replicate(self, message) void
    -standby_index_to_replica(self, index) u8
    -standby_replica_to_index(self, replica) u32
    -reset_quorum_messages(self, messages, command) void
    -reset_quorum_counter(self, counter) void
    -reset_quorum_do_view_change(self) void
    -reset_quorum_start_view_change(self) void
    -send_prepare_ok(self, header) void
    -send_prepare_oks_after_view_change(self) void
    -send_start_view_change(self) void
    -send_do_view_change(self) void
    -send_eviction_message_to_client(self, client) void
    -send_reply_message_to_client(self, reply) void
    -send_header_to_client(self, client, header) void
    -send_header_to_other_replicas(self, header) void
    -send_header_to_other_replicas_and_standbys(self, header) void
    -send_header_to_replica(self, replica, header) void
    -send_message_to_other_replicas(self, message) void
    -send_message_to_replica(self, replica, message) void
    -view_durable(self) u32
    -log_view_durable(self) u32
    -view_durable_updating(self) bool
    -view_durable_update(self) void
    -view_durable_update_callback(context) void
    -set_op_and_commit_max(self, op, commit_max, method) void
    -primary_set_log_from_do_view_change_messages(self) void
    -primary_log_do_view_change_quorum(self, context) void
    -primary_start_view_as_the_new_primary(self) void
    -transition_to_recovering_head(self) void
    -transition_to_normal_from_recovering_status(self) void
    -transition_to_normal_from_recovering_head_status(self, view_new) void
    -transition_to_normal_from_view_change_status(self, view_new) void
    -transition_to_view_change_status(self, view_new_min) void
    -sync_start_from_committing(self) void
    -sync_start_from_sync(self) void
    -sync_dispatch(self, state_new) void
    -sync_cancel_commit_callback(self) void
    -sync_cancel_grid_callback(grid) void
    -sync_requesting_trailers_callback(self) void
    -sync_superblock_update(self) void
    -sync_superblock_update_callback(superblock_context) void
    -valid_hash_chain(self, method) bool
    -valid_hash_chain_between(self, op_min, op_max) bool
    -jump_view(self, header) void
    -jump_sync_target(self, header) void
    -write_prepare(self, message, trigger) void
    -write_prepare_callback(self, wrote, trigger) void
    -on_grid_read_fault(grid, read) void
    -on_grid_read_fault_next_tick(next_tick) void
    -send_request_blocks(self) void
    -send_request_sync_trailer(self, command, offset) void
    -send_sync_trailer(self, command, parameters) void
    -next(iterator) ?*const Header
}
link HeaderIterator "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica.zig#L8738"
class DVCQuorum["DVCQuorum [str]"] {
    -verify(dvc_quorum) void
    -verify_message(message) void
    -dvcs_all(dvc_quorum) DVCArray
    -dvcs_canonical(dvc_quorum) DVCArray
    -dvcs_with_log_view(dvc_quorum, log_view) DVCArray
    -dvcs_uncanonical(dvc_quorum) DVCArray
    -op_checkpoint_max(dvc_quorum) u64
    -log_view_max(dvc_quorum) u32
    -commit_max(dvc_quorum) u64
    -timestamp_max(dvc_quorum) u64
    -op_max_canonical(dvc_quorum) u64
    -quorum_headers(dvc_quorum, options) union(enum)
}
DVCQuorum <-- HeaderIterator
link DVCQuorum "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica.zig#L8412"
class PipelineQueue["PipelineQueue [str]"] {
    -prepare_queue: PrepareQueue
    -request_queue: RequestQueue
    -deinit(pipeline, message_pool) void
    -verify(pipeline) void
    -full(pipeline) bool
    -prepare_by_op_and_checksum(pipeline, op, checksum) ?*Prepare
    -prepare_by_prepare_ok(pipeline, ok) ?*Prepare
    -message_by_client(pipeline, client_id) ?*const Message
    -pop_prepare(pipeline) ?Prepare
    -pop_request(pipeline) ?Request
    -push_request(pipeline, request) void
    -push_prepare(pipeline, message) void
}
link PipelineQueue "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica.zig#L8855"
class PipelineCache["PipelineCache [str]"] {
    -prepares: [prepares_max]?*Message
    -init_from_queue(queue) PipelineCache
    -deinit(pipeline, message_pool) void
    -empty(pipeline) bool
    -contains_header(pipeline, header) bool
    -prepare_by_op_and_checksum(pipeline, op, checksum) ?*Message
    -insert(pipeline, prepare) ?*Message
}
link PipelineCache "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica.zig#L9021"
class `vsr/replica.zig` {
    +ReplicaType(StateMachine, MessageBus, Storage, Time, AOF) type
    -message_body_as_view_headers(message) vsr.Headers.ViewChangeSlice
    -message_body_as_headers(message) []const Header
    -message_body_as_headers_unchecked(message) []const Header
}
`vsr/replica.zig` <-- Status
`vsr/replica.zig` <-- CommitStage
`vsr/replica.zig` <-- ReplicaEvent
`vsr/replica.zig` <-- Prepare
`vsr/replica.zig` <-- Request
`vsr/replica.zig` <-- DVCQuorum
`vsr/replica.zig` <-- PipelineQueue
`vsr/replica.zig` <-- PipelineCache
link `vsr/replica.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica.zig"
class `vsr/replica_format.zig` {
    test "format"()
    +format(Storage, allocator, options, storage, superblock) !void
    -ReplicaFormatType(Storage) type
}
link `vsr/replica_format.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica_format.zig"
class `vsr/grid.zig` {
    +allocate_block(allocator) error[OutOfMemory]!*align(constants.sector_size) [constants.block_size]u8
    +GridType(Storage) type
}
link `vsr/grid.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/grid.zig"
class Environment["Environment [str]"] {
    -sequence_states: SequenceStates
    -members: vsr.Members
    -superblock: *SuperBlock
    -superblock_verify: *SuperBlock
    -latest_sequence: u64
    -latest_checksum: u128
    -latest_parent: u128
    -latest_vsr_state: VSRState
    -context_format: SuperBlock.Context
    -context_open: SuperBlock.Context
    -context_checkpoint: SuperBlock.Context
    -context_view_change: SuperBlock.Context
    -context_verify: SuperBlock.Context
    -pending: std.enums.EnumSet(Caller)
    -pending_verify: bool
    -tick(env) !void
    -verify(env) !void
    -verify_callback(context) void
    -format(env) !void
    -format_callback(context) void
    -open(env) void
    -open_callback(context) void
    -view_change(env) !void
    -view_change_callback(context) void
    -checkpoint(env) !void
    -checkpoint_callback(context) void
}
link Environment "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_fuzz.zig#L162"
class `vsr/superblock_fuzz.zig` {
    +main() !void
    -run_fuzz(allocator, seed, transitions_count_total) !void
    -checksum_free_set(superblock) u128
}
`vsr/superblock_fuzz.zig` <-- Environment
link `vsr/superblock_fuzz.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_fuzz.zig"
class Reservation["Reservation [str]"] {
    +block_base: usize
    +block_count: usize
    +session: usize
}
link Reservation "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_free_set.zig#L18"
class FreeSet["FreeSet [str]"] {
    +index: DynamicBitSetUnmanaged
    +blocks: DynamicBitSetUnmanaged
    +staging: DynamicBitSetUnmanaged
    +reservation_blocks: usize
    +reservation_count: usize
    +reservation_state: enum
    +reservation_session: usize
    +init(allocator, blocks_count) !FreeSet
    +deinit(set, allocator) void
    +reset(set) void
    +count_reservations(set) usize
    +count_free(set) usize
    +count_free_reserved(set, reservation) usize
    +count_acquired(set) usize
    +highest_address_acquired(set) ?u64
    +reserve(set, reserve_count) ?Reservation
    +forfeit(set, reservation) void
    +acquire(set, reservation) ?u64
    -find_free_block_in_shard(set, shard) ?usize
    +is_free(set, address) bool
    +release(set, address) void
    -release_now(set, address) void
    +checkpoint(set) void
    +include_staging(set) void
    +exclude_staging(set) void
    +decode(set, source) const u8) void
    +encode_size_max(blocks_count) usize
    +encode(set, target) u8) usize
    +blocks_count_floor(blocks_count) usize
}
link FreeSet "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_free_set.zig#L41"
class TestPattern["TestPattern [str]"] {
    -fill: TestPatternFill
    -words: usize
}
link TestPattern "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_free_set.zig#L721"
class TestPatternFill["TestPatternFill [enu]"] {
    -uniform_ones
    -uniform_zeros
    -literal
}
link TestPatternFill "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_free_set.zig#L726"
class `vsr/superblock_free_set.zig` {
    test "FreeSet block shard count"()
    test "FreeSet highest_address_acquired"()
    test "FreeSet acquire/release"()
    test "FreeSet.reserve/acquire"()
    test "FreeSet checkpoint"()
    test "FreeSet encode, decode, encode"()
    test "FreeSet decode small bitset into large bitset"()
    test "FreeSet encode/decode manual"()
    test "find_bit"()
    -bit_set_masks(bit_set) []MaskInt
    -test_block_shards_count(expect_shards_count, blocks_count) !void
    -test_acquire_release(blocks_count) !void
    -test_encode(patterns) !void
    -expect_free_set_equal(a, b) !void
    -expect_bit_set_equal(a, b) !void
    -find_bit(bit_set, bit_min, bit_max, bit_kind) ?usize
    -test_find_bit(random, bit_set, bit_kind) !void
}
`vsr/superblock_free_set.zig` <-- Reservation
`vsr/superblock_free_set.zig` <-- FreeSet
`vsr/superblock_free_set.zig` <-- TestPattern
`vsr/superblock_free_set.zig` <-- TestPatternFill
link `vsr/superblock_free_set.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_free_set.zig"
class VSRState["VSRState [str]"] {
    +previous_checkpoint_id: u128
    +commit_min_checksum: u128
    +replica_id: u128
    +members: vsr.Members
    +commit_min: u64
    +commit_max: u64
    +log_view: u32
    +view: u32
    +replica_count: u8
    +reserved: [7]u8
    +root(options) VSRState
    +assert_internally_consistent(state) void
    +monotonic(old, new) bool
    +would_be_updated_by(old, new) bool
    +op_compacted(state, op) bool
}
link VSRState "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock.zig#L127"
class Snapshot["Snapshot [str]"] {
    +created: u64
    +queried: u64
    +timeout: u64
    +exists(snapshot) bool
}
link Snapshot "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock.zig#L236"
class SuperBlockHeader["SuperBlockHeader [str]"] {
    +checksum: u128
    +copy: u16
    +version: u16
    +cluster: u32
    +storage_size: u64
    +storage_size_max: u64
    +sequence: u64
    +parent: u128
    +manifest_checksum: u128
    +free_set_checksum: u128
    +client_sessions_checksum: u128
    +vsr_state: VSRState
    +flags: u64
    +snapshots: [constants.lsm_snapshots_max]Snapshot
    +manifest_size: u32
    +free_set_size: u32
    +client_sessions_size: u32
    +vsr_headers_count: u32
    +reserved: [2920]u8
    +vsr_headers_all: [constants.view_change_headers_max]vsr.Header
    +vsr_headers_reserved: [vsr_headers_reserved_size]u8
    +calculate_checksum(superblock) u128
    +set_checksum(superblock) void
    +valid_checksum(superblock) bool
    +checkpoint_id(superblock) u128
    +equal(a, b) bool
    +vsr_headers(superblock) vsr.Headers.ViewChangeSlice
    +trailer_size(superblock, trailer) u32
    +trailer_checksum(superblock, trailer) u128
}
SuperBlockHeader <-- VSRState
SuperBlockHeader <-- Snapshot
link SuperBlockHeader "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock.zig#L42"
class Caller["Caller [enu]"] {
    +format
    +open
    +checkpoint
    +view_change
    +sync
    -updates_vsr_headers(caller) bool
    -updates_trailers(caller) bool
}
link Caller "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock.zig#L1633"
class Trailer["Trailer [enu]"] {
    +manifest
    +free_set
    +client_sessions
    +zone(trailer) SuperBlockZone
}
link Trailer "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock.zig#L1679"
class SuperBlockZone["SuperBlockZone [enu]"] {
    +header
    +manifest
    +free_set
    +client_sessions
    +start(zone) u64
    +start_for_copy(zone, copy) u64
    +size_max(zone) u64
}
link SuperBlockZone "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock.zig#L1693"
class `vsr/superblock.zig` {
    test "SuperBlockHeader"()
    +SuperBlockType(Storage) type
}
`vsr/superblock.zig` <-- SuperBlockHeader
`vsr/superblock.zig` <-- Caller
`vsr/superblock.zig` <-- Trailer
`vsr/superblock.zig` <-- SuperBlockZone
link `vsr/superblock.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock.zig"
class `vsr/journal_format_fuzz.zig` {
    +main() !void
    +fuzz_format_wal_headers(write_size_max) !void
    +fuzz_format_wal_prepares(write_size_max) !void
    -verify_slot_header(slot, header) !void
}
link `vsr/journal_format_fuzz.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/journal_format_fuzz.zig"
class ProcessSelector["ProcessSelector [enu]"] {
    -__
    -R_
    -R0
    -R1
    -R2
    -R3
    -R4
    -R5
    -S_
    -S0
    -S1
    -S2
    -S3
    -S4
    -S5
    -A0
    -B1
    -B2
    -B3
    -B4
    -B5
    -C_
}
link ProcessSelector "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica_test.zig#L1013"
class TestContext["TestContext [str]"] {
    -cluster: *Cluster
    -log_level: std.log.Level
    -client_requests: [constants.clients_max]usize
    -client_replies: [constants.clients_max]usize
    +init(options) !*TestContext
    +deinit(t) void
    +replica(t, selector) TestReplicas
    +clients(t, index, count) TestClients
    +run(t) void
    -tick(t) bool
    -on_client_reply(cluster, client, request, reply) void
    -processes(t, selector) ProcessList
}
link TestContext "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica_test.zig#L1038"
class Role["Role [enu]"]
link Role "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica_test.zig#L1328"
class LinkDirection["LinkDirection [enu]"]
link LinkDirection "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica_test.zig#L1423"
class TestReplicas["TestReplicas [str]"] {
    -context: *TestContext
    -cluster: *Cluster
    -replicas: std.BoundedArray(u8, constants.members_max)
    -primary
    -backup
    -standby
    -bidirectional
    -incoming
    -outgoing
    +stop(t) void
    +open(t) !void
    +index(t) u8
    -get(t, field) std.meta.fieldInfo(Cluster.Replica, field).field_type
    +status(t) vsr.Status
    +view(t) u32
    +log_view(t) u32
    +op_head(t) u64
    +commit(t) u64
    +state_machine_opened(t) bool
    -sync_stage(t) vsr.SyncStage
    +sync_status(t) std.meta.Tag(vsr.SyncStage)
    -sync_target(t) ?vsr.SyncTarget
    +sync_target_checkpoint_op(t) ?u64
    +sync_target_checkpoint_id(t) ?u128
    +role(t) Role
    +op_checkpoint_id(t) u128
    +op_checkpoint(t) u64
    +view_headers(t) []const vsr.Header
    +diverge(t) void
    +corrupt(t, target) void
    +pass_all(t, peer, direction) void
    +drop_all(t, peer, direction) void
    +pass(t, peer, direction, command) void
    +drop(t, peer, direction, command) void
    +record(t, peer, direction, command) void
    +replay_recorded(t) void
    -peer_paths(t, peer, direction) std.BoundedArray(Network.Path, paths_max)
}
TestReplicas <-- Role
TestReplicas <-- LinkDirection
link TestReplicas "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica_test.zig#L1208"
class TestClients["TestClients [str]"] {
    -context: *TestContext
    -cluster: *Cluster
    -clients: std.BoundedArray(usize, constants.clients_max)
    -requests: usize
    +request(t, requests, expect_replies) !void
    +replies(t) usize
}
link TestClients "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica_test.zig#L1498"
class `vsr/replica_test.zig` {
    test "Cluster: recovery: WAL prepare corruption (R=3, corrupt right of head)"()
    test "Cluster: recovery: WAL prepare corruption (R=3, corrupt left of head, 3/3 corrupt)"()
    test "Cluster: recovery: WAL prepare corruption (R=3, corrupt root)"()
    test "Cluster: recovery: WAL prepare corruption (R=3, corrupt checkpoint…head)"()
    test "Cluster: recovery: WAL prepare corruption (R=1, corrupt between checkpoint and head)"()
    test "Cluster: recovery: WAL header corruption (R=1)"()
    test "Cluster: recovery: WAL torn prepare, standby with intact prepare (R=1 S=1)"()
    test "Cluster: recovery: grid corruption (disjoint)"()
    test "Cluster: recovery: recovering_head, outdated start view"()
    test "Cluster: recovery: recovering head: idle cluster"()
    test "Cluster: network: partition 2-1 (isolate backup, symmetric)"()
    test "Cluster: network: partition 2-1 (isolate backup, asymmetric, send-only)"()
    test "Cluster: network: partition 2-1 (isolate backup, asymmetric, receive-only)"()
    test "Cluster: network: partition 1-2 (isolate primary, symmetric)"()
    test "Cluster: network: partition 1-2 (isolate primary, asymmetric, send-only)"()
    test "Cluster: network: partition 1-2 (isolate primary, asymmetric, receive-only)"()
    test "Cluster: network: partition client-primary (symmetric)"()
    test "Cluster: network: partition client-primary (asymmetric, drop requests)"()
    test "Cluster: network: partition client-primary (asymmetric, drop replies)"()
    test "Cluster: repair: partition 2-1, then backup fast-forward 1 checkpoint"()
    test "Cluster: repair: view-change, new-primary lagging behind checkpoint, forfeit"()
    test "Cluster: repair: crash, corrupt committed pipeline op, repair it, view-change; dont nack"()
    test "Cluster: repair: corrupt reply"()
    test "Cluster: repair: ack committed prepare"()
    test "Cluster: repair: primary checkpoint, backup crash before checkpoint, primary prepare"()
    test "Cluster: view-change: DVC, 1+1/2 faulty header stall, 2+1/3 faulty header succeed"()
    test "Cluster: view-change: DVC, 2/3 faulty header stall"()
    test "Cluster: sync: partition, lag, sync (transition from idle)"()
    test "Cluster: sync: sync, bump target, sync"()
    test "Cluster: sync: R=2"()
    test "Cluster: sync: checkpoint diverges, sync (primary diverges)"()
    test "Cluster: sync: R=4, 2/4 ahead + idle, 2/4 lagging, sync"()
}
`vsr/replica_test.zig` <-- ProcessSelector
`vsr/replica_test.zig` <-- TestContext
`vsr/replica_test.zig` <-- TestReplicas
`vsr/replica_test.zig` <-- TestClients
link `vsr/replica_test.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica_test.zig"
class Aegis128["Aegis128 [str]"] {
    -init(key, nonce) State
    -update(blocks, d1, d2) void
    -absorb(blocks, src) void
    -mac(blocks, adlen, mlen) [16]u8
    -hash(blocks, source) u128
}
link Aegis128 "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/checksum.zig#L7"
class TestVector["TestVector [str]"] {
    -source: []const u8
    -hash: u128
}
link TestVector "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/checksum.zig#L107"
class `vsr/checksum.zig` {
    test "Aegis test vectors"()
    test "Aegis simple fuzzing"()
    -seed_init() void
    +checksum(source) u128
    -std_checksum(cipher, msg) u128
}
`vsr/checksum.zig` <-- Aegis128
link `vsr/checksum.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/checksum.zig"
class `vsr/client.zig` {
    +Client(StateMachine_, MessageBus) type
}
link `vsr/client.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/client.zig"
class Variant["Variant [enu]"] {
    -valid
    -valid_high_copy
    -invalid_broken
    -invalid_fork
    -invalid_misdirect
    -invalid_parent
    -invalid_vsr_state
}
link Variant "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_quorums_fuzz.zig#L202"
class CopyTemplate["CopyTemplate [str]"] {
    +sequence: u64
    +variant: Variant
    +make_valid(sequence) CopyTemplate
    +make_valid_high_copy(sequence) CopyTemplate
    +make_invalid_broken(_) CopyTemplate
    +make_invalid_fork(sequence) CopyTemplate
    +make_invalid_misdirect(sequence) CopyTemplate
    +make_invalid_parent(sequence) CopyTemplate
    +make_invalid_vsr_state(sequence) CopyTemplate
    -less_than(_, a, b) bool
}
CopyTemplate <-- Variant
link CopyTemplate "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_quorums_fuzz.zig#L198"
class `vsr/superblock_quorums_fuzz.zig` {
    +main() !void
    +fuzz_quorums_working(random) !void
    -test_quorums_working(random, threshold_count, copies, result) !void
    +fuzz_quorum_repairs(random, options) !void
}
`vsr/superblock_quorums_fuzz.zig` <-- CopyTemplate
link `vsr/superblock_quorums_fuzz.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_quorums_fuzz.zig"
class FreeSetEvent["FreeSetEvent [uni]"] {
    -blocks: usize
    -reserve: struct
    -forfeit: void
    -reservation: usize
    -acquire: struct
    -address: usize
    -release: struct
    -checkpoint: void
}
link FreeSetEvent "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_free_set_fuzz.zig#L118"
class FreeSetModel["FreeSetModel [str]"] {
    -blocks_acquired: std.DynamicBitSetUnmanaged
    -blocks_released: std.DynamicBitSetUnmanaged
    -blocks_reserved: std.DynamicBitSetUnmanaged
    -reservation_count: usize
    -reservation_session: usize
    -init(allocator, blocks_count) !FreeSetModel
    -deinit(set, allocator) void
    +count_reservations(set) usize
    +count_free(set) usize
    +count_free_reserved(set, reservation) usize
    +count_acquired(set) usize
    +highest_address_acquired(set) ?u64
    +reserve(set, reserve_count) ?Reservation
    +forfeit(set, reservation) void
    +acquire(set, reservation) ?u64
    +is_free(set, address) bool
    +release(set, address) void
    +checkpoint(set) void
    -assert_reservation_active(set, reservation) void
}
link FreeSetModel "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_free_set_fuzz.zig#L165"
class `vsr/superblock_free_set_fuzz.zig` {
    +main() !void
    -run_fuzz(allocator, random, blocks_count, events) !void
    -generate_events(allocator, random, blocks_count) ![]const FreeSetEvent
}
`vsr/superblock_free_set_fuzz.zig` <-- FreeSetEvent
`vsr/superblock_free_set_fuzz.zig` <-- FreeSetModel
link `vsr/superblock_free_set_fuzz.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_free_set_fuzz.zig"
class Options["Options [str]"] {
    +superblock_copies: u8
}
link Options "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_quorums.zig#L10"
class `vsr/superblock_quorums.zig` {
    test "Quorums.working"()
    test "Quorum.repairs"()
    +QuorumsType(options) type
}
`vsr/superblock_quorums.zig` <-- Options
link `vsr/superblock_quorums.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_quorums.zig"
class ReplySlot["ReplySlot [str]"] {
    +index: usize
}
link ReplySlot "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_client_sessions.zig#L10"
class Entry["Entry [str]"] {
    +session: u64
    +header: vsr.Header
}
link Entry "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_client_sessions.zig#L32"
class Iterator["Iterator [str]"] {
    +client_sessions: *const ClientSessions
    +index: usize
    +next(it) ?*const Entry
}
link Iterator "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_client_sessions.zig#L305"
class ClientSessions["ClientSessions [str]"] {
    +entries: []Entry
    +entries_by_client: EntriesByClient
    +entries_free: EntriesFree
    +init(allocator) !ClientSessions
    +deinit(client_sessions, allocator) void
    +reset(client_sessions) void
    +encode(client_sessions, target) u8) u64
    +decode(client_sessions, source) const u8) void
    +count(client_sessions) usize
    +capacity(client_sessions) usize
    +get(client_sessions, client) ?*Entry
    +get_slot_for_client(client_sessions, client) ?ReplySlot
    +get_slot_for_header(client_sessions, header) ?ReplySlot
    +put(client_sessions, session, header) ReplySlot
    +evictee(client_sessions) u128
    +remove(client_sessions, client) void
    +iterator(client_sessions) Iterator
}
ClientSessions <-- Entry
ClientSessions <-- Iterator
link ClientSessions "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_client_sessions.zig#L15"
class `vsr/superblock_client_sessions.zig`
`vsr/superblock_client_sessions.zig` <-- ReplySlot
`vsr/superblock_client_sessions.zig` <-- ClientSessions
link `vsr/superblock_client_sessions.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_client_sessions.zig"
class Interval["Interval [str]"] {
    +lower_bound: i64
    +upper_bound: i64
    +sources_true: u8
    +sources_false: u8
}
link Interval "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/marzullo.zig#L10"
class Tuple["Tuple [str]"] {
    +source: u8
    +offset: i64
    +bound: enum
}
link Tuple "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/marzullo.zig#L31"
class Marzullo["Marzullo [str]"] {
    +smallest_interval(tuples) Interval
    -less_than(context, a, b) bool
}
Marzullo <-- Interval
Marzullo <-- Tuple
link Marzullo "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/marzullo.zig#L8"
class `vsr/marzullo.zig` {
    test "marzullo"()
    -test_smallest_interval(bounds, smallest_interval) !void
}
`vsr/marzullo.zig` <-- Marzullo
link `vsr/marzullo.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/marzullo.zig"
class RequestingTrailers["RequestingTrailers [str]"] {
    +target: Target
    +trailers: Trailers
    +previous_checkpoint_id: ?u128
    +checkpoint_op_checksum: ?u128
    +done(self) bool
}
link RequestingTrailers "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/sync.zig#L27"
class UpdatingSuperBlock["UpdatingSuperBlock [str]"] {
    +target: Target
    +previous_checkpoint_id: u128
    +checkpoint_op_checksum: u128
}
link UpdatingSuperBlock "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/sync.zig#L50"
class Stage["Stage [uni]"] {
    +idle
    +canceling_commit
    +canceling_grid
    +requesting_target
    +requesting_trailers: RequestingTrailers
    +updating_superblock: UpdatingSuperBlock
    +valid_transition(from, to) bool
    +target(stage) ?Target
}
Stage <-- RequestingTrailers
Stage <-- UpdatingSuperBlock
link Stage "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/sync.zig#L9"
class TargetCandidate["TargetCandidate [str]"] {
    +checkpoint_id: u128
    +checkpoint_op: u64
    +canonical(target) Target
}
link TargetCandidate "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/sync.zig#L86"
class Target["Target [str]"] {
    +checkpoint_id: u128
    +checkpoint_op: u64
}
link Target "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/sync.zig#L100"
class TargetQuorum["TargetQuorum [str]"] {
    +candidates: [constants.replicas_max]?TargetCandidate
    +replace(quorum, replica, candidate) bool
    +count(quorum, candidate) usize
}
link TargetQuorum "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/sync.zig#L107"
class Trailer["Trailer [str]"] {
    +offset: u32
    +done: bool
    +size: u32
    +checksum: u128
    +final: ?struct
    +write_chunk(trailer, destination, chunk) enum [ complete, incomplete, ignore ]
}
link Trailer "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/sync.zig#L154"
class `vsr/sync.zig` {
    test "sync: Trailer chunk sequence"()
    test "sync: Trailer past/future chunk"()
}
`vsr/sync.zig` <-- Stage
`vsr/sync.zig` <-- TargetCandidate
`vsr/sync.zig` <-- Target
`vsr/sync.zig` <-- TargetQuorum
`vsr/sync.zig` <-- Trailer
link `vsr/sync.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/sync.zig"
class AssertionPoint["AssertionPoint [str]"] {
    -replica: u8
    -time: *Time
    -epoch: Epoch
    -window: Epoch
    -marzullo_tuples: []Marzullo.Tuple
    -synchronization_disabled: bool
    -tick: u64
    -expected_offset: i64
    +init(allocator, replica_count, replica, time) !Self
    +deinit(self, allocator) void
    +learn(self, replica, m0, t1, m2) void
    +monotonic(self) u64
    +realtime(self) i64
    +realtime_synchronized(self) ?i64
    +tick(self) void
    -estimate_asymmetric_delay(self, replica, one_way_delay, clock_offset) i64
    -synchronize(self) void
    -after_synchronization(self) void
    -window_tuples(self, tolerance) []Marzullo.Tuple
    -minimum_one_way_delay(a, b) ?Sample
}
link AssertionPoint "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/clock.zig#L502"
class ClockUnitTestContainer["ClockUnitTestContainer [str]"] {
    -time: DeterministicTime
    -clock: DeterministicClock
    -rtt: u64
    -owd: u64
    -learn_interval: u64
    +init(self, allocator, offset_type, offset_coefficient_A, offset_coefficient_B) !void
    +run_till_tick(self, tick) void
    +ticks_to_perform_assertions(self) [3]AssertionPoint
}
ClockUnitTestContainer <-- AssertionPoint
link ClockUnitTestContainer "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/clock.zig#L458"
class Packet["Packet [str]"] {
    -m0: u64
    -t1: ?i64
    -clock_simulator: *ClockSimulator
    +clone(packet) Packet
    +deinit(packet) void
    +command(_) Command
}
link Packet "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/clock.zig#L634"
class Options["Options [str]"] {
    -ping_timeout: u32
    -clock_count: u8
    -network_options: PacketSimulatorOptions
}
link Options "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/clock.zig#L653"
class ClockSimulator["ClockSimulator [str]"] {
    -allocator: std.mem.Allocator
    -options: Options
    -ticks: u64
    -network: PacketSimulatorType(Packet)
    -times: []DeterministicTime
    -clocks: []DeterministicClock
    -prng: std.rand.DefaultPrng
    +init(allocator, options) !ClockSimulator
    +deinit(self) void
    +tick(self) void
    -handle_packet(packet, path) void
}
ClockSimulator <-- Packet
ClockSimulator <-- Options
link ClockSimulator "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/clock.zig#L633"
class `vsr/clock.zig` {
    test "ideal clocks get clamped to cluster time"()
    test "clock: fuzz test"()
    +ClockType(Time) type
}
`vsr/clock.zig` <-- ClockUnitTestContainer
`vsr/clock.zig` <-- ClockSimulator
link `vsr/clock.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/clock.zig"
class Ring["Ring [enu]"] {
    -headers
    -prepares
    -offset(ring, slot) u64
}
link Ring "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/journal.zig#L24"
class Slot["Slot [str]"] {
    -index: usize
}
link Slot "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/journal.zig#L66"
class SlotRange["SlotRange [str]"] {
    +head: Slot
    +tail: Slot
    +contains(range, slot) bool
}
link SlotRange "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/journal.zig#L69"
class RecoveryDecision["RecoveryDecision [enu]"] {
    -append
    -fix
    -repair
    -pipeline
    -op_min: u64
    -op_max: u64
    -eql
    -nil
    -fix
    -vsr
    -cut_torn
    -cut_view_range
}
link RecoveryDecision "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/journal.zig#L2210"
class Matcher["Matcher [enu]"] {
    -any
    -is_false
    -is_true
    -assert_is_false
    -assert_is_true
}
link Matcher "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/journal.zig#L2225"
class Case["Case [str]"] {
    -label: []const u8
    -decision_multiple: RecoveryDecision
    -decision_single: RecoveryDecision
    -pattern: [9]Matcher
    -init(label, decision_multiple, decision_single, pattern) Case
    -check(case, parameters) !bool
    -decision(case, solo) RecoveryDecision
}
link Case "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/journal.zig#L2227"
class BitSet["BitSet [str]"] {
    +bits: std.DynamicBitSetUnmanaged
    +count: u64
    -init_full(allocator, count) !BitSet
    -deinit(bit_set, allocator) void
    +clear(bit_set, slot) void
    +bit(bit_set, slot) bool
    +set(bit_set, slot) void
}
link BitSet "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/journal.zig#L2367"
class `vsr/journal.zig` {
    test "recovery_cases"()
    test "format_wal_headers"()
    test "format_wal_prepares"()
    +JournalType(Replica, Storage) type
    -recovery_case(header, prepare, prepare_op_max) *const Case
    -header_ok(cluster, slot, header) ?*const Header
    +format_wal_headers(cluster, offset_logical, target) usize
    +format_wal_prepares(cluster, offset_logical, target) usize
}
`vsr/journal.zig` <-- Ring
`vsr/journal.zig` <-- Slot
`vsr/journal.zig` <-- SlotRange
`vsr/journal.zig` <-- RecoveryDecision
`vsr/journal.zig` <-- Matcher
`vsr/journal.zig` <-- Case
`vsr/journal.zig` <-- BitSet
link `vsr/journal.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/journal.zig"
class TableExtentKey["TableExtentKey [str]"] {
    +tree_hash: u128
    +table: u64
}
link TableExtentKey "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_manifest.zig#L42"
class TableExtent["TableExtent [str]"] {
    +block: u64
    +entry: u32
}
link TableExtent "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_manifest.zig#L47"
class BlockReference["BlockReference [str]"] {
    +tree: u128
    +checksum: u128
    +address: u64
}
link BlockReference "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_manifest.zig#L377"
class IteratorReverse["IteratorReverse [str]"] {
    +manifest: *const Manifest
    +tree: u128
    +count: u32
    +next(it) ?BlockReference
}
link IteratorReverse "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_manifest.zig#L386"
class Manifest["Manifest [str]"] {
    +trees: []u128
    +checksums: []u128
    +addresses: []u64
    +count: u32
    +count_max: u32
    +tables: Tables
    +compaction_set: std.AutoHashMapUnmanaged(u64, void)
    +init(allocator, manifest_block_count_max, forest_table_count_max) !Manifest
    +deinit(manifest, allocator) void
    +reset(manifest) void
    +encode(manifest, target) u8) u64
    +decode(manifest, source) const u8) void
    +append(manifest, tree, checksum, address) void
    +remove(manifest, tree, checksum, address) void
    -index_for_address(manifest, address) ?u32
    +queue_for_compaction(manifest, address) void
    +queued_for_compaction(manifest, address) bool
    +oldest_block_queued_for_compaction(manifest, tree) ?BlockReference
    +insert_table_extent(manifest, tree_hash, table, block, entry) bool
    +update_table_extent(manifest, tree_hash, table, block, entry) ?u64
    +remove_table_extent(manifest, tree_hash, table, block, entry) bool
    +iterator_reverse(manifest, tree) IteratorReverse
    +verify(manifest) void
    +verify_index_tree_checksum_address(manifest, index, tree, checksum, address) void
}
Manifest <-- TableExtentKey
Manifest <-- TableExtent
Manifest <-- BlockReference
Manifest <-- IteratorReverse
link Manifest "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_manifest.zig#L18"
class `vsr/superblock_manifest.zig` {
    test "SuperBlockManifest"()
    -test_iterator_reverse(manifest, tree, expect) !void
    -test_codec(manifest) !void
}
`vsr/superblock_manifest.zig` <-- Manifest
link `vsr/superblock_manifest.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_manifest.zig"
class `vsr/client_replies.zig` {
    -slot_offset(slot) usize
    +ClientRepliesType(Storage) type
}
link `vsr/client_replies.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/client_replies.zig"
```
