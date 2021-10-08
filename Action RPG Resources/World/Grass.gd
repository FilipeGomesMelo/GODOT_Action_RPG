extends Node2D

const GrassEffect = preload("res://Action RPG Resources/Effects/GrassEffect.tscn")

func create_grass_effect():
	var grass_effect = GrassEffect.instance()
	grass_effect.global_position = global_position
	get_parent().add_child(grass_effect)


func _on_Hurtbox_area_entered(_area):
	create_grass_effect()
	queue_free()
