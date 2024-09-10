extends Node2D

@export var pipe : PackedScene; 
var game_running : bool
var game_over : bool
var scroll
var score
const SCROLL_SPEED : int = 2
var screen_size : Vector2i
var ground_height : int
var new_pipe;
var i = 0;
var coord = [-100, -50, 0, 50, 100];

var pipe_array = [];
func _ready():
	screen_size = get_window().size
	new_game()

func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	reset_pipes()
	create_new_pipe()
	$Bird.reset()
	
func reset_pipes():
	for pipe in pipe_array:
		pipe.queue_free()
	pipe_array.clear()

func _input(event):
	if game_over == false:
		if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed) or Input.is_action_just_pressed("ui_accept"):
			if game_running == false:
				start_game()
			else:
				if $Bird.flying:
					$Bird.flap()
					check_top()

func start_game():
	game_running = true
	$Bird.flying = true
	$Bird.flap()
	$Timer.start()

func create_new_pipe():
	new_pipe = pipe.instantiate();
	new_pipe.position.x = 400
	new_pipe.position.y = coord[randi() % 5]
	new_pipe.hit.connect(bird_hit)
	add_child(new_pipe)
	pipe_array.append(new_pipe)
	
func check_top():
	if $Bird.position.y < 0:
		$Bird.falling = true
		stop_game()

func bird_hit():
	stop_game()

func stop_game():
	$Timer.stop()
	$Bird.flying = false
	
	$Bird.falling = true
	game_running = false
	game_over = true
	print("GAME OVER\n")
	


	
	
func _process(delta: float) -> void:
	if game_running:
		for pipe in pipe_array:
			pipe.position.x -= SCROLL_SPEED
		scroll += SCROLL_SPEED
		if scroll >= screen_size.x:
			scroll = 0
		$Ground.position.x = -scroll
		$Ground2.position.x = -scroll + screen_size.x
		

func _on_timer_timeout() -> void:
	create_new_pipe();
