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
# Description
# -----------
# Command line interface for the GUT unit testing tool.  Allows you to run tests
# from the command line instead of running a scene.  Place this script along with
# gut.gd into your scripts directory at the root of your project.  Once there you
# can run this script (from the root of your project) using the following command:
# 	godot -s -d test/gut/gut_cmdln.gd
#
# See the readme for a list of options and examples.  You can also use the -gh
# option to get more information about how to use the command line interface.
#
# Version 6.8.2
################################################################################
extends SceneTree

var Optparse = load('res://addons/gutlite/optparse.gd')
var TestRunner = load("res://addons/gutlite/testrunner.gd")
var runner = TestRunner.new()

#-------------------------------------------------------------------------------
# Helper class to resolve the various different places where an option can
# be set.  Using the get_value method will enforce the order of precedence of:
# 	1.  command line value
#	2.  config file value
#	3.  default value
#
# The idea is that you set the base_opts.  That will get you a copies of the
# hash with null values for the other types of values.  Lower precedented hashes
# will punch through null values of higher precedented hashes.
#-------------------------------------------------------------------------------
class OptionResolver:
    var base_opts = null
    var cmd_opts = null
    var config_opts = null


    func get_value(key):
        return _nvl(cmd_opts[key], _nvl(config_opts[key], base_opts[key]))

    func set_base_opts(opts):
        base_opts = opts
        cmd_opts = _null_copy(opts)
        config_opts = _null_copy(opts)

    # creates a copy of a hash with all values null.
    func _null_copy(h):
        var new_hash = {}
        for key in h:
            new_hash[key] = null
        return new_hash

    func _nvl(a, b):
        if(a == null):
            return b
        else:
            return a
    func _string_it(h):
        var to_return = ''
        for key in h:
            to_return += str('(',key, ':', _nvl(h[key], 'NULL'), ')')
        return to_return

    func to_s():
        return str("base:\n", _string_it(base_opts), "\n", \
                   "config:\n", _string_it(config_opts), "\n", \
                   "cmd:\n", _string_it(cmd_opts), "\n", \
                   "resolved:\n", _string_it(get_resolved_values()))

    func get_resolved_values():
        var to_return = {}
        for key in base_opts:
            to_return[key] = get_value(key)
        return to_return

    func to_s_verbose():
        var to_return = ''
        var resolved = get_resolved_values()
        for key in base_opts:
            to_return += str(key, "\n")
            to_return += str('  default: ', _nvl(base_opts[key], 'NULL'), "\n")
            to_return += str('  config:  ', _nvl(config_opts[key], ' --'), "\n")
            to_return += str('  cmd:     ', _nvl(cmd_opts[key], ' --'), "\n")
            to_return += str('  final:   ', _nvl(resolved[key], 'NULL'), "\n")

        return to_return

#-------------------------------------------------------------------------------
# Here starts the actual script that uses the Options class to kick off Gut
# and run your tests.
#-------------------------------------------------------------------------------

# array of command line options specified
var _final_opts = []
# Hash for easier access to the options in the code.  Options will be
# extracted into this hash and then the hash will be used afterwards so
# that I don't make any dumb typos and get the neat code-sense when I
# type a dot.
var options = {
    config_file = 'res://.gutconfig.json',
    dirs = [],
    disable_colors = false,
    double_strategy = 'partial',
    ignore_pause = false,
    include_subdirs = false,
    inner_class = '',
    log_level = 1,
    opacity = 100,
    post_run_script = '',
    pre_run_script = '',
    prefix = 'test_',
    selected = '',
    should_exit = false,
    should_exit_on_success = false,
    should_maximize = false,
    show_help = false,
    suffix = '.gd',
    tests = [],
    unit_test_name = '',
}


func setup_options():
    var opts = Optparse.new()
    opts.set_banner(('This is the command line interface for the unit testing tool Gut.  With this ' +
                    'interface you can run one or more test scripts from the command line.  In order ' +
                    'for the Gut options to not clash with any other godot options, each option starts ' +
                    'with a "g".  Also, any option that requires a value will take the form of ' +
                    '"-g<name>=<value>".  There cannot be any spaces between the option, the "=", or ' +
                    'inside a specified value or godot will think you are trying to run a scene.'))
    opts.add('-gtest', [], 'Comma delimited list of full paths to test scripts to run.')
    opts.add('-gexit', false, 'Exit after running tests.  If not specified you have to manually close the window.')
    opts.add('-gexit_on_success', false, 'Only exit if all tests pass.')
    opts.add('-gh', false, 'Print this help, then quit')
    opts.add('-gpo', false, 'Print option values from all sources and the value used, then quit.')

    return opts


# Parses options, applying them to the _tester or setting values
# in the options struct.
func extract_command_line_options(from, to):
    to.should_exit = from.get_value('-gexit')
    to.should_exit_on_success = from.get_value('-gexit_on_success')
    to.tests = from.get_value('-gtest')

func test_scripts(opts):
    pass

# parse options and run Gut
func _init():
    var opt_resolver = OptionResolver.new()
    opt_resolver.set_base_opts(options)
    get_root().add_child(runner)
    runner.connect('test_scripts_completed', self, "_on_test_scripts_completed")
    
    print(' ---  GutLite  ---')
    var o = setup_options()

    var all_options_valid = o.parse()
    extract_command_line_options(o, opt_resolver.cmd_opts)

    if(!all_options_valid):
        quit()
    elif(o.get_value('-gh')):
        var v_info = Engine.get_version_info()
        print(str('Godot version:  ', v_info.major,  '.',  v_info.minor,  '.',  v_info.patch))
        #print(str('GUT version:  ', Gut.new().get_version()))

        o.print_help()
        quit()
    elif(o.get_value('-gpo')):
        print('All command line options and where they are specified.  ' +
            'The "final" value shows which value will actually be used ' +
            'based on order of precedence (default < .gutconfig < cmd line).' + "\n")
        print(opt_resolver.to_s_verbose())
        quit()
#		elif(o.get_value('-gprint_gutconfig_sample')):
#			_print_gutconfigs(opt_resolver.get_resolved_values())
#			quit()
    else:
        _final_opts = opt_resolver.get_resolved_values();
        runner.test_scripts(_final_opts)
        #quit()

func _on_test_scripts_completed():
    quit()
