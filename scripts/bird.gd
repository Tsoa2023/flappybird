extends CharacterBody2D

const GRAVITY : int = 1000
const MAX_VEL : int = 600
const FLAP_SPEED : int = -300
var flying : bool = false
var falling : bool = false
const START_POS = Vector2(180, 400)
var is_on_ground = false

func _ready():
	reset()

func reset():
	falling = false
	flying = false
	is_on_ground = false
	position = START_POS
	set_rotation(0)
	
func _physics_process(delta):
	if not is_on_ground:
		if flying or falling:
			velocity.y += GRAVITY * delta

			if velocity.y > MAX_VEL:
				velocity.y = MAX_VEL
			if flying:
				set_rotation(deg_to_rad(velocity.y * 0.05))
				$AnimatedSprite2D.play()
			elif falling:
				set_rotation(PI/2)
				$AnimatedSprite2D.stop()
			move_and_collide(velocity * delta)
		else:
			$AnimatedSprite2D.stop()
	else:
		velocity = Vector2.ZERO
		
func flap():
	if not is_on_ground:
		velocity.y = FLAP_SPEED
