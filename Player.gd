extends RigidBody2D


var fuel
var thrust = Vector2(0,-500)
var torque = 20000
var crash_sound
var bump_sound
var burn_sound
var BOOST_FUEL = 0.4
var THRUSTER_FUEL = 0.2
var bumping = false
var crashing = false
var landed = false

var BUMP_MIN = 15
var CRASH_MIN = 50

signal crashed
signal landed
signal bump

func _ready():
    crash_sound = $RocketCrashSound
    bump_sound = $RocketThumpSound
    burn_sound = $RocketBurnSound
    fuel = 100

func _process(delta):
    
    if fuel > 0:       
        var rotation_dir = 0.0
        if Input.is_action_pressed("ui_left"):
            fuel -= THRUSTER_FUEL
            rotation_dir -= 0.05
        if Input.is_action_pressed("ui_right"):
            fuel -= THRUSTER_FUEL
            rotation_dir += 0.05
          
        set_applied_torque(rotation_dir * torque)
            
        if Input.is_action_pressed("ui_up"):
            $Sprite.animation = "burn"
            fuel -= BOOST_FUEL
            set_applied_force(thrust.rotated(rotation))
            if not burn_sound.playing:
                burn_sound.play()
        else:
            $Sprite.animation = "default"
            set_applied_force(Vector2())
            burn_sound.stop()  
    else:
        burn_sound.stop()
        $Sprite.animation = "default"
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
        elif body_name == "LandingPad":
            if v < CRASH_MIN and v > BUMP_MIN:
                bumped = true
                landed = true
                if not landed:
                    emit_signal("landed",v)
            elif v > CRASH_MIN:
                crashed = true
                emit_signal("crashed",v)            
            else:   
                if not landed:
                    emit_signal("landed",v)
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
    if not crashed: crashing = false
    
        
