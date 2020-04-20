extends "res://addons/gutlite/test.gd"

var Grid = load("res://Grid.gd")
var grid : Grid

var grid_test_cols = 8
var grid_test_rows = 8

var grid_test_data = [
	[null, '*', ' ', ' ', ' ', ' ', ' ', ' '],
	[' ', 'D', ' ', ' ', ' ', ' ', ' ', ' '],
	[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
	[' ', ' ', ' ', ' ', ' ', 'T', ' ', ' '],
	[' ', ' ', ' ', ' ', 'W', ' ', ' ', ' '],
	[' ', ' ', ' ', ' ', ' ', 'C', ' ', ' '],
	[' ', ' ', ' ', ' ', ' ', 'C', ' ', ' '],
	[' ', ' ', ' ', ' ', ' ', ' ', ' ', 'P'],
]

var grid_init_data = [
	[null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null],
]


func reset_test_data():
	for y in range(len(grid_test_data)):
		for x in range(len(grid_test_data[y])):
			grid._set_coords(x, y, grid_test_data[y][x])


func before_each():
	pass


func after_each():
	pass


func before_all():
	grid = Grid.new()
	grid.init_empty_grid(grid_test_rows, grid_test_cols)
	yield(get_tree().create_timer(0.1), "timeout")


func after_all():
	grid.call_deferred("free")
	grid = null
	pass


func test_allocation():
	# Simple signature check of scene being loaded.
	assert_not_null(grid, "Grid load and allocation check")


func test_grid_init():
	grid.init_empty_grid(grid_test_rows, grid_test_cols)
	var equal = true
	for y in range(len(grid_init_data)):
		for x in range(len(grid_init_data[y])):
			if grid_init_data[y][x] != grid.get_coords(x, y):
				equal = false
				print("init_data[%s][%s] %s != grid.get_coords(%s, %s) %s" % \
					[y, x, grid_init_data[y][x], x, y, grid.get_coords(x, y)])
	assert_true(equal, "Check grid init is correct.")


func test_grid_unsafe_set_coords():
	reset_test_data()
	var equal = true
	for y in range(len(grid_test_data)):
		for x in range(len(grid_test_data[y])):
			if grid_test_data[y][x] != grid.get_coords(x, y):
				equal = false
				print("test_data[%s][%s] %s != grid.get_coords(%s, %s) %s" % \
					[y, x, grid_test_data[y][x], x, y, grid.get_coords(x, y)])
	assert_true(equal, "Check grid unsafe _set_coords work.")


func test_grid_set_coords():
	reset_test_data()
	grid.set_coords(1, 1, 'Z')
	assert_true(grid.get_coords(1, 1) == 'Z', "Check grid set_coords works.")


func test_grid_set_position():
	reset_test_data()
	grid.set_position(Vector2(2, 2), 'Q')
	assert_true(grid.get_coords(2, 2) == 'Q', "Check grid set_position works.")


func test_grid_get_position():
	reset_test_data()
	assert_true(grid.get_position(Vector2(1, 1)) == 'D', "Check grid get_position works.")


func test_grid_is_valid_coords():
	assert_true(grid.is_valid_coords(0, 0), "Check valid coords upper left")
	assert_true(grid.is_valid_coords(grid_test_cols-1, grid_test_rows-1), "Check valid coords lower right")
	assert_false(grid.is_valid_coords(grid_test_cols+1, 0), "Check invalid X > cols")
	assert_false(grid.is_valid_coords(-1, 0), "Check invalid X < 0")
	assert_false(grid.is_valid_coords(0, grid_test_rows + 1), "Check invalid Y > rows")
	assert_false(grid.is_valid_coords(0, -1), "Check invalid Y < 0")


func test_grid_is_valid_position():
	assert_true(grid.is_valid_position(Vector2(0, 0)), "Check valid position upper left")
	assert_true(grid.is_valid_position(Vector2(grid_test_cols-1, grid_test_rows-1)), "Check valid position lower right")
	assert_false(grid.is_valid_position(Vector2(grid_test_cols+1, 0)), "Check invalid X > cols")
	assert_false(grid.is_valid_position(Vector2(-1, 0)), "Check invalid X < 0")
	assert_false(grid.is_valid_position(Vector2(0, grid_test_rows+1)), "Check invalid Y > rows")
	assert_false(grid.is_valid_position(Vector2(0, -1)), "Check invalid Y < 0")
	
	
func test_grid_cols_rows():
	assert_true(grid.get_cols() == grid_test_cols, "Testing get_cols")
	assert_true(grid.get_rows() == grid_test_rows, "Testing get_rows")


func test_empty_positions():
	reset_test_data()
	assert_true(grid.is_empty_position(Vector2(0, 0)), "Check is_empty_position when empty")
	assert_true(grid.is_empty_coords(0, 0), "Check is_empty_coords when empty")
	assert_false(grid.is_empty_position(Vector2(1, 1)), "Check is_empty_position when not empty")
	assert_false(grid.is_empty_coords(1, 1), "Check is_empty_coords when not empty")


