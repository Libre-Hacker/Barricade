extends CanvasLayer

enum lobby_status{Private, Friends, Public, Invisible}
enum search_distance{Close, Default, Far, Worldwide}

export (Resource) var clickSound

onready var steamName = get_node("SteamName")
onready var lobbyChat = get_node("Chat/RichTextLabel")
onready var playerCount = get_node("Players/Label")
onready var playerList = get_node("Players/RichTextLabel")
onready var chatInput = get_node("SendMessageButton/TextEdit")
onready var hostButton = get_node("HostButton")
onready var leaveLobbyButton = get_node("LeaveLobbyButton")
onready var mainMenuButton = get_node("MainMenuButton")
onready var findGameButton = get_node("FindGameButton")
onready var findPlayersButton = get_node("FindPlayersButton")
onready var inviteFriendsButton = get_node("InviteFriends")
onready var searchingSprite = get_node("SearchingSprite")
onready var cancelSearchButton = get_node("CancelSearchButton")
onready var startGameButton = get_node("StartGameButton")

func _ready():
	steamName.text = SteamGlobals.STEAM_NAME
	
	Steam.connect("lobby_created", self, "_on_lobby_created")
	Steam.connect("lobby_match_list", self, "_on_lobby_match_list")
	Steam.connect("lobby_joined", self, "_on_lobby_joined")
	Steam.connect("lobby_chat_update", self, "_on_lobby_chat_update")
	Steam.connect("lobby_message", self, "_on_lobby_message")
	Steam.connect("lobby_data_update", self, "_on_lobby_data_update")
	Steam.connect("join_requested", self, "_on_lobby_join_requested")
	check_command_line()

func _input(event):
	if(Input.is_action_just_pressed("ui_accept")):
		get_tree().set_input_as_handled()
		send_chat_message()


func display_message(message):
	lobbyChat.add_text("\n" + str(message))

func create_lobby():
	Network.create_server()
	if(SteamGlobals.LOBBY_ID == 0):
		Steam.createLobby(lobby_status.Private, 3)

func _on_lobby_created(connect, lobbyID):
	if(connect == 1):
		SteamGlobals.LOBBY_ID = lobbyID
		Steam.setLobbyGameServer(SteamGlobals.LOBBY_ID, Network.IP_ADDRESS, Network.DEFAULT_PORT, 0)
		display_message("Created lobby: " + str(lobbyID))
		hostButton.hide()
		mainMenuButton.hide()
		findGameButton.hide()
		findPlayersButton.show()
		inviteFriendsButton.show()
		leaveLobbyButton.show()
		startGameButton.show()


func join_lobby(lobbyID):
	display_message("Joining lobby " + str(lobbyID) + "...")
	SteamGlobals.LOBBY_MEMBERS.clear()
	Steam.joinLobby(lobbyID)
	Network.join_server(Steam.getLobbyGameServer(lobbyID)['ip'])
	hostButton.hide()
	findGameButton.hide()
	mainMenuButton.hide()
	leaveLobbyButton.show()
	inviteFriendsButton.show()


func _on_lobby_joined(lobbyID, permissions, locked, response):
	SteamGlobals.LOBBY_ID = lobbyID
	get_lobby_members()

func leave_lobby():
	if(SteamGlobals.LOBBY_ID == 0):
		return
	
	display_message("Leaving Lobby...")
	Steam.leaveLobby(SteamGlobals.LOBBY_ID)
	SteamGlobals.LOBBY_ID = 0
	playerCount.text = "Players (0)"
	playerList.clear()
	leaveLobbyButton.hide()
	findPlayersButton.hide()
	inviteFriendsButton.hide()
	searchingSprite.hide()
	mainMenuButton.show()
	hostButton.show()
	findGameButton.show()
	
	for members in SteamGlobals.LOBBY_MEMBERS:
		Steam.closeP2PSessionWithUser(members['steamID'])
	
	SteamGlobals.LOBBY_MEMBERS.clear()

func get_lobby_members():
	SteamGlobals.LOBBY_MEMBERS.clear()
	var memberCount = Steam.getNumLobbyMembers(SteamGlobals.LOBBY_ID)
	playerCount.set_text("Players (" + str(memberCount) + ")")
	for member in range(0,memberCount):
		var memberSteamID = Steam.getLobbyMemberByIndex(SteamGlobals.LOBBY_ID, member)
		var memberSteamName = Steam.getFriendPersonaName(memberSteamID)
		add_player_list(memberSteamID, memberSteamName)


func add_player_list(steamID, steamName):
	SteamGlobals.LOBBY_MEMBERS.append({"steamID":steamID, "steamName":steamName})
	playerList.clear()
	for member in SteamGlobals.LOBBY_MEMBERS:
		playerList.add_text(str(member['steamName']) + "\n")


func send_chat_message():
	var message = chatInput.text
	if(message.empty()):
		return
	var sent = Steam.sendLobbyChatMsg(SteamGlobals.LOBBY_ID, message)
	if(sent == false):
		display_message("ERROR: Chat message failed to send.")
	chatInput.text = ""

func check_command_line():
	var ARGUMENTS = OS.get_cmdline_args()
	
	if(ARGUMENTS.size() > 0):
		for argument in ARGUMENTS:
			if(SteamGlobals.LOBBY_INVITE_ARG):
				join_lobby(int(argument))
				pass


func _on_lobby_message(result, user, message, type):
	var sender = Steam.getFriendPersonaName(user)
	display_message(str(sender) + " : " + str(message))

func _on_lobby_chat_update(lobbyID, changedID, makingChangeID, chatState):
	var changer = Steam.getFriendPersonaName(makingChangeID)
	
	if(chatState == 1):
		display_message(str(changer) + " has joined the lobby.")
	if(chatState == 2):
		display_message(str(changer) + " has left the lobby.")
	if(chatState == 8):
		display_message(str(changer) + " has been kicked from the lobby.")

	get_lobby_members()

func _on_MainMenu_pressed():
	AudioManager.new_sound(clickSound)
	MenuSwitcher.load_scene("res://assets/scenes/MainMenu.tscn")



func _on_HostButton_pressed():
	AudioManager.new_sound(clickSound)
	create_lobby()


func _on_FindGameButton_pressed():
	AudioManager.new_sound(clickSound)
	display_message("Searching for lobbies...")
	Steam.requestLobbyList()

func _on_lobby_match_list(lobbies):
	if(lobbies.empty()):
		display_message("No lobbies available, creating a lobby instead.")
		create_lobby()
		return
	join_lobby(lobbies[0])
	startGameButton.hide()


func _on_SendMessageButton_pressed():
	AudioManager.new_sound(clickSound)
	send_chat_message()


func _on_LeaveLobbyButton_pressed():
	AudioManager.new_sound(clickSound)
	leave_lobby()


func _on_FindPlayersButton_pressed():
	AudioManager.new_sound(clickSound)
	Steam.setLobbyType(SteamGlobals.LOBBY_ID, lobby_status.Public)
	findPlayersButton.hide()
	cancelSearchButton.show()
	searchingSprite.show()


func _on_CancelSearchButton_pressed():
	AudioManager.new_sound(clickSound)
	Steam.setLobbyType(SteamGlobals.LOBBY_ID, lobby_status.Private)
	searchingSprite.hide()
	cancelSearchButton.hide()
	findPlayersButton.show()


func _on_StartGameButton_pressed():
	AudioManager.new_sound(clickSound)
	GameManager.rpc("start_game")
