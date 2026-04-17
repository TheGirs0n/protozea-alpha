extends Node

func create_random() -> CellStartStatResource:
	var resource = CellStartStatResource.new()
	resource.cell_base_strength = randi_range(1, 5)
	resource.cell_base_immune = randi_range(1, 5)
	resource.cell_base_swiftness = randi_range(1, 5)
	return resource
