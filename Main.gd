extends Node

var indicator
var speedometer
var tiltometer
var altimeter
var pad
var player
var start_pos
var game_over
# TODO
# particle-system thruster / booster
# title screen / Game Over / Restart
# meteors
# 

func _ready():
    game_over = false
    indicator = $HUDLayer/HUD/FuelIndicator    
    speedometer = $HUDLayer/HUD/Speedometer    
    tiltometer = $HUDLayer/HUD/Tiltometer
    altimeter = $HUDLayer/HUD/Altimeter
    pad = $LandingPad
    player = $Player
    start_pos = player.position
    $HUDLayer/Splash.visible = false
    $HUDLayer/Splash/CrashButton.visible = false
    $HUDLayer/Splash/LandedButton.visible = false
    init()
    
func init():
    indicator.value = 100
    speedometer.text = "0"
    tiltometer.text = "0"
    player.fuel = player.FUEL_MAX
    player.position = start_pos
    player.rotation = 0
    
    
func _process(delta):
    if game_over and Input.is_action_pressed("ui_space"):
        new_game()
    
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

    altimeter.text = str(player.altitude())

    player.adjust_zoom()

  

func _on_Player_crashed(v):
    if game_over: return
    game_over = true
    $HUDLayer/Splash.visible = true
    $HUDLayer/Splash/CrashButton.visible = true
	
func _on_Player_landed():
    if game_over: return
    game_over = true
    $HUDLayer/Splash.visible = true
    $HUDLayer/Splash/LandedButton.visible = true

func new_game():
	get_tree().change_scene("res://Main.tscn")

func _on_LandedButton_pressed():
	new_game()

func _on_CrashButton_pressed():
	new_game()
