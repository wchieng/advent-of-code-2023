extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	day3()

func day3() -> void:
	var solver: Day3Solver = Day3Solver.new()
	solver.init_grid_file("res://day3/day3_input.txt")
	
	var answer_part1:int = solver.solve_part1()
	print("Day 3 Part 1 Answer: %d" % answer_part1)
	
	var answer_part2: int = solver.solve_part2()
	print("Day 3 Part 2 Answer: %d" % answer_part2)
