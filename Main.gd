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

    indicator.value = player.fuel
    speedometer.text = str(int(player.linear_velocity.length()))
    tiltometer.text = str(int(rad2deg(player.rotation)))


func _on_Player_crashed(v):
    $HUD/Message.text = "CRASHED at %0.0f!"%v

func _on_Player_landed(v):
    $HUD/Message.text = "LANDED!"
