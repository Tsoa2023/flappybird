extends Node2D

@export var pipe : PackedScene; 
var game_running : bool
var game_over : bool
var scroll
var score
const SCROLL_SPEED : int = 2
const SCROLL_SPEED_GROUND : int = 3.5
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
	$ScoreLabel.text = "SCORE: " + str(score)
	$GameOver.hide()
	get_tree().call_group("pipes", "queue_free")
	pipe_array.clear()
	scroll = 0
	create_new_pipe()
	$Bird.reset()
	

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
	$GameOver.hide()
	$Bird.flying = true
	$Bird.flap()
	$Timer.start()

func create_new_pipe():
	var pipes_to_remove = []
	for pipe in pipe_array:
		if is_instance_valid(pipe) and pipe.position.x < -100:
			pipes_to_remove.append(pipe)
	for pipe in pipes_to_remove:
		remove_pipe(pipe)	 
	new_pipe = pipe.instantiate();
	new_pipe.position.x = 400
	new_pipe.position.y = coord[randi() % 5]
	new_pipe.hit.connect(bird_hit)
	new_pipe.scored.connect(scored)
	add_child(new_pipe)
	pipe_array.append(new_pipe)
	
func remove_pipe(pipe):
	if pipe in pipe_array:
		pipe_array.erase(pipe)
	pipe.queue_free()
	
func scored():
	score  +=  1
	$ScoreLabel.text = "SCORE: " + str(score)
func check_top():
	if $Bird.position.y < 0:
		$Bird.falling = true
		stop_game()

func bird_hit():
	$Bird.falling = true
	stop_game()

func stop_game():
	$Timer.stop()
	$Bird.flying = false
	$GameOver.show()
	game_running = false
	game_over = true
	print("GAME OVER\n")
	


	
	
func _process(delta: float) -> void:
	if game_running:
		var pipes_to_remove = []
		for pipe in pipe_array:
			if is_instance_valid(pipe):
				pipe.position.x -= SCROLL_SPEED
			else:
				pipes_to_remove.append(pipe)
		
		# Supprimez les tuyaux invalides du tableau
		for pipe in pipes_to_remove:
			pipe_array.erase(pipe)

		scroll += SCROLL_SPEED_GROUND
		if scroll >= screen_size.x:
			scroll = 0
		$Ground.position.x = -scroll
		$Ground2.position.x = -scroll + screen_size.x
		
func sleep(seconds):
	await get_tree().create_timer(seconds).timeout

			

func _on_timer_timeout() -> void:
	create_new_pipe();

func _on_ground_hit() -> void:
	$Bird.falling = true
	$Bird.is_on_ground = true
	stop_game()
	

func _on_ground_2_hit() -> void:
	$Bird.falling = true
	$Bird.is_on_ground = true
	stop_game()


func _on_game_over_restart() -> void:
	new_game()
