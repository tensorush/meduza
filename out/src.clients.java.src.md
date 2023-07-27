```mermaid
---
title: Tigerbeetle database (clients/java/src)
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
```
