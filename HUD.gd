extends Control

var coin = 0

func _ready():
	$Coins.text = String(coin)
	

# warning-ignore:unused_argument
func _physics_process(delta):
	if coin == 4:
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://WORLD.tscn")

func _on_coin_collected():
	coin = coin + 1
	_ready()
