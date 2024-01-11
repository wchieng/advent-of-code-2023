extends Node
class_name Day3Solver

var grid: Day3Grid

func init_grid_file(filepath: String) -> void:
	self.grid = Day3Grid.new()
	
	var input_file: FileAccess = FileAccess.open(filepath, FileAccess.READ)
	if input_file == null:
		# Couldn't open the file
		return
			
	var current_line: String = input_file.get_line()
	var row_num = 0
	while current_line != "":
		self.grid.add_row(row_num, current_line)
		current_line = input_file.get_line()
		row_num += 1

# For testing
func init_empty_grid() -> void:
	self.grid = Day3Grid.new()

func solve_part1() -> int:
	if !self.grid.is_initialized():
		return 0
	
	# all_neighbor_nums holds all numbers that neighbor symbols, mapped from
	# number identifier to the actual number. This allows us to deduplicate in
	# case multiple symbols neighbor the same number (or one symbol neighbors 
	# multiple digits of the same number).
	var all_neighbor_nums: Dictionary = {}
	var positions: Array = self.grid.get_symbol_positions()
	
	for pos in positions:
		var neighbors: Array[FullNumber] = self.grid.get_neighbor_nums(pos)
		for neighbor in neighbors:
			all_neighbor_nums[neighbor.get_id()] = neighbor.get_num()

	# Now we have all the numbers that neighbor symbols, de-duplicated. Sum them.
	return all_neighbor_nums.values().reduce(_sum, 0)

func _sum(accum: int, number: int) -> int:
	return accum + number

func solve_part2() -> int:
	if !self.grid.is_initialized():
		return 0
	var sum: int = 0
	var gears: Dictionary = self.grid.get_gears()
	for pos in gears:
		var gear: Gear = gears[pos]
		sum += gear.get_ratio()	
	return sum

class FullNumber:
	var num: String
	var start_pos: Vector2
	var end_pos: Vector2
	
	func _init(n, sp, ep):
		self.num = n
		self.start_pos = sp
		self.end_pos = ep
	
	func get_num() -> int:
		return self.num.to_int()
	
	# get_id returns a string identifier representing this FullNumber. This 
	# allows us to deduplicate in case a symbol neighbors multiple digits of the 
	# same FullNumber.
	func get_id() -> String:
		return "%s-(%d,%d)-(%d,%d)" % [num, start_pos.x, start_pos.y, end_pos.x, end_pos.y]

class Gear:
	var symbol: String
	var symbol_pos: Vector2
	var part_num1: int
	var part_num2: int
	
	func _init(s: String, pos: Vector2, p1: int, p2: int):
		self.symbol = s
		self.symbol_pos = pos
		self.part_num1 = p1
		self.part_num2 = p2
	
	func get_ratio() -> int:
		return self.part_num1 * self.part_num2

class Day3Grid:
	# grid represents the engine schematic in a positional grid of x,y coordinates
	# An (x,y) coordinate pair accesses a specific character in the engine schematic.
	var grid: Dictionary
	
	# symbol_pos holds the (x,y) position of each symbol in the schematic. Maps
	# (x,y) Vector2 to a symbol.  
	var symbol_pos: Dictionary
	
	# full_num maps (x,y) coordinates (Vector2) to full numbers (represented as 
	# FullNumber objects). Note that if a number has several digits (like 789, 
	# in row 0: ".789.." - starting on column 1, ending on column 3), then there 
	# will be entries for each of those columns (digits).
	var full_num: Dictionary
	
	var initialized: bool

	func _init():
		self.grid = {}
		self.symbol_pos = {}
		self.full_num = {}
		self.initialized = false
	
	func is_initialized() -> bool:
		return self.initialized

	# add_row adds a line of the engine schematic into the grid as a row.
	func add_row(row_num: int, row_str: String):
		self.initialized = true
		
		# row maps column (zero-indexed) to character (num, symbol)
		var row: Dictionary = {}
		
		# Because we need the full number next to a particular symbol, and 
		# because full numbers are contiguous, we can use num_so_far to track 
		# contiguous numbers.
		var num_so_far: PackedStringArray = []
		var num_col_start: int = -1
		var num_col_end: int = -1
		
		for i in range(row_str.length()):
			var character: String = row_str[i]
			row[i] = character
			
			if character.is_valid_int():
				num_so_far.append(character)
				if num_col_start == -1:
					num_col_start = i
				num_col_end = i
				continue
			
			# If not a number, then we have our full number (if we have been 
			# tracking a number).
			if num_so_far.size() > 0:
				# Save the full number keyed on its (x,y) positions (for each 
				# column its digits are in)
				var num_str: String = "".join(num_so_far)
				for num_col in range(num_col_start, num_col_end+1):
					var full_num_obj: FullNumber = FullNumber.new(num_str, Vector2(num_col_start, row_num), Vector2(num_col_end, row_num))
					full_num[Vector2(num_col, row_num)] = full_num_obj
				
				# Reset the full number tracking
				num_so_far = []
				num_col_start = -1
				num_col_end = -1
				
			# Now that we've taken care of potential numbers, let's handle the
			# symbol in the current column.
			if character == ".":
				# Periods are just spacers. No processing needed.
				continue 
			
			# Any other symbol counts though. Save the (x,y) positions.
			symbol_pos[Vector2(i, row_num)] = character
		
		# If we're at the end of the row, and it ends with a number, record it.
		if num_so_far.size() > 0:
			# Save the full number keyed on its (x,y) positions (for each 
			# column its digits are in)
			var num_str: String = "".join(num_so_far)
			for num_col in range(num_col_start, num_col_end+1):
				var full_num_obj: FullNumber = FullNumber.new(num_str, Vector2(num_col_start, row_num), Vector2(num_col_end, row_num))
				full_num[Vector2(num_col, row_num)] = full_num_obj
		
		grid[row_num] = row

	# get_neighbor_nums, given an (x,y) coordinate pair, will return the full 
	# numbers adjacent to that position. Duplicates can occur at this stage, 
	# since we're only looking per symbol so far. We'll deduplicate later.
	func get_neighbor_nums(pos: Vector2) -> Array[FullNumber]:
		var neighbor_nums: Array[FullNumber] = []
		
		var min_x: int = clampi(pos.x-1, 0, pos.x)
		var max_x: int = pos.x+1
		var min_y: int = clampi(pos.y-1, 0, pos.y)
		var max_y: int = pos.y+1
		
		for current_x in range(min_x, max_x+1):
			for current_y in range(min_y, max_y+1):
				# Actually doesn't matter if we go out of bounds, since it just 
				# means there's no key in the number dictionary.
				var key: Vector2 = Vector2(current_x, current_y)
				if self.full_num.has(key):
					neighbor_nums.append(self.full_num[key])
		return neighbor_nums

	func get_symbol_positions() -> Array:
		return self.symbol_pos.keys()
		
	func get_potential_gear_positions() -> Array[Vector2]:
		var potential_gear_pos: Array[Vector2] = []
		for pos in self.symbol_pos:
			if self.symbol_pos[pos] == '*':
				potential_gear_pos.append(pos)
		return potential_gear_pos
	
	func get_gears() -> Dictionary:
		var gears: Dictionary = {}
		# Get the location of each '*' symbol
		var potential_gears: Array[Vector2] = get_potential_gear_positions()
		# Then check to see if each of them neighbor 2 part numbers
		for pos in potential_gears:
			var neighbors: Array[FullNumber] = get_neighbor_nums(pos)
			# Remember: get_neighbor_nums can return duplicates!
			var dedupe_map: Dictionary = {}
			for neighbor in neighbors:
				dedupe_map[neighbor.get_id()] = neighbor
			if dedupe_map.size() == 2:
				var deduped_neighbors: Array = dedupe_map.values()
				gears[pos] = Gear.new("*", pos, deduped_neighbors[0].get_num(), deduped_neighbors[1].get_num())
		return gears

	
