extends Node
@onready var main_menu = $"Lights & Effects/CanvasLayer/main menu"
@onready var address_entry = $"Lights & Effects/CanvasLayer/main menu/MarginContainer/VBoxContainer/Adddress entry"

var Player = preload("res://player.tscn");

const PORT = 9999;
var enet_peer = ENetMultiplayerPeer.new()


func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		

func _on_host_button_pressed():
	main_menu.hide();
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	
	add_player(multiplayer.get_unique_id())


func _on_join_button_pressed():
	pass # Replace with function body.

func add_player(peer_id):
	var p = Player.instantiate()
	p.name = str(peer_id)
	add_child(p)
