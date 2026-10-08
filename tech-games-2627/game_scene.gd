extends Node

signal player_attacked(damage)
signal level_count_changed(count)

@export var available_levels: Array[PackedScene]
@export var basic_enemy_scene: PackedScene
@export var ranged_enemy_scene: PackedScene
const GAME_OVER_SCENE = preload("res://game_over_scene.tscn")
const CHEST_SELECTION_SCENE = preload("res://chest_selection_scene.tscn")
var loaded_enemies = []
var enemy_health
var levels_completed = 0
var current_level = null


# Called when the node enters the scene tree for the first time.
func _ready():
	load_random_level()

func load_random_level():
	var random_level = available_levels.pick_random()
	print("Selected level: ", random_level.resource_path)
	var level_instance = random_level.instantiate()
	add_child(level_instance)
	current_level = level_instance
	var enemies = get_tree().get_nodes_in_group("enemies")
	
	for enemy in enemies:
		if enemy.has_signal("player_hit"):
			enemy.player_hit.connect(_on_enemy_player_hit)
		if enemy.has_signal("ranged_attack"):
			enemy.ranged_attack.connect(_on_ranged_enemy_ranged_attack)
		enemy.collidables.append($Player)
		loaded_enemies.append(enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_enemy_player_hit(damage):
	player_attacked.emit(damage)


func _on_ranged_enemy_ranged_attack(Bullet, direction, location, bullet_damage):
	var spawned_bullet = Bullet.instantiate()
	add_child(spawned_bullet)
	spawned_bullet.direction = direction
	spawned_bullet.position = location
	spawned_bullet.bullet_damage = bullet_damage
	spawned_bullet.player_hit.connect(_on_enemy_player_hit)


func _on_player_player_position(position):
	for enemy in loaded_enemies:
		enemy.player_position = position


func _on_player_player_melee_attack(in_range_enemies, player_damage):
	for enemy in loaded_enemies:
		if in_range_enemies.has(enemy):
			enemy_health = enemy.health - player_damage
			enemy.health -= player_damage
			print("Enemy Health: ", enemy_health)
			if enemy_health <= 0:
					loaded_enemies.erase(enemy)
					if loaded_enemies.is_empty():
						_on_level_clear()

func _on_bullet_enemy_hit(hit_enemy, bullet_damage):
	for enemy in loaded_enemies:
		if hit_enemy == enemy:
			enemy_health = enemy.health - bullet_damage
			enemy.health -= bullet_damage
			print("Enemy Health: ", enemy_health)
			if enemy_health <= 0:
					loaded_enemies.erase(enemy)
					if loaded_enemies.is_empty():
						_on_level_clear()

func _on_player_player_death():
	var game_over = GAME_OVER_SCENE.instantiate()
	get_tree().root.add_child(game_over)
	queue_free()


func _on_player_shoot_blaster(Bullet, direction, location, bullet_damage):
	var spawned_bullet = Bullet.instantiate()
	add_child(spawned_bullet)
	spawned_bullet.direction = direction
	spawned_bullet.position = location
	spawned_bullet.bullet_damage = bullet_damage
	spawned_bullet.enemy_hit.connect(_on_bullet_enemy_hit)

func _on_level_clear():
	levels_completed += 1 
	level_count_changed.emit(levels_completed)
	var level_clear = CHEST_SELECTION_SCENE.instantiate()
	add_child(level_clear)  
	$Player.get_node("HUD").visible = false
	get_tree().paused = true 
	
func load_next_level():
	loaded_enemies.clear()
	
	if current_level:
		current_level.queue_free()
		current_level = null
	
	$Player.get_node("HUD").visible = true
	
	await get_tree().process_frame
	
	load_random_level()  


func _on_pause_menu_scene_pause_change(pause_state):
	if pause_state:
		$Player.get_node("HUD").visible = true
	else:
		$Player.get_node("HUD").visible = false
