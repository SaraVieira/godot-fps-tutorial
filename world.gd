extends Node
@onready var main_menu = $"Lights & Effects/CanvasLayer/main menu"
@onready var address_entry = $"Lights & Effects/CanvasLayer/main menu/MarginContainer/VBoxContainer/Adddress entry"
@onready var hud = $"Lights & Effects/CanvasLayer/HUD"
@onready var health_bar = $"Lights & Effects/CanvasLayer/HUD/health bar"

var Player = preload("res://player.tscn");

const PORT = 7800;
var enet_peer = ENetMultiplayerPeer.new()


func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		

func _on_host_button_pressed():
	main_menu.hide();
	hud.show()
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(multiplayer.get_unique_id())


func _on_join_button_pressed():
	main_menu.hide();
	hud.show()
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer
	
func update_health_bar(health):
	health_bar.value = health;
	

func add_player(peer_id):
	var p = Player.instantiate()
	p.name = str(peer_id)
	add_child(p)
	if(p.is_multiplayer_authority()):
		p.health_changed.connect(update_health_bar)


func _on_multiplayer_spawner_spawned(node):
	if(node.is_multiplayer_authority()):
		node.health_changed.connect(update_health_bar)
