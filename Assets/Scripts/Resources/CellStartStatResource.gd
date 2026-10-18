extends Resource
class_name CellStartStatResource

@export_group("Base Cell Stat")
@export var cell_base_strength: int
@export var cell_base_immune: int
@export var cell_base_swiftness: int


static func create_random(balance: CellBalanceConfig) -> CellStartStatResource:
	var resource: CellStartStatResource = CellStartStatResource.new()
	resource.cell_base_strength = randi_range(balance.min_stat, balance.max_stat)
	resource.cell_base_immune = randi_range(balance.min_stat, balance.max_stat)
	resource.cell_base_swiftness = randi_range(balance.min_stat, balance.max_stat)
	return resource
