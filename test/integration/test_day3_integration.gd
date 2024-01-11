extends GutTest

func test_get_potential_gear_positions():
	var solver: Day3Solver = Day3Solver.new()
	
	# There should be 3 potential gears (* symbols) but two actual gears.
	solver.init_grid_file("res://day3_example.txt")
	var potential_gears: Array[Vector2] = solver.grid.get_potential_gear_positions()
	assert_eq(potential_gears.size(), 3)
	
	var actual_gears: Dictionary = solver.grid.get_gears()
	assert_eq(actual_gears.size(), 2)

func test_solve_example():
	# The example should output 467835.
	var solver: Day3Solver = Day3Solver.new()
	solver.init_grid_file("res://day3_example.txt")
	
	var part1: int = solver.solve_part1()
	assert_eq(part1, 4361)
	
	var part2: int = solver.solve_part2()
	assert_eq(part2, 467835)
