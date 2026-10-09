extends CanvasLayer

const LEVEL_CLEAR_SCENE = preload("res://level_complete_scene.tscn")

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _on_health_upgrade_button_pressed() -> void:
	var player = get_parent().get_node("Player")
	player.max_health += 20
	player.health = player.max_health  # Full heal
	print("Health upgraded! New max health: ", player.max_health)
	show_level_complete()

func _on_damage_upgrade_button_pressed() -> void:
	var player = get_parent().get_node("Player")
	player.heavy_melee_damage += 5
	player.light_melee_damage += 5
	player.heavy_ranged_damage += 5
	player.light_ranged_damage += 5
	print("Damage upgraded! New damages: HM=", player.heavy_melee_damage, 
		  " LM=", player.light_melee_damage,
		  " HR=", player.heavy_ranged_damage,
		  " LR=", player.light_ranged_damage)
	show_level_complete()

func show_level_complete():
	queue_free()
	
	var level_clear = LEVEL_CLEAR_SCENE.instantiate()
	get_parent().add_child(level_clear)  
