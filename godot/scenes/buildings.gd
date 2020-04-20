extends Node2D

enum { PLAYING, GAME_OVER }

var counter
var count_down_level
var state = PLAYING

onready var explosion_scene = preload("res://scenes/explosion.tscn")

func _ready():
	counter = 1
	state = PLAYING

func new_game():
	counter = 1
	state = PLAYING
	_redisplay()

func new_card():
	counter += 1
	_redisplay()

func game_over():
	count_down_level = int(clamp(log(counter) / log(1.4), 1, 15))
	state = GAME_OVER
	$game_over_timer.start()

func _redisplay():
	var level = int(clamp(log(counter) / log(1.4), 1, 15))
	show_level(level)

func show_level(level):
	var i = 1
	while i <= 15:
		var node = get_node("buildings_%d" % i)
		node.visible = false
		i += 1
	get_node("buildings_%d" % level).visible = true

func _on_game_over_timer_timeout():
	if state != GAME_OVER:
		$game_over_timer.stop()
		return
	count_down_level -= 1
	if count_down_level < 1:
		$game_over_timer.stop()
		return
	show_level(count_down_level)

func _on_timer_timeout():
	var idx = Utils.rng.randi_range(1, 5)
	var pos = get_node("effects/explosions/pos_%d" % idx)
	var explosion = explosion_scene.instance()
	explosion.position = pos.position
	add_child(explosion)
	$effects/explosions/timer.wait_time = Utils.rng.randi_range(10, 25)
