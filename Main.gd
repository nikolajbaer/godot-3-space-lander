extends Node

var indicator
var speedometer
var tiltometer
var pad
var player
var start_pos

# TODO
# particle-system thruster / booster
# title screen / Game Over / Restart
# meteors
# 

func _ready():
    indicator = $HUD/FuelIndicator    
    speedometer = $HUD/Speedometer    
    tiltometer = $HUD/Tiltometer
    pad = $LandingPad
    player = $Player
    start_pos = player.position
    $Splash.visible = false
    $Splash/CrashButton.visible = false
    $Splash/LandedButton.visible = false
    init()
    
func init():
    indicator.value = 100
    speedometer.text = "0"
    tiltometer.text = "0"
    player.fuel = player.FUEL_MAX
    player.position = start_pos
    player.rotation = 0
    
    
func _process(delta):
    var fuel = player.fuel_percent()

    indicator.value = fuel
    if fuel < 0.5:
        indicator.add_color_override("font_color",Color(255,255,0))
    elif fuel < 0.25:
        indicator.add_color_override("font_color",Color(255,0,0))
    else:
        indicator.add_color_override("font_color",Color(255,255,255))
        
    var speed = int(player.linear_velocity.length())
    speedometer.text = str(speed)
    if speed > player.CRASH_MIN:
        speedometer.add_color_override("font_color",Color(255,255,0))
    else:
        speedometer.add_color_override("font_color",Color(255,255,255))
    
    tiltometer.text = str(int(rad2deg(player.rotation)))


func _on_Player_crashed(v):
    $Splash.visible = true
    $Splash/CrashButton.visible = true
	
func _on_Player_landed():
    $Splash.visible = true
    $Splash/LandedButton.visible = true


func _on_LandedButton_pressed():
	get_tree().change_scene("res://Title.tscn")


func _on_CrashButton_pressed():
	get_tree().change_scene("res://Title.tscn")
