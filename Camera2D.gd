extends Camera2D

onready var bottomright = $Limits/BottomRight
onready var topleft = $Limits/TopLeft

func _ready():
	limit_top = topleft.position.y
	limit_left = topleft.position.x
	limit_bottom = bottomright.position.y
	limit_right = bottomright.position.x
