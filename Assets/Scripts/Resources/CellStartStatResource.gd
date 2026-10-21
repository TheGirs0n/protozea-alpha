extends Resource
class_name CellStartStatResource

@export_group("Base Cell Stat")
@export var cell_base_strength: int
@export var cell_base_immune: int
@export var cell_base_swiftness: int


## Every stat is rolled between balance.min_stat and max_stat (clamped to the balance range).
static func create_random(balance: CellBalanceConfig, max_stat: int) -> CellStartStatResource:
	var top: int = clampi(max_stat, balance.min_stat, balance.max_stat)
	var resource: CellStartStatResource = CellStartStatResource.new()
	resource.cell_base_strength = randi_range(balance.min_stat, top)
	resource.cell_base_immune = randi_range(balance.min_stat, top)
	resource.cell_base_swiftness = randi_range(balance.min_stat, top)
	return resource
