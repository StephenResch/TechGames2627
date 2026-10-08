extends CanvasLayer

const LEVEL_CLEAR_SCENE = preload("res://level_complete_scene.tscn")

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _on_health_upgrade_button_pressed() -> void:
	show_level_complete()

func _on_damage_upgrade_button_pressed() -> void:
	show_level_complete()

func show_level_complete():
	queue_free()
	
	var level_clear = LEVEL_CLEAR_SCENE.instantiate()
	get_parent().add_child(level_clear)  
