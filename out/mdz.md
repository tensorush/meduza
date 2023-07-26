```mermaid
---
title: Tigerbeetle database
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
class AOFEntryMetadata["AOFEntryMetadata [struct]"] {
    +primary: u64
    +replica: u64
    +reserved: [64]u8
}
link AOFEntryMetadata "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/aof.zig#L26"
class AOFEntry["AOFEntry [struct]"] {
    +magic_number: u128
    +metadata: AOFEntryMetadata
    +message: [constants.message_size_max]u8 align(constants.sector_size)
    +calculate_disk_size(self) u64
    +header(self) *Header
    +to_message(self, target) void
    +from_message(self, message, options, last_checksum) void
}
link AOFEntry "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/aof.zig#L37"
class AOF["AOF [struct]"] {
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
class AOFReplayClient["AOFReplayClient [struct]"] {
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
class EntryInfo["EntryInfo [struct]"] {
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
class `clients/go/docs.zig` {
    -go_current_commit_pre_install_hook(arena, sample_dir, _) !void
    -go_current_commit_post_install_hook(arena, sample_dir, root) !void
}
link `clients/go/docs.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/go/docs.zig"
class `clients/go/go_bindings.zig` {
    test "bindings go"()
    -go_type(Type) []const u8
    -get_mapped_type_name(Type) ?[]const u8
    -to_pascal_case(input, min_len) []const u8
    -calculate_min_len(type_info) comptime_int
    -is_upper_case(word) bool
    -emit_enum(buffer, Type, name, prefix, int_type) !void
    -emit_packed_struct(buffer, type_info, name, int_type) !void
    -emit_struct(buffer, type_info, name) !void
    +generate_bindings(buffer) !void
    +main() !void
}
link `clients/go/go_bindings.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/go/go_bindings.zig"
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
class TypeMapping["TypeMapping [struct]"] {
    -name: []const u8
    -private_fields: []const []const u8
    -readonly_fields: []const []const u8
    -docs_link: ?[]const u8
    -public
    -internal
    -visibility: enum
    +is_private(self, name) bool
    +is_read_only(self, name) bool
}
link TypeMapping "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/java_bindings.zig#L10"
class `clients/java/java_bindings.zig` {
    test "bindings java"()
    -java_type(Type) []const u8
    -get_mapped_type_name(Type) ?[]const u8
    -to_case(input, case) []const u8
    -emit_enum(buffer, Type, mapping, int_type) !void
    -emit_packed_enum(buffer, type_info, mapping, int_type) !void
    -batch_type(Type) []const u8
    -emit_batch(buffer, type_info, mapping, size) !void
    -emit_batch_accessors(buffer, mapping, field) !void
    -emit_u128_batch_accessors(buffer, mapping, field) !void
    +generate_bindings(ZigType, mapping, buffer) !void
    +main() !void
}
`clients/java/java_bindings.zig` <-- TypeMapping
link `clients/java/java_bindings.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/java_bindings.zig"
class `clients/java/docs.zig` {
    -find_tigerbeetle_client_jar(arena, root) ![]const u8
    -java_current_commit_pre_install_hook(arena, sample_root, root) !void
    -local_command_hook(arena, cmd) ![]const u8
}
link `clients/java/docs.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/docs.zig"
class `clients/java/src/jni_tests.zig` {
    test "JNI: check jvm"()
    test "JNI: GetVersion"()
    test "JNI: FindClass"()
    test "JNI: GetSuperclass"()
    test "JNI: IsAssignableFrom"()
    test "JNI: GetModule"()
    test "JNI: Throw"()
    test "JNI: ThrowNew"()
    test "JNI: ExceptionOccurred"()
    test "JNI: ExceptionDescribe"()
    test "JNI: ExceptionClear"()
    test "JNI: ExceptionCheck"()
    test "JNI: References"()
    test "JNI: LocalFrame"()
    test "JNI: AllocObject"()
    test "JNI: NewObject"()
    test "JNI: IsInstanceOf"()
    test "JNI: GetFieldId"()
    test "JNI: Get<Type>Field, Set<Type>Field"()
    test "JNI: GetMethodId"()
    test "JNI: Call<Type>Method,CallNonVirtual<Type>Method"()
    test "JNI: GetStaticFieldId"()
    test "JNI: GetStatic<Type>Field, SetStatic<Type>Field"()
    test "JNI: GetStaticMethodId"()
    test "JNI: CallStatic<Type>Method"()
    test "JNI: strings"()
    test "JNI: strings utf"()
    test "JNI: GetStringRegion"()
    test "JNI: GetStringUTFRegion"()
    test "JNI: GetStringCritical"()
    test "JNI: DirectByteBuffer"()
    test "JNI: object array"()
    test "JNI: primitive arrays"()
}
link `clients/java/src/jni_tests.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/src/jni_tests.zig"
class JNIResultType["JNIResultType [enum]"] {
    +ok
    +unknown
    +thread_detached
    +bad_version
    +out_of_memory
    +vm_already_exists
    +invalid_arguments
    +_
}
link JNIResultType "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/src/jni.zig#L31"
class JBoolean["JBoolean [enum]"] {
    +jni_true
    +jni_false
}
link JBoolean "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/src/jni.zig#L60"
class JValue["JValue [union]"] {
    +object: JObject
    +boolean: JBoolean
    +byte: JByte
    +char: JChar
    +short: JShort
    +int: JInt
    +long: JLong
    +float: JFloat
    +double: JDouble
    +to_jvalue(value) JValue
}
link JValue "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/src/jni.zig#L97"
class JArrayReleaseMode["JArrayReleaseMode [enum]"] {
    +default
    +commit
    +abort
}
link JArrayReleaseMode "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/src/jni.zig#L126"
class JObjectRefType["JObjectRefType [enum]"] {
    +invalid
    +local
    +global
    +weak_global
    +_
}
link JObjectRefType "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/src/jni.zig#L138"
class JNINativeMethod["JNINativeMethod [struct]"] {
    +name: [*:0]const u8
    +signature: [*:0]const u8
    +fn_ptr: ?*anyopaque
}
link JNINativeMethod "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/src/jni.zig#L147"
class FunctionTable["FunctionTable [enum]"] {
    -get_version
    -define_class
    -find_class
    -from_reflected_method
    -from_feflected_field
    -to_reflected_method
    -get_super_class
    -is_assignable_from
    -to_reflected_field
    -throw
    -throw_new
    -exception_occurred
    -exception_describe
    -exception_clear
    -fatal_error
    -push_local_frame
    -pop_local_frame
    -new_global_ref
    -delete_global_ref
    -delete_local_ref
    -is_same_object
    -new_local_ref
    -ensure_local_capacity
    -alloc_object
    -new_object
    -get_object_class
    -is_instance_of
    -get_method_id
    -call_object_method
    -call_boolean_method
    -call_byte_method
    -call_char_method
    -call_short_method
    -call_int_method
    -call_long_method
    -call_float_method
    -call_double_method
    -call_void_method
    -call_nonvirtual_object_method
    -call_nonvirtual_boolean_method
    -call_nonvirtual_byte_method
    -call_nonvirtual_char_method
    -call_nonvirtual_short_method
    -call_nonvirtual_int_method
    -call_nonvirtual_long_method
    -call_nonvirtual_float_method
    -call_nonvirtual_double_method
    -call_nonvirtual_void_method
    -get_field_id
    -get_object_field
    -get_boolean_field
    -get_byte_field
    -get_char_field
    -get_short_field
    -get_int_field
    -get_long_field
    -get_float_field
    -get_double_field
    -set_object_field
    -set_boolean_field
    -set_byte_field
    -set_char_field
    -set_short_field
    -set_int_field
    -set_long_field
    -set_float_field
    -set_double_field
    -get_static_method_id
    -call_static_object_method
    -call_static_boolean_method
    -call_static_byte_method
    -call_static_char_method
    -call_static_short_method
    -call_static_int_method
    -call_static_long_method
    -call_static_float_method
    -call_static_double_method
    -call_static_void_method
    -get_static_field_id
    -get_static_object_field
    -get_static_boolean_field
    -get_static_byte_field
    -get_static_char_field
    -get_static_short_field
    -get_static_int_field
    -get_static_long_field
    -get_static_float_field
    -get_static_double_field
    -set_static_object_field
    -set_static_boolean_field
    -set_static_byte_field
    -set_static_char_field
    -set_static_short_field
    -set_static_int_field
    -set_static_long_field
    -set_static_float_field
    -set_static_double_field
    -new_string
    -get_string_length
    -get_string_chars
    -release_string_chars
    -new_string_utf
    -get_string_utf_length
    -get_string_utf_chars
    -release_string_utf_chars
    -get_array_length
    -new_object_array
    -get_object_array_element
    -set_object_array_element
    -new_boolean_array
    -new_byte_array
    -new_char_array
    -new_short_array
    -new_int_array
    -new_long_array
    -new_float_array
    -new_double_array
    -get_boolean_array_elements
    -get_byte_array_elements
    -get_char_array_elements
    -get_short_array_elements
    -get_int_array_elements
    -get_long_array_elements
    -get_float_array_elements
    -get_double_array_elements
    -release_boolean_array_elements
    -release_byte_array_elements
    -release_char_array_elements
    -release_short_array_elements
    -release_int_array_elements
    -release_long_array_elements
    -release_float_array_elements
    -release_double_array_elements
    -get_boolean_array_region
    -get_byte_array_region
    -get_char_array_region
    -get_short_array_region
    -get_int_array_region
    -get_long_array_region
    -get_float_array_region
    -get_double_array_region
    -set_boolean_array_region
    -set_byte_array_region
    -set_char_array_region
    -set_short_array_region
    -set_int_array_region
    -set_long_array_region
    -set_float_array_region
    -set_double_array_region
    -register_natives
    -unregister_natives
    -monitor_enter
    -monitor_exit
    -get_java_vm
    -get_string_region
    -get_string_utf_region
    -get_primitive_array_critical
    -release_primitive_array_critical
    -get_string_critical
    -release_string_critical
    -new_weak_global_ref
    -delete_weak_global_ref
    -exception_check
    -new_direct_byte_buffer
    -get_direct_buffer_address
    -get_direct_buffer_capacity
    -get_object_ref_type
    -get_module
}
link FunctionTable "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/src/jni.zig#L156"
class JNIEnv["JNIEnv [opaque]"] {
    +get_version(env) JInt
    +define_class(env, name, loader, buf, buf_len) JClass
    +find_class(env, name) JClass
    +from_reflected_method(env, jobject) JMethodID
    +from_feflected_field(env, jobject) JFieldID
    +to_reflected_method(env, cls, method_id, is_static) JObject
    +get_super_class(env, clazz) JClass
    +is_assignable_from(env, clazz_1, clazz_2) JBoolean
    +to_reflected_field(env, cls, field_id, is_static) JObject
    +throw(env, obj) JNIResultType
    +throw_new(env, clazz, message) JNIResultType
    +exception_occurred(env) JThrowable
    +exception_describe(env) void
    +exception_clear(env) void
    +fatal_error(env, msg) noreturn
    +push_local_frame(env, capacity) JNIResultType
    +pop_local_frame(env, result) JObject
    +new_global_ref(env, obj) JObject
    +delete_global_ref(env, global_ref) void
    +delete_local_ref(env, local_ref) void
    +is_same_object(env, ref_1, ref_2) JBoolean
    +new_local_ref(env, ref) JObject
    +ensure_local_capacity(env, capacity) JNIResultType
    +alloc_object(env, clazz) JObject
    +new_object(env, clazz, method_id, args) JObject
    +get_object_class(env, jobject) JClass
    +is_instance_of(env, jobject, clazz) JBoolean
    +get_method_id(env, clazz, name, sig) JMethodID
    +call_object_method(env, obj, method_id, args) JObject
    +call_boolean_method(env, obj, method_id, args) JBoolean
    +call_byte_method(env, obj, method_id, args) JByte
    +call_char_method(env, obj, method_id, args) JChar
    +call_short_method(env, obj, method_id, args) JShort
    +call_int_method(env, obj, method_id, args) JInt
    +call_long_method(env, obj, method_id, args) JLong
    +call_float_method(env, obj, method_id, args) JFloat
    +call_double_method(env, obj, method_id, args) JDouble
    +call_void_method(env, obj, method_id, args) void
    +call_nonvirtual_object_method(env, obj, clazz, method_id, args) JObject
    +call_nonvirtual_boolean_method(env, obj, clazz, method_id, args) JBoolean
    +call_nonvirtual_byte_method(env, obj, clazz, method_id, args) JByte
    +call_nonvirtual_char_method(env, obj, clazz, method_id, args) JChar
    +call_nonvirtual_short_method(env, obj, clazz, method_id, args) JShort
    +call_nonvirtual_int_method(env, obj, clazz, method_id, args) JInt
    +call_nonvirtual_long_method(env, obj, clazz, method_id, args) JLong
    +call_nonvirtual_float_method(env, obj, clazz, method_id, args) JFloat
    +call_nonvirtual_double_method(env, obj, clazz, method_id, args) JDouble
    +call_nonvirtual_void_method(env, obj, clazz, method_id, args) void
    +get_field_id(env, clazz, name, sig) JFieldID
    +get_object_field(env, obj, field_id) JObject
    +get_boolean_field(env, obj, field_id) JBoolean
    +get_byte_field(env, obj, field_id) JByte
    +get_char_field(env, obj, field_id) JChar
    +get_short_field(env, obj, field_id) JShort
    +get_int_field(env, obj, field_id) JInt
    +get_long_field(env, obj, field_id) JLong
    +get_float_field(env, obj, field_id) JFloat
    +get_double_field(env, obj, field_id) JDouble
    +set_object_field(env, obj, field_id, value) void
    +set_boolean_field(env, obj, field_id, value) void
    +set_byte_field(env, obj, field_id, value) void
    +set_char_field(env, obj, field_id, value) void
    +set_short_field(env, obj, field_id, value) void
    +set_int_field(env, obj, field_id, value) void
    +set_long_field(env, obj, field_id, value) void
    +set_float_field(env, obj, field_id, value) void
    +set_double_field(env, obj, field_id, value) void
    +get_static_method_id(env, clazz, name, sig) JMethodID
    +call_static_object_method(env, clazz, method_id, args) JObject
    +call_static_boolean_method(env, clazz, method_id, args) JBoolean
    +call_static_byte_method(env, clazz, method_id, args) JByte
    +call_static_char_method(env, clazz, method_id, args) JChar
    +call_static_short_method(env, clazz, method_id, args) JShort
    +call_static_int_method(env, clazz, method_id, args) JInt
    +call_static_long_method(env, clazz, method_id, args) JLong
    +call_static_float_method(env, clazz, method_id, args) JFloat
    +call_static_double_method(env, clazz, method_id, args) JDouble
    +call_static_void_method(env, clazz, method_id, args) void
    +get_static_field_id(env, clazz, name, sig) JFieldID
    +get_static_object_field(env, clazz, field_id) JObject
    +get_static_boolean_field(env, clazz, field_id) JBoolean
    +get_static_byte_field(env, clazz, field_id) JByte
    +get_static_char_field(env, clazz, field_id) JChar
    +get_static_short_field(env, clazz, field_id) JShort
    +get_static_int_field(env, clazz, field_id) JInt
    +get_static_long_field(env, clazz, field_id) JLong
    +get_static_float_field(env, clazz, field_id) JFloat
    +get_static_double_field(env, clazz, field_id) JDouble
    +set_static_object_field(env, clazz, field_id, value) void
    +set_static_boolean_field(env, clazz, field_id, value) void
    +set_static_byte_field(env, clazz, field_id, value) void
    +set_static_char_field(env, clazz, field_id, value) void
    +set_static_short_field(env, clazz, field_id, value) void
    +set_static_int_field(env, clazz, field_id, value) void
    +set_static_long_field(env, clazz, field_id, value) void
    +set_static_float_field(env, clazz, field_id, value) void
    +set_static_double_field(env, clazz, field_id, value) void
    +new_string(env, unicode_chars, size) JString
    +get_string_length(env, string) JSize
    +get_string_chars(env, string, is_copy) ?[*]const JChar
    +release_string_chars(env, string, chars) void
    +new_string_utf(env, bytes) JString
    +get_string_utf_length(env, string) JSize
    +get_string_utf_chars(env, string, is_copy) ?[*:0]const u8
    +release_string_utf_chars(env, string, utf) void
    +get_array_length(env, array) JSize
    +new_object_array(env, length, element_class, initial_element) JObjectArray
    +get_object_array_element(env, array, index) JObject
    +set_object_array_element(env, array, index, value) void
    +new_boolean_array(env, length) JBooleanArray
    +new_byte_array(env, length) JByteArray
    +new_char_array(env, length) JCharArray
    +new_short_array(env, length) JShortArray
    +new_int_array(env, length) JIntArray
    +new_long_array(env, length) JLongArray
    +new_float_array(env, length) JFloatArray
    +new_double_array(env, length) JDoubleArray
    +get_boolean_array_elements(env, array, is_copy) ?[*]JBoolean
    +get_byte_array_elements(env, array, is_copy) ?[*]JByte
    +get_char_array_elements(env, array, is_copy) ?[*]JChar
    +get_short_array_elements(env, array, is_copy) ?[*]JShort
    +get_int_array_elements(env, array, is_copy) ?[*]JInt
    +get_long_array_elements(env, array, is_copy) ?[*]JLong
    +get_float_array_elements(env, array, is_copy) ?[*]JFloat
    +get_double_array_elements(env, array, is_copy) ?[*]JDouble
    +release_boolean_array_elements(env, array, elems, mode) void
    +release_byte_array_elements(env, array, elems, mode) void
    +release_char_array_elements(env, array, elems, mode) void
    +release_short_array_elements(env, array, elems, mode) void
    +release_int_array_elements(env, array, elems, mode) void
    +release_long_array_elements(env, array, elems, mode) void
    +release_float_array_elements(env, array, elems, mode) void
    +release_double_array_elements(env, array, elems, mode) void
    +get_boolean_array_region(env, array, start, len, buf) void
    +get_byte_array_region(env, array, start, len, buf) void
    +get_char_array_region(env, array, start, len, buf) void
    +get_short_array_region(env, array, start, len, buf) void
    +get_int_array_region(env, array, start, len, buf) void
    +get_long_array_region(env, array, start, len, buf) void
    +get_float_array_region(env, array, start, len, buf) void
    +get_double_array_region(env, array, start, len, buf) void
    +set_boolean_array_region(env, array, start, len, buf) void
    +set_byte_array_region(env, array, start, len, buf) void
    +set_char_array_region(env, array, start, len, buf) void
    +set_short_array_region(env, array, start, len, buf) void
    +set_int_array_region(env, array, start, len, buf) void
    +set_long_array_region(env, array, start, len, buf) void
    +set_float_array_region(env, array, start, len, buf) void
    +set_double_array_region(env, array, start, len, buf) void
    +register_natives(env, clazz, methods, methods_len) JNIResultType
    +unregister_natives(env, clazz) JNIResultType
    +monitor_enter(env, obj) JNIResultType
    +monitor_exit(env, obj) JNIResultType
    +get_java_vm(env, vm) JNIResultType
    +get_string_region(env, string, start, len, buf) void
    +get_string_utf_region(env, string, start, len, buf) void
    +get_primitive_array_critical(env, array, is_copy) ?*anyopaque
    +release_primitive_array_critical(env, array, c_array, mode) void
    +get_string_critical(env, string, is_copy) ?[*]const JChar
    +release_string_critical(env, string, chars) void
    +new_weak_global_ref(env, obj) JWeakReference
    +delete_weak_global_ref(env, ref) void
    +exception_check(env) JBoolean
    +new_direct_byte_buffer(env, address, capacity) JObject
    +get_direct_buffer_address(env, buf) ?[*]u8
    +get_direct_buffer_capacity(env, buf) JLong
    +get_object_ref_type(env, obj) JObjectRefType
    +get_module(env, clazz) JObject
}
JNIEnv <-- FunctionTable
link JNIEnv "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/src/jni.zig#L153"
class JavaVMOption["JavaVMOption [struct]"] {
    +option_string: [*:0]const u8
    +extra_info: ?*anyopaque
}
link JavaVMOption "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/src/jni.zig#L3072"
class JavaVMInitArgs["JavaVMInitArgs [struct]"] {
    +version: JInt
    +options_len: JInt
    +options: ?[*]JavaVMOption
    +ignore_unrecognized: JBoolean
}
link JavaVMInitArgs "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/src/jni.zig#L3079"
class JavaVMAttachArgs["JavaVMAttachArgs [struct]"] {
    +version: JInt
    +name: [*:0]const u8
    +group: JObject
}
link JavaVMAttachArgs "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/src/jni.zig#L3087"
class FunctionTable["FunctionTable [enum]"] {
    -destroy_java_vm
    -attach_current_thread
    -detach_current_thread
    -get_env
    -attach_current_thread_as_daemon
}
link FunctionTable "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/src/jni.zig#L3098"
class JavaVM["JavaVM [opaque]"] {
    +destroy_java_vm(vm) JNIResultType
    +attach_current_thread(vm, env, args) JNIResultType
    +detach_current_thread(vm) JNIResultType
    +attach_current_thread_as_daemon(vm, env, args) JNIResultType
    +get_env(vm, env, version) JNIResultType
}
JavaVM <-- FunctionTable
link JavaVM "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/src/jni.zig#L3094"
class `clients/java/src/jni.zig` {
    -JniInterface(T) type
}
`clients/java/src/jni.zig` <-- JNIResultType
`clients/java/src/jni.zig` <-- JBoolean
`clients/java/src/jni.zig` <-- JValue
`clients/java/src/jni.zig` <-- JArrayReleaseMode
`clients/java/src/jni.zig` <-- JObjectRefType
`clients/java/src/jni.zig` <-- JNINativeMethod
`clients/java/src/jni.zig` <-- JNIEnv
`clients/java/src/jni.zig` <-- JavaVMOption
`clients/java/src/jni.zig` <-- JavaVMInitArgs
`clients/java/src/jni.zig` <-- JavaVMAttachArgs
`clients/java/src/jni.zig` <-- JavaVM
link `clients/java/src/jni.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/src/jni.zig"
class Context["Context [struct]"] {
    -jvm: *jni.JavaVM
    -client: tb.tb_client_t
}
link Context "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/src/client.zig#L27"
class NativeClient["NativeClient [struct]"] {
    -on_load(vm) jni.JInt
    -on_unload(vm) void
    -client_init(echo_client, env, cluster_id, addresses_obj, max_concurrency) ?*Context
    -client_deinit(context) void
    -submit(env, context, request_obj) tb.tb_packet_acquire_status_t
    -on_completion(context_ptr, client, packet, result_ptr, result_len) callconv(.C) void
}
link NativeClient "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/src/client.zig#L33"
class Exports["Exports [struct]"] {
    -on_load(vm) callconv(jni.JNICALL) jni.JInt
    -on_unload(vm) callconv(jni.JNICALL) void
    -client_init(env, class, cluster_id, addresses, max_concurrency) callconv(jni.JNICALL) jni.JLong
    -client_init_echo(env, class, cluster_id, addresses, max_concurrency) callconv(jni.JNICALL) jni.JLong
    -client_deinit(env, class, context_handle) callconv(jni.JNICALL) void
    -submit(env, class, context_handle, request_obj) callconv(jni.JNICALL) jni.JInt
}
link Exports "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/src/client.zig#L185"
class ReflectionHelper["ReflectionHelper [struct]"] {
    +load(env) void
    +unload(env) void
    +initialization_exception_throw(env, status) void
    +assertion_error_throw(env, message) void
    +get_send_buffer_slice(env, this_obj) ?[]u8
    +set_reply_buffer(env, this_obj, reply) void
    +get_request_operation(env, this_obj) u8
    +end_request(env, this_obj, packet_operation, packet_status) void
}
ReflectionHelper <-- Exports
link ReflectionHelper "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/src/client.zig#L268"
class JNIHelper["JNIHelper [struct]"] {
    +get_env(vm) *jni.JNIEnv
    +attach_current_thread(jvm) *jni.JNIEnv
    +get_java_vm(env) *jni.JavaVM
    +vm_panic(env, fmt, args) noreturn
    +check_jni_result(env, jni_result, fmt, args) void
    +find_class(env, class_name) jni.JClass
    +find_field(env, class, name, signature) jni.JFieldID
    +find_method(env, class, name, signature) jni.JMethodID
    +get_direct_buffer(env, buffer_obj) ?[]u8
    +new_global_reference(env, obj) jni.JObject
    +get_string_utf(env, string) ?[:0]const u8
}
link JNIHelper "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/src/client.zig#L526"
class `clients/java/src/client.zig`
`clients/java/src/client.zig` <-- Context
`clients/java/src/client.zig` <-- NativeClient
`clients/java/src/client.zig` <-- ReflectionHelper
`clients/java/src/client.zig` <-- JNIHelper
link `clients/java/src/client.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/java/src/client.zig"
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
class TypeMapping["TypeMapping [struct]"] {
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
class `clients/dotnet/dotnet_bindings.zig` {
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
`clients/dotnet/dotnet_bindings.zig` <-- TypeMapping
link `clients/dotnet/dotnet_bindings.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/dotnet/dotnet_bindings.zig"
class `clients/dotnet/docs.zig` {
    -current_commit_pre_install_hook(arena, sample_dir, _) !void
}
link `clients/dotnet/docs.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/dotnet/docs.zig"
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
class `clients/node/docs.zig` {
    -find_node_client_tar(arena, root) ![]const u8
    -node_current_commit_post_install_hook(arena, sample_dir, root) !void
}
link `clients/node/docs.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/node/docs.zig"
class TypeMapping["TypeMapping [struct]"] {
    -name: []const u8
    -hidden_fields: []const []const u8
    -docs_link: ?[]const u8
    +hidden(self, name) bool
}
link TypeMapping "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/node/node_bindings.zig#L7"
class `clients/node/node_bindings.zig` {
    test "bindings node"()
    -typescript_type(Type) []const u8
    -get_mapped_type_name(Type) ?[]const u8
    -emit_enum(buffer, Type, mapping) !void
    -emit_packed_struct(buffer, type_info, mapping) !void
    -emit_struct(buffer, type_info, mapping) !void
    -emit_docs(buffer, mapping, indent, field) !void
    +generate_bindings(buffer) !void
    +main() !void
}
`clients/node/node_bindings.zig` <-- TypeMapping
link `clients/node/node_bindings.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/node/node_bindings.zig"
class TranslationError["TranslationError [error]"] {
    -ExceptionThrown
}
link TranslationError "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/node/src/translate.zig#L21"
class UserData["UserData [struct]"] {
    +env: c.napi_env
    +callback_reference: c.napi_ref
}
link UserData "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/node/src/translate.zig#L73"
class `clients/node/src/translate.zig` {
    +register_function(env, exports, name, function) !void
    +throw(env, message) TranslationError
    +capture_undefined(env) !c.napi_value
    +set_instance_data(env, data, finalize_callback) !void
    +create_external(env, context) !c.napi_value
    +value_external(env, value, error_message) !?*anyopaque
    +user_data_from_value(env, value) !UserData
    +globals(env) !?*anyopaque
    +slice_from_object(env, object, key) ![]const u8
    +slice_from_value(env, value, key) ![]u8
    +bytes_from_object(env, object, length, key) ![length]u8
    +bytes_from_buffer(env, buffer, output, key) !usize
    +u128_from_object(env, object, key) !u128
    +u64_from_object(env, object, key) !u64
    +u32_from_object(env, object, key) !u32
    +u16_from_object(env, object, key) !u16
    +u128_from_value(env, value, name) !u128
    +u64_from_value(env, value, name) !u64
    +u32_from_value(env, value, name) !u32
    +byte_slice_into_object(env, object, key, value, error_message) !void
    +u128_into_object(env, object, key, value, error_message) !void
    +u64_into_object(env, object, key, value, error_message) !void
    +u32_into_object(env, object, key, value, error_message) !void
    +u16_into_object(env, object, key, value, error_message) !void
    +create_object(env, error_message) !c.napi_value
    -create_buffer(env, value, error_message) !c.napi_value
    +create_array(env, length, error_message) !c.napi_value
    +set_array_element(env, array, index, value, error_message) !void
    +array_element(env, array, index) !c.napi_value
    +array_length(env, array) !u32
    +delete_reference(env, reference) !void
    +call_function(env, this, callback, argc, argv) !void
    +scope(env, error_message) !c.napi_value
    +reference_value(env, callback_reference, error_message) !c.napi_value
}
`clients/node/src/translate.zig` <-- TranslationError
`clients/node/src/translate.zig` <-- UserData
link `clients/node/src/translate.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/node/src/translate.zig"
class `clients/node/src/c.zig`
link `clients/node/src/c.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/node/src/c.zig"
class Globals["Globals [struct]"] {
    -allocator: std.mem.Allocator
    -io: IO
    -napi_undefined: c.napi_value
    +init(allocator, env) !*Globals
    +deinit(self) void
    +destroy(env, data, hint) callconv(.C) void
}
link Globals "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/node/src/node.zig#L70"
class Context["Context [struct]"] {
    -io: *IO
    -addresses: []std.net.Address
    -client: Client
    -message_pool: MessagePool
    -create(env, allocator, io, cluster, addresses_raw) !c.napi_value
}
link Context "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/node/src/node.zig#L121"
class `clients/node/src/node.zig` {
    -napi_register_module_v1(env, exports) c.napi_value
    -globalsCast(globals_raw) *Globals
    -contextCast(context_raw) !*Context
    -validate_timestamp(env, object) !u64
    -decode_from_object(T, env, object) !T
    +decode_events(env, array, operation, output) !usize
    -decode_events_from_array(env, array, T, output) !usize
    -encode_napi_results_array(Result, env, data) !c.napi_value
    -init(env, info) callconv(.C) c.napi_value
    -request(env, info) callconv(.C) c.napi_value
    -raw_request(env, info) callconv(.C) c.napi_value
    -on_result(user_data, operation, results) void
    -tick(env, info) callconv(.C) c.napi_value
    -deinit(env, info) callconv(.C) c.napi_value
}
`clients/node/src/node.zig` <-- Globals
`clients/node/src/node.zig` <-- Context
link `clients/node/src/node.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/node/src/node.zig"
class `clients/integration.zig` {
    -error_main() !void
    +main() !void
}
link `clients/integration.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/integration.zig"
class tb_status_t["tb_status_t [enum]"] {
    +success
    +unexpected
    +out_of_memory
    +address_invalid
    +address_limit_exceeded
    +concurrency_max_invalid
    +system_resources
    +network_subsystem
}
link tb_status_t "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/c/tb_client.zig#L9"
class ffi["ffi [struct]"] {
    +c_init(out_client, cluster_id, addresses_ptr, addresses_len, packets_count, on_completion_ctx, on_completion_fn) callconv(.C) tb_status_t
    +c_init_echo(out_client, cluster_id, addresses_ptr, addresses_len, packets_count, on_completion_ctx, on_completion_fn) callconv(.C) tb_status_t
}
link ffi "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/c/tb_client.zig#L68"
class `clients/c/tb_client.zig` {
    +context_to_client(implementation) tb_client_t
    -client_to_context(tb_client) *ContextImplementation
    +init_error_to_status(err) tb_status_t
    +init(allocator, cluster_id, addresses, packets_count, on_completion_ctx, on_completion_fn) InitError!tb_client_t
    +init_echo(allocator, cluster_id, addresses, packets_count, on_completion_ctx, on_completion_fn) InitError!tb_client_t
    +acquire_packet(client, out_packet) callconv(.C) tb_packet_acquire_status_t
    +release_packet(client, packet) callconv(.C) void
    +submit(client, packet) callconv(.C) void
    +deinit(client) callconv(.C) void
}
`clients/c/tb_client.zig` <-- tb_status_t
`clients/c/tb_client.zig` <-- ffi
link `clients/c/tb_client.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/c/tb_client.zig"
class `clients/c/tb_client_header_test.zig` {
    test "valid tb_client.h"()
    -to_lowercase(input) []const u8
    -to_uppercase(input) []const u8
    -to_snakecase(input) []const u8
}
link `clients/c/tb_client_header_test.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/c/tb_client_header_test.zig"
class `clients/c/tb_client_header.zig` {
    -resolve_c_type(Type) []const u8
    -to_uppercase(input) []const u8
    -emit_enum(buffer, Type, type_info, c_name, value_fmt, skip_fields) !void
    -emit_struct(buffer, type_info, c_name) !void
    +main() !void
}
link `clients/c/tb_client_header.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/c/tb_client_header.zig"
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
class Completion["Completion [struct]"] {
    -pending: usize
    -mutex: Mutex
    -cond: Condition
    +complete(self) void
    +wait_pending(self) void
}
link Completion "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/c/test.zig#L60"
class `clients/c/test.zig` {
    test "c_client echo"()
    test "c_client tb_status"()
    test "c_client tb_packet_status"()
    -RequestContextType(request_size_max) type
}
`clients/c/test.zig` <-- Completion
link `clients/c/test.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/clients/c/test.zig"
class CliArgs["CliArgs [union]"] {
    -bytes: u32
    -memcpy: struct
    -funcsize
    -parse(arena) !CliArgs
}
link CliArgs "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/copyhound.zig#L41"
class T["T [struct]"] {
    -check(line, want) !void
}
link T "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/copyhound.zig#L214"
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
class BuildOptions["BuildOptions [struct]"] {
    -config_base: ConfigBase
    -config_log_level: std.log.Level
    -tracer_backend: TracerBackend
    -hash_log_mode: HashLogMode
    -config_aof_record: bool
    -config_aof_recovery: bool
}
link BuildOptions "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/config.zig#L15"
class Config["Config [struct]"] {
    +cluster: ConfigCluster
    +process: ConfigProcess
}
link Config "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/config.zig#L58"
class ConfigProcess["ConfigProcess [struct]"] {
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
class ConfigCluster["ConfigCluster [struct]"] {
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
class ConfigBase["ConfigBase [enum]"] {
    +production
    +development
    +test_min
    +default
}
link ConfigBase "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/config.zig#L182"
class TracerBackend["TracerBackend [enum]"] {
    +none
    +tracy
}
link TracerBackend "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/config.zig#L189"
class HashLogMode["HashLogMode [enum]"] {
    +none
    +create
    +check
}
link HashLogMode "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/config.zig#L195"
class configs["configs [struct]"]
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
class Time["Time [struct]"] {
    +monotonic_guard: u64
    +monotonic(self) u64
    +realtime(_) i64
    +tick(_) void
}
link Time "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/time.zig#L9"
class `time.zig`
`time.zig` <-- Time
link `time.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/time.zig"
class InFlight["InFlight [union]"] {
    -create_accounts: [accounts_batch_size_max]CreateAccountResultSet
    -create_transfers: [transfers_batch_size_max]CreateTransferResultSet
}
link InFlight "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/state_machine/auditor.zig#L29"
class PendingTransfer["PendingTransfer [struct]"] {
    -client_index: usize
    -client_request: usize
    -amount: u64
    -debit_account_index: usize
    -credit_account_index: usize
}
link PendingTransfer "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/state_machine/auditor.zig#L40"
class PendingExpiry["PendingExpiry [struct]"] {
    -transfer: u128
    -timestamp: u64
}
link PendingExpiry "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/state_machine/auditor.zig#L46"
class Options["Options [struct]"] {
    +accounts_max: usize
    +account_id_permutation: IdPermutation
    +client_count: usize
    +transfers_pending_max: usize
    +in_flight_max: usize
}
link Options "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/state_machine/auditor.zig#L61"
class AccountingAuditor["AccountingAuditor [struct]"] {
    +random: std.rand.Random
    +options: Options
    +timestamp: u64
    +accounts: []tb.Account
    +accounts_created: []bool
    +pending_transfers: std.AutoHashMapUnmanaged(u128, PendingTransfer)
    +pending_expiries: PendingExpiryQueue
    +in_flight: InFlightQueue
    +creates_sent: []usize
    +creates_delivered: []usize
    -compare(_, a, b) std.math.Order
    +init(allocator, random, options) !Self
    +deinit(self, allocator) void
    +done(self) bool
    +expect_create_accounts(self, client_index) []CreateAccountResultSet
    +expect_create_transfers(self, client_index) []CreateTransferResultSet
    -tick_to_timestamp(self, timestamp) void
    +on_create_accounts(self, client_index, timestamp, accounts, results) void
    +on_create_transfers(self, client_index, timestamp, transfers, results) void
    +on_lookup_accounts(self, client_index, timestamp, ids, results) void
    +on_lookup_transfers(self, client_index, timestamp, ids, results) void
    +pick_account(self, match) ?*const tb.Account
    +account_id_to_index(self, id) usize
    +account_index_to_id(self, index) u128
    -take_in_flight(self, client_index) InFlight
}
AccountingAuditor <-- Options
link AccountingAuditor "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/state_machine/auditor.zig#L58"
class `state_machine/auditor.zig` {
    +IteratorForCreate(Result) type
    +IteratorForLookup(Result) type
}
`state_machine/auditor.zig` <-- InFlight
`state_machine/auditor.zig` <-- PendingTransfer
`state_machine/auditor.zig` <-- PendingExpiry
`state_machine/auditor.zig` <-- AccountingAuditor
link `state_machine/auditor.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/state_machine/auditor.zig"
class TransferOutcome["TransferOutcome [enum]"] {
    -success
    -failure
    -unknown
}
link TransferOutcome "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/state_machine/workload.zig#L34"
class Method["Method [enum]"] {
    -single_phase
    -pending
    -post_pending
    -void_pending
}
link Method "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/state_machine/workload.zig#L61"
class TransferPlan["TransferPlan [struct]"] {
    -valid: bool
    -limit: bool
    -method: Method
    -outcome(self) TransferOutcome
}
TransferPlan <-- Method
link TransferPlan "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/state_machine/workload.zig#L48"
class TransferTemplate["TransferTemplate [struct]"] {
    -ledger: u32
    -result: accounting_auditor.CreateTransferResultSet
}
link TransferTemplate "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/state_machine/workload.zig#L78"
class TransferBatch["TransferBatch [struct]"] {
    -min: usize
    -max: usize
    -compare(_, a, b) std.math.Order
}
link TransferBatch "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/state_machine/workload.zig#L92"
class `state_machine/workload.zig` {
    +WorkloadType(AccountingStateMachine) type
    -OptionsType(StateMachine, Action) type
    -sample_distribution(random, distribution) std.meta.FieldEnum(@TypeOf(distribution))
    -chance(random, p) bool
}
`state_machine/workload.zig` <-- TransferOutcome
`state_machine/workload.zig` <-- TransferPlan
`state_machine/workload.zig` <-- TransferTemplate
`state_machine/workload.zig` <-- TransferBatch
link `state_machine/workload.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/state_machine/workload.zig"
class State["State [enum]"] {
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
class Status["Status [enum]"] {
    +normal
    +view_change
    +recovering
    +recovering_head
}
link Status "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica.zig#L33"
class CommitStage["CommitStage [enum]"] {
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
class ReplicaEvent["ReplicaEvent [union]"] {
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
class Prepare["Prepare [struct]"] {
    -message: *Message
    -ok_from_all_replicas: QuorumCounter
    -ok_quorum_received: bool
}
link Prepare "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica.zig#L91"
class Request["Request [struct]"] {
    -message: *Message
    -realtime: i64
}
link Request "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica.zig#L102"
class HeaderIterator["HeaderIterator [struct]"] {
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
link HeaderIterator "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica.zig#L8685"
class DVCQuorum["DVCQuorum [struct]"] {
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
link DVCQuorum "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica.zig#L8359"
class PipelineQueue["PipelineQueue [struct]"] {
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
link PipelineQueue "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica.zig#L8802"
class PipelineCache["PipelineCache [struct]"] {
    -prepares: [prepares_max]?*Message
    -init_from_queue(queue) PipelineCache
    -deinit(pipeline, message_pool) void
    -empty(pipeline) bool
    -contains_header(pipeline, header) bool
    -prepare_by_op_and_checksum(pipeline, op, checksum) ?*Message
    -insert(pipeline, prepare) ?*Message
}
link PipelineCache "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica.zig#L8968"
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
class Environment["Environment [struct]"] {
    -sequence_states: SequenceStates
    -members: [constants.nodes_max]u128
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
class Reservation["Reservation [struct]"] {
    +block_base: usize
    +block_count: usize
    +session: usize
}
link Reservation "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_free_set.zig#L18"
class FreeSet["FreeSet [struct]"] {
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
class TestPattern["TestPattern [struct]"] {
    -fill: TestPatternFill
    -words: usize
}
link TestPattern "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_free_set.zig#L721"
class TestPatternFill["TestPatternFill [enum]"] {
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
class VSRState["VSRState [struct]"] {
    +previous_checkpoint_id: u128
    +commit_min_checksum: u128
    +replica_id: u128
    +members: [constants.nodes_max]u128
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
link VSRState "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock.zig#L119"
class Snapshot["Snapshot [struct]"] {
    +created: u64
    +queried: u64
    +timeout: u64
    +exists(snapshot) bool
}
link Snapshot "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock.zig#L233"
class SuperBlockHeader["SuperBlockHeader [struct]"] {
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
class Caller["Caller [enum]"] {
    +format
    +open
    +checkpoint
    +view_change
    +sync
    -updates_vsr_headers(caller) bool
    -updates_trailers(caller) bool
}
link Caller "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock.zig#L1639"
class Trailer["Trailer [enum]"] {
    +manifest
    +free_set
    +client_sessions
    +zone(trailer) SuperBlockZone
}
link Trailer "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock.zig#L1685"
class SuperBlockZone["SuperBlockZone [enum]"] {
    +header
    +manifest
    +free_set
    +client_sessions
    +start(zone) u64
    +start_for_copy(zone, copy) u64
    +size_max(zone) u64
}
link SuperBlockZone "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock.zig#L1699"
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
class ProcessSelector["ProcessSelector [enum]"] {
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
class TestContext["TestContext [struct]"] {
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
class Role["Role [enum]"]
link Role "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica_test.zig#L1330"
class LinkDirection["LinkDirection [enum]"]
link LinkDirection "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica_test.zig#L1425"
class TestReplicas["TestReplicas [struct]"] {
    -context: *TestContext
    -cluster: *Cluster
    -replicas: std.BoundedArray(u8, constants.nodes_max)
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
link TestReplicas "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica_test.zig#L1210"
class TestClients["TestClients [struct]"] {
    -context: *TestContext
    -cluster: *Cluster
    -clients: std.BoundedArray(usize, constants.clients_max)
    -requests: usize
    +request(t, requests, expect_replies) !void
    +replies(t) usize
}
link TestClients "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/replica_test.zig#L1502"
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
    test "Cluster: network: partititon client-primary (asymmetric, drop requests)"()
    test "Cluster: network: partititon client-primary (asymmetric, drop replies)"()
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
class Aegis128["Aegis128 [struct]"] {
    -init(key, nonce) State
    -update(blocks, d1, d2) void
    -absorb(blocks, src) void
    -mac(blocks, adlen, mlen) [16]u8
    -hash(blocks, source) u128
}
link Aegis128 "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/checksum.zig#L7"
class TestVector["TestVector [struct]"] {
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
class Variant["Variant [enum]"] {
    -valid
    -valid_high_copy
    -invalid_broken
    -invalid_fork
    -invalid_misdirect
    -invalid_parent
    -invalid_vsr_state
}
link Variant "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_quorums_fuzz.zig#L202"
class CopyTemplate["CopyTemplate [struct]"] {
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
class FreeSetEvent["FreeSetEvent [union]"] {
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
class FreeSetModel["FreeSetModel [struct]"] {
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
class Options["Options [struct]"] {
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
class ReplySlot["ReplySlot [struct]"] {
    +index: usize
}
link ReplySlot "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_client_sessions.zig#L10"
class Entry["Entry [struct]"] {
    +session: u64
    +header: vsr.Header
}
link Entry "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_client_sessions.zig#L32"
class Iterator["Iterator [struct]"] {
    +client_sessions: *const ClientSessions
    +index: usize
    +next(it) ?*const Entry
}
link Iterator "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_client_sessions.zig#L299"
class ClientSessions["ClientSessions [struct]"] {
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
class Interval["Interval [struct]"] {
    +lower_bound: i64
    +upper_bound: i64
    +sources_true: u8
    +sources_false: u8
}
link Interval "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/marzullo.zig#L10"
class Tuple["Tuple [struct]"] {
    +source: u8
    +offset: i64
    +bound: enum
}
link Tuple "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/marzullo.zig#L31"
class Marzullo["Marzullo [struct]"] {
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
class RequestingTrailers["RequestingTrailers [struct]"] {
    +target: Target
    +trailers: Trailers
    +previous_checkpoint_id: ?u128
    +checkpoint_op_checksum: ?u128
    +done(self) bool
}
link RequestingTrailers "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/sync.zig#L27"
class UpdatingSuperBlock["UpdatingSuperBlock [struct]"] {
    +target: Target
    +previous_checkpoint_id: u128
    +checkpoint_op_checksum: u128
}
link UpdatingSuperBlock "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/sync.zig#L50"
class Stage["Stage [union]"] {
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
class TargetCandidate["TargetCandidate [struct]"] {
    +checkpoint_id: u128
    +checkpoint_op: u64
    +canonical(target) Target
}
link TargetCandidate "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/sync.zig#L86"
class Target["Target [struct]"] {
    +checkpoint_id: u128
    +checkpoint_op: u64
}
link Target "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/sync.zig#L100"
class TargetQuorum["TargetQuorum [struct]"] {
    +candidates: [constants.replicas_max]?TargetCandidate
    +replace(quorum, replica, candidate) bool
    +count(quorum, candidate) usize
}
link TargetQuorum "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/sync.zig#L107"
class Trailer["Trailer [struct]"] {
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
class AssertionPoint["AssertionPoint [struct]"] {
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
class ClockUnitTestContainer["ClockUnitTestContainer [struct]"] {
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
class Packet["Packet [struct]"] {
    -m0: u64
    -t1: ?i64
    -clock_simulator: *ClockSimulator
    +clone(packet) Packet
    +deinit(packet) void
    +command(_) Command
}
link Packet "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/clock.zig#L634"
class Options["Options [struct]"] {
    -ping_timeout: u32
    -clock_count: u8
    -network_options: PacketSimulatorOptions
}
link Options "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/clock.zig#L653"
class ClockSimulator["ClockSimulator [struct]"] {
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
class Ring["Ring [enum]"] {
    -headers
    -prepares
    -offset(ring, slot) u64
}
link Ring "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/journal.zig#L24"
class Slot["Slot [struct]"] {
    -index: usize
}
link Slot "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/journal.zig#L66"
class SlotRange["SlotRange [struct]"] {
    +head: Slot
    +tail: Slot
    +contains(range, slot) bool
}
link SlotRange "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/journal.zig#L69"
class RecoveryDecision["RecoveryDecision [enum]"] {
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
class Matcher["Matcher [enum]"] {
    -any
    -is_false
    -is_true
    -assert_is_false
    -assert_is_true
}
link Matcher "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/journal.zig#L2225"
class Case["Case [struct]"] {
    -label: []const u8
    -decision_multiple: RecoveryDecision
    -decision_single: RecoveryDecision
    -pattern: [9]Matcher
    -init(label, decision_multiple, decision_single, pattern) Case
    -check(case, parameters) !bool
    -decision(case, solo) RecoveryDecision
}
link Case "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/journal.zig#L2227"
class BitSet["BitSet [struct]"] {
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
class TableExtentKey["TableExtentKey [struct]"] {
    +tree_hash: u128
    +table: u64
}
link TableExtentKey "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_manifest.zig#L42"
class TableExtent["TableExtent [struct]"] {
    +block: u64
    +entry: u32
}
link TableExtent "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_manifest.zig#L47"
class BlockReference["BlockReference [struct]"] {
    +tree: u128
    +checksum: u128
    +address: u64
}
link BlockReference "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_manifest.zig#L377"
class IteratorReverse["IteratorReverse [struct]"] {
    +manifest: *const Manifest
    +tree: u128
    +count: u32
    +next(it) ?BlockReference
}
link IteratorReverse "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr/superblock_manifest.zig#L386"
class Manifest["Manifest [struct]"] {
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
class ProcessType["ProcessType [enum]"] {
    +replica
    +client
}
link ProcessType "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L55"
class Zone["Zone [enum]"] {
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
class Command["Command [enum]"] {
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
class Operation["Operation [enum]"] {
    +reserved
    +root
    +register
    +_
    +from(StateMachine, op) Operation
    +cast(self, StateMachine) StateMachine.Operation
    +valid(self, StateMachine) bool
    +vsr_reserved(self) bool
    +tag_name(self, StateMachine) []const u8
    -check_state_machine_operations(Op) void
}
link Operation "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L156"
class Header["Header [struct]"] {
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
link Header "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L229"
class BlockRequest["BlockRequest [struct]"] {
    +block_checksum: u128
    +block_address: u64
    +reserved: [8]u8
}
link BlockRequest "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L929"
class Timeout["Timeout [struct]"] {
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
link Timeout "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L940"
class IdSeed["IdSeed [struct]"] {
    -raw: []const u8
    -addresses: []const std.net.Address
    -raw: []const u8
    -err: anyerror![]std.net.Address
    -cluster_config_checksum: u128 align(1)
    -cluster: u32 align(1)
    -replica: u8 align(1)
}
link IdSeed "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L1333"
class Headers["Headers [struct]"] {
    -dvc_blank(op) Header
    +dvc_header_type(header) enum [ blank, valid ]
}
Headers <-- IdSeed
link Headers "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L1372"
class ViewChangeCommand["ViewChangeCommand [enum]"] {
    +do_view_change
    +start_view
}
link ViewChangeCommand "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L1400"
class ViewRange["ViewRange [struct]"] {
    -min: u32
    -max: u32
    +contains(range, view) bool
}
link ViewRange "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L1464"
class ViewChangeHeadersSlice["ViewChangeHeadersSlice [struct]"] {
    -command: ViewChangeCommand
    -slice: []const Header
    +init(command, slice) ViewChangeHeadersSlice
    +verify(headers) void
    +view_for_op(headers, op, log_view) ViewRange
}
ViewChangeHeadersSlice <-- ViewRange
link ViewChangeHeadersSlice "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L1402"
class ViewChangeHeadersArray["ViewChangeHeadersArray [struct]"] {
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
link ViewChangeHeadersArray "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig#L1563"
class `vsr.zig` {
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
    +root_members(cluster) [constants.nodes_max]u128
    +assert_valid_members(members) void
    +assert_valid_member(members, replica_id) void
}
`vsr.zig` <-- ProcessType
`vsr.zig` <-- Zone
`vsr.zig` <-- Command
`vsr.zig` <-- Operation
`vsr.zig` <-- Header
`vsr.zig` <-- BlockRequest
`vsr.zig` <-- Timeout
`vsr.zig` <-- Headers
`vsr.zig` <-- ViewChangeCommand
`vsr.zig` <-- ViewChangeHeadersSlice
`vsr.zig` <-- ViewChangeHeadersArray
link `vsr.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vsr.zig"
class T["T [struct]"] {
    -check(cmd, args, want) !void
}
link T "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/shell.zig#L288"
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
class Completion["Completion [struct]"] {
    +io: *IO
    +result: i32
    +next: ?*Completion
    +operation: Operation
    +context: ?*anyopaque
    +callback: *const fn (context: ?*anyopaque, completion: *Completion, result: *const anyopaque)
    -prep(completion, sqe) void
    -complete(completion, callback_tracer_slot) void
}
link Completion "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/io/linux.zig#L244"
class Operation["Operation [union]"] {
    -accept: struct
    -close: struct
    -connect: struct
    -read: struct
    -recv: struct
    -send: struct
    -timeout: struct
    -write: struct
}
link Operation "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/io/linux.zig#L546"
class IO["IO [struct]"] {
    +ring: IO_Uring
    +unqueued: FIFO(Completion)
    +completed: FIFO(Completion)
    +ios_queued: u64
    +ios_in_kernel: u64
    +flush_tracer_slot: ?tracer.SpanStart
    +callback_tracer_slot: ?tracer.SpanStart
    +init(entries, flags) !IO
    +deinit(self) void
    +tick(self) !void
    +run_for_ns(self, nanoseconds) !void
    -flush(self, wait_nr, timeouts, etime) !void
    -flush_completions(self, wait_nr, timeouts, etime) !void
    -flush_submissions(self, wait_nr, timeouts, etime) !void
    -enqueue(self, completion) void
    -call_callback(completion, result, callback_tracer_slot) void
    +accept(self, Context, context, callback, completion, socket) void
    +close(self, Context, context, callback, completion, fd) void
    +connect(self, Context, context, callback, completion, socket, address) void
    +read(self, Context, context, callback, completion, fd, buffer, offset) void
    +recv(self, Context, context, callback, completion, socket, buffer) void
    +send(self, Context, context, callback, completion, socket, buffer) void
    +timeout(self, Context, context, callback, completion, nanoseconds) void
    +write(self, Context, context, callback, completion, fd, buffer, offset) void
    +open_socket(self, family, sock_type, protocol) !os.socket_t
    +open_dir(dir_path) !os.fd_t
    +open_file(dir_fd, relative_path, size, method) !os.fd_t
    -fs_supports_direct_io(dir_fd) !bool
    -fs_allocate(fd, size) !void
}
IO <-- Completion
IO <-- Operation
link IO "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/io/linux.zig#L15"
class `io/linux.zig`
`io/linux.zig` <-- IO
link `io/linux.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/io/linux.zig"
class Completion["Completion [struct]"] {
    +next: ?*Completion
    +context: ?*anyopaque
    +callback: *const fn (*IO, *Completion)
    +operation: Operation
}
link Completion "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/io/darwin.zig#L190"
class Operation["Operation [union]"] {
    -accept: struct
    -close: struct
    -connect: struct
    -read: struct
    -recv: struct
    -send: struct
    -timeout: struct
    -write: struct
}
link Operation "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/io/darwin.zig#L197"
class IO["IO [struct]"] {
    +kq: os.fd_t
    +time: Time
    +io_inflight: usize
    +timeouts: FIFO(Completion)
    +completed: FIFO(Completion)
    +io_pending: FIFO(Completion)
    +init(entries, flags) !IO
    +deinit(self) void
    +tick(self) !void
    +run_for_ns(self, nanoseconds) !void
    -flush(self, wait_for_completions) !void
    -flush_io(_, events, io_pending_top) usize
    -flush_timeouts(self) ?u64
    -submit(self, context, callback, completion, operation_tag, operation_data, OperationImpl) void
    +accept(self, Context, context, callback, completion, socket) void
    +close(self, Context, context, callback, completion, fd) void
    +connect(self, Context, context, callback, completion, socket, address) void
    +read(self, Context, context, callback, completion, fd, buffer, offset) void
    +recv(self, Context, context, callback, completion, socket, buffer) void
    +send(self, Context, context, callback, completion, socket, buffer) void
    +timeout(self, Context, context, callback, completion, nanoseconds) void
    +write(self, Context, context, callback, completion, fd, buffer, offset) void
    +open_socket(self, family, sock_type, protocol) !os.socket_t
    +open_dir(dir_path) !os.fd_t
    +open_file(dir_fd, relative_path, size, method) !os.fd_t
    -fs_sync(fd) !void
    -fs_allocate(fd, size) !void
}
IO <-- Completion
IO <-- Operation
link IO "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/io/darwin.zig#L12"
class `io/darwin.zig`
`io/darwin.zig` <-- IO
link `io/darwin.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/io/darwin.zig"
class FlushMode["FlushMode [enum]"] {
    -blocking
    -non_blocking
}
link FlushMode "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/io/windows.zig#L59"
class Completion["Completion [struct]"] {
    +next: ?*Completion
    +context: ?*anyopaque
    +callback: *const fn (Context)
    +operation: Operation
}
link Completion "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/io/windows.zig#L160"
class IO["IO [struct]"] {
    +iocp: os.windows.HANDLE
    +timer: Time
    +io_pending: usize
    +timeouts: FIFO(Completion)
    +completed: FIFO(Completion)
    +init(entries, flags) !IO
    +deinit(self) void
    +tick(self) !void
    +run_for_ns(self, nanoseconds) !void
    -flush(self, mode) !void
    -flush_timeouts(self) ?u64
    -submit(self, context, callback, completion, op_tag, op_data, OperationImpl) void
    +accept(self, Context, context, callback, completion, socket) void
    +connect(self, Context, context, callback, completion, socket, address) void
    +send(self, Context, context, callback, completion, socket, buffer) void
    +recv(self, Context, context, callback, completion, socket, buffer) void
    +read(self, Context, context, callback, completion, fd, buffer, offset) void
    +write(self, Context, context, callback, completion, fd, buffer, offset) void
    +close(self, Context, context, callback, completion, fd) void
    +timeout(self, Context, context, callback, completion, nanoseconds) void
    +open_socket(self, family, sock_type, protocol) !os.socket_t
    +open_dir(dir_path) !os.fd_t
    -open_file_handle(relative_path, method) !os.fd_t
    +open_file(dir_handle, relative_path, size, method) !os.fd_t
    -fs_lock(handle, size) !void
    -fs_allocate(handle, size) !void
}
IO <-- FlushMode
IO <-- Completion
link IO "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/io/windows.zig#L11"
class `io/windows.zig` {
    -getsockoptError(socket) IO.ConnectError!void
}
`io/windows.zig` <-- IO
link `io/windows.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/io/windows.zig"
class Socket["Socket [struct]"] {
    -fd: os.socket_t
    -completion: IO.Completion
}
link Socket "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/io/benchmark.zig#L104"
class Pipe["Pipe [struct]"] {
    -socket: Socket
    -buffer: []u8
    -transferred: usize
}
link Pipe "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/io/benchmark.zig#L108"
class TransferType["TransferType [enum]"] {
    -read
    -write
}
link TransferType "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/io/benchmark.zig#L143"
class Context["Context [struct]"] {
    -io: IO
    -tx: Pipe
    -rx: Pipe
    -server: Socket
    -transferred: u64
    -on_accept(self, completion, result) void
    -on_connect(self, completion, result) void
    -do_transfer(self, pipe_name, transfer_type, bytes) void
}
Context <-- Socket
Context <-- Pipe
Context <-- TransferType
link Context "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/io/benchmark.zig#L97"
class `io/benchmark.zig` {
    +main() !void
}
`io/benchmark.zig` <-- Context
link `io/benchmark.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/io/benchmark.zig"
class `io/test.zig` {
    test "write/read/close"()
    test "accept/connect/send/receive"()
    test "timeout"()
    test "submission queue full"()
    test "tick to wait"()
    test "pipe data over socket"()
}
link `io/test.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/io/test.zig"
class Event["Event [union]"] {
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
class Fiber["Fiber [union]"] {
    -main
    -tree: struct
    -tree_compaction: struct
    -grid_read_iop: struct
    -grid_write_iop: struct
    -io
    +format(fiber, fmt, options, writer) !void
}
link Fiber "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tracer.zig#L178"
class LevelA["LevelA [struct]"] {
    -level_b: u8
    +format(level_a, fmt, options, writer) !void
}
link LevelA "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tracer.zig#L228"
class PlotId["PlotId [union]"] {
    +queue_count: struct
    +cache_hits: struct
    +cache_misses: struct
    +filter_block_hits: struct
    +filter_block_misses: struct
    +format(plot_id, fmt, options, writer) !void
}
link PlotId "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tracer.zig#L246"
class TracerNone["TracerNone [struct]"] {
    +init(allocator) !void
    +deinit(allocator) void
    +start(slot, event, src) void
    +end(slot, event) void
    +plot(plot_id, value) void
}
link TracerNone "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tracer.zig#L286"
class TracedAllocator["TracedAllocator [struct]"] {
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
class TracerTracy["TracerTracy [struct]"] {
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
class Options["Options [struct]"] {
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
class BlockType["BlockType [enum]"] {
    +reserved
    +manifest
    +index
    +filter
    +data
    +from(vsr_operation) BlockType
    +operation(block_type) vsr.Operation
}
link BlockType "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/grid.zig#L24"
class `lsm/grid.zig` {
    +allocate_block(allocator) error[OutOfMemory]!*align(constants.sector_size) [constants.block_size]u8
    +GridType(Storage) type
}
`lsm/grid.zig` <-- BlockType
link `lsm/grid.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/grid.zig"
class Config["Config [struct]"] {
    +lower_bound
    +upper_bound
    +mode: enum
}
link Config "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/binary_search.zig#L7"
class BinarySearchResult["BinarySearchResult [struct]"] {
    -index: u32
    -exact: bool
}
link BinarySearchResult "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/binary_search.zig#L116"
class BinarySearchRangeUpsertIndexes["BinarySearchRangeUpsertIndexes [struct]"] {
    +start: u32
    +end: u32
}
link BinarySearchRangeUpsertIndexes "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/binary_search.zig#L159"
class BinarySearchRange["BinarySearchRange [struct]"] {
    +start: u32
    +count: u32
}
link BinarySearchRange "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/binary_search.zig#L237"
class test_binary_search["test_binary_search [struct]"] {
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
class Value["Value [struct]"] {
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
class Bounds["Bounds [struct]"] {
    +lower: ?u32
    +upper: ?u32
}
link Bounds "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/eytzinger.zig#L313"
class test_eytzinger["test_eytzinger [struct]"] {
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
class Value["Value [struct]"] {
    -id: u64
    -value: u63
    -tombstone: u1
}
link Value "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/tree_fuzz.zig#L36"
class Key["Key [struct]"] {
    -id: u64
    -compare_keys(a, b) std.math.Order
    -key_from_value(value) Key
    -tombstone(value) bool
    -tombstone_from_key(key) Key.Value
}
Key <-- Value
link Key "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/tree_fuzz.zig#L33"
class FuzzOp["FuzzOp [union]"] {
    -compact: struct
    -put: Key.Value
    -remove: Key.Value
    -get: Key
}
link FuzzOp "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/tree_fuzz.zig#L68"
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
    -snapshot_min_for_table_output(op_min) u64
}
link `lsm/compaction.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/compaction.zig"
class Direction["Direction [enum]"] {
    +descending
    +reverse(d) Direction
}
link Direction "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/direction.zig#L1"
class `lsm/direction.zig` {
    +ascending
}
`lsm/direction.zig` <-- Direction
link `lsm/direction.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/direction.zig"
class Layout["Layout [struct]"] {
    +ways: u64
    +tag_bits: u64
    +clock_bits: u64
    +cache_line_size: u64
    +value_alignment: ?u29
}
link Layout "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/set_associative_cache.zig#L16"
class context["context [struct]"] {
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
class context["context [struct]"] {
    -key_from_value(value) Key
    -hash(key) u64
    -equal(a, b) bool
}
link context "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/set_associative_cache.zig#L550"
class context["context [struct]"] {
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
class reference["reference [struct]"] {
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
class TableUsage["TableUsage [enum]"] {
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
class Context["Context [struct]"] {
    +filter_block_count: u32
    +filter_block_count_max: u32
    +data_block_count: u32
    +data_block_count_max: u32
}
link Context "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/schema.zig#L79"
class Parameters["Parameters [struct]"] {
    -key_size: u32
    -filter_block_count_max: u32
    -data_block_count_max: u32
}
link Parameters "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/schema.zig#L109"
class TableIndex["TableIndex [struct]"] {
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
link TableIndex "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/schema.zig#L69"
class Context["Context [struct]"] {
    +data_block_count_max: u32
    +reserved: [12]u8
}
link Context "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/schema.zig#L276"
class TableFilter["TableFilter [struct]"] {
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
link TableFilter "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/schema.zig#L274"
class Context["Context [struct]"] {
    +key_count: u32
    +key_layout_size: u32
    +value_count_max: u32
    +value_size: u32
}
link Context "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/schema.zig#L341"
class TableData["TableData [struct]"] {
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
link TableData "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/schema.zig#L339"
class `lsm/schema.zig` {
    +header_from_block(block) *const vsr.Header
}
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
class Tuple["Tuple [struct]"] {
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
class Value["Value [struct]"] {
    -key: Key
    -tombstone: bool
}
link Value "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_level_fuzz.zig#L37"
class FuzzOp["FuzzOp [union]"] {
    -insert_tables: usize
    -update_tables: usize
    -take_snapshot
    -remove_invisible: usize
    -remove_visible: usize
}
link FuzzOp "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_level_fuzz.zig#L96"
class GenerateContext["GenerateContext [struct]"] {
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
class IdTreeValue["IdTreeValue [struct]"] {
    -id: u128
    -timestamp: u64
    -padding: u64
    -compare_keys(a, b) std.math.Order
    -key_from_value(value) u128
    -tombstone(value) bool
    -tombstone_from_key(id) IdTreeValue
}
link IdTreeValue "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/groove.zig#L47"
class `lsm/groove.zig` {
    test "Groove"()
    -ObjectTreeHelpers(Object) type
    -IndexCompositeKeyType(Field) type
    -IndexTreeType(Storage, Field, value_count_max) type
    +GrooveType(Storage, Object, groove_options) type
}
`lsm/groove.zig` <-- IdTreeValue
link `lsm/groove.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/groove.zig"
class FuzzOpAction["FuzzOpAction [union]"] {
    -compact: struct
    -put_account: struct
    -get_account: u128
}
link FuzzOpAction "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/forest_fuzz.zig#L26"
class FuzzOpModifier["FuzzOpModifier [union]"] {
    -normal
    -crash_after_ticks: usize
}
link FuzzOpModifier "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/forest_fuzz.zig#L40"
class FuzzOp["FuzzOp [struct]"] {
    -action: FuzzOpAction
    -modifier: FuzzOpModifier
}
link FuzzOp "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/forest_fuzz.zig#L46"
class State["State [enum]"] {
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
class Model["Model [struct]"] {
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
class Environment["Environment [struct]"] {
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
    test "table_count_max_for_level/tree"()
    test "TreeType"()
    +TreeType(TreeTable, Storage) type
    +compaction_op_min(op) u64
    -lookup_snapshot_max_for_checkpoint(op_checkpoint) u64
    +table_count_max_for_tree(growth_factor, levels_count) u32
    +table_count_max_for_level(growth_factor, level) u32
}
link `lsm/tree.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/tree.zig"
class ManifestEvent["ManifestEvent [union]"] {
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
link ManifestEvent "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_log_fuzz.zig#L125"
class EventType["EventType [enum]"] {
    -insert_new
    -insert_change_level
    -insert_change_snapshot
    -remove
    -compact
    -checkpoint
}
link EventType "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_log_fuzz.zig#L139"
class TableInfo["TableInfo [struct]"] {
    -checksum: u128
    -address: u64
    -flags: u64
    -snapshot_min: u64
    -snapshot_max: u64
    -key_min: u128
    -key_max: u128
}
TableInfo <-- EventType
link TableInfo "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_log_fuzz.zig#L265"
class Environment["Environment [struct]"] {
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
link Environment "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_log_fuzz.zig#L281"
class TableEntry["TableEntry [struct]"] {
    -level: u7
    -table: TableInfo
    -level: u7
    -table: TableInfo
}
link TableEntry "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_log_fuzz.zig#L539"
class ManifestLogModel["ManifestLogModel [struct]"] {
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
link ManifestLogModel "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_log_fuzz.zig#L534"
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
class Fingerprint["Fingerprint [struct]"] {
    +hash: u32
    +mask: meta.Vector(8, u32)
    +create(hash) Fingerprint
}
link Fingerprint "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/bloom_filter.zig#L10"
class test_bloom_filter["test_bloom_filter [struct]"] {
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
class State["State [enum]"] {
    -uninit
    -init
    -formatted
    -superblock_open
    -forest_open
    -forest_compacting
    -forest_checkpointing
    -superblock_checkpointing
}
link State "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/test.zig#L40"
class Visibility["Visibility [enum]"] {
    -visible
    -invisible
}
link Visibility "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/test.zig#L238"
class Environment["Environment [struct]"] {
    -state: State
    -dir_fd: os.fd_t
    -fd: os.fd_t
    -io: IO
    -storage: Storage
    -superblock: SuperBlock
    -superblock_context: SuperBlock.Context
    -grid: Grid
    -forest: Forest
    -forest_exists: bool
    -init(env, must_create) !void
    -deinit(env) void
    -tick(env) !void
    +format() !void
    -superblock_format_callback(superblock_context) void
    +open(env) !void
    -superblock_open_callback(superblock_context) void
    -forest_open_callback(forest) void
    +checkpoint(env) !void
    -forest_checkpoint_callback(forest) void
    -superblock_checkpoint_callback(superblock_context) void
    +compact(env, op) !void
    -forest_compact_callback(forest) void
    +assert_visibility(env, visibility, groove, objects, commit_entries_max) !void
    -run() !void
}
Environment <-- State
Environment <-- Visibility
link Environment "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/test.zig#L23"
class `lsm/test.zig` {
    +main() !void
}
`lsm/test.zig` <-- Environment
link `lsm/test.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/test.zig"
class `lsm/manifest_log.zig` {
    +ManifestLogType(Storage, TableInfo) type
    -ManifestLogBlockType(Storage, TableInfo) type
}
link `lsm/manifest_log.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_log.zig"
class Options["Options [struct]"] {
    +verify: bool
}
link Options "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/segmented_array.zig#L43"
class CompareInt["CompareInt [struct]"] {
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
class CompareTable["CompareTable [struct]"] {
    -compare_keys(a, b) std.math.Order
    -key_from_value(value) u64
}
link CompareTable "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/segmented_array.zig#L1270"
class TestOptions["TestOptions [struct]"] {
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
class Page["Page [struct]"] {
    -keys: [layout.keys_count]K
    -values: [layout.values_count]V
}
link Page "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/eytzinger_benchmark.zig#L79"
class Layout["Layout [struct]"] {
    -blob_size: usize
    -key_size: usize
    -value_size: usize
    -keys_count: usize
    -values_count: usize
    -searches: usize
}
Layout <-- Page
link Layout "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/eytzinger_benchmark.zig#L183"
class BenchmarkResult["BenchmarkResult [struct]"] {
    -wall_time: u64
    -utime: u64
    -cpu_cycles: usize
    -instructions: usize
    -cache_references: usize
    -cache_misses: usize
    -branch_misses: usize
}
link BenchmarkResult "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/eytzinger_benchmark.zig#L215"
class Benchmark["Benchmark [struct]"] {
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
class Options["Options [struct]"] {
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
link Options "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_level.zig#L1195"
class `lsm/manifest_level.zig` {
    test "ManifestLevel"()
    +ManifestLevelType(NodePool, Key, TableInfo, compare_keys, table_count_max) type
    +TestContext(node_size, Key, table_count_max) type
}
link `lsm/manifest_level.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/lsm/manifest_level.zig"
class Account["Account [struct]"] {
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
link Account "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tigerbeetle.zig#L5"
class AccountFlags["AccountFlags [struct]"] {
    +linked: bool
    +debits_must_not_exceed_credits: bool
    +credits_must_not_exceed_debits: bool
    +padding: u13
}
link AccountFlags "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tigerbeetle.zig#L38"
class Transfer["Transfer [struct]"] {
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
link Transfer "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tigerbeetle.zig#L59"
class TransferFlags["TransferFlags [struct]"] {
    +linked: bool
    +pending: bool
    +post_pending_transfer: bool
    +void_pending_transfer: bool
    +balancing_debit: bool
    +balancing_credit: bool
    +padding: u10
}
link TransferFlags "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tigerbeetle.zig#L84"
class CreateAccountResult["CreateAccountResult [enum]"] {
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
link CreateAccountResult "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tigerbeetle.zig#L101"
class CreateTransferResult["CreateTransferResult [enum]"] {
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
link CreateTransferResult "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tigerbeetle.zig#L138"
class CreateAccountsResult["CreateAccountsResult [struct]"] {
    +index: u32
    +result: CreateAccountResult
}
link CreateAccountsResult "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tigerbeetle.zig#L218"
class CreateTransfersResult["CreateTransfersResult [struct]"] {
    +index: u32
    +result: CreateTransferResult
}
link CreateTransfersResult "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tigerbeetle.zig#L228"
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
class InMemoryAOF["InMemoryAOF [struct]"] {
    -backing_store: []align(constants.sector_size)
    -index: usize
    +seekTo(self, to) !void
    +readAll(self, buf) !usize
    +close() void
}
link InMemoryAOF "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/aof.zig#L15"
class AOF["AOF [struct]"] {
    +index: usize
    +backing_store: []align(constants.sector_size)
    +validation_target: *AOFEntry
    +last_checksum: ?u128
    +validation_checksums: std.AutoHashMap(u128, void)
    +init(allocator) !AOF
    +deinit(self, allocator) void
    +validate(self, last_checksum) !void
    +write(self, message, options) !void
    +iterator(self) Iterator
}
link AOF "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/aof.zig#L37"
class `testing/aof.zig`
`testing/aof.zig` <-- InMemoryAOF
`testing/aof.zig` <-- AOF
link `testing/aof.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/aof.zig"
class Checkpoint["Checkpoint [struct]"] {
    -checksum_superblock_manifest: u128
    -checksum_superblock_free_set: u128
    -checksum_superblock_client_sessions: u128
    -checksum_client_replies: u128
    -checksum_grid: u128
}
link Checkpoint "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/cluster/storage_checker.zig#L47"
class `testing/cluster/storage_checker.zig` {
    +StorageCheckerType(Replica) type
}
`testing/cluster/storage_checker.zig` <-- Checkpoint
link `testing/cluster/storage_checker.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/cluster/storage_checker.zig"
class `testing/cluster/sync_checker.zig` {
    +SyncCheckerType(Replica) type
    -checkpoint_index(checkpoint_op) usize
}
link `testing/cluster/sync_checker.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/cluster/sync_checker.zig"
class Process["Process [union]"] {
    +replica: u8
    +client: u128
}
link Process "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/cluster/message_bus.zig#L13"
class Options["Options [struct]"] {
    +network: *Network
}
link Options "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/cluster/message_bus.zig#L28"
class MessageBus["MessageBus [struct]"] {
    +network: *Network
    +pool: *MessagePool
    +cluster: u32
    +process: Process
    +on_message_callback: *const fn (message_bus: *MessageBus, message: *Message)
    +init(_, cluster, process, message_pool, on_message_callback, options) !MessageBus
    +deinit(_, _) void
    +tick(_) void
    +get_message(bus) *Message
    +unref(bus, message) void
    +send_message_to_replica(bus, replica, message) void
    +send_message_to_client(bus, client_id, message) void
}
MessageBus <-- Options
link MessageBus "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/cluster/message_bus.zig#L18"
class `testing/cluster/message_bus.zig`
`testing/cluster/message_bus.zig` <-- Process
`testing/cluster/message_bus.zig` <-- MessageBus
link `testing/cluster/message_bus.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/cluster/message_bus.zig"
class ReplicaHead["ReplicaHead [struct]"] {
    -header: vsr.Header
    -replicas: ReplicaSet
    -view: u32
    -op: u64
}
link ReplicaHead "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/cluster/state_checker.zig#L18"
class `testing/cluster/state_checker.zig` {
    +StateCheckerType(Client, Replica) type
}
`testing/cluster/state_checker.zig` <-- ReplicaHead
link `testing/cluster/state_checker.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/cluster/state_checker.zig"
class Packet["Packet [struct]"] {
    +network: *Network
    +message: *Message
    +clone(packet) Packet
    +deinit(packet) void
    +command(packet) vsr.Command
}
link Packet "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/cluster/network.zig#L26"
class Path["Path [struct]"] {
    +source: Process
    +target: Process
}
link Path "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/cluster/network.zig#L46"
class Network["Network [struct]"] {
    +allocator: std.mem.Allocator
    +options: NetworkOptions
    +packet_simulator: PacketSimulatorType(Packet)
    +buses: std.ArrayListUnmanaged(*MessageBus)
    +buses_enabled: std.ArrayListUnmanaged(bool)
    +processes: std.ArrayListUnmanaged(u128)
    +message_pool: MessagePool
    +init(allocator, options) !Network
    +deinit(network) void
    +tick(network) void
    +transition_to_liveness_mode(network, core) void
    +link(network, process, message_bus) void
    +process_enable(network, process) void
    +process_disable(network, process) void
    +link_filter(network, path) *LinkFilter
    +link_record(network, path) *LinkFilter
    +replay_recorded(network) void
    +send_message(network, message, path) void
    -process_to_address(network, process) u8
    +get_message_bus(network, process) *MessageBus
    -deliver_message(packet, path) void
    -raw_process_to_process(raw) Process
}
Network <-- Packet
Network <-- Path
link Network "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/cluster/network.zig#L25"
class `testing/cluster/network.zig`
`testing/cluster/network.zig` <-- Network
link `testing/cluster/network.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/cluster/network.zig"
class OffsetType["OffsetType [enum]"] {
    +linear
    +periodic
    +step
    +non_ideal
}
link OffsetType "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/time.zig#L4"
class Time["Time [struct]"] {
    +resolution: u64
    +offset_type: OffsetType
    +offset_coefficient_A: i64
    +offset_coefficient_B: i64
    +offset_coefficient_C: u32
    +prng: std.rand.DefaultPrng
    +ticks: u64
    +epoch: i64
    +monotonic(self) u64
    +realtime(self) i64
    +offset(self, ticks) i64
    +tick(self) void
}
link Time "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/time.zig#L11"
class `testing/time.zig`
`testing/time.zig` <-- OffsetType
`testing/time.zig` <-- Time
link `testing/time.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/time.zig"
class `testing/hash_log.zig` {
    -ensure_init() void
    +emit(hash) void
    -emit_never_inline(hash) void
    +emit_autohash(hashable, strategy) void
}
link `testing/hash_log.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/hash_log.zig"
class FuzzArgs["FuzzArgs [struct]"] {
    +seed: u64
    +events_max: ?usize
}
link FuzzArgs "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/fuzz.zig#L70"
class `testing/fuzz.zig` {
    +random_int_exponential(random, T, avg) T
    +Distribution(Enum) type
    +random_enum_distribution(random, Enum) Distribution(Enum)
    +random_enum(random, Enum, distribution) Enum
    +parse_fuzz_args(args_allocator) !FuzzArgs
}
`testing/fuzz.zig` <-- FuzzArgs
link `testing/fuzz.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/fuzz.zig"
class ReplicaHealth["ReplicaHealth [enum]"] {
    +up
    +down
}
link ReplicaHealth "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/cluster.zig#L29"
class Failure["Failure [enum]"] {
    +crash
    +liveness
    +correctness
}
link Failure "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/cluster.zig#L34"
class `testing/cluster.zig` {
    +ClusterType(StateMachineType) type
}
`testing/cluster.zig` <-- ReplicaHealth
`testing/cluster.zig` <-- Failure
link `testing/cluster.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/cluster.zig"
class `testing/table.zig` {
    test "comment"()
    test "enum"()
    test "bool"()
    test "int"()
    test "struct"()
    test "struct (nested)"()
    test "array"()
    test "union"()
    +parse(Row, table_string) std.BoundedArray(Row, 128)
    -parse_data(Data, tokens) Data
    -eat(tokens, token) bool
    -field(Enum, name) Enum
    -test_parse(Row, rows_expect, string) !void
}
link `testing/table.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/table.zig"
class PendingReply["PendingReply [struct]"] {
    -client_index: usize
    -request: *Message
    -reply: *Message
    -compare(context, a, b) std.math.Order
}
link PendingReply "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/reply_sequence.zig#L18"
class ReplySequence["ReplySequence [struct]"] {
    +message_pool: MessagePool
    +stalled_op: u64
    +stalled_queue: PendingReplyQueue
    +init(allocator) !ReplySequence
    +deinit(sequence, allocator) void
    +empty(sequence) bool
    +free(sequence) usize
    +insert(sequence, client_index, request_message, reply_message) void
    +peek(sequence) ?PendingReply
    +next(sequence) void
    -clone_message(sequence, message_client) *Message
}
link ReplySequence "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/reply_sequence.zig#L32"
class `testing/reply_sequence.zig`
`testing/reply_sequence.zig` <-- PendingReply
`testing/reply_sequence.zig` <-- ReplySequence
link `testing/reply_sequence.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/reply_sequence.zig"
class PacketSimulatorOptions["PacketSimulatorOptions [struct]"] {
    +node_count: u8
    +client_count: u8
    +seed: u64
    +recorded_count_max: u8
    +one_way_delay_mean: u64
    +one_way_delay_min: u64
    +packet_loss_probability: u8
    +packet_replay_probability: u8
    +partition_mode: PartitionMode
    +partition_symmetry: PartitionSymmetry
    +partition_probability: u8
    +unpartition_probability: u8
    +partition_stability: u32
    +unpartition_stability: u32
    +path_maximum_capacity: u8
    +path_clog_duration_mean: u64
    +path_clog_probability: u8
}
link PacketSimulatorOptions "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/packet_simulator.zig#L10"
class Path["Path [struct]"] {
    +source: u8
    +target: u8
}
link Path "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/packet_simulator.zig#L49"
class PartitionMode["PartitionMode [enum]"] {
    +none
    +uniform_size
    +uniform_partition
    +isolate_single
}
link PartitionMode "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/packet_simulator.zig#L61"
class PartitionSymmetry["PartitionSymmetry [enum]"] {
    +symmetric
    +asymmetric
}
link PartitionSymmetry "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/packet_simulator.zig#L77"
class `testing/packet_simulator.zig` {
    +PacketSimulatorType(Packet) type
}
`testing/packet_simulator.zig` <-- PacketSimulatorOptions
`testing/packet_simulator.zig` <-- Path
`testing/packet_simulator.zig` <-- PartitionMode
`testing/packet_simulator.zig` <-- PartitionSymmetry
link `testing/packet_simulator.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/packet_simulator.zig"
class Options["Options [struct]"] {
    +seed: u64
    +replica_index: ?u8
    +read_latency_min: u64
    +read_latency_mean: u64
    +write_latency_min: u64
    +write_latency_mean: u64
    +read_fault_probability: u8
    +write_fault_probability: u8
    +crash_fault_probability: u8
    +fault_atlas: ?*const ClusterFaultAtlas
}
link Options "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/storage.zig#L56"
class Read["Read [struct]"] {
    +always_synchronous
    +always_asynchronous
    +callback: *const fn (read: *Storage.Read)
    +buffer: []u8
    +zone: vsr.Zone
    +offset: u64
    +done_at_tick: u64
    +stack_trace: StackTrace
    -less_than(context, a, b) math.Order
}
link Read "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/storage.zig#L94"
class Write["Write [struct]"] {
    +callback: *const fn (write: *Storage.Write)
    +buffer: []const u8
    +zone: vsr.Zone
    +offset: u64
    +done_at_tick: u64
    +stack_trace: StackTrace
    -less_than(context, a, b) math.Order
}
link Write "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/storage.zig#L111"
class NextTick["NextTick [struct]"] {
    +next: ?*NextTick
    +source: NextTickSource
    +callback: *const fn (next_tick: *NextTick)
}
link NextTick "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/storage.zig#L128"
class NextTickSource["NextTickSource [enum]"]
link NextTickSource "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/storage.zig#L134"
class MessageRaw["MessageRaw [struct]"] {
    -header: vsr.Header
    -body: [constants.message_size_max - @sizeOf(vsr.Header)
}
link MessageRaw "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/storage.zig#L524"
class Storage["Storage [struct]"] {
    +lsm
    +vsr
    +allocator: mem.Allocator
    +size: u64
    +options: Options
    +prng: std.rand.DefaultPrng
    +memory: []align(constants.sector_size)
    +memory_written: std.DynamicBitSetUnmanaged
    +faults: std.DynamicBitSetUnmanaged
    +faulty: bool
    +reads: PriorityQueue(*Storage.Read, void, Storage.Read.less_than)
    +writes: PriorityQueue(*Storage.Write, void, Storage.Write.less_than)
    +ticks: u64
    +next_tick_queue: FIFO(NextTick)
    +init(allocator, size, options) !Storage
    +deinit(storage, allocator) void
    +reset(storage) void
    +size_used(storage) usize
    +copy(storage, origin) void
    +tick(storage) void
    +on_next_tick(storage, source, callback, next_tick) void
    +reset_next_tick_lsm(storage) void
    +read_sectors(storage, callback, read, buffer, zone, offset_in_zone) void
    -read_sectors_finish(storage, read) void
    +write_sectors(storage, callback, write, buffer, zone, offset_in_zone) void
    -write_sectors_finish(storage, write) void
    -read_latency(storage) u64
    -write_latency(storage) u64
    -latency(storage, min, mean) u64
    -x_in_100(storage, x) bool
    -fault_faulty_sectors(storage, zone, offset_in_zone, size) void
    -fault_sector(storage, zone, sector) void
    +superblock_header(storage, copy_) *const superblock.SuperBlockHeader
    +wal_headers(storage) []const vsr.Header
    +wal_prepares(storage) []const MessageRaw
    +grid_block(storage, address) *align(constants.sector_size) [constants.block_size]u8
    +log_pending_io(storage) void
    +assert_no_pending_reads(storage, zone) void
    +assert_no_pending_writes(storage, zone) void
}
Storage <-- Options
Storage <-- Read
Storage <-- Write
Storage <-- NextTick
Storage <-- NextTickSource
Storage <-- MessageRaw
link Storage "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/storage.zig#L54"
class Area["Area [union]"] {
    +zone: superblock.SuperBlockZone
    +copy: u8
    +superblock: struct
    +sector: usize
    +wal_headers: struct
    +slot: usize
    +wal_prepares: struct
    +slot: usize
    +client_replies: struct
    +address: u64
    +grid: struct
    -sectors(area) SectorRange
}
link Area "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/storage.zig#L617"
class SectorRange["SectorRange [struct]"] {
    -min: usize
    -max: usize
    -from_zone(zone, offset_in_zone, size) SectorRange
    -from_offset(offset_in_storage, size) SectorRange
    -random(range, rand) usize
    -next(range) ?usize
    -intersect(a, b) ?SectorRange
}
link SectorRange "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/storage.zig#L655"
class Options["Options [struct]"] {
    +faulty_superblock: bool
    +faulty_wal_headers: bool
    +faulty_wal_prepares: bool
    +faulty_client_replies: bool
    +faulty_grid: bool
}
link Options "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/storage.zig#L702"
class ClusterFaultAtlas["ClusterFaultAtlas [struct]"] {
    +options: Options
    +faulty_superblock_areas: FaultySuperBlockAreas
    +faulty_wal_header_sectors: [constants.nodes_max]FaultyWALHeaders
    +faulty_client_reply_slots: [constants.nodes_max]FaultyClientReplies
    +faulty_grid_blocks: [constants.nodes_max]FaultyGridBlocks
    +init(replica_count, random, options) ClusterFaultAtlas
    -faulty_superblock(atlas, replica_index, offset_in_zone, size) ?SectorRange
    -faulty_wal_headers(atlas, replica_index, offset_in_zone, size) ?SectorRange
    -faulty_wal_prepares(atlas, replica_index, offset_in_zone, size) ?SectorRange
    -faulty_client_replies(atlas, replica_index, offset_in_zone, size) ?SectorRange
    -faulty_grid(atlas, replica_index, offset_in_zone, size) ?SectorRange
    -faulty_sectors(chunk_count, chunk_size, zone, faulty_chunks, offset_in_zone, size) ?SectorRange
}
ClusterFaultAtlas <-- Options
link ClusterFaultAtlas "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/storage.zig#L701"
class StackTrace["StackTrace [struct]"] {
    -addresses: [64]usize
    -index: usize
    -capture() StackTrace
    +format(self, fmt, options, writer) !void
}
link StackTrace "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/storage.zig#L949"
class `testing/storage.zig` {
    -verify_alignment(buffer) void
}
`testing/storage.zig` <-- Storage
`testing/storage.zig` <-- Area
`testing/storage.zig` <-- SectorRange
`testing/storage.zig` <-- ClusterFaultAtlas
`testing/storage.zig` <-- StackTrace
link `testing/storage.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/storage.zig"
class `testing/state_machine.zig` {
    +StateMachineType(Storage, config) type
    -WorkloadType(StateMachine) type
}
link `testing/state_machine.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/state_machine.zig"
class IdPermutation["IdPermutation [union]"] {
    +identity: void
    +inversion: void
    +zigzag: void
    +random: u64
    +encode(self, data) u128
    +decode(self, id) usize
    +generate(random) IdPermutation
}
link IdPermutation "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/id.zig#L8"
class `testing/id.zig` {
    test "IdPermutation"()
    -test_id_permutation(permutation, value) !void
}
`testing/id.zig` <-- IdPermutation
link `testing/id.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/id.zig"
class Snap["Snap [struct]"] {
    +location: SourceLocation
    +text: []const u8
    +update_this: bool
    +snap(location, text) Snap
    +update(snapshot) Snap
    -should_update(snapshot) bool
    +diff_fmt(snapshot, fmt, fmt_args) !void
    +diff_json(snapshot, value) !void
    +diff(snapshot, got) !void
}
link Snap "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/snaptest.zig#L62"
class Range["Range [struct]"] {
    -start: usize
    -end: usize
}
link Range "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/snaptest.zig#L175"
class `testing/snaptest.zig` {
    -snap_range(text, src_line) Range
    -is_multiline_string(line) bool
    -get_indent(line) []const u8
}
`testing/snaptest.zig` <-- Snap
`testing/snaptest.zig` <-- Range
link `testing/snaptest.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/testing/snaptest.zig"
class Message["Message [struct]"] {
    +header: *Header
    +buffer: *align(constants.sector_size)
    +references: u32
    +next: ?*Message
    +ref(message) *Message
    +body(message) []align(@sizeOf(Header)) u8
}
link Message "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/message_pool.zig#L65"
class MessagePool["MessagePool [struct]"] {
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
class Options["Options [struct]"] {
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
link Options "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/simulator.zig#L314"
class Simulator["Simulator [struct]"] {
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
link Simulator "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/simulator.zig#L313"
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
class Process["Process [union]"] {
    -replica: u8
    -client: u128
}
link Process "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/message_bus.zig#L36"
class `message_bus.zig` {
    -MessageBusType(process_type) type
}
link `message_bus.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/message_bus.zig"
class BufferCompletion["BufferCompletion [struct]"] {
    -next: ?*BufferCompletion
    -buffer: [256]u8
    -completion: IO.Completion
}
link BufferCompletion "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/statsd.zig#L6"
class StatsD["StatsD [struct]"] {
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
class Foo["Foo [struct]"] {
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
class CopyPrecision["CopyPrecision [enum]"] {
    +exact
    +inexact
}
link CopyPrecision "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/stdx.zig#L51"
class Cut["Cut [struct]"] {
    -prefix: []const u8
    -suffix: []const u8
}
link Cut "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/stdx.zig#L157"
class TimeIt["TimeIt [struct]"] {
    -inner: std.time.Timer
    +lap(self, label) void
}
link TimeIt "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/stdx.zig#L208"
class Case["Case [struct]"] {
    +scoped(scope) type
}
link Case "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/stdx.zig#L349"
class `stdx.zig` {
    test "div_ceil"()
    test "copy_left"()
    test "copy_right"()
    test "disjoint_slices"()
    test "hash_inline"()
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
    +hash_inline(value) u64
    -low_level_hash(seed, input) u64
}
`stdx.zig` <-- CopyPrecision
`stdx.zig` <-- Cut
`stdx.zig` <-- TimeIt
link `stdx.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/stdx.zig"
class BitSetConfig["BitSetConfig [struct]"] {
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
class Read["Read [struct]"] {
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
class Write["Write [struct]"] {
    +completion: IO.Completion
    +callback: *const fn (write: *Storage.Write)
    +buffer: []const u8
    +offset: u64
}
link Write "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/storage.zig#L64"
class NextTick["NextTick [struct]"] {
    +next: ?*NextTick
    +source: NextTickSource
    +callback: *const fn (next_tick: *NextTick)
}
link NextTick "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/storage.zig#L71"
class NextTickSource["NextTickSource [enum]"]
link NextTickSource "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/storage.zig#L77"
class Storage["Storage [struct]"] {
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
class Report["Report [struct]"] {
    -checksum: [16]u8
    -bug: u8
    -seed: [8]u8
    -commit: [20]u8
}
link Report "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vopr.zig#L61"
class Flags["Flags [struct]"] {
    -seed: ?u64
    -send_address: ?net.Address
    -build_mode: std.builtin.Mode
    -simulations: u32
}
link Flags "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/vopr.zig#L68"
class Bug["Bug [enum]"] {
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
class Start["Start [struct]"] {
    +args_allocated: std.ArrayList([:0]const u8)
    +addresses: []net.Address
    +cache_accounts: u32
    +cache_transfers: u32
    +cache_transfers_posted: u32
    +storage_size_limit: u64
    +cache_grid_blocks: u32
    +path: [:0]const u8
}
link Start "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tigerbeetle/cli.zig#L97"
class Command["Command [union]"] {
    +format: struct
    +start: Start
    +version: struct
    +deinit(command, allocator) void
}
Command <-- Start
link Command "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tigerbeetle/cli.zig#L96"
class `tigerbeetle/cli.zig` {
    test "parse_size"()
    +parse_args(allocator) !Command
    +fatal(fmt_string, args) noreturn
    -parse_flag(flag, arg) [:0]const u8
    -parse_cluster(raw_cluster) u32
    -parse_addresses(allocator, raw_addresses) []net.Address
    -parse_storage_size(size_string) u64
    -parse_cache_size_to_count(T, SetAssociativeCache, size_string, default_size) u32
    -parse_size(string) u64
    -parse_size_unit(value, suffixes) bool
    -parse_replica(replica_count, raw_replica) u8
    -parse_replica_count(raw_count) u8
}
`tigerbeetle/cli.zig` <-- Command
link `tigerbeetle/cli.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tigerbeetle/cli.zig"
class Command["Command [struct]"] {
    -dir_fd: os.fd_t
    -fd: os.fd_t
    -io: IO
    -storage: Storage
    -message_pool: MessagePool
    -init(command, allocator, path, must_create) !void
    -deinit(command, allocator) void
    +format(allocator, options, path) !void
    +start(arena, args) !void
    +version(allocator, verbose) !void
}
link Command "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tigerbeetle/main.zig#L64"
class `tigerbeetle/main.zig` {
    +main() !void
    -print_value(writer, field, value) !void
}
`tigerbeetle/main.zig` <-- Command
link `tigerbeetle/main.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/tigerbeetle/main.zig"
class Benchmark["Benchmark [struct]"] {
    -io: *IO
    -message_pool: *MessagePool
    -client: *Client
    -batch_accounts: std.ArrayList(tb.Account)
    -account_count: usize
    -account_index: usize
    -rng: std.rand.DefaultPrng
    -timer: std.time.Timer
    -batch_latency_ns: std.ArrayList(u64)
    -transfer_latency_ns: std.ArrayList(u64)
    -batch_transfers: std.ArrayList(tb.Transfer)
    -batch_start_ns: usize
    -transfers_sent: usize
    -tranfer_index: usize
    -transfer_count: usize
    -transfer_count_per_second: usize
    -transfer_arrival_rate_ns: usize
    -transfer_start_ns: std.ArrayList(u64)
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
link Benchmark "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/benchmark.zig#L222"
class `benchmark.zig` {
    +main() !void
    -parse_arg_addresses(allocator, args, arg, arg_name, arg_value) !bool
    -parse_arg_usize(args, arg, arg_name, arg_value) !bool
    -parse_arg_bool(args, arg, arg_name, arg_value) !bool
    -print_deciles(stdout, label, latencies) void
}
`benchmark.zig` <-- Benchmark
link `benchmark.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/benchmark.zig"
class StateMachineConfig["StateMachineConfig [struct]"] {
    +message_body_size_max: comptime_int
    +lsm_batch_multiple: comptime_int
    +vsr_operations_reserved: u8
}
link StateMachineConfig "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/constants.zig#L539"
class `constants.zig`
`constants.zig` <-- StateMachineConfig
link `constants.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/constants.zig"
class `demos/demo_07_lookup_transfers.zig` {
    +main() !void
}
link `demos/demo_07_lookup_transfers.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/demos/demo_07_lookup_transfers.zig"
class `demos/demo.zig` {
    +request(operation, batch, on_reply) !void
    +on_create_accounts(user_data, operation, results) void
    +on_lookup_accounts(user_data, operation, results) void
    +on_lookup_transfers(user_data, operation, results) void
    +on_create_transfers(user_data, operation, results) void
    -print_results(Results, results) void
}
link `demos/demo.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/demos/demo.zig"
class `demos/demo_03_create_transfers.zig` {
    +main() !void
}
link `demos/demo_03_create_transfers.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/demos/demo_03_create_transfers.zig"
class `demos/demo_04_create_pending_transfers.zig` {
    +main() !void
}
link `demos/demo_04_create_pending_transfers.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/demos/demo_04_create_pending_transfers.zig"
class `demos/demo_05_post_pending_transfers.zig` {
    +main() !void
}
link `demos/demo_05_post_pending_transfers.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/demos/demo_05_post_pending_transfers.zig"
class `demos/demo_06_void_pending_transfers.zig` {
    +main() !void
}
link `demos/demo_06_void_pending_transfers.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/demos/demo_06_void_pending_transfers.zig"
class `demos/demo_01_create_accounts.zig` {
    +main() !void
}
link `demos/demo_01_create_accounts.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/demos/demo_01_create_accounts.zig"
class `demos/demo_02_lookup_accounts.zig` {
    +main() !void
}
link `demos/demo_02_lookup_accounts.zig` "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/demos/demo_02_lookup_accounts.zig"
class StringContext["StringContext [struct]"] {
    +hash(self, s) u64
    +eql(self, a, b) bool
}
link StringContext "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/hash_map.zig#L79"
class StringIndexContext["StringIndexContext [struct]"] {
    +bytes: *std.ArrayListUnmanaged(u8)
    +eql(self, a, b) bool
    +hash(self, x) u64
}
link StringIndexContext "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/hash_map.zig#L98"
class StringIndexAdapter["StringIndexAdapter [struct]"] {
    +bytes: *std.ArrayListUnmanaged(u8)
    +eql(self, a_slice, b) bool
    +hash(self, adapted_key) u64
}
link StringIndexAdapter "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/hash_map.zig#L112"
class AdaptedContext["AdaptedContext [struct]"] {
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
class TestContext["TestContext [struct]"] {
    -storage: Storage
    -superblock: SuperBlock
    -grid: Grid
    -state_machine: StateMachine
    -init(ctx, allocator) !void
    -deinit(ctx, allocator) void
}
link TestContext "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/state_machine.zig#L1470"
class TestAction["TestAction [union]"] {
    -setup: struct
    -commit: TestContext.StateMachine.Operation
    -account: TestCreateAccount
    -transfer: TestCreateTransfer
    -lookup_account: struct
    -lookup_transfer: struct
}
link TestAction "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/state_machine.zig#L1534"
class TestCreateAccount["TestCreateAccount [struct]"] {
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
link TestCreateAccount "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/state_machine.zig#L1566"
class TestCreateTransfer["TestCreateTransfer [struct]"] {
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
link TestCreateTransfer "https://github.com/tigerbeetle/tigerbeetle/blob/main/src/state_machine.zig#L1608"
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
