extends RigidBody2D


var fuel
var thrust = Vector2(0,-500)
var torque = 20000
var BOOST_FUEL = 0.4
var THRUSTER_FUEL = 0.2

func _ready():
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
        else:
            $Sprite.animation = "default"
            set_applied_force(Vector2())    
    else:
        $Sprite.animation = "default"
        set_applied_force(Vector2())    
        set_applied_torque(0)


    
