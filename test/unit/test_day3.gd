extends GutTest

func test_add_row():
	# 1 2 3 . # . 4 5 6
	var solver: Day3Solver = Day3Solver.new()
	solver.init_empty_grid()
	solver.grid.add_row(0, "123.#.456")
	# There should be 2 full numbers (though at multiple columns)
	# Here's the first one
	assert_eq(solver.grid.full_num[Vector2(0,0)].get_num(), 123)
	assert_eq(solver.grid.full_num[Vector2(1,0)].get_num(), 123)
	assert_eq(solver.grid.full_num[Vector2(2,0)].get_num(), 123)
	# Second one
	assert_eq(solver.grid.full_num[Vector2(6,0)].get_num(), 456)
	assert_eq(solver.grid.full_num[Vector2(7,0)].get_num(), 456)
	assert_eq(solver.grid.full_num[Vector2(8,0)].get_num(), 456)
	# And one symbol
	assert_eq(solver.grid.symbol_pos[Vector2(4,0)], "#")
	
	# What if the row doesn't start with a number?
	# $ 1 2 3 . # 4 5 6
	solver.init_empty_grid()
	solver.grid.add_row(0, "$123.#456")
	# There should be 2 full numbers (though at multiple columns)
	# Here's the first one
	assert_eq(solver.grid.full_num[Vector2(1,0)].get_num(), 123)
	assert_eq(solver.grid.full_num[Vector2(2,0)].get_num(), 123)
	assert_eq(solver.grid.full_num[Vector2(3,0)].get_num(), 123)
	# Second one
	assert_eq(solver.grid.full_num[Vector2(6,0)].get_num(), 456)
	assert_eq(solver.grid.full_num[Vector2(7,0)].get_num(), 456)
	assert_eq(solver.grid.full_num[Vector2(8,0)].get_num(), 456)
	# And one symbol
	assert_eq(solver.grid.symbol_pos[Vector2(5,0)], "#")
	
func test_get_neighbor_nums():
	# No neighbors to this symbol
	# 1 2 3 . # . 4 5 6
	var solver: Day3Solver = Day3Solver.new()
	solver.init_empty_grid()
	solver.grid.add_row(0, "123.#.456")
	var neighbors: Array = solver.grid.get_neighbor_nums(Vector2(4,0))
	assert_eq(neighbors.size(), 0)

	# Neighbors one
	# 1 2 3 # . 4 5 6
	solver.init_empty_grid()
	solver.grid.add_row(0, "123#.456")
	neighbors = solver.grid.get_neighbor_nums(Vector2(3,0))
	assert_eq(neighbors.size(), 1)
	assert_eq(neighbors[0].get_num(), 123)
	
	# 2 Neighbors
	# 1 2 3 # 4 5 6
	solver.init_empty_grid()
	solver.grid.add_row(0, "123#456")
	neighbors = solver.grid.get_neighbor_nums(Vector2(3,0))
	assert_eq(neighbors.size(), 2)
	assert_eq(neighbors[0].get_num(), 123)
	assert_eq(neighbors[1].get_num(), 456)
