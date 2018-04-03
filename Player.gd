extends RigidBody2D


var fuel
var thrust = Vector2(0,-500)
var torque = 20000
var crash_sound
var bump_sound
var burn_sound
var BOOST_FUEL = 0.4
var THRUSTER_FUEL = 0.2
var FUEL_MAX = 150
var bumping = false
var crashing = false
var landing = false
var landed = false
var starting_y

var BUMP_MIN = 15
var CRASH_MIN = 50
var engine
var lthrust
var rthrust
var camera
var screen_height

signal crashed
signal landed
signal bump

func _ready():
    crash_sound = $RocketCrashSound
    bump_sound = $RocketThumpSound
    burn_sound = $RocketBurnSound
    engine = $Engine
    camera = $Camera2D
    lthrust = $LeftThruster
    rthrust = $RightThruster
    fuel = FUEL_MAX
    starting_y = position.y
    screen_height = camera.get_viewport().size.y

func altitude():
	return floor(abs(position.y - starting_y))

func adjust_zoom():
	if crashing: return
	var v_y = camera.get_viewport().size.y
	var z = 1 + ((altitude()*2) / v_y)
	if z > 1:
		camera.zoom = Vector2(z,z)
	else:
		camera.zoom = Vector2(1,1)

func fuel_percent():
    return (self.fuel / FUEL_MAX) * 100
    
func _process(delta):
    
    if fuel > 0 and not landed:       
        var rotation_dir = 0.0
        if Input.is_action_pressed("ui_left"):
            rthrust.emitting = true
            fuel -= THRUSTER_FUEL
            rotation_dir -= 0.05
        else:
            rthrust.emitting = false
        if Input.is_action_pressed("ui_right"):
            fuel -= THRUSTER_FUEL
            rotation_dir += 0.05
            lthrust.emitting = true
        else:
            lthrust.emitting = false
          
        set_applied_torque(rotation_dir * torque)
            
        if Input.is_action_pressed("ui_up"):
            engine.emitting = true
            fuel -= BOOST_FUEL
            set_applied_force(thrust.rotated(rotation))
            if not burn_sound.playing:
                burn_sound.play()
        else:
            engine.emitting = false
            set_applied_force(Vector2())
            burn_sound.stop()  
    else:
        burn_sound.stop()
        engine.emitting = false
        lthrust.emitting = false
        rthrust.emitting = false
        set_applied_force(Vector2())    
        set_applied_torque(0)  

func play_crash():
    if not (crash_sound.playing and crash_sound.get_playback_position() < 0.5):
        crash_sound.play() 

func play_bump():
    if not (bump_sound.playing and bump_sound.get_playback_position() < 0.1):
        bump_sound.play() 


func _physics_process(delta):
    var bodies = get_colliding_bodies()
    var v = self.linear_velocity.length()    

    var crashed = false
    var bumped = false
    for b in bodies:
        var body_name = b.get_name()
        if body_name == "Surface":
            if v > CRASH_MIN:
                emit_signal("crashed",v)
                crashed = true
            elif v > BUMP_MIN:
                emit_signal("bumped",v) # TODO dust
                bumped = true

    if landing and v < 1 and angular_velocity < 1 and abs(rotation_degrees) < 5 and not crashing and not crashed:
        landed = true
        emit_signal("landed")

    if position.y > screen_height:
        crashed = true
        emit_signal("crashed",v)

    # if we crash this step, and aren't already crashing
    # play the sound
    if crashed and not crashing:
        crashing = true
        play_crash()
    # likewise if we bumped this step and didn't already have our bump
    # play the bump sound
    if bumped and not bumping:
        bumping = true
        if not crashing: play_bump()
    if not bumped: bumping = false

    
        


func _on_LandingPad_body_entered(body):
    if landed: return
    if body.get_name() != "Player": return
    landing = true
