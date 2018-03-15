extends Node

var indicator
var speedometer
var tiltometer
var pad
var player
var start_pos

func _ready():
    indicator = $HUD/FuelIndicator    
    speedometer = $HUD/Speedometer    
    tiltometer = $HUD/Tiltometer
    pad = $LandingPad
    player = $Player
    start_pos = player.position
    init()
    
func init():
    indicator.value = 100
    speedometer.text = "0"
    tiltometer.text = "0"
    player.fuel = 100
    player.position = start_pos
    player.rotation = 0
    
    
func _process(delta):
    var fuel = $Player.fuel
    #if fuel < 50:

    indicator.value = player.fuel
    speedometer.text = str(int(player.linear_velocity.length()))
    tiltometer.text = str(int(rad2deg(player.rotation)))

# TODO probably should check get_colliding_bodies, and when all has settled, declare a landing
func _on_LandingPad_body_entered(body):
    if body.get_name() == "Player" and body.linear_velocity.length() < 10 and abs(deg2rad(body.rotation)) < 5:
        $HUD/Message.text = "LANDED!"



func _on_Ground_body_entered(body):
     if body.get_name() == "Player" and body.linear_velocity.length() > 100:
        $HUD/Message.text = "CRASHED!"

