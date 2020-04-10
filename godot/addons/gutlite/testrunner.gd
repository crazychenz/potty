extends Node

var _was_yield_method_called = false
var _waiting = false
var _wait_timer = Timer.new()

func _init():
    add_user_signal('timeout')
    add_user_signal('done_waiting')
    add_user_signal('test_scripts_completed')

func _ready():
    add_child(_wait_timer)

# ------------------------------------------------------------------------------
# Checks the passed in thing to see if it is a "function state" object that gets
# returned when a function yields.
# ------------------------------------------------------------------------------
func _is_function_state(script_result):
    return script_result != null and \
           typeof(script_result) == TYPE_OBJECT and \
           script_result is GDScriptFunctionState

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
func _wait_for_done(result):
    var iter_counter = 0
    var print_after = 3

    # sets waiting to false.
    result.connect('completed', self, '_on_test_script_yield_completed')

    if(!_was_yield_method_called):
        print('/# Yield detected, waiting #/')

    _was_yield_method_called = false
    _waiting = true
    _wait_timer.set_wait_time(0.25)

    while(_waiting):
        iter_counter += 1
        if(iter_counter > print_after):
            #print(WAITING_MESSAGE, 2)
            iter_counter = 0
        _wait_timer.start()
        yield(_wait_timer, 'timeout')

    emit_signal('done_waiting')

# ------------------------------------------------------------------------------
# completed signal for GDScriptFucntionState returned from a test script that
# has yielded
# ------------------------------------------------------------------------------
func _on_test_script_yield_completed():
    _waiting = false

func test_scripts(opts):
    for i in range(opts.tests.size()):
        print(opts.tests[i])
        
        var script = load(opts.tests[i]).new()
        add_child(script)
        
        script.before_all()
        yield(get_tree().create_timer(0.1), "timeout")
        
        print("size %s" % script.get_method_list().size())
        
        for method in script.get_method_list():
            
            if method.name.begins_with("test_") and method.args.size() == 0:
                
                var script_result = null
                
                print("  %s" % method.name)
                
                script.before_each()
                
                #When the script yields it will return a GDScriptFunctionState object
                script_result = script.call(method.name)
                if(_is_function_state(script_result)):
                    _wait_for_done(script_result)
                    yield(self, 'done_waiting')
                
                script.after_each()
                
                var fail_pass_text_end = script._fail_pass_text.size() - 1
                if fail_pass_text_end >= 0:
                    print(script._fail_pass_text[fail_pass_text_end])
        
        yield(get_tree().create_timer(0.1), "timeout")
        script.after_all()
        
        yield(get_tree(), "idle_frame")
        print(script.call('get_summary_text'))
        var summary = script.call('get_summary')
        if summary.failed != 0:
            OS.exit_code = 1
        
        remove_child(script)
        script.call_deferred('queue_free')
    emit_signal("test_scripts_completed")
