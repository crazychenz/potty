################################################################################
#(G)odot (U)nit (T)est class
#
################################################################################
#The MIT License (MIT)
#=====================
#
#Copyright (c) 2019 Tom "Butch" Wesley
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.
#
################################################################################
# View readme for usage details.
#
# Version - see gut.gd
################################################################################
# Class that all test scripts must extend.
#
# This provides all the asserts and other testing features.  Test scripts are
# run by the Gut class in gut.gd
################################################################################

extends Node

# ------------------------------------------------------------------------------
# Begin test.gd
# ------------------------------------------------------------------------------

# constant for signal when calling yield_for
const YIELD = 'timeout'

# Need a reference to the instance that is running the tests.  This
# is set by the gut class when it runs the tests.  This gets you
# access to the asserts in the tests you write.
var gut = null
var passed = false
var failed = false
var _disable_strict_datatype_checks = false
# Holds all the text for a test's fail/pass.  This is used for testing purposes
# to see the text of a failed sub-test in test_test.gd
var _fail_pass_text = []

# Hash containing all the built in types in Godot.  This provides an English
# name for the types that corosponds with the type constants defined in the
# engine.  This is used for priting out messages when comparing types fails.
var types = {}

func _init_types_dictionary():
    types[TYPE_NIL] = 'TYPE_NIL'
    types[TYPE_BOOL] = 'Bool'
    types[TYPE_INT] = 'Int'
    types[TYPE_REAL] = 'Float/Real'
    types[TYPE_STRING] = 'String'
    types[TYPE_VECTOR2] = 'Vector2'
    types[TYPE_RECT2] = 'Rect2'
    types[TYPE_VECTOR3] = 'Vector3'
    #types[8] = 'Matrix32'
    types[TYPE_PLANE] = 'Plane'
    types[TYPE_QUAT] = 'QUAT'
    types[TYPE_AABB] = 'AABB'
    #types[12] = 'Matrix3'
    types[TYPE_TRANSFORM] = 'Transform'
    types[TYPE_COLOR] = 'Color'
    #types[15] = 'Image'
    types[TYPE_NODE_PATH] = 'Node Path'
    types[TYPE_RID] = 'RID'
    types[TYPE_OBJECT] = 'TYPE_OBJECT'
    #types[19] = 'TYPE_INPUT_EVENT'
    types[TYPE_DICTIONARY] = 'Dictionary'
    types[TYPE_ARRAY] = 'Array'
    types[TYPE_RAW_ARRAY] = 'TYPE_RAW_ARRAY'
    types[TYPE_INT_ARRAY] = 'TYPE_INT_ARRAY'
    types[TYPE_REAL_ARRAY] = 'TYPE_REAL_ARRAY'
    types[TYPE_STRING_ARRAY] = 'TYPE_STRING_ARRAY'
    types[TYPE_VECTOR2_ARRAY] = 'TYPE_VECTOR2_ARRAY'
    types[TYPE_VECTOR3_ARRAY] = 'TYPE_VECTOR3_ARRAY'
    types[TYPE_COLOR_ARRAY] = 'TYPE_COLOR_ARRAY'
    types[TYPE_MAX] = 'TYPE_MAX'

const EDITOR_PROPERTY = PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_DEFAULT
const VARIABLE_PROPERTY = PROPERTY_USAGE_SCRIPT_VARIABLE

# Summary counts for the test.
var _summary = {
    asserts = 0,
    passed = 0,
    failed = 0,
    tests = 0,
    pending = 0
}

func _init():
    _init_types_dictionary()

# ------------------------------------------------------------------------------
# Fail an assertion.  Causes test and script to fail as well.
# ------------------------------------------------------------------------------
func _fail(text):
    _summary.asserts += 1
    _summary.failed += 1
    var msg = 'FAILED:  ' + text
    _fail_pass_text.append(msg)

# ------------------------------------------------------------------------------
# Pass an assertion.
# ------------------------------------------------------------------------------
func _pass(text):
    _summary.asserts += 1
    _summary.passed += 1
    var msg = "PASSED:  " + text
    _fail_pass_text.append(msg)

# ------------------------------------------------------------------------------
# Checks if the datatypes passed in match.  If they do not then this will cause
# a fail to occur.  If they match then TRUE is returned, FALSE if not.  This is
# used in all the assertions that compare values.
# ------------------------------------------------------------------------------
func _do_datatypes_match__fail_if_not(got, expected, text):
    var did_pass = true

    if(!_disable_strict_datatype_checks):
        var got_type = typeof(got)
        var expect_type = typeof(expected)
        if(got_type != expect_type and got != null and expected != null):
            # If we have a mismatch between float and int (types 2 and 3) then
            # print out a warning but do not fail.
            #if([2, 3].has(got_type) and [2, 3].has(expect_type)):
            #	_lgr.warn(str('Warn:  Float/Int comparison.  Got ', types[got_type], ' but expected ', types[expect_type]))
            #else:
            _fail('Cannot compare ' + types[got_type] + '[' + str(got) + '] to ' + types[expect_type] + '[' + str(expected) + '].  ' + text)
            did_pass = false

    return did_pass

# #######################
# Virtual Methods
# #######################

# alias for prerun_setup
func before_all():
    pass

# alias for setup
func before_each():
    pass

# alias for postrun_teardown
func after_all():
    pass

# alias for teardown
func after_each():
    pass

# #######################
# Asserts
# #######################

# ------------------------------------------------------------------------------
# Asserts that the expected value equals the value got.
# ------------------------------------------------------------------------------
func assert_eq(got, expected, text=""):
    var disp = "[" + str(got) + "] expected to equal [" + str(expected) + "]:  " + text
    if(_do_datatypes_match__fail_if_not(got, expected, text)):
        if(expected != got):
            _fail(disp)
        else:
            _pass(disp)

# ------------------------------------------------------------------------------
# Asserts that the value got does not equal the "not expected" value.
# ------------------------------------------------------------------------------
func assert_ne(got, not_expected, text=""):
    var disp = "[" + str(got) + "] expected to be anything except [" + str(not_expected) + "]:  " + text
    if(_do_datatypes_match__fail_if_not(got, not_expected, text)):
        if(got == not_expected):
            _fail(disp)
        else:
            _pass(disp)

# ------------------------------------------------------------------------------
# Asserts that the expected value almost equals the value got.
# ------------------------------------------------------------------------------
func assert_almost_eq(got, expected, error_interval, text=''):
    var disp = "[" + str(got) + "] expected to equal [" + str(expected) + "] +/- [" + str(error_interval) + "]:  " + text
    if(_do_datatypes_match__fail_if_not(got, expected, text) and _do_datatypes_match__fail_if_not(got, error_interval, text)):
        if(got < (expected - error_interval) or got > (expected + error_interval)):
            _fail(disp)
        else:
            _pass(disp)

# ------------------------------------------------------------------------------
# Asserts that the expected value does not almost equal the value got.
# ------------------------------------------------------------------------------
func assert_almost_ne(got, not_expected, error_interval, text=''):
    var disp = "[" + str(got) + "] expected to not equal [" + str(not_expected) + "] +/- [" + str(error_interval) + "]:  " + text
    if(_do_datatypes_match__fail_if_not(got, not_expected, text) and _do_datatypes_match__fail_if_not(got, error_interval, text)):
        if(got < (not_expected - error_interval) or got > (not_expected + error_interval)):
            _pass(disp)
        else:
            _fail(disp)

# ------------------------------------------------------------------------------
# Asserts got is greater than expected
# ------------------------------------------------------------------------------
func assert_gt(got, expected, text=""):
    var disp = "[" + str(got) + "] expected to be > than [" + str(expected) + "]:  " + text
    if(_do_datatypes_match__fail_if_not(got, expected, text)):
        if(got > expected):
            _pass(disp)
        else:
            _fail(disp)

# ------------------------------------------------------------------------------
# Asserts got is less than expected
# ------------------------------------------------------------------------------
func assert_lt(got, expected, text=""):
    var disp = "[" + str(got) + "] expected to be < than [" + str(expected) + "]:  " + text
    if(_do_datatypes_match__fail_if_not(got, expected, text)):
        if(got < expected):
            _pass(disp)
        else:
            _fail(disp)

# ------------------------------------------------------------------------------
# asserts that got is true
# ------------------------------------------------------------------------------
func assert_true(got, text=""):
    if(!got):
        _fail(text)
    else:
        _pass(text)

# ------------------------------------------------------------------------------
# Asserts that got is false
# ------------------------------------------------------------------------------
func assert_false(got, text=""):
    if(got):
        _fail(text)
    else:
        _pass(text)

# ------------------------------------------------------------------------------
# Asserts value is between (inclusive) the two expected values.
# ------------------------------------------------------------------------------
func assert_between(got, expect_low, expect_high, text=""):
    var disp = "[" + str(got) + "] expected to be between [" + str(expect_low) + "] and [" + str(expect_high) + "]:  " + text

    if(_do_datatypes_match__fail_if_not(got, expect_low, text) and _do_datatypes_match__fail_if_not(got, expect_high, text)):
        if(expect_low > expect_high):
            disp = "INVALID range.  [" + str(expect_low) + "] is not less than [" + str(expect_high) + "]"
            _fail(disp)
        else:
            if(got < expect_low or got > expect_high):
                _fail(disp)
            else:
                _pass(disp)

# ------------------------------------------------------------------------------
# Uses the 'has' method of the object passed in to determine if it contains
# the passed in element.
# ------------------------------------------------------------------------------
func assert_has(obj, element, text=""):
    var disp = str('Expected [', obj, '] to contain value:  [', element, ']:  ', text)
    if(obj.has(element)):
        _pass(disp)
    else:
        _fail(disp)

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func assert_does_not_have(obj, element, text=""):
    var disp = str('Expected [', obj, '] to NOT contain value:  [', element, ']:  ', text)
    if(obj.has(element)):
        _fail(disp)
    else:
        _pass(disp)

# ------------------------------------------------------------------------------
# Asserts that a file exists
# ------------------------------------------------------------------------------
func assert_file_exists(file_path):
    var disp = 'expected [' + file_path + '] to exist.'
    var f = File.new()
    if(f.file_exists(file_path)):
        _pass(disp)
    else:
        _fail(disp)

# ------------------------------------------------------------------------------
# Asserts that a file should not exist
# ------------------------------------------------------------------------------
func assert_file_does_not_exist(file_path):
    var disp = 'expected [' + file_path + '] to NOT exist'
    var f = File.new()
    if(!f.file_exists(file_path)):
        _pass(disp)
    else:
        _fail(disp)

# ------------------------------------------------------------------------------
# Asserts the specified file is empty
# ------------------------------------------------------------------------------
func assert_file_empty(file_path):
    var disp = 'expected [' + file_path + '] to be empty'
    var f = File.new()
    if(f.file_exists(file_path) and gut.is_file_empty(file_path)):
        _pass(disp)
    else:
        _fail(disp)

# ------------------------------------------------------------------------------
# Asserts the specified file is not empty
# ------------------------------------------------------------------------------
func assert_file_not_empty(file_path):
    var disp = 'expected [' + file_path + '] to contain data'
    if(!gut.is_file_empty(file_path)):
        _pass(disp)
    else:
        _fail(disp)

# ------------------------------------------------------------------------------
# Asserts the object has the specified method
# ------------------------------------------------------------------------------
func assert_has_method(obj, method):
    assert_true(obj.has_method(method), 'Should have method: ' + method)

# ------------------------------------------------------------------------------
# Verifies the object has get and set methods for the property passed in.  The
# property isn't tied to anything, just a name to be appended to the end of
# get_ and set_.  Asserts the get_ and set_ methods exist, if not, it stops there.
# If they exist then it asserts get_ returns the expected default then calls
# set_ and asserts get_ has the value it was set to.
# ------------------------------------------------------------------------------
func assert_accessors(obj, property, default, set_to):
    var fail_count = _summary.failed
    var get = 'get_' + property
    var set = 'set_' + property
    assert_has_method(obj, get)
    assert_has_method(obj, set)
    # SHORT CIRCUIT
    if(_summary.failed > fail_count):
        return
    assert_eq(obj.call(get), default, 'It should have the expected default value.')
    obj.call(set, set_to)
    assert_eq(obj.call(get), set_to, 'The set value should have been returned.')


# ---------------------------------------------------------------------------
# Property search helper.  Used to retrieve Dictionary of specified property
# from passed object. Returns null if not found.
# If provided, property_usage constrains the type of property returned by
# passing either:
# EDITOR_PROPERTY for properties defined as: export(int) var some_value
# VARIABLE_PROPERTY for properties defunded as: var another_value
# ---------------------------------------------------------------------------
func _find_object_property(obj, property_name, property_usage=null):
    var result = null
    var found = false
    var properties = obj.get_property_list()

    while !found and !properties.empty():
        var property = properties.pop_back()
        if property['name'] == property_name:
            if property_usage == null or property['usage'] == property_usage:
                result = property
                found = true
    return result

# ------------------------------------------------------------------------------
# Asserts a class exports a variable.
# ------------------------------------------------------------------------------
func assert_exports(obj, property_name, type):
    var disp = 'expected %s to have editor property [%s]' % [obj, property_name]
    var property = _find_object_property(obj, property_name, EDITOR_PROPERTY)
    if property != null:
        disp += ' of type [%s]. Got type [%s].' % [types[type], types[property['type']]]
        if property['type'] == type:
            _pass(disp)
        else:
            _fail(disp)
    else:
        _fail(disp)

# ------------------------------------------------------------------------------
# Check if an object is connected to a signal on another object. Returns True
# if it is and false otherwise
# ------------------------------------------------------------------------------
func _is_connected(signaler_obj, connect_to_obj, signal_name, method_name=""):
    if(method_name != ""):
        return signaler_obj.is_connected(signal_name, connect_to_obj, method_name)
    else:
        var connections = signaler_obj.get_signal_connection_list(signal_name)
        for conn in connections:
            if((conn.source == signaler_obj) and (conn.target == connect_to_obj)):
                return true
        return false

# ------------------------------------------------------------------------------
# Asserts that an object is connected to a signal on another object
#
# This will fail with specific messages if the target object is not connected
# to the specified signal on the source object.
# ------------------------------------------------------------------------------
func assert_connected(signaler_obj, connect_to_obj, signal_name, method_name=""):
    pass
    var method_disp = ''
    if (method_name != ""):
        method_disp = str(' using method: [', method_name, '] ')
    var disp = str('Expected object ', signaler_obj,\
        ' to be connected to signal: [', signal_name, '] on ',\
        connect_to_obj, method_disp)
    if(_is_connected(signaler_obj, connect_to_obj, signal_name, method_name)):
        _pass(disp)
    else:
        _fail(disp)

# ------------------------------------------------------------------------------
# Asserts that an object is not connected to a signal on another object
#
# This will fail with specific messages if the target object is connected
# to the specified signal on the source object.
# ------------------------------------------------------------------------------
func assert_not_connected(signaler_obj, connect_to_obj, signal_name, method_name=""):
    var method_disp = ''
    if (method_name != ""):
        method_disp = str(' using method: [', method_name, '] ')
    var disp = str('Expected object ', signaler_obj,\
        ' to not be connected to signal: [', signal_name, '] on ',\
        connect_to_obj, method_disp)
    if(_is_connected(signaler_obj, connect_to_obj, signal_name, method_name)):
        _fail(disp)
    else:
        _pass(disp)

# Alias for assert_extends
func assert_is(object, a_class, text=''):
    var disp = str('Expected [', object, '] to be type of [', a_class, ']: ', text)
    var NATIVE_CLASS = 'GDScriptNativeClass'
    var GDSCRIPT_CLASS = 'GDScript'
    var bad_param_2 = 'Parameter 2 must be a Class (like Node2D or Label).  You passed '

    if(typeof(object) != TYPE_OBJECT):
        _fail(str('Parameter 1 must be an instance of an object.  You passed:  ', types[typeof(object)]))
    elif(typeof(a_class) != TYPE_OBJECT):
        _fail(str(bad_param_2, types[typeof(a_class)]))
    else:
        disp = str('Expected [', object.get_class(), '] to extend [', a_class.get_class(), ']: ', text)
        if(a_class.get_class() != NATIVE_CLASS and a_class.get_class() != GDSCRIPT_CLASS):
            _fail(str(bad_param_2, a_class.get_class(), '  ', types[typeof(a_class)]))
        else:
            if(object is a_class):
                _pass(disp)
            else:
                _fail(disp)

func _get_typeof_string(the_type):
    var to_return = ""
    if(types.has(the_type)):
        to_return += str(the_type, '(',  types[the_type], ')')
    else:
        to_return += str(the_type)
    return to_return

    # ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func assert_typeof(object, type, text=''):
    var disp = str('Expected [typeof(', object, ') = ')
    disp += _get_typeof_string(typeof(object))
    disp += '] to equal ['
    disp += _get_typeof_string(type) +  ']'
    disp += '.  ' + text
    if(typeof(object) == type):
        _pass(disp)
    else:
        _fail(disp)

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func assert_not_typeof(object, type, text=''):
    var disp = str('Expected [typeof(', object, ') = ')
    disp += _get_typeof_string(typeof(object))
    disp += '] to not equal ['
    disp += _get_typeof_string(type) +  ']'
    disp += '.  ' + text
    if(typeof(object) != type):
        _pass(disp)
    else:
        _fail(disp)

# ------------------------------------------------------------------------------
# Assert that text contains given search string.
# The match_case flag determines case sensitivity.
# ------------------------------------------------------------------------------
func assert_string_contains(text, search, match_case=true):
    var empty_search = 'Expected text and search strings to be non-empty. You passed \'%s\' and \'%s\'.'
    var disp = 'Expected \'%s\' to contain \'%s\', match_case=%s' % [text, search, match_case]
    if(text == '' or search == ''):
        _fail(empty_search % [text, search])
    elif(match_case):
        if(text.find(search) == -1):
            _fail(disp)
        else:
            _pass(disp)
    else:
        if(text.to_lower().find(search.to_lower()) == -1):
            _fail(disp)
        else:
            _pass(disp)

# ------------------------------------------------------------------------------
# Assert that text starts with given search string.
# match_case flag determines case sensitivity.
# ------------------------------------------------------------------------------
func assert_string_starts_with(text, search, match_case=true):
    var empty_search = 'Expected text and search strings to be non-empty. You passed \'%s\' and \'%s\'.'
    var disp = 'Expected \'%s\' to start with \'%s\', match_case=%s' % [text, search, match_case]
    if(text == '' or search == ''):
        _fail(empty_search % [text, search])
    elif(match_case):
        if(text.find(search) == 0):
            _pass(disp)
        else:
            _fail(disp)
    else:
        if(text.to_lower().find(search.to_lower()) == 0):
            _pass(disp)
        else:
            _fail(disp)

# ------------------------------------------------------------------------------
# Assert that text ends with given search string.
# match_case flag determines case sensitivity.
# ------------------------------------------------------------------------------
func assert_string_ends_with(text, search, match_case=true):
    var empty_search = 'Expected text and search strings to be non-empty. You passed \'%s\' and \'%s\'.'
    var disp = 'Expected \'%s\' to end with \'%s\', match_case=%s' % [text, search, match_case]
    var required_index = len(text) - len(search)
    if(text == '' or search == ''):
        _fail(empty_search % [text, search])
    elif(match_case):
        if(text.find(search) == required_index):
            _pass(disp)
        else:
            _fail(disp)
    else:
        if(text.to_lower().find(search.to_lower()) == required_index):
            _pass(disp)
        else:
            _fail(disp)


# ------------------------------------------------------------------------------
# Asserts the passed in value is null
# ------------------------------------------------------------------------------
func assert_null(got, text=''):
    var disp = str('Expected [', got, '] to be NULL:  ', text)
    if(got == null):
        _pass(disp)
    else:
        _fail(disp)

# ------------------------------------------------------------------------------
# Asserts the passed in value is null
# ------------------------------------------------------------------------------
func assert_not_null(got, text=''):
    var disp = str('Expected [', got, '] to be anything but NULL:  ', text)
    if(got == null):
        _fail(disp)
    else:
        _pass(disp)

# -----------------------------------------------------------------------------
# Asserts object has been freed from memory
# We pass in a title (since if it is freed, we lost all identity data)
# -----------------------------------------------------------------------------
func assert_freed(obj, title):
    assert_true(not is_instance_valid(obj), "Object %s is freed" % title)

# ------------------------------------------------------------------------------
# Asserts Object has not been freed from memory
# -----------------------------------------------------------------------------
func assert_not_freed(obj, title):
    assert_true(is_instance_valid(obj), "Object %s is not freed" % title)

func get_summary():
    return _summary

func get_fail_count():
    return _summary.failed

func get_pass_count():
    return _summary.passed

func get_pending_count():
    return _summary.pending

func get_assert_count():
    return _summary.asserts

# ------------------------------------------------------------------------------
# Convert the _summary dictionary into text
# ------------------------------------------------------------------------------
func get_summary_text():
    var to_return = "" #= get_script().get_path() + "\n"
    to_return += str('  ', _summary.passed, ' of ', _summary.asserts, ' passed.')
    if(_summary.pending > 0):
        to_return += str("\n  ", _summary.pending, ' pending')
    if(_summary.failed > 0):
        to_return += str("\n  ", _summary.failed, ' failed.')
    return to_return
