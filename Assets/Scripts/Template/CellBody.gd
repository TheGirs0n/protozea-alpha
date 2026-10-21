@abstract
extends CharacterBody2D
class_name CellBody

## A cell that moves and has an animated sprite. Cells with stats and battles extend BaseCell.

@export_group("Components")
@export var cell_movement_component: BaseCellMovementComponent
@export var cell_animated_sprite_component: BaseCellAnimatedSprite
