```mermaid
---
title: Tigerbeetle database (lsm)
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
class Options["Options [str]"] {
    -Key: type
    -value_size: u32
    -value_count: u32
    -node_size: u32
}
link Options "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/segmented_array_benchmark.zig#L12"
class `lsm/segmented_array_benchmark.zig` {
    +main() !void
    -alloc_shuffled_index(allocator, n, rand) ![]usize
}
`lsm/segmented_array_benchmark.zig` <-- Options
link `lsm/segmented_array_benchmark.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/segmented_array_benchmark.zig"
class `lsm/manifest.zig` {
    +TableInfoType(Table) type
    +ManifestType(Table, Storage) type
}
link `lsm/manifest.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest.zig"
class `lsm/table_data_iterator.zig` {
    +TableDataIteratorType(Storage) type
}
link `lsm/table_data_iterator.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/table_data_iterator.zig"
class Config["Config [str]"] {
    +lower_bound
    +upper_bound
    +mode: enum
}
link Config "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/binary_search.zig#L7"
class BinarySearchResult["BinarySearchResult [str]"] {
    -index: u32
    -exact: bool
}
link BinarySearchResult "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/binary_search.zig#L116"
class BinarySearchRangeUpsertIndexes["BinarySearchRangeUpsertIndexes [str]"] {
    +start: u32
    +end: u32
}
link BinarySearchRangeUpsertIndexes "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/binary_search.zig#L159"
class BinarySearchRange["BinarySearchRange [str]"] {
    +start: u32
    +count: u32
}
link BinarySearchRange "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/binary_search.zig#L237"
class test_binary_search["test_binary_search [str]"] {
    -key_min
    -key_max
    -compare_keys(a, b) math.Order
    -less_than_key(_, a, b) bool
    -exhaustive_search(keys_count, mode) !void
    -explicit_search(keys, target_keys, expected_results, mode) !void
    -random_sequence(allocator, random, iter) ![]const u32
    -random_search(random, iter, mode) !void
    +explicit_range_search(sequence, key_min, key_max, expected) !void
    -random_range_search(random, iter) !void
}
link test_binary_search "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/binary_search.zig#L304"
class `lsm/binary_search.zig` {
    test "binary search: exhaustive"()
    test "binary search: explicit"()
    test "binary search: duplicates"()
    test "binary search: random"()
    test "binary search: explicit range"()
    test "binary search: duplicated range"()
    test "binary search: random range"()
    +binary_search_values_upsert_index(Key, Value, key_from_value, compare_keys, values, key, config) u32
    +binary_search_keys_upsert_index(Key, compare_keys, keys, key, config) u32
    +binary_search_values(Key, Value, key_from_value, compare_keys, values, key, config) BinarySearchResult
    +binary_search_keys(Key, compare_keys, keys, key, config) BinarySearchResult
    +binary_search_values_range_upsert_indexes(Key, Value, key_from_value, compare_keys, values, key_min, key_max) BinarySearchRangeUpsertIndexes
    +binary_search_keys_range_upsert_indexes(Key, compare_keys, keys, key_min, key_max) BinarySearchRangeUpsertIndexes
    +binary_search_values_range(Key, Value, key_from_value, compare_keys, values, key_min, key_max) BinarySearchRange
    +binary_search_keys_range(Key, compare_keys, keys, key_min, key_max) BinarySearchRange
}
`lsm/binary_search.zig` <-- Config
`lsm/binary_search.zig` <-- BinarySearchResult
`lsm/binary_search.zig` <-- BinarySearchRangeUpsertIndexes
`lsm/binary_search.zig` <-- BinarySearchRange
`lsm/binary_search.zig` <-- test_binary_search
link `lsm/binary_search.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/binary_search.zig"
class `lsm/level_index_iterator.zig` {
    +LevelIndexIteratorType(Table, Storage) type
}
link `lsm/level_index_iterator.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/level_index_iterator.zig"
class `lsm/forest.zig` {
    +ForestType(Storage, groove_cfg) type
}
link `lsm/forest.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/forest.zig"
class Value["Value [str]"] {
    -key: u32
    -left_ancestor(node) ?u32
    -right_ancestor(node) ?u32
    -parent(node) ?u32
    -is_right_child(node) bool
    -is_left_child(node) bool
    +layout_from_keys_or_values(Key, Value, key_from_value, sentinel_key, values, layout) void
    +search_values(Key, Value, compare_keys, layout, values, key) []const Value
    +search_keys(Key, compare_keys, layout, values_count, key) ?u32
    -ffs(x) u6
    -to_key(value) u32
}
link Value "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/eytzinger.zig#L299"
class Bounds["Bounds [str]"] {
    +lower: ?u32
    +upper: ?u32
}
link Bounds "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/eytzinger.zig#L313"
class test_eytzinger["test_eytzinger [str]"] {
    -compare_keys(a, b) math.Order
    -layout_from_keys_or_values(keys_count, values_max, expect) !void
    -search(keys_count, values_max, sentinels_max) !void
}
test_eytzinger <-- Value
test_eytzinger <-- Bounds
link test_eytzinger "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/eytzinger.zig#L296"
class `lsm/eytzinger.zig` {
    test "eytzinger: equal key and value count"()
    test "eytzinger: power of two value count > key count"()
    test "eytzinger: non power of two value count"()
    test "eytzinger: handle classic binary search overflow"()
    test "eytzinger: search"()
    +eytzinger(keys_count, values_max) type
}
`lsm/eytzinger.zig` <-- test_eytzinger
link `lsm/eytzinger.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/eytzinger.zig"
class Value["Value [str]"] {
    -id: u64
    -value: u63
    -tombstone: u1
}
link Value "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/tree_fuzz.zig#L37"
class Key["Key [str]"] {
    -id: u64
    -compare_keys(a, b) std.math.Order
    -key_from_value(value) Key
    -tombstone(value) bool
    -tombstone_from_key(key) Key.Value
}
Key <-- Value
link Key "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/tree_fuzz.zig#L34"
class FuzzOp["FuzzOp [uni]"] {
    -compact: struct
    -put: Key.Value
    -remove: Key.Value
    -get: Key
}
link FuzzOp "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/tree_fuzz.zig#L73"
class `lsm/tree_fuzz.zig` {
    -EnvironmentType(table_usage) type
    -random_id(random, Int) Int
    +generate_fuzz_ops(random, fuzz_op_count) ![]const FuzzOp
    +main() !void
}
`lsm/tree_fuzz.zig` <-- Key
`lsm/tree_fuzz.zig` <-- FuzzOp
link `lsm/tree_fuzz.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/tree_fuzz.zig"
class `lsm/composite_key.zig` {
    +CompositeKey(Field) type
}
link `lsm/composite_key.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/composite_key.zig"
class `lsm/compaction.zig` {
    +CompactionType(Table, Tree, Storage) type
    -snapshot_max_for_table_input(op_min) u64
    +snapshot_min_for_table_output(op_min) u64
}
link `lsm/compaction.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/compaction.zig"
class Direction["Direction [enu]"] {
    +descending
    +reverse(d) Direction
}
link Direction "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/direction.zig#L1"
class `lsm/direction.zig` {
    +ascending
}
`lsm/direction.zig` <-- Direction
link `lsm/direction.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/direction.zig"
class Layout["Layout [str]"] {
    +ways: u64
    +tag_bits: u64
    +clock_bits: u64
    +cache_line_size: u64
    +value_alignment: ?u29
}
link Layout "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/set_associative_cache.zig#L16"
class context["context [str]"] {
    -name: []const u8
    -sets: u64
    -hits: u64
    -misses: u64
    -tags: []Tag
    -values: []align(value_alignment)
    -counts: PackedUnsignedIntegerArray(Count)
    -clocks: PackedUnsignedIntegerArray(Clock)
    +init(allocator, value_count_max, options) !Self
    +deinit(self, allocator) void
    +reset(self) void
    +get_index(self, key) ?usize
    +get(self, key) ?*align(value_alignment) Value
    +remove(self, key) void
    +demote(self, key) void
    -search(self, set, key) ?usize
    -search_tags(tags, tag) Ways
    +insert(self, value) void
    +insert_index(self, value) usize
    -associate(self, key) Set
    +inspect() void
    -run() !void
    -key_from_value(value) Key
    -hash(key) u64
    -equal(a, b) bool
}
link context "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/set_associative_cache.zig#L531"
class context["context [str]"] {
    -key_from_value(value) Key
    -hash(key) u64
    -equal(a, b) bool
}
link context "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/set_associative_cache.zig#L550"
class context["context [str]"] {
    -words: []Word
    -random: std.rand.Random
    -array: Array
    -reference: []UInt
    -bits: Bits
    +get(self, index) UInt
    +set(self, index, value) void
    -mask(index) Word
    -word(self, index) *Word
    -bits_index(index) BitsIndex
    -init(random, len) !Self
    -deinit(context) void
    -run(context) !void
    -verify(context) !void
    -next(it) ?BitIndex
    -key_from_value(value) Key
    -hash(key) u64
    -equal(a, b) bool
}
link context "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/set_associative_cache.zig#L780"
class reference["reference [str]"] {
    -search_tags(tags, tag) SAC.Ways
}
link reference "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/set_associative_cache.zig#L801"
class `lsm/set_associative_cache.zig` {
    test "SetAssociativeCache: eviction"()
    test "SetAssociativeCache: hash collision"()
    test "PackedUnsignedIntegerArray: unit"()
    test "PackedUnsignedIntegerArray: fuzz"()
    test "BitIterator"()
    test "SetAssociativeCache: search_tags()"()
    +SetAssociativeCache(Key, Value, key_from_value, hash, equal, layout) type
    -set_associative_cache_test(Key, Value, context, layout) type
    -PackedUnsignedIntegerArray(UInt) type
    -PackedUnsignedIntegerArrayFuzzTest(UInt) type
    -BitIterator(Bits) type
    -search_tags_test(Key, Value, layout) type
}
`lsm/set_associative_cache.zig` <-- Layout
link `lsm/set_associative_cache.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/set_associative_cache.zig"
class TableUsage["TableUsage [enu]"] {
    +general
    +secondary_index
}
link TableUsage "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/table.zig#L21"
class `lsm/table.zig` {
    test "Table"()
    +TableType(TableKey, TableValue, table_compare_keys, table_key_from_value, table_sentinel_key, table_tombstone, table_tombstone_from_key, table_value_count_max, table_usage) type
}
`lsm/table.zig` <-- TableUsage
link `lsm/table.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/table.zig"
class BlockType["BlockType [enu]"] {
    +reserved
    +manifest
    +index
    +filter
    +data
    +from(vsr_operation) BlockType
    +operation(block_type) vsr.Operation
}
link BlockType "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/schema.zig#L72"
class Context["Context [str]"] {
    +filter_block_count: u32
    +filter_block_count_max: u32
    +data_block_count: u32
    +data_block_count_max: u32
}
link Context "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/schema.zig#L100"
class Parameters["Parameters [str]"] {
    -key_size: u32
    -filter_block_count_max: u32
    -data_block_count_max: u32
}
link Parameters "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/schema.zig#L130"
class TableIndex["TableIndex [str]"] {
    +key_size: u32
    +filter_block_count_max: u32
    +data_block_count_max: u32
    +size: u32
    +filter_checksums_offset: u32
    +filter_checksums_size: u32
    +data_checksums_offset: u32
    +data_checksums_size: u32
    +keys_offset: u32
    +keys_size: u32
    +filter_addresses_offset: u32
    +filter_addresses_size: u32
    +data_addresses_offset: u32
    +data_addresses_size: u32
    +padding_offset: u32
    +padding_size: u32
    +init(parameters) TableIndex
    +from(index_block) TableIndex
    +data_addresses(index, index_block) []u64
    +data_addresses_used(index, index_block) []const u64
    +data_checksums(index, index_block) []u128
    +data_checksums_used(index, index_block) []const u128
    +filter_addresses(index, index_block) []u64
    +filter_addresses_used(index, index_block) []const u64
    +filter_checksums(index, index_block) []u128
    +filter_checksums_used(index, index_block) []const u128
    -blocks_used(index, index_block) u32
    -filter_blocks_used(index, index_block) u32
    +data_blocks_used(index, index_block) u32
}
TableIndex <-- Context
TableIndex <-- Parameters
link TableIndex "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/schema.zig#L90"
class Context["Context [str]"] {
    +data_block_count_max: u32
    +reserved: [12]u8
}
link Context "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/schema.zig#L297"
class TableFilter["TableFilter [str]"] {
    +data_block_count_max: u32
    +filter_offset: u32
    +filter_size: u32
    +padding_offset: u32
    +padding_size: u32
    +init(parameters) TableFilter
    +from(filter_block) TableFilter
    +block_filter(filter, filter_block) []u8
    +block_filter_const(filter, filter_block) []const u8
}
TableFilter <-- Context
link TableFilter "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/schema.zig#L295"
class Context["Context [str]"] {
    +key_count: u32
    +key_layout_size: u32
    +value_count_max: u32
    +value_size: u32
}
link Context "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/schema.zig#L362"
class TableData["TableData [str]"] {
    +key_count: u32
    +value_size: u32
    +value_count_max: u32
    +key_layout_offset: u32
    +key_layout_size: u32
    +values_offset: u32
    +values_size: u32
    +padding_offset: u32
    +padding_size: u32
    +init(parameters) TableData
    +from(data_block) TableData
    +block_values_bytes(schema, data_block) []align(16) u8
    +block_values_bytes_const(schema, data_block) []align(16) const u8
    +block_values_used_bytes(schema, data_block) []align(16) const u8
}
TableData <-- Context
link TableData "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/schema.zig#L360"
class `lsm/schema.zig` {
    +header_from_block(block) *const vsr.Header
}
`lsm/schema.zig` <-- BlockType
`lsm/schema.zig` <-- TableIndex
`lsm/schema.zig` <-- TableFilter
`lsm/schema.zig` <-- TableData
link `lsm/schema.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/schema.zig"
class `lsm/k_way_merge.zig` {
    test "k_way_merge: unit"()
    test "k_way_merge: fuzz"()
    +KWayMergeIteratorType(Context, Key, Value, key_from_value, compare_keys, k_max, stream_peek, stream_pop, stream_precedence) type
    -TestContext(k_max) type
}
link `lsm/k_way_merge.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/k_way_merge.zig"
class Tuple["Tuple [str]"] {
    -buffer: []align(node_alignment)
    -free: std.bit_set.DynamicBitSetUnmanaged
    -node_count: u32
    -random: std.rand.Random
    -node_pool: TestPool
    -node_map: std.AutoArrayHashMap(TestPool.Node, u64)
    -sentinel: u64
    -acquires: u64
    -releases: u64
    -node_size: u32
    -node_alignment: u12
    +init(allocator, node_count) !Self
    +deinit(pool, allocator) void
    +reset(pool) void
    +acquire(pool) Node
    +release(pool, node) void
    -init(random, node_count) !Self
    -deinit(context) void
    -run(context) !void
    -acquire(context) !void
    -release(context) !void
    -release_all(context) !void
}
link Tuple "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/node_pool.zig#L224"
class `lsm/node_pool.zig` {
    test "NodePool"()
    +NodePool(_node_size, _node_alignment) type
    -TestContext(node_size, node_alignment) type
}
link `lsm/node_pool.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/node_pool.zig"
class Value["Value [str]"] {
    -key: Key
    -tombstone: bool
}
link Value "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_level_fuzz.zig#L37"
class FuzzOp["FuzzOp [uni]"] {
    -insert_tables: usize
    -update_tables: usize
    -take_snapshot
    -remove_invisible: usize
    -remove_visible: usize
}
link FuzzOp "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_level_fuzz.zig#L96"
class GenerateContext["GenerateContext [str]"] {
    -inserted: usize
    -updated: usize
    -invisible: usize
    -max_inserted: usize
    -random: std.rand.Random
    -next(ctx, fuzz_op_tag) FuzzOp
}
link GenerateContext "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_level_fuzz.zig#L136"
class `lsm/manifest_level_fuzz.zig` {
    -compare_keys(a, b) std.math.Order
    -key_from_value(value) Key
    -tombstone_from_key(key) Value
    -tombstone(value) bool
    +main() !void
    -generate_fuzz_ops(random, table_count_max, fuzz_op_count) ![]const FuzzOp
    +EnvironmentType(table_count_max, node_size) type
}
`lsm/manifest_level_fuzz.zig` <-- Value
`lsm/manifest_level_fuzz.zig` <-- FuzzOp
`lsm/manifest_level_fuzz.zig` <-- GenerateContext
link `lsm/manifest_level_fuzz.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_level_fuzz.zig"
class `lsm/level_data_iterator.zig` {
    +LevelTableValueBlockIteratorType(Table, Storage) type
}
link `lsm/level_data_iterator.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/level_data_iterator.zig"
class IdTreeValue["IdTreeValue [str]"] {
    -id: u128
    -timestamp: u64
    -padding: u64
    -compare_keys(a, b) std.math.Order
    -key_from_value(value) u128
    -tombstone(value) bool
    -tombstone_from_key(id) IdTreeValue
}
link IdTreeValue "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/groove.zig#L48"
class `lsm/groove.zig` {
    test "Groove"()
    -ObjectTreeHelpers(Object) type
    -IndexCompositeKeyType(Field) type
    -IndexTreeType(Storage, Field, value_count_max) type
    +GrooveType(Storage, Object, groove_options) type
}
`lsm/groove.zig` <-- IdTreeValue
link `lsm/groove.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/groove.zig"
class FuzzOpAction["FuzzOpAction [uni]"] {
    -compact: struct
    -put_account: struct
    -get_account: u128
}
link FuzzOpAction "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/forest_fuzz.zig#L26"
class FuzzOpModifier["FuzzOpModifier [uni]"] {
    -normal
    -crash_after_ticks: usize
}
link FuzzOpModifier "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/forest_fuzz.zig#L40"
class FuzzOp["FuzzOp [str]"] {
    -action: FuzzOpAction
    -modifier: FuzzOpModifier
}
link FuzzOp "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/forest_fuzz.zig#L46"
class State["State [enu]"] {
    -op: u64
    -checkpoint: bool
    -op: u64
    -account: Account
    -init
    -superblock_format
    -superblock_open
    -forest_init
    -forest_open
    -fuzzing
    -forest_compact
    -forest_checkpoint
    -superblock_checkpoint
}
link State "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/forest_fuzz.zig#L80"
class Model["Model [str]"] {
    -checkpointed: KVType
    -log: LogType
    +init() Model
    +deinit(model) void
    +put_account(model, account, op) !void
    +get_account(model, id) ?Account
    +checkpoint(model, op) !void
    +storage_reset(model) void
}
link Model "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/forest_fuzz.zig#L294"
class Environment["Environment [str]"] {
    -state: State
    -storage: *Storage
    -superblock: SuperBlock
    -superblock_context: SuperBlock.Context
    -grid: Grid
    -forest: Forest
    -checkpoint_op: ?u64
    -ticks_remaining: usize
    -op: u64
    -account: Account
    -init(env, storage) !void
    -deinit(env) void
    +run(storage, fuzz_ops) !void
    -change_state(env, current_state, next_state) void
    -tick_until_state_change(env, current_state, next_state) !void
    -open(env) !void
    -close(env) void
    -superblock_format_callback(superblock_context) void
    -superblock_open_callback(superblock_context) void
    -forest_open_callback(forest) void
    +compact(env, op) !void
    -forest_compact_callback(forest) void
    +checkpoint(env, op) !void
    -forest_checkpoint_callback(forest) void
    -superblock_checkpoint_callback(superblock_context) void
    -prefetch_account(env, id) !void
    -put_account(env, a) void
    -get_account(env, id) ?Account
    -apply(env, fuzz_ops) !void
    -apply_op(env, fuzz_op, model) !void
    -apply_op_action(env, fuzz_op_action, model) !void
}
Environment <-- State
Environment <-- Model
link Environment "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/forest_fuzz.zig#L51"
class `lsm/forest_fuzz.zig` {
    +run_fuzz_ops(storage_options, fuzz_ops) !void
    -random_id(random, Int) Int
    +generate_fuzz_ops(random, fuzz_op_count) ![]const FuzzOp
    +main() !void
}
`lsm/forest_fuzz.zig` <-- FuzzOpAction
`lsm/forest_fuzz.zig` <-- FuzzOpModifier
`lsm/forest_fuzz.zig` <-- FuzzOp
`lsm/forest_fuzz.zig` <-- Environment
link `lsm/forest_fuzz.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/forest_fuzz.zig"
class `lsm/table_mutable.zig` {
    +TableMutableType(Table) type
}
link `lsm/table_mutable.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/table_mutable.zig"
class `lsm/tree.zig` {
    test "is_composite_key"()
    test "table_count_max_for_level/tree"()
    test "TreeType"()
    +TreeType(TreeTable, Storage) type
    +compaction_op_min(op) u64
    +table_count_max_for_tree(growth_factor, levels_count) u32
    +table_count_max_for_level(growth_factor, level) u32
    +key_fingerprint(key) Fingerprint
    -is_composite_key(Key) bool
}
link `lsm/tree.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/tree.zig"
class ManifestEvent["ManifestEvent [uni]"] {
    -level: u7
    -table: TableInfo
    -insert: struct
    -level: u7
    -table: TableInfo
    -remove: struct
    -compact: void
    -checkpoint: void
    -noop: void
}
link ManifestEvent "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_log_fuzz.zig#L126"
class EventType["EventType [enu]"] {
    -insert_new
    -insert_change_level
    -insert_change_snapshot
    -remove
    -compact
    -checkpoint
}
link EventType "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_log_fuzz.zig#L140"
class TableInfo["TableInfo [str]"] {
    -checksum: u128
    -address: u64
    -flags: u64
    -snapshot_min: u64
    -snapshot_max: u64
    -key_min: u128
    -key_max: u128
}
TableInfo <-- EventType
link TableInfo "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_log_fuzz.zig#L266"
class Environment["Environment [str]"] {
    -allocator: std.mem.Allocator
    -superblock_context: SuperBlock.Context
    -manifest_log: ManifestLog
    -manifest_log_verify: ManifestLog
    -manifest_log_model: ManifestLogModel
    -manifest_log_opening: ?ManifestLogModel.TableMap
    -manifest_log_reserved: bool
    -pending: usize
    -init(allocator, options) !Environment
    -deinit(env, allocator) void
    -wait(env, manifest_log) void
    -format_superblock(env) void
    -format_superblock_callback(context) void
    -open_superblock(env) void
    -open_superblock_callback(context) void
    -open(env) void
    -open_event(manifest_log, level, table) void
    -open_callback(manifest_log) void
    -reserve(env) void
    -insert(env, level, table) !void
    -remove(env, level, table) !void
    -compact(env) !void
    -compact_callback(manifest_log) void
    -checkpoint(env) !void
    -checkpoint_callback(manifest_log) void
    -checkpoint_superblock_callback(context) void
    -verify(env) !void
    -verify_superblock_open_callback(superblock_context) void
    -verify_manifest_open_event(manifest_log_verify, level, table) void
    -verify_manifest_open_callback(manifest_log_verify) void
}
link Environment "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_log_fuzz.zig#L282"
class TableEntry["TableEntry [str]"] {
    -level: u7
    -table: TableInfo
    -level: u7
    -table: TableInfo
}
link TableEntry "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_log_fuzz.zig#L540"
class ManifestLogModel["ManifestLogModel [str]"] {
    -insert
    -remove
    -tables: TableMap
    -appends: AppendList
    -init(allocator) !ManifestLogModel
    -deinit(model) void
    -current(model, table_address) ?TableEntry
    -insert(model, level, table) !void
    -remove(model, level, table) !void
    -checkpoint(model) !void
}
ManifestLogModel <-- TableEntry
link ManifestLogModel "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_log_fuzz.zig#L535"
class `lsm/manifest_log_fuzz.zig` {
    +main() !void
    -run_fuzz(allocator, random, events) !void
    -generate_events(allocator, random, events_count) ![]const ManifestEvent
    -verify_manifest(expect, actual) !void
    -verify_manifest_compaction_set(superblock, manifest_log_model) !void
    -hash_map_equals(K, V, a, b) bool
}
`lsm/manifest_log_fuzz.zig` <-- ManifestEvent
`lsm/manifest_log_fuzz.zig` <-- TableInfo
`lsm/manifest_log_fuzz.zig` <-- Environment
`lsm/manifest_log_fuzz.zig` <-- ManifestLogModel
link `lsm/manifest_log_fuzz.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_log_fuzz.zig"
class Fingerprint["Fingerprint [str]"] {
    +hash: u32
    +mask: @Vector(8, u32)
    +create(hash) Fingerprint
}
link Fingerprint "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/bloom_filter.zig#L10"
class test_bloom_filter["test_bloom_filter [str]"] {
    -random_keys(random, iter) !void
}
link test_bloom_filter "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/bloom_filter.zig#L85"
class `lsm/bloom_filter.zig` {
    test "bloom filter: refAllDecls"()
    test "bloom filter: random"()
    +add(fingerprint, filter) void
    +may_contain(fingerprint, filter) bool
    -block_index(hash, size) u32
}
`lsm/bloom_filter.zig` <-- Fingerprint
`lsm/bloom_filter.zig` <-- test_bloom_filter
link `lsm/bloom_filter.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/bloom_filter.zig"
class `lsm/table_immutable.zig` {
    +TableImmutableType(Table) type
    +TableImmutableIteratorType(Table, Storage) type
}
link `lsm/table_immutable.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/table_immutable.zig"
class `lsm/segmented_array_fuzz.zig` {
    +main() !void
}
link `lsm/segmented_array_fuzz.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/segmented_array_fuzz.zig"
class `lsm/manifest_log.zig` {
    +ManifestLogType(Storage, TableInfo) type
    -ManifestLogBlockType(Storage, TableInfo) type
}
link `lsm/manifest_log.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_log.zig"
class Options["Options [str]"] {
    +verify: bool
}
link Options "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/segmented_array.zig#L43"
class CompareInt["CompareInt [str]"] {
    -node_count: u32
    -nodes: *[node_count_max]?*[node_capacity]T
    -indexes: *[node_count_max + 1]u32
    -random: std.rand.Random
    -pool: TestPool
    -array: TestArray
    -reference: std.ArrayList(T)
    -inserts: u64
    -removes: u64
    +init(allocator) !Self
    +deinit(array, allocator, node_pool) void
    +reset(array) void
    +verify(array) void
    -insert_elements_at_absolute_index(array, node_pool, absolute_index, elements) void
    -insert_elements_batch(array, node_pool, absolute_index, elements) void
    -copy_backwards(a, b, target, source) void
    -insert_empty_node_at(array, node_pool, node) void
    +remove_elements(array, node_pool, absolute_index, remove_count) void
    -remove_elements_batch(array, node_pool, absolute_index, remove_count) void
    -maybe_remove_or_merge_node_with_next(array, node_pool, node) void
    -maybe_merge_nodes(array, node_pool, node, elements_next_node) void
    -remove_empty_node_at(array, node_pool, node) void
    -count(array, node) u32
    -increment_indexes_after(array, node, delta) void
    -decrement_indexes_after(array, node, delta) void
    +node_elements(array, node) []T
    +node_last_element(array, node) T
    +element_at_cursor(array, cursor) T
    +first(_) Cursor
    +last(array) Cursor
    +len(array) u32
    +absolute_index_for_cursor(array, cursor) u32
    -cursor_for_absolute_index(array, absolute_index) Cursor
    +iterator_from_cursor(array, cursor, direction) Iterator
    +iterator_from_index(array, absolute_index, direction) Iterator
    -init(allocator, random) !Self
    -deinit(context, allocator) void
    -run(context) !void
    -insert(context) !void
    -remove(context) !void
    -insert_before_first(context) !void
    -remove_last(context) !void
    -remove_all(context) !void
    -verify(context) !void
    -verify_search(context) !void
    -reference_index(context, key) u32
    -compare_keys(a, b) std.math.Order
    -key_from_value(value) u32
}
link CompareInt "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/segmented_array.zig#L1260"
class CompareTable["CompareTable [str]"] {
    -compare_keys(a, b) std.math.Order
    -key_from_value(value) u64
}
link CompareTable "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/segmented_array.zig#L1270"
class TestOptions["TestOptions [str]"] {
    -element_type: type
    -node_size: u32
    -element_count_max: u32
}
link TestOptions "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/segmented_array.zig#L1286"
class `lsm/segmented_array.zig` {
    test "SegmentedArray"()
    +SegmentedArray(T, NodePool, element_count_max, options) type
    +SortedSegmentedArray(T, NodePool, element_count_max, Key, key_from_value, compare_keys, options) type
    -SegmentedArrayType(T, NodePool, element_count_max, Key, key_from_value) else voi
    -TestContext(T, node_size, element_count_max, Key, key_from_value, compare_keys, element_order, options) type
    +run_tests(allocator, seed, options) !void
}
`lsm/segmented_array.zig` <-- Options
link `lsm/segmented_array.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/segmented_array.zig"
class Page["Page [str]"] {
    -keys: [layout.keys_count]K
    -values: [layout.values_count]V
}
link Page "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/eytzinger_benchmark.zig#L79"
class Layout["Layout [str]"] {
    -blob_size: usize
    -key_size: usize
    -value_size: usize
    -keys_count: usize
    -values_count: usize
    -searches: usize
}
Layout <-- Page
link Layout "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/eytzinger_benchmark.zig#L183"
class BenchmarkResult["BenchmarkResult [str]"] {
    -wall_time: u64
    -utime: u64
    -cpu_cycles: usize
    -instructions: usize
    -cache_references: usize
    -cache_misses: usize
    -branch_misses: usize
}
link BenchmarkResult "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/eytzinger_benchmark.zig#L215"
class Benchmark["Benchmark [str]"] {
    -timer: std.time.Timer
    -rusage: std.os.rusage
    -perf_fds: [perf_counters.len]std.os.fd_t
    -begin() !Benchmark
    -end(self, samples) !BenchmarkResult
}
link Benchmark "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/eytzinger_benchmark.zig#L234"
class `lsm/eytzinger_benchmark.zig` {
    +main() !void
    -run_benchmark(layout, blob, random) !void
    -Value(layout) type
    -shuffled_index(n, rand) [n]usize
    -timeval_to_ns(tv) u64
    -readPerfFd(fd) !usize
    -binary_search_keys(layout, Key, V, compare_keys, keys, values, key) []const V
}
`lsm/eytzinger_benchmark.zig` <-- Layout
`lsm/eytzinger_benchmark.zig` <-- BenchmarkResult
`lsm/eytzinger_benchmark.zig` <-- Benchmark
link `lsm/eytzinger_benchmark.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/eytzinger_benchmark.zig"
class Options["Options [str]"] {
    -keys: Keys
    -tables: Tables
    -key_range: LevelKeyRange
    -table_count_visible: u32
    -generation: u32
    -random: std.rand.Random
    -pool: TestPool
    -level: TestLevel
    -snapshot_max: u64
    -snapshots: std.BoundedArray(u64, 8)
    -snapshot_tables: std.BoundedArray(std.ArrayList(TableInfo)
    -reference: std.ArrayList(TableInfo)
    -inserts: u64
    -removes: u64
    -key_type: type
    -node_size: u32
    -table_count_max: u32
    +init(allocator) !Self
    +deinit(level, allocator, node_pool) void
    +reset(level) void
    +insert_table(level, node_pool, table) void
    +set_snapshot_max(level, snapshot, table_ref) void
    +remove_table_visible(level, node_pool, table) *const TableInfo
    +remove_table_invisible(level, node_pool, snapshots, table) void
    +key_range_contains(level, snapshot, key) bool
    -remove_table(level, node_pool, table) void
    +iterator(level, visibility, snapshots, direction, key_range) Iterator
    -iterator_start(level, key_min, key_max, direction) ?Keys.Cursor
    -iterator_start_boundary(level, key_cursor, direction) Keys.Cursor
    +contains(level, table) bool
    +table_with_least_overlap(level_a, level_b, snapshot, max_overlapping_tables) ?LeastOverlapTable
    +next_table(self, parameters) ?*const TableInfo
    +tables_overlapping_with_key_range(level, key_min, key_max, snapshot, max_overlapping_tables) ?OverlapRange
    -compare_keys(a, b) math.Order
    -key_from_value(value) Key
    -tombstone_from_key(key) Value
    -tombstone(value) bool
    -init(random) !Self
    -deinit(context) void
    -run(context) !void
    -insert_tables(context) !void
    -random_greater_non_overlapping_table(context, key) TableInfo
    -take_snapshot(context) u64
    -create_snapshot(context) !void
    -drop_snapshot(context) !void
    -delete_tables(context) !void
    -remove_all(context) !void
    -verify(context) !void
    -verify_snapshot(context, snapshot, reference) !void
    -key_min_from_table(table) Key
}
link Options "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_level.zig#L1202"
class `lsm/manifest_level.zig` {
    test "ManifestLevel"()
    +ManifestLevelType(NodePool, Key, TableInfo, compare_keys, table_count_max) type
    +TestContext(node_size, Key, table_count_max) type
}
link `lsm/manifest_level.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_level.zig"
```
