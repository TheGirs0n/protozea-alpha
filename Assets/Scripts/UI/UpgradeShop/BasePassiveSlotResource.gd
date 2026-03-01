extends Resource
class_name BasePassiveSlotResource

@export var passive_slot_name : String
@export var passive_slot_description : String
@export var passive_slot_cost : int
@export var passive_slot_needed_slots_to_upgrade : Dictionary[BasePassiveSlotResource, bool]
@export var passive_slot_reward : BasePassiveSkill
