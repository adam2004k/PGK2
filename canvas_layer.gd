extends CanvasLayer

@onready var hp_label = $PanelContainer/HBoxContainer/HPLabel
@onready var ammo_label = $PanelContainer/HBoxContainer/AmmoLabel

var player = null
func _ready():
	player = get_tree().get_first_node_in_group("player")


func _process(delta):
	if player:
		hp_label.text = "HP: " + str(player.hp)
		ammo_label.text = "Ammo: " + str(player.ammo)
		
