extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
    # Called every time the node is added to the scene.
    # Initialization here
    pass

func _process(delta):
    if Input.is_action_pressed("ui_accept"):
        run_game()


func _on_PlayButton_pressed():
	run_game()	

			
func run_game():
	get_tree().change_scene("res://Main.tscn")

		