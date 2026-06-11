extends Node2D

const API_BASE := "http://127.0.0.1:8000"
const WALK_SPEED := 260.0
const PLAYER_SCALE := Vector2(0.12, 0.12)
const NPC_SCALE := Vector2(0.105, 0.105)
const MAP_SIZE := Vector2(1536, 1024)
const SAVE_PATH := "user://agent_town_save.json"
const BUILDING_REGISTRY_PATH := "res://data/buildings.json"
const AGENT_REGISTRY_PATH := "res://data/agents.json"
const WORKSPACE_REGISTRY_PATH := "res://data/workspaces.json"
const QUEST_REGISTRY_PATH := "res://data/quests.json"
const NPC_QUEST_REGISTRY_PATH := "res://data/npc_quests.json"
const DISTRICT_REGISTRY_PATH := "res://data/districts.json"
const ROOM_SCENE_REGISTRY_PATH := "res://data/room_scenes.json"
const MAP_DECOR_REGISTRY_PATH := "res://data/map_decor.json"
const ACTIVITY_LOG_LIMIT := 8
const COLOR_INK := Color("#2f2418")
const COLOR_PARCHMENT := Color("#fff3d8")
const COLOR_PARCHMENT_DARK := Color("#ead4a5")
const COLOR_WOOD := Color("#8b5e34")
const COLOR_GOLD := Color("#d9a441")
const COLOR_MAGIC_BLUE := Color("#7dbbe8")
const COLOR_SOFT_GREEN := Color("#9fc7a4")

var player: Sprite2D
var camera: Camera2D
var target_position := Vector2(768, 620)
var agents := {}
var agent_nodes := {}
var building_nodes := {}
var district_nodes := {}
var map_decor_nodes := {}
var active_agent_id := ""
var active_building_id := ""
var active_district_id := "central-plaza"
var active_waypoint_id := ""
var active_waypoint_title := ""
var active_waypoint_hint := ""
var active_waypoint_pos := Vector2.ZERO
var pending_request := ""

var hud: CanvasLayer
var status_label: Label
var waypoint_panel: PanelContainer
var waypoint_body: RichTextLabel
var activity_panel: PanelContainer
var activity_body: RichTextLabel
var detail_title: Label
var detail_body: RichTextLabel
var dialogue_input: LineEdit
var dialogue_button: Button
var action_button: Button
var room_button: Button
var quest_list: VBoxContainer
var quest_body: RichTextLabel
var daily_routes_button: Button
var daily_claim_button: Button
var daily_next_button: Button
var collection_codex_button: Button
var room_overlay: PanelContainer
var room_title: Label
var room_stage: Control
var room_body: RichTextLabel
var desktop_test_button: Button
var room_capability_atlas_button: Button
var room_capability_next_button: Button
var room_capability_open_button: Button
var room_workflow_routes_button: Button
var room_workflow_next_button: Button
var room_workflow_open_button: Button
var room_scan_button: Button
var room_review_button: Button
var room_memory_button: Button
var room_memory_detail_button: Button
var room_memory_proposal_button: Button
var room_memory_promote_button: Button
var room_knowledge_button: Button
var room_knowledge_refresh_button: Button
var room_knowledge_search_button: Button
var room_knowledge_detail_button: Button
var room_file_roots_button: Button
var room_file_index_button: Button
var room_file_organize_audit_button: Button
var room_file_search_button: Button
var room_file_tag_button: Button
var room_file_open_button: Button
var room_file_reveal_button: Button
var room_file_preview_button: Button
var room_file_organize_button: Button
var room_research_button: Button
var room_project_detail_button: Button
var room_research_agent_button: Button
var room_research_log_button: Button
var room_agent_button: Button
var room_dispatch_button: Button
var room_agent_runner_button: Button
var room_agent_runner_preview_button: Button
var room_agent_runner_launch_button: Button
var room_agent_chat_button: Button
var room_agent_chat_send_button: Button
var room_agent_chat_tool_button: Button
var room_agent_tasks_button: Button
var room_agent_task_policy_button: Button
var room_agent_task_logs_button: Button
var room_agent_task_submit_button: Button
var room_agent_task_next_button: Button
var room_agent_task_open_button: Button
var room_agent_task_events_button: Button
var room_agent_task_pause_button: Button
var room_agent_task_cancel_button: Button
var room_agent_task_resume_button: Button
var room_agent_tools_button: Button
var room_agent_tool_run_button: Button
var room_agent_tool_next_button: Button
var room_agent_tool_open_button: Button
var room_agent_tool_events_button: Button
var room_agent_tool_logs_button: Button
var room_agent_companion_button: Button
var room_project_browser_button: Button
var room_local_project_detail_button: Button
var room_code_task_button: Button
var room_code_context_button: Button
var room_code_patch_plan_button: Button
var room_code_agent_button: Button
var room_code_explain_button: Button
var room_code_verify_button: Button
var room_code_check_job_button: Button
var room_harbor_button: Button
var room_harbor_detail_button: Button
var room_harbor_github_button: Button
var room_harbor_readiness_button: Button
var room_harbor_draft_button: Button
var room_harbor_publish_plan_button: Button
var room_terminal_button: Button
var room_terminal_preview_button: Button
var room_terminal_run_button: Button
var room_terminal_next_log_button: Button
var room_terminal_open_log_button: Button
var room_system_button: Button
var room_jobs_button: Button
var room_job_cancel_button: Button
var room_job_log_button: Button
var room_job_events_button: Button
var room_events_button: Button
var room_model_button: Button
var room_model_profiles_button: Button
var room_model_config_button: Button
var room_model_test_button: Button
var room_model_key_vault_button: Button
var room_task_board_button: Button
var room_create_task_button: Button
var room_task_next_button: Button
var room_task_open_button: Button
var room_task_agent_button: Button
var room_task_doing_button: Button
var room_task_done_button: Button
var room_writing_button: Button
var room_new_draft_button: Button
var room_automation_button: Button
var room_automation_scheduler_button: Button
var room_automation_draft_button: Button
var room_permission_button: Button
var room_permission_secret_button: Button
var room_settings_button: Button
var room_registry_health_button: Button
var room_settings_draft_button: Button
var room_testing_button: Button
var room_test_plan_button: Button
var room_vertical_proof_button: Button
var room_next_proof_button: Button
var room_open_proof_button: Button
var room_bug_button: Button
var room_bug_report_button: Button
var room_project_management_button: Button
var room_project_brief_button: Button
var room_download_button: Button
var room_download_triage_button: Button
var room_download_intake_button: Button
var room_asset_button: Button
var room_asset_inspect_button: Button
var room_asset_note_button: Button
var room_office_button: Button
var room_office_note_button: Button
var room_schedule_button: Button
var room_schedule_draft_button: Button
var room_learning_button: Button
var room_learning_plan_button: Button
var room_language_button: Button
var room_language_practice_button: Button
var room_research_data_button: Button
var room_research_data_note_button: Button
var room_paper_reading_button: Button
var room_paper_citation_button: Button
var room_paper_note_button: Button
var room_paper_citation_note_button: Button
var room_paper_extract_button: Button
var room_paper_extract_job_button: Button
var room_release_button: Button
var room_release_checklist_button: Button
var room_release_report_button: Button
var room_plugin_button: Button
var room_plugin_manifest_button: Button
var room_plugin_draft_button: Button
var room_plugin_activation_button: Button
var room_backup_button: Button
var room_backup_check_button: Button
var room_backup_plan_button: Button
var room_goal_button: Button
var room_goal_draft_button: Button
var room_inspiration_button: Button
var room_inspiration_note_button: Button
var room_temp_drafts_button: Button
var room_temp_draft_button: Button
var room_draft_button: Button
var room_save_draft_button: Button
var room_leave_button: Button
var badge_body: RichTextLabel
var http: HTTPRequest
var quest_http: HTTPRequest
var daily_http: HTTPRequest
var collection_http: HTTPRequest
var action_http: HTTPRequest
var room_http: HTTPRequest
var file_http: HTTPRequest
var research_http: HTTPRequest
var memory_http: HTTPRequest
var knowledge_http: HTTPRequest
var agent_hub_http: HTTPRequest
var agent_task_http: HTTPRequest
var agent_tool_http: HTTPRequest
var project_http: HTTPRequest
var harbor_http: HTTPRequest
var terminal_http: HTTPRequest
var system_http: HTTPRequest
var town_http: HTTPRequest
var model_http: HTTPRequest
var task_http: HTTPRequest
var writing_http: HTTPRequest
var automation_http: HTTPRequest
var permission_http: HTTPRequest
var settings_http: HTTPRequest
var testing_http: HTTPRequest
var bug_http: HTTPRequest
var management_http: HTTPRequest
var download_http: HTTPRequest
var asset_http: HTTPRequest
var office_http: HTTPRequest
var schedule_http: HTTPRequest
var learning_http: HTTPRequest
var language_http: HTTPRequest
var research_data_http: HTTPRequest
var paper_reading_http: HTTPRequest
var release_http: HTTPRequest
var plugin_http: HTTPRequest
var backup_http: HTTPRequest
var goal_http: HTTPRequest
var inspiration_http: HTTPRequest
var temp_draft_http: HTTPRequest
var quest_defs := {}
var accepted_quests := {}
var completed_quests := {}
var quest_steps := {}
var earned_badges := {}
var daily_routes := {}
var daily_route_claims := {}
var active_daily_route_id := ""
var daily_route_date := ""
var room_mastery := {}
var npc_chain_progress := {}
var activity_log := []
var companion_roster := {}
var active_companion_id := ""
var selected_agent_roster_id := ""
var last_agent_chat_tool_suggestions := []
var pending_draft_confirmation := ""
var current_room_id := "town"
var agent_task_cards := []
var selected_agent_task_id := ""
var selected_agent_task_index := 0
var agent_task_pending_action := ""
var selected_agent_task_event_cursor := 0
var selected_agent_runner_handoff_path := ""
var agent_tool_invocation_cards := []
var selected_agent_tool_invocation_id := ""
var selected_agent_tool_invocation_index := 0
var selected_agent_tool_event_cursor := 0
var selected_knowledge_doc_id := ""
var selected_memory_category := ""
var selected_memory_filename := ""
var selected_memory_proposal_id := ""
var pending_memory_promotion_confirmation := ""
var selected_file_root_id := ""
var selected_file_path := ""
var selected_file_kind := ""
var research_project_ids := []
var selected_research_project_id := ""
var selected_project_id := ""
var selected_project_job_id := ""
var pending_project_verification_confirmation := false
var selected_harbor_repo_id := ""
var selected_paper_root_id := ""
var selected_paper_relative_path := ""
var selected_paper_job_id := ""
var current_agent_chat_id := ""
var selected_terminal_command_id := ""
var selected_terminal_job_id := ""
var system_job_cards := []
var selected_system_job_id := ""
var selected_system_job_log_id := ""
var selected_system_job_event_cursor := 0
var terminal_confirmation_required := ""
var terminal_log_cards := []
var selected_terminal_log_index := -1
var vertical_proof_cards := []
var selected_vertical_proof_index := -1
var selected_vertical_proof_id := ""
var local_task_cards := []
var selected_task_id := ""
var selected_task_index := 0
var town_capability_cards := []
var selected_town_capability_id := ""
var selected_town_capability_index := 0
var town_workflow_cards := []
var selected_town_workflow_id := ""
var selected_town_workflow_index := 0
var workflow_route_claims := {}
var capture_smoke_mode := false
var desktop_ui_test_mode := false

var fallback_building_defs := [
	{"id": "memory-library", "name": "Memory Library", "role": "agentmemory and shared decisions", "pos": Vector2(360, 330), "size": Vector2(180, 120), "color": Color("#dcd6f7")},
	{"id": "skill-workshop", "name": "Skill Workshop", "role": "local skills and workflows", "pos": Vector2(650, 310), "size": Vector2(190, 120), "color": Color("#ffeaa7")},
	{"id": "knowledge-tower", "name": "Knowledge Tower", "role": "knowledge base and research wiki", "pos": Vector2(970, 285), "size": Vector2(190, 140), "color": Color("#a8d8ea")},
	{"id": "devtools-lab", "name": "Devtools Lab", "role": "local CLIs and development tools", "pos": Vector2(420, 560), "size": Vector2(185, 120), "color": Color("#a8e6cf")},
	{"id": "code-workshop", "name": "Code Workshop", "role": "local software projects and Git status", "pos": Vector2(545, 690), "size": Vector2(190, 112), "color": Color("#b8d8ff")},
	{"id": "github-harbor", "name": "GitHub Harbor", "role": "local Git remotes, branches, commits, tags, and release prep", "pos": Vector2(970, 710), "size": Vector2(190, 112), "color": Color("#b7c4ff")},
	{"id": "terminal-control", "name": "Terminal Control", "role": "allowlisted local command jobs and logs", "pos": Vector2(1185, 710), "size": Vector2(190, 112), "color": Color("#9fd0cb")},
	{"id": "system-monitor", "name": "System Monitor", "role": "services, job queue, logs, and workspace health", "pos": Vector2(1225, 430), "size": Vector2(190, 112), "color": Color("#b8e0d2")},
	{"id": "model-market", "name": "Model Market", "role": "API gateway profiles and model key status", "pos": Vector2(1010, 445), "size": Vector2(185, 110), "color": Color("#f6d6ad")},
	{"id": "task-board", "name": "Task Board", "role": "local tasks, quest signals, and memory events", "pos": Vector2(610, 470), "size": Vector2(165, 100), "color": Color("#f7c98b")},
	{"id": "writing-studio", "name": "Writing Studio", "role": "project documents and local writing drafts", "pos": Vector2(420, 710), "size": Vector2(175, 108), "color": Color("#f3d7a4")},
	{"id": "automation-factory", "name": "Automation Factory", "role": "script catalog and draft-only automation blueprints", "pos": Vector2(1320, 600), "size": Vector2(190, 110), "color": Color("#c9e7a5")},
	{"id": "permission-hall", "name": "Permission Hall", "role": "safety classes, confirmation gates, scopes, and audit trail", "pos": Vector2(1315, 285), "size": Vector2(190, 112), "color": Color("#f1c0a9")},
	{"id": "settings-center", "name": "Settings Center", "role": "registries, launchers, env requirements, and config drafts", "pos": Vector2(1095, 180), "size": Vector2(185, 105), "color": Color("#e7c6ff")},
	{"id": "testing-arena", "name": "Testing Arena", "role": "smoke scripts, visual evidence, logs, and test plans", "pos": Vector2(1175, 300), "size": Vector2(180, 105), "color": Color("#f6b6c8")},
	{"id": "bug-clinic", "name": "Bug Clinic", "role": "diagnostics, failed jobs, known issues, and bug reports", "pos": Vector2(1375, 405), "size": Vector2(175, 105), "color": Color("#f7b2ad")},
	{"id": "project-management-hall", "name": "Project Management Hall", "role": "portfolio, research, tasks, and project briefs", "pos": Vector2(955, 175), "size": Vector2(210, 105), "color": Color("#c7d2fe")},
	{"id": "download-station", "name": "Download Station", "role": "downloads, imported assets, and intake drafts", "pos": Vector2(1245, 170), "size": Vector2(180, 100), "color": Color("#ffd6a5")},
	{"id": "asset-gallery", "name": "Asset Resource Gallery", "role": "runtime assets, source art, and curation notes", "pos": Vector2(1340, 725), "size": Vector2(210, 105), "color": Color("#ffdfba")},
	{"id": "local-office-center", "name": "Local Office Center", "role": "company folders, office notes, and follow-ups", "pos": Vector2(210, 585), "size": Vector2(205, 105), "color": Color("#fde2c8")},
	{"id": "schedule-plan-center", "name": "Schedule and Plan Center", "role": "planning signals, time boxes, and schedule drafts", "pos": Vector2(200, 705), "size": Vector2(210, 105), "color": Color("#f9dcc4")},
	{"id": "learning-training-grounds", "name": "Learning Training Grounds", "role": "skills, practice tracks, and learning plans", "pos": Vector2(640, 835), "size": Vector2(215, 105), "color": Color("#d6f5c8")},
	{"id": "language-learning-area", "name": "Language Learning Area", "role": "language practice, UI phrases, and multilingual notes", "pos": Vector2(875, 835), "size": Vector2(210, 105), "color": Color("#d8f3dc")},
	{"id": "research-data-center", "name": "Research Data Center", "role": "research datasets, result artifacts, and provenance notes", "pos": Vector2(1110, 835), "size": Vector2(215, 105), "color": Color("#cfe8ef")},
	{"id": "paper-reading-room", "name": "Paper Reading Room", "role": "papers, citations, BibTeX, and reading notes", "pos": Vector2(1090, 955), "size": Vector2(215, 96), "color": Color("#f2e6c9")},
	{"id": "version-release-plaza", "name": "Version Release Plaza", "role": "release readiness, docs, screenshots, and GitHub gates", "pos": Vector2(1320, 955), "size": Vector2(215, 96), "color": Color("#f8d7da")},
	{"id": "plugin-registry", "name": "Plugin Registry", "role": "extensions, manifests, skills, scripts, and plugin drafts", "pos": Vector2(1345, 845), "size": Vector2(190, 105), "color": Color("#d9f0ff")},
	{"id": "backup-station", "name": "Backup Station", "role": "backup sources, targets, and restore plans", "pos": Vector2(1430, 180), "size": Vector2(180, 100), "color": Color("#cdeac0")},
	{"id": "goal-tower", "name": "Long-Term Goal Tower", "role": "objectives, milestones, and goal drafts", "pos": Vector2(1430, 520), "size": Vector2(190, 110), "color": Color("#d8bbff")},
	{"id": "inspiration-station", "name": "Inspiration Station", "role": "idea inbox, visual references, and notes", "pos": Vector2(225, 220), "size": Vector2(200, 105), "color": Color("#ffcad4")},
	{"id": "temporary-draft-box", "name": "Temporary Draft Box", "role": "scratch notes and draft shelves", "pos": Vector2(230, 360), "size": Vector2(190, 100), "color": Color("#f8edeb")},
	{"id": "file-vault", "name": "File Vault", "role": "D drive project and file map", "pos": Vector2(775, 575), "size": Vector2(180, 120), "color": Color("#ffb7b2")},
	{"id": "research-hall", "name": "Research Hall", "role": "active scientific projects", "pos": Vector2(1090, 575), "size": Vector2(190, 120), "color": Color("#d7e9b9")},
	{"id": "agent-hub", "name": "Agent Hub", "role": "multi-agent coordination", "pos": Vector2(760, 430), "size": Vector2(170, 105), "color": Color("#f8e8d4")},
	{"id": "town-hall", "name": "Town Hall", "role": "architecture and operating rules", "pos": Vector2(750, 185), "size": Vector2(210, 105), "color": Color("#c9b79c")}
]

var fallback_agent_defs := [
	{"id": "opus", "name": "Opus", "role": "Chief Architect", "pos": Vector2(820, 215), "sheet": "res://assets/characters/opus-sheet.png"},
	{"id": "pixelcat", "name": "PixelCat", "role": "Builder", "pos": Vector2(650, 455), "sheet": "res://assets/characters/pixelcat-sheet.png"},
	{"id": "codex", "name": "Codex", "role": "Coordinator", "pos": Vector2(790, 490), "sheet": "res://assets/characters/codex-sheet.png"},
	{"id": "sonnet", "name": "Sonnet", "role": "Reviewer", "pos": Vector2(405, 460), "sheet": "res://assets/characters/sonnet-sheet.png"},
	{"id": "haiku", "name": "Haiku", "role": "Runner", "pos": Vector2(610, 660), "sheet": "res://assets/characters/haiku-sheet.png"},
	{"id": "deepseek", "name": "DeepSeek", "role": "Bulk Worker", "pos": Vector2(985, 665), "sheet": "res://assets/characters/deepseek-sheet.png"},
	{"id": "aris", "name": "ARIS", "role": "Research Frame", "pos": Vector2(1090, 430), "sheet": "res://assets/characters/aris-sheet.png"}
]

var building_defs := []
var agent_defs := []
var workspace_defs := []
var local_quest_defs := []
var npc_quest_defs := {}
var district_defs := []
var room_scene_defs := {}
var map_decor_defs := []

func _ready() -> void:
	capture_smoke_mode = OS.get_environment("AGENT_TOWN_CAPTURE") == "1"
	desktop_ui_test_mode = OS.get_environment("AGENT_TOWN_DESKTOP_TEST") == "1"
	if capture_smoke_mode:
		print("Agent Town capture mode enabled")
	if desktop_ui_test_mode:
		print("Agent Town desktop UI test mode enabled")
	_load_registries()
	_load_progress()
	_build_world()
	_build_hud()
	_request_health()
	_request_quests()
	if capture_smoke_mode:
		call_deferred("_capture_visual_smoke")
	elif desktop_ui_test_mode:
		call_deferred("_enter_desktop_ui_test_room")

func _process(delta: float) -> void:
	var keyboard_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if keyboard_vector.length() > 0.0:
		target_position = player.position + keyboard_vector * WALK_SPEED * delta * 2.0
		target_position = target_position.clamp(Vector2(80, 120), MAP_SIZE - Vector2(80, 80))

	var offset := target_position - player.position
	if offset.length() > 4.0:
		player.position += offset.normalized() * min(WALK_SPEED * delta, offset.length())
		_update_sprite_frame(player, offset)
	camera.position = camera.position.lerp(player.position, 0.12)

	for agent_id in agent_nodes.keys():
		var node: Sprite2D = agent_nodes[agent_id]
		var bob := sin(Time.get_ticks_msec() / 450.0 + float(agent_id.length())) * 2.0
		node.offset.y = bob
	_update_waypoint_distance()

func _input(event: InputEvent) -> void:
	if not desktop_ui_test_mode:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if room_stage == null or not room_overlay.visible:
			return
		var mouse_event := event as InputEventMouseButton
		var local_pos: Vector2 = mouse_event.position - room_stage.global_position
		var target_rect := Rect2(Vector2(392, 62), Vector2(138, 36))
		if target_rect.has_point(local_pos):
			_desktop_ui_test_button_pressed()

func _load_registries() -> void:
	building_defs = _load_registry_array(BUILDING_REGISTRY_PATH, fallback_building_defs, true)
	agent_defs = _load_registry_array(AGENT_REGISTRY_PATH, fallback_agent_defs, false)
	workspace_defs = _load_registry_array(WORKSPACE_REGISTRY_PATH, [], false)
	local_quest_defs = _load_registry_array(QUEST_REGISTRY_PATH, [], false)
	npc_quest_defs = _load_npc_quest_registry()
	district_defs = _load_district_registry()
	room_scene_defs = _load_room_scene_registry()
	map_decor_defs = _load_map_decor_registry()

func _load_npc_quest_registry() -> Dictionary:
	var chains := {}
	var parsed = null
	if FileAccess.file_exists(NPC_QUEST_REGISTRY_PATH):
		var file := FileAccess.open(NPC_QUEST_REGISTRY_PATH, FileAccess.READ)
		if file != null:
			parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_ARRAY:
		return chains
	for item in parsed:
		if typeof(item) != TYPE_DICTIONARY:
			continue
		var building_id := str(item.get("building_id", ""))
		if building_id == "":
			continue
		if not chains.has(building_id):
			chains[building_id] = []
		chains[building_id].append(item)
	return chains

func _load_district_registry() -> Array:
	var parsed = null
	if FileAccess.file_exists(DISTRICT_REGISTRY_PATH):
		var file := FileAccess.open(DISTRICT_REGISTRY_PATH, FileAccess.READ)
		if file != null:
			parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_ARRAY:
		return []
	var normalized := []
	for item in parsed:
		if typeof(item) != TYPE_DICTIONARY:
			continue
		var entry: Dictionary = item.duplicate(true)
		if not entry.has("id") or not entry.has("name"):
			continue
		entry["anchor"] = _array_to_vector2(entry.get("anchor", []), target_position)
		entry["portal_pos"] = _array_to_vector2(entry.get("portal_pos", []), entry["anchor"])
		entry["color"] = Color(str(entry.get("color", "#dcd6f7")))
		if not entry.has("buildings") or typeof(entry.get("buildings")) != TYPE_ARRAY:
			entry["buildings"] = []
		normalized.append(entry)
	return normalized

func _load_room_scene_registry() -> Dictionary:
	var scenes := {}
	var parsed = null
	if FileAccess.file_exists(ROOM_SCENE_REGISTRY_PATH):
		var file := FileAccess.open(ROOM_SCENE_REGISTRY_PATH, FileAccess.READ)
		if file != null:
			parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_ARRAY:
		return scenes
	for item in parsed:
		if typeof(item) != TYPE_DICTIONARY:
			continue
		var room_id := str(item.get("id", ""))
		if room_id == "":
			continue
		scenes[room_id] = item
	return scenes

func _load_map_decor_registry() -> Array:
	var parsed = null
	if FileAccess.file_exists(MAP_DECOR_REGISTRY_PATH):
		var file := FileAccess.open(MAP_DECOR_REGISTRY_PATH, FileAccess.READ)
		if file != null:
			parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_ARRAY:
		return []
	var normalized := []
	for item in parsed:
		if typeof(item) != TYPE_DICTIONARY:
			continue
		var entry: Dictionary = item.duplicate(true)
		if not entry.has("id") or not entry.has("name"):
			continue
		entry["pos"] = _array_to_vector2(entry.get("pos", []), Vector2.ZERO)
		entry["size"] = _array_to_vector2(entry.get("size", []), Vector2(96, 36))
		entry["color"] = Color(str(entry.get("color", "#fff3d8")), float(entry.get("alpha", 0.65)))
		normalized.append(entry)
	return normalized

func _load_registry_array(path: String, fallback: Array, is_building: bool) -> Array:
	var parsed = null
	if FileAccess.file_exists(path):
		var file := FileAccess.open(path, FileAccess.READ)
		if file != null:
			parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_ARRAY:
		return fallback.duplicate(true)
	var normalized := []
	for item in parsed:
		if typeof(item) != TYPE_DICTIONARY:
			continue
		var entry: Dictionary = item.duplicate(true)
		if entry.has("pos"):
			entry["pos"] = _array_to_vector2(entry["pos"], Vector2.ZERO)
		if entry.has("size"):
			entry["size"] = _array_to_vector2(entry["size"], Vector2(120, 80))
		if entry.has("color"):
			entry["color"] = Color(str(entry["color"]))
		if not entry.has("id") or not entry.has("name"):
			continue
		if is_building and (not entry.has("pos") or not entry.has("size")):
			continue
		if not is_building and (not entry.has("pos") or not entry.has("sheet")):
			continue
		normalized.append(entry)
	if normalized.is_empty():
		return fallback.duplicate(true)
	return normalized

func _array_to_vector2(value, fallback: Vector2) -> Vector2:
	if typeof(value) == TYPE_VECTOR2:
		return value
	if typeof(value) == TYPE_ARRAY and value.size() >= 2:
		return Vector2(float(value[0]), float(value[1]))
	return fallback

func _panel_style(fill: Color = COLOR_PARCHMENT, border: Color = COLOR_WOOD, radius: int = 10) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	style.content_margin_left = 10
	style.content_margin_top = 8
	style.content_margin_right = 10
	style.content_margin_bottom = 8
	return style

func _button_style(fill: Color, border: Color = COLOR_WOOD) -> StyleBoxFlat:
	var style := _panel_style(fill, border, 8)
	style.content_margin_left = 8
	style.content_margin_top = 5
	style.content_margin_right = 8
	style.content_margin_bottom = 5
	return style

func _style_panel(panel: PanelContainer, fill: Color = COLOR_PARCHMENT) -> void:
	panel.add_theme_stylebox_override("panel", _panel_style(fill))

func _style_button(button: Button, accent: Color = COLOR_PARCHMENT_DARK) -> void:
	button.add_theme_stylebox_override("normal", _button_style(accent))
	button.add_theme_stylebox_override("hover", _button_style(accent.lightened(0.08), COLOR_GOLD))
	button.add_theme_stylebox_override("pressed", _button_style(accent.darkened(0.08), COLOR_WOOD))
	button.add_theme_stylebox_override("disabled", _button_style(Color("#d4c3a4"), Color("#9d8a6c")))
	button.add_theme_color_override("font_color", COLOR_INK)
	button.add_theme_color_override("font_hover_color", COLOR_INK)
	button.add_theme_color_override("font_pressed_color", COLOR_INK)
	button.add_theme_color_override("font_disabled_color", Color("#6f6250"))

func _style_text(text_node: Control) -> void:
	text_node.add_theme_color_override("default_color", COLOR_INK)
	text_node.add_theme_color_override("font_color", COLOR_INK)

func _style_input(input: LineEdit) -> void:
	input.add_theme_stylebox_override("normal", _panel_style(Color("#fff8e8"), Color("#a7773f"), 8))
	input.add_theme_stylebox_override("focus", _panel_style(Color("#fffdf4"), COLOR_GOLD, 8))
	input.add_theme_color_override("font_color", COLOR_INK)
	input.add_theme_color_override("font_placeholder_color", Color("#7c6a55"))

func _apply_storybook_theme(root: Node) -> void:
	if root is PanelContainer:
		_style_panel(root as PanelContainer)
	elif root is Button:
		_style_button(root as Button)
	elif root is LineEdit:
		_style_input(root as LineEdit)
	elif root is RichTextLabel:
		_style_text(root as Control)
	elif root is Label:
		_style_text(root as Control)
	for child in root.get_children():
		_apply_storybook_theme(child)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_handle_world_click(get_global_mouse_position())
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.zoom = (camera.zoom * 1.1).clamp(Vector2(0.55, 0.55), Vector2(2.2, 2.2))
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.zoom = (camera.zoom * 0.9).clamp(Vector2(0.55, 0.55), Vector2(2.2, 2.2))
	if event.is_action_pressed("interact"):
		_interact_nearest()

func _build_world() -> void:
	var map := Sprite2D.new()
	map.name = "TownMap"
	map.texture = load("res://assets/town/town-map.png")
	map.centered = false
	add_child(map)

	_create_plaza_decor()
	_create_district_portals()
	_create_building_hotspots()
	_create_agents()
	_create_player()

	camera = Camera2D.new()
	camera.name = "PlayerCamera"
	camera.position = player.position
	camera.zoom = Vector2(0.85, 0.85)
	camera.enabled = true
	add_child(camera)

func _create_player() -> void:
	player = Sprite2D.new()
	player.name = "Player"
	player.texture = load("res://assets/characters/player-sheet.png")
	player.region_enabled = true
	player.region_rect = Rect2(0, 0, player.texture.get_width() / 4.0, player.texture.get_height() / 4.0)
	player.scale = PLAYER_SCALE
	player.position = target_position
	player.z_index = 50
	add_child(player)

func _create_agents() -> void:
	for def in agent_defs:
		agents[def.id] = def
		var node := Sprite2D.new()
		node.name = "Agent_%s" % def.id
		node.texture = load(def.sheet)
		node.region_enabled = true
		node.region_rect = Rect2(0, 0, node.texture.get_width() / 4.0, node.texture.get_height() / 4.0)
		node.scale = NPC_SCALE
		node.position = def.pos
		node.z_index = 40
		agent_nodes[def.id] = node
		add_child(node)

func _create_plaza_decor() -> void:
	if map_decor_defs.is_empty():
		_add_world_rect(Vector2(650, 380), Vector2(270, 92), Color("#d9c08c", 0.42), "Central Plaza")
		_add_world_rect(Vector2(750, 408), Vector2(70, 70), Color("#7dbbe8", 0.58), "Fountain")
		_add_world_rect(Vector2(708, 446), Vector2(155, 26), Color("#fff3d8", 0.82), "Quest Board")
		_add_world_rect(Vector2(912, 410), Vector2(94, 42), Color("#dcd6f7", 0.72), "Portal")
		_add_world_rect(Vector2(570, 435), Vector2(88, 38), Color("#d9a441", 0.55), "Agent Gate")
		_add_world_rect(Vector2(1000, 530), Vector2(110, 28), Color("#b8d8ff", 0.65), "Code Path")
		return
	for decor in map_decor_defs:
		_add_map_decor_hotspot(decor)

func _add_map_decor_hotspot(decor: Dictionary) -> void:
	var area := Area2D.new()
	var decor_id := str(decor.get("id", "decor"))
	area.name = "Decor_%s" % decor_id
	area.position = decor.get("pos", Vector2.ZERO)
	var size: Vector2 = decor.get("size", Vector2(96, 36))
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = size
	collision.shape = shape
	area.add_child(collision)

	var marker := ColorRect.new()
	marker.name = "DecorMarker"
	marker.color = decor.get("color", Color("#fff3d8", 0.65))
	marker.size = size
	marker.position = -size / 2.0
	marker.z_index = 8
	area.add_child(marker)

	var trim := ColorRect.new()
	trim.name = "DecorTrim"
	trim.color = Color("#8b5e34", 0.76)
	trim.size = Vector2(size.x, 5)
	trim.position = Vector2(-size.x / 2.0, -size.y / 2.0)
	trim.z_index = 9
	area.add_child(trim)

	if decor.get("visible_label", true):
		var label := Label.new()
		label.text = str(decor.get("name", decor_id))
		label.position = -size / 2.0 + Vector2(6, 5)
		label.size = size - Vector2(12, 10)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 11)
		label.add_theme_color_override("font_color", COLOR_INK)
		label.z_index = 10
		area.add_child(label)

	map_decor_nodes[decor_id] = area
	add_child(area)

func _create_district_portals() -> void:
	for district in district_defs:
		var portal := Area2D.new()
		portal.name = "District_%s" % district.id
		portal.position = district.portal_pos
		var collision := CollisionShape2D.new()
		var shape := RectangleShape2D.new()
		shape.size = Vector2(128, 48)
		collision.shape = shape
		portal.add_child(collision)

		var base := ColorRect.new()
		base.name = "PortalMarker"
		base.color = Color(district.color, 0.58)
		base.size = Vector2(128, 48)
		base.position = -base.size / 2.0
		base.z_index = 12
		portal.add_child(base)

		var trim := ColorRect.new()
		trim.color = Color("#8b5e34", 0.78)
		trim.size = Vector2(128, 6)
		trim.position = Vector2(-64, -24)
		trim.z_index = 13
		portal.add_child(trim)

		var label := Label.new()
		label.text = district.name
		label.position = Vector2(-59, -16)
		label.size = Vector2(118, 32)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 11)
		label.add_theme_color_override("font_color", COLOR_INK)
		label.z_index = 14
		portal.add_child(label)

		district_nodes[district.id] = portal
		add_child(portal)

func _add_world_rect(center: Vector2, size: Vector2, color: Color, text: String = "") -> void:
	var rect := ColorRect.new()
	rect.position = center - size / 2.0
	rect.size = size
	rect.color = color
	rect.z_index = 8
	add_child(rect)
	if text != "":
		var label := Label.new()
		label.text = text
		label.position = rect.position + Vector2(6, 5)
		label.size = size - Vector2(12, 10)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 12)
		label.add_theme_color_override("font_color", COLOR_INK)
		label.z_index = 9
		add_child(label)

func _create_building_hotspots() -> void:
	for def in building_defs:
		var area := Area2D.new()
		area.name = "Building_%s" % def.id
		area.position = def.pos
		var collision := CollisionShape2D.new()
		var shape := RectangleShape2D.new()
		shape.size = def.size
		collision.shape = shape
		area.add_child(collision)

		var marker := ColorRect.new()
		marker.name = "Marker"
		marker.color = Color(def.color, 0.36)
		marker.size = def.size
		marker.position = -def.size / 2.0
		area.add_child(marker)

		var trim := ColorRect.new()
		trim.name = "SignTrim"
		trim.color = Color("#8b5e34", 0.72)
		trim.size = Vector2(def.size.x, 8)
		trim.position = Vector2(-def.size.x / 2.0, -def.size.y / 2.0)
		area.add_child(trim)

		var label := Label.new()
		label.text = def.name
		label.add_theme_color_override("font_color", COLOR_INK)
		label.add_theme_font_size_override("font_size", 14)
		label.position = Vector2(-def.size.x / 2.0 + 8.0, -def.size.y / 2.0 + 8.0)
		area.add_child(label)
		building_nodes[def.id] = area
		add_child(area)

func _build_hud() -> void:
	hud = CanvasLayer.new()
	hud.name = "HUD"
	add_child(hud)

	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	hud.add_child(root)

	var top_bar := PanelContainer.new()
	top_bar.position = Vector2(16, 14)
	top_bar.size = Vector2(760, 48)
	root.add_child(top_bar)

	status_label = Label.new()
	status_label.text = "Agent Town Godot | Backend: checking | Click map to walk, click agents/buildings, E interacts"
	status_label.add_theme_font_size_override("font_size", 16)
	top_bar.add_child(status_label)

	waypoint_panel = PanelContainer.new()
	waypoint_panel.position = Vector2(300, 78)
	waypoint_panel.size = Vector2(500, 58)
	root.add_child(waypoint_panel)
	waypoint_body = RichTextLabel.new()
	waypoint_body.bbcode_enabled = true
	waypoint_body.scroll_active = false
	waypoint_body.custom_minimum_size = Vector2(470, 44)
	waypoint_body.text = "[b]Waypoint[/b]\nSelect a landmark, route, building, or district."
	waypoint_panel.add_child(waypoint_body)

	activity_panel = PanelContainer.new()
	activity_panel.position = Vector2(936, 628)
	activity_panel.size = Vector2(314, 76)
	root.add_child(activity_panel)
	activity_body = RichTextLabel.new()
	activity_body.bbcode_enabled = true
	activity_body.scroll_active = false
	activity_body.custom_minimum_size = Vector2(292, 62)
	activity_panel.add_child(activity_body)
	_render_activity_log()

	var side := PanelContainer.new()
	side.position = Vector2(16, 78)
	side.size = Vector2(260, 285)
	root.add_child(side)
	var list := VBoxContainer.new()
	side.add_child(list)
	var side_title := Label.new()
	side_title.text = "Residents"
	side_title.add_theme_font_size_override("font_size", 20)
	list.add_child(side_title)
	for def in agent_defs:
		var button := Button.new()
		button.text = "%s - %s" % [def.name, def.role]
		button.pressed.connect(func(agent_id = def.id): _select_agent(agent_id))
		list.add_child(button)

	var quest_panel := PanelContainer.new()
	quest_panel.position = Vector2(16, 378)
	quest_panel.size = Vector2(300, 300)
	root.add_child(quest_panel)
	var quest_box := VBoxContainer.new()
	quest_panel.add_child(quest_box)
	var quest_title := Label.new()
	quest_title.text = "Quest Board"
	quest_title.add_theme_font_size_override("font_size", 20)
	quest_box.add_child(quest_title)
	var daily_buttons := GridContainer.new()
	daily_buttons.columns = 2
	quest_box.add_child(daily_buttons)
	daily_routes_button = Button.new()
	daily_routes_button.text = "Daily Routes"
	daily_routes_button.custom_minimum_size = Vector2(128, 32)
	daily_routes_button.tooltip_text = "Load today's safe local-work route cards"
	daily_routes_button.pressed.connect(_request_daily_routes)
	daily_buttons.add_child(daily_routes_button)
	daily_claim_button = Button.new()
	daily_claim_button.text = "Claim Route"
	daily_claim_button.custom_minimum_size = Vector2(128, 32)
	daily_claim_button.tooltip_text = "Save the selected daily route in this player profile"
	daily_claim_button.disabled = true
	daily_claim_button.pressed.connect(_claim_active_daily_route)
	daily_buttons.add_child(daily_claim_button)
	daily_next_button = Button.new()
	daily_next_button.text = "Next Stop"
	daily_next_button.custom_minimum_size = Vector2(128, 32)
	daily_next_button.tooltip_text = "Guide the player to the next unvisited building in the claimed route"
	daily_next_button.disabled = true
	daily_next_button.pressed.connect(_guide_to_daily_route_next_stop)
	daily_buttons.add_child(daily_next_button)
	collection_codex_button = Button.new()
	collection_codex_button.text = "Codex"
	collection_codex_button.custom_minimum_size = Vector2(128, 32)
	collection_codex_button.tooltip_text = "Open the local collection codex for badges, companions, mastery, and routes"
	collection_codex_button.pressed.connect(_request_collection_codex)
	daily_buttons.add_child(collection_codex_button)
	quest_body = RichTextLabel.new()
	quest_body.bbcode_enabled = true
	quest_body.custom_minimum_size = Vector2(270, 80)
	quest_body.text = "Loading local work quests..."
	quest_box.add_child(quest_body)
	quest_list = VBoxContainer.new()
	quest_box.add_child(quest_list)
	badge_body = RichTextLabel.new()
	badge_body.bbcode_enabled = true
	badge_body.custom_minimum_size = Vector2(270, 56)
	quest_box.add_child(badge_body)
	_update_badge_case()

	var detail := PanelContainer.new()
	detail.position = Vector2(820, 78)
	detail.size = Vector2(430, 540)
	root.add_child(detail)
	var detail_box := VBoxContainer.new()
	detail.add_child(detail_box)
	detail_title = Label.new()
	detail_title.text = "Town Console"
	detail_title.add_theme_font_size_override("font_size", 22)
	detail_box.add_child(detail_title)
	detail_body = RichTextLabel.new()
	detail_body.custom_minimum_size = Vector2(390, 285)
	detail_body.bbcode_enabled = true
	detail_body.text = "Choose a resident or building. This Godot client reads the local workspace through the FastAPI bridge."
	detail_box.add_child(detail_body)
	room_button = Button.new()
	room_button.text = "Enter Room"
	room_button.disabled = true
	room_button.pressed.connect(_enter_selected_room)
	detail_box.add_child(room_button)
	action_button = Button.new()
	action_button.text = "Do Safe Work Scan"
	action_button.disabled = true
	action_button.pressed.connect(_run_safe_work_scan)
	detail_box.add_child(action_button)
	dialogue_input = LineEdit.new()
	dialogue_input.placeholder_text = "Ask the selected agent to inspect, plan, summarize, or coordinate..."
	detail_box.add_child(dialogue_input)
	dialogue_button = Button.new()
	dialogue_button.text = "Send to Agent"
	dialogue_button.disabled = true
	dialogue_button.pressed.connect(_send_dialogue)
	detail_box.add_child(dialogue_button)

	_build_room_overlay(root)
	_apply_storybook_theme(root)

	http = HTTPRequest.new()
	http.request_completed.connect(_on_http_completed)
	add_child(http)
	quest_http = HTTPRequest.new()
	quest_http.request_completed.connect(_on_quest_http_completed)
	add_child(quest_http)
	daily_http = HTTPRequest.new()
	daily_http.request_completed.connect(_on_daily_http_completed)
	add_child(daily_http)
	collection_http = HTTPRequest.new()
	collection_http.request_completed.connect(_on_collection_http_completed)
	add_child(collection_http)
	action_http = HTTPRequest.new()
	action_http.request_completed.connect(_on_action_http_completed)
	add_child(action_http)
	room_http = HTTPRequest.new()
	room_http.request_completed.connect(_on_room_http_completed)
	add_child(room_http)
	file_http = HTTPRequest.new()
	file_http.request_completed.connect(_on_file_http_completed)
	add_child(file_http)
	research_http = HTTPRequest.new()
	research_http.request_completed.connect(_on_research_http_completed)
	add_child(research_http)
	memory_http = HTTPRequest.new()
	memory_http.request_completed.connect(_on_memory_http_completed)
	add_child(memory_http)
	knowledge_http = HTTPRequest.new()
	knowledge_http.request_completed.connect(_on_knowledge_http_completed)
	add_child(knowledge_http)
	agent_hub_http = HTTPRequest.new()
	agent_hub_http.request_completed.connect(_on_agent_hub_http_completed)
	add_child(agent_hub_http)
	agent_task_http = HTTPRequest.new()
	agent_task_http.request_completed.connect(_on_agent_task_http_completed)
	add_child(agent_task_http)
	agent_tool_http = HTTPRequest.new()
	agent_tool_http.request_completed.connect(_on_agent_tool_http_completed)
	add_child(agent_tool_http)
	project_http = HTTPRequest.new()
	project_http.request_completed.connect(_on_project_http_completed)
	add_child(project_http)
	harbor_http = HTTPRequest.new()
	harbor_http.request_completed.connect(_on_harbor_http_completed)
	add_child(harbor_http)
	terminal_http = HTTPRequest.new()
	terminal_http.request_completed.connect(_on_terminal_http_completed)
	add_child(terminal_http)
	system_http = HTTPRequest.new()
	system_http.request_completed.connect(_on_system_http_completed)
	add_child(system_http)
	town_http = HTTPRequest.new()
	town_http.request_completed.connect(_on_town_http_completed)
	add_child(town_http)
	model_http = HTTPRequest.new()
	model_http.request_completed.connect(_on_model_http_completed)
	add_child(model_http)
	task_http = HTTPRequest.new()
	task_http.request_completed.connect(_on_task_http_completed)
	add_child(task_http)
	writing_http = HTTPRequest.new()
	writing_http.request_completed.connect(_on_writing_http_completed)
	add_child(writing_http)
	automation_http = HTTPRequest.new()
	automation_http.request_completed.connect(_on_automation_http_completed)
	add_child(automation_http)
	permission_http = HTTPRequest.new()
	permission_http.request_completed.connect(_on_permission_http_completed)
	add_child(permission_http)
	settings_http = HTTPRequest.new()
	settings_http.request_completed.connect(_on_settings_http_completed)
	add_child(settings_http)
	testing_http = HTTPRequest.new()
	testing_http.request_completed.connect(_on_testing_http_completed)
	add_child(testing_http)
	bug_http = HTTPRequest.new()
	bug_http.request_completed.connect(_on_bug_http_completed)
	add_child(bug_http)
	management_http = HTTPRequest.new()
	management_http.request_completed.connect(_on_management_http_completed)
	add_child(management_http)
	download_http = HTTPRequest.new()
	download_http.request_completed.connect(_on_download_http_completed)
	add_child(download_http)
	asset_http = HTTPRequest.new()
	asset_http.request_completed.connect(_on_asset_http_completed)
	add_child(asset_http)
	office_http = HTTPRequest.new()
	office_http.request_completed.connect(_on_office_http_completed)
	add_child(office_http)
	schedule_http = HTTPRequest.new()
	schedule_http.request_completed.connect(_on_schedule_http_completed)
	add_child(schedule_http)
	learning_http = HTTPRequest.new()
	learning_http.request_completed.connect(_on_learning_http_completed)
	add_child(learning_http)
	language_http = HTTPRequest.new()
	language_http.request_completed.connect(_on_language_http_completed)
	add_child(language_http)
	research_data_http = HTTPRequest.new()
	research_data_http.request_completed.connect(_on_research_data_http_completed)
	add_child(research_data_http)
	paper_reading_http = HTTPRequest.new()
	paper_reading_http.request_completed.connect(_on_paper_reading_http_completed)
	add_child(paper_reading_http)
	release_http = HTTPRequest.new()
	release_http.request_completed.connect(_on_release_http_completed)
	add_child(release_http)
	plugin_http = HTTPRequest.new()
	plugin_http.request_completed.connect(_on_plugin_http_completed)
	add_child(plugin_http)
	backup_http = HTTPRequest.new()
	backup_http.request_completed.connect(_on_backup_http_completed)
	add_child(backup_http)
	goal_http = HTTPRequest.new()
	goal_http.request_completed.connect(Callable(self, "_on_goal_http_completed"))
	add_child(goal_http)
	inspiration_http = HTTPRequest.new()
	inspiration_http.request_completed.connect(_on_inspiration_http_completed)
	add_child(inspiration_http)
	temp_draft_http = HTTPRequest.new()
	temp_draft_http.request_completed.connect(_on_temp_draft_http_completed)
	add_child(temp_draft_http)

func _build_room_overlay(root: Control) -> void:
	room_overlay = PanelContainer.new()
	room_overlay.visible = false
	room_overlay.position = Vector2(300, 70)
	room_overlay.size = Vector2(620, 585)
	root.add_child(room_overlay)
	var room_box := VBoxContainer.new()
	room_overlay.add_child(room_box)
	room_title = Label.new()
	room_title.text = "Room"
	room_title.add_theme_font_size_override("font_size", 26)
	room_box.add_child(room_title)
	room_stage = Control.new()
	room_stage.custom_minimum_size = Vector2(580, 210)
	room_box.add_child(room_stage)
	room_body = RichTextLabel.new()
	room_body.bbcode_enabled = true
	room_body.custom_minimum_size = Vector2(580, 220)
	room_body.text = "Loading room..."
	room_box.add_child(room_body)
	var button_scroll := ScrollContainer.new()
	button_scroll.custom_minimum_size = Vector2(580, 96)
	room_box.add_child(button_scroll)
	var buttons := GridContainer.new()
	buttons.columns = 4
	button_scroll.add_child(buttons)
	room_review_button = Button.new()
	room_review_button.text = "Review Shelves"
	room_review_button.pressed.connect(_review_room_shelves)
	buttons.add_child(room_review_button)
	room_capability_atlas_button = Button.new()
	room_capability_atlas_button.text = "Atlas"
	room_capability_atlas_button.pressed.connect(_load_town_capability_atlas)
	buttons.add_child(room_capability_atlas_button)
	room_capability_next_button = Button.new()
	room_capability_next_button.text = "Next Atlas"
	room_capability_next_button.disabled = true
	room_capability_next_button.pressed.connect(_select_next_town_capability)
	buttons.add_child(room_capability_next_button)
	room_capability_open_button = Button.new()
	room_capability_open_button.text = "Open Atlas"
	room_capability_open_button.disabled = true
	room_capability_open_button.pressed.connect(_open_selected_town_capability)
	buttons.add_child(room_capability_open_button)
	room_workflow_routes_button = Button.new()
	room_workflow_routes_button.text = "Workflows"
	room_workflow_routes_button.pressed.connect(_load_town_workflow_routes)
	buttons.add_child(room_workflow_routes_button)
	var room_workflow_claim_button := Button.new()
	room_workflow_claim_button.text = "Claim Flow"
	room_workflow_claim_button.pressed.connect(_claim_selected_town_workflow)
	buttons.add_child(room_workflow_claim_button)
	var room_workflow_guide_button := Button.new()
	room_workflow_guide_button.text = "Flow Stop"
	room_workflow_guide_button.pressed.connect(_guide_to_town_workflow_next_stop)
	buttons.add_child(room_workflow_guide_button)
	room_workflow_next_button = Button.new()
	room_workflow_next_button.text = "Next Flow"
	room_workflow_next_button.disabled = true
	room_workflow_next_button.pressed.connect(_select_next_town_workflow)
	buttons.add_child(room_workflow_next_button)
	room_workflow_open_button = Button.new()
	room_workflow_open_button.text = "Open Flow"
	room_workflow_open_button.disabled = true
	room_workflow_open_button.pressed.connect(_open_selected_town_workflow)
	buttons.add_child(room_workflow_open_button)
	room_memory_button = Button.new()
	room_memory_button.text = "Memory Shelves"
	room_memory_button.pressed.connect(_load_memory_index)
	buttons.add_child(room_memory_button)
	room_memory_detail_button = Button.new()
	room_memory_detail_button.text = "Detail"
	room_memory_detail_button.disabled = true
	room_memory_detail_button.pressed.connect(_load_selected_memory_item)
	buttons.add_child(room_memory_detail_button)
	room_memory_proposal_button = Button.new()
	room_memory_proposal_button.text = "Proposal"
	room_memory_proposal_button.pressed.connect(_create_memory_proposal)
	buttons.add_child(room_memory_proposal_button)
	room_memory_promote_button = Button.new()
	room_memory_promote_button.text = "Promote"
	room_memory_promote_button.disabled = true
	room_memory_promote_button.pressed.connect(_promote_memory_proposal)
	buttons.add_child(room_memory_promote_button)
	room_knowledge_button = Button.new()
	room_knowledge_button.text = "Knowledge Index"
	room_knowledge_button.pressed.connect(_load_knowledge_index)
	buttons.add_child(room_knowledge_button)
	room_knowledge_refresh_button = Button.new()
	room_knowledge_refresh_button.text = "Refresh Index"
	room_knowledge_refresh_button.pressed.connect(_refresh_knowledge_index)
	buttons.add_child(room_knowledge_refresh_button)
	room_knowledge_search_button = Button.new()
	room_knowledge_search_button.text = "Search Wiki"
	room_knowledge_search_button.pressed.connect(_search_knowledge)
	buttons.add_child(room_knowledge_search_button)
	room_knowledge_detail_button = Button.new()
	room_knowledge_detail_button.text = "Open Knowledge"
	room_knowledge_detail_button.disabled = true
	room_knowledge_detail_button.pressed.connect(_load_selected_knowledge_item)
	buttons.add_child(room_knowledge_detail_button)
	room_file_roots_button = Button.new()
	room_file_roots_button.text = "File Roots"
	room_file_roots_button.pressed.connect(_load_file_roots)
	buttons.add_child(room_file_roots_button)
	room_file_index_button = Button.new()
	room_file_index_button.text = "File Index"
	room_file_index_button.pressed.connect(_refresh_file_index)
	buttons.add_child(room_file_index_button)
	room_file_organize_audit_button = Button.new()
	room_file_organize_audit_button.text = "Org Audit"
	room_file_organize_audit_button.pressed.connect(_load_file_organize_audit)
	buttons.add_child(room_file_organize_audit_button)
	room_file_search_button = Button.new()
	room_file_search_button.text = "Search Files"
	room_file_search_button.pressed.connect(_search_file_vault)
	buttons.add_child(room_file_search_button)
	room_file_tag_button = Button.new()
	room_file_tag_button.text = "Tag File"
	room_file_tag_button.disabled = true
	room_file_tag_button.pressed.connect(_tag_selected_file)
	buttons.add_child(room_file_tag_button)
	room_file_open_button = Button.new()
	room_file_open_button.text = "Open Folder"
	room_file_open_button.disabled = true
	room_file_open_button.pressed.connect(_open_selected_file_folder)
	buttons.add_child(room_file_open_button)
	room_file_reveal_button = Button.new()
	room_file_reveal_button.text = "Reveal Item"
	room_file_reveal_button.disabled = true
	room_file_reveal_button.pressed.connect(_reveal_selected_file_item)
	buttons.add_child(room_file_reveal_button)
	room_file_preview_button = Button.new()
	room_file_preview_button.text = "Preview File"
	room_file_preview_button.disabled = true
	room_file_preview_button.pressed.connect(_preview_selected_file)
	buttons.add_child(room_file_preview_button)
	room_file_organize_button = Button.new()
	room_file_organize_button.text = "Organize Plan"
	room_file_organize_button.disabled = true
	room_file_organize_button.pressed.connect(_create_file_organize_proposal)
	buttons.add_child(room_file_organize_button)
	room_research_button = Button.new()
	room_research_button.text = "Research Projects"
	room_research_button.pressed.connect(_load_research_projects)
	buttons.add_child(room_research_button)
	room_project_detail_button = Button.new()
	room_project_detail_button.text = "Project Detail"
	room_project_detail_button.disabled = true
	room_project_detail_button.pressed.connect(_load_selected_research_project)
	buttons.add_child(room_project_detail_button)
	room_research_agent_button = Button.new()
	room_research_agent_button.text = "Research Agent"
	room_research_agent_button.disabled = true
	room_research_agent_button.pressed.connect(_submit_research_agent_task)
	buttons.add_child(room_research_agent_button)
	room_research_log_button = Button.new()
	room_research_log_button.text = "Research Log"
	room_research_log_button.disabled = true
	room_research_log_button.pressed.connect(_create_research_log_draft)
	buttons.add_child(room_research_log_button)
	room_agent_button = Button.new()
	room_agent_button.text = "Agent Roster"
	room_agent_button.pressed.connect(_load_agent_roster)
	buttons.add_child(room_agent_button)
	room_dispatch_button = Button.new()
	room_dispatch_button.text = "Draft Dispatch"
	room_dispatch_button.pressed.connect(_create_agent_dispatch_draft)
	buttons.add_child(room_dispatch_button)
	room_agent_runner_button = Button.new()
	room_agent_runner_button.text = "Runner Ready"
	room_agent_runner_button.pressed.connect(_load_agent_runner_readiness)
	buttons.add_child(room_agent_runner_button)
	room_agent_runner_preview_button = Button.new()
	room_agent_runner_preview_button.text = "Runner Plan"
	room_agent_runner_preview_button.pressed.connect(_create_agent_runner_dispatch_preview)
	buttons.add_child(room_agent_runner_preview_button)
	room_agent_runner_launch_button = Button.new()
	room_agent_runner_launch_button.text = "Run Gate"
	room_agent_runner_launch_button.disabled = true
	room_agent_runner_launch_button.pressed.connect(_preview_agent_runner_launch_gate)
	buttons.add_child(room_agent_runner_launch_button)
	room_agent_chat_button = Button.new()
	room_agent_chat_button.text = "Agent Chat"
	room_agent_chat_button.pressed.connect(_start_agent_chat)
	buttons.add_child(room_agent_chat_button)
	room_agent_chat_send_button = Button.new()
	room_agent_chat_send_button.text = "Send Chat"
	room_agent_chat_send_button.disabled = true
	room_agent_chat_send_button.pressed.connect(_send_agent_chat_message)
	buttons.add_child(room_agent_chat_send_button)
	room_agent_chat_tool_button = Button.new()
	room_agent_chat_tool_button.text = "Run Suggested"
	room_agent_chat_tool_button.disabled = true
	room_agent_chat_tool_button.pressed.connect(_run_suggested_agent_chat_tool)
	buttons.add_child(room_agent_chat_tool_button)
	room_agent_tasks_button = Button.new()
	room_agent_tasks_button.text = "Agent Tasks"
	room_agent_tasks_button.pressed.connect(_load_agent_tasks)
	buttons.add_child(room_agent_tasks_button)
	room_agent_task_policy_button = Button.new()
	room_agent_task_policy_button.text = "Task Policy"
	room_agent_task_policy_button.pressed.connect(_load_agent_task_policy)
	buttons.add_child(room_agent_task_policy_button)
	room_agent_task_logs_button = Button.new()
	room_agent_task_logs_button.text = "Task Logs"
	room_agent_task_logs_button.pressed.connect(_load_agent_task_logs)
	buttons.add_child(room_agent_task_logs_button)
	room_agent_task_submit_button = Button.new()
	room_agent_task_submit_button.text = "Queue Agent"
	room_agent_task_submit_button.pressed.connect(_submit_agent_task)
	buttons.add_child(room_agent_task_submit_button)
	room_agent_task_next_button = Button.new()
	room_agent_task_next_button.text = "Next Result"
	room_agent_task_next_button.disabled = true
	room_agent_task_next_button.pressed.connect(_select_next_agent_task)
	buttons.add_child(room_agent_task_next_button)
	room_agent_task_open_button = Button.new()
	room_agent_task_open_button.text = "Open Result"
	room_agent_task_open_button.disabled = true
	room_agent_task_open_button.pressed.connect(_open_selected_agent_task_result)
	buttons.add_child(room_agent_task_open_button)
	room_agent_task_events_button = Button.new()
	room_agent_task_events_button.text = "Task Events"
	room_agent_task_events_button.disabled = true
	room_agent_task_events_button.pressed.connect(_load_selected_agent_task_events)
	buttons.add_child(room_agent_task_events_button)
	room_agent_task_pause_button = Button.new()
	room_agent_task_pause_button.text = "Pause Task"
	room_agent_task_pause_button.disabled = true
	room_agent_task_pause_button.pressed.connect(_pause_selected_agent_task)
	buttons.add_child(room_agent_task_pause_button)
	room_agent_task_cancel_button = Button.new()
	room_agent_task_cancel_button.text = "Cancel Task"
	room_agent_task_cancel_button.disabled = true
	room_agent_task_cancel_button.pressed.connect(_cancel_selected_agent_task)
	buttons.add_child(room_agent_task_cancel_button)
	room_agent_task_resume_button = Button.new()
	room_agent_task_resume_button.text = "Resume Task"
	room_agent_task_resume_button.disabled = true
	room_agent_task_resume_button.pressed.connect(_resume_selected_agent_task)
	buttons.add_child(room_agent_task_resume_button)
	room_agent_tools_button = Button.new()
	room_agent_tools_button.text = "Tool Catalog"
	room_agent_tools_button.pressed.connect(_load_agent_tools)
	buttons.add_child(room_agent_tools_button)
	room_agent_tool_run_button = Button.new()
	room_agent_tool_run_button.text = "Run Tool"
	room_agent_tool_run_button.pressed.connect(_run_agent_tool)
	buttons.add_child(room_agent_tool_run_button)
	room_agent_tool_next_button = Button.new()
	room_agent_tool_next_button.text = "Next Tool"
	room_agent_tool_next_button.disabled = true
	room_agent_tool_next_button.pressed.connect(_select_next_agent_tool_invocation)
	buttons.add_child(room_agent_tool_next_button)
	room_agent_tool_open_button = Button.new()
	room_agent_tool_open_button.text = "Open Tool"
	room_agent_tool_open_button.disabled = true
	room_agent_tool_open_button.pressed.connect(_open_selected_agent_tool_invocation)
	buttons.add_child(room_agent_tool_open_button)
	room_agent_tool_events_button = Button.new()
	room_agent_tool_events_button.text = "Tool Events"
	room_agent_tool_events_button.disabled = true
	room_agent_tool_events_button.pressed.connect(_load_selected_agent_tool_events)
	buttons.add_child(room_agent_tool_events_button)
	room_agent_tool_logs_button = Button.new()
	room_agent_tool_logs_button.text = "Tool Logs"
	room_agent_tool_logs_button.pressed.connect(_load_agent_tool_logs)
	buttons.add_child(room_agent_tool_logs_button)
	room_agent_companion_button = Button.new()
	room_agent_companion_button.text = "Recruit Agent"
	room_agent_companion_button.disabled = true
	room_agent_companion_button.pressed.connect(_recruit_selected_agent_companion)
	buttons.add_child(room_agent_companion_button)
	room_project_browser_button = Button.new()
	room_project_browser_button.text = "Code Projects"
	room_project_browser_button.pressed.connect(_load_code_projects)
	buttons.add_child(room_project_browser_button)
	room_local_project_detail_button = Button.new()
	room_local_project_detail_button.text = "Repo Detail"
	room_local_project_detail_button.disabled = true
	room_local_project_detail_button.pressed.connect(_load_selected_code_project)
	buttons.add_child(room_local_project_detail_button)
	room_code_task_button = Button.new()
	room_code_task_button.text = "Code Task"
	room_code_task_button.disabled = true
	room_code_task_button.pressed.connect(_create_code_task_draft)
	buttons.add_child(room_code_task_button)
	room_code_context_button = Button.new()
	room_code_context_button.text = "Context Pack"
	room_code_context_button.disabled = true
	room_code_context_button.pressed.connect(_create_code_context_pack)
	buttons.add_child(room_code_context_button)
	room_code_patch_plan_button = Button.new()
	room_code_patch_plan_button.text = "Patch Plan"
	room_code_patch_plan_button.disabled = true
	room_code_patch_plan_button.pressed.connect(_create_code_patch_plan)
	buttons.add_child(room_code_patch_plan_button)
	room_code_agent_button = Button.new()
	room_code_agent_button.text = "Code Agent"
	room_code_agent_button.disabled = true
	room_code_agent_button.pressed.connect(_submit_code_agent_task)
	buttons.add_child(room_code_agent_button)
	room_code_explain_button = Button.new()
	room_code_explain_button.text = "Explain Code"
	room_code_explain_button.disabled = true
	room_code_explain_button.pressed.connect(_submit_code_explain_task)
	buttons.add_child(room_code_explain_button)
	room_code_verify_button = Button.new()
	room_code_verify_button.text = "Run Check"
	room_code_verify_button.disabled = true
	room_code_verify_button.pressed.connect(_run_project_verification)
	buttons.add_child(room_code_verify_button)
	room_code_check_job_button = Button.new()
	room_code_check_job_button.text = "Check Job"
	room_code_check_job_button.disabled = true
	room_code_check_job_button.pressed.connect(_poll_selected_project_job)
	buttons.add_child(room_code_check_job_button)
	room_harbor_button = Button.new()
	room_harbor_button.text = "Harbor Repos"
	room_harbor_button.pressed.connect(_load_harbor_repos)
	buttons.add_child(room_harbor_button)
	room_harbor_detail_button = Button.new()
	room_harbor_detail_button.text = "Harbor Detail"
	room_harbor_detail_button.disabled = true
	room_harbor_detail_button.pressed.connect(_load_selected_harbor_repo)
	buttons.add_child(room_harbor_detail_button)
	room_harbor_github_button = Button.new()
	room_harbor_github_button.text = "GH Status"
	room_harbor_github_button.disabled = true
	room_harbor_github_button.pressed.connect(_load_selected_harbor_github)
	buttons.add_child(room_harbor_github_button)
	room_harbor_readiness_button = Button.new()
	room_harbor_readiness_button.text = "Publish Ready"
	room_harbor_readiness_button.disabled = true
	room_harbor_readiness_button.pressed.connect(_load_selected_harbor_publish_readiness)
	buttons.add_child(room_harbor_readiness_button)
	room_harbor_draft_button = Button.new()
	room_harbor_draft_button.text = "Harbor Draft"
	room_harbor_draft_button.disabled = true
	room_harbor_draft_button.pressed.connect(_create_harbor_draft)
	buttons.add_child(room_harbor_draft_button)
	room_harbor_publish_plan_button = Button.new()
	room_harbor_publish_plan_button.text = "PR Plan"
	room_harbor_publish_plan_button.disabled = true
	room_harbor_publish_plan_button.pressed.connect(_create_harbor_publish_plan)
	buttons.add_child(room_harbor_publish_plan_button)
	room_terminal_button = Button.new()
	room_terminal_button.text = "Terminal Jobs"
	room_terminal_button.pressed.connect(_load_terminal_commands)
	buttons.add_child(room_terminal_button)
	room_terminal_preview_button = Button.new()
	room_terminal_preview_button.text = "Preview Cmd"
	room_terminal_preview_button.disabled = true
	room_terminal_preview_button.pressed.connect(_preview_selected_terminal_command)
	buttons.add_child(room_terminal_preview_button)
	room_terminal_run_button = Button.new()
	room_terminal_run_button.text = "Run Command"
	room_terminal_run_button.disabled = true
	room_terminal_run_button.pressed.connect(_run_selected_terminal_command)
	buttons.add_child(room_terminal_run_button)
	room_terminal_next_log_button = Button.new()
	room_terminal_next_log_button.text = "Next Log"
	room_terminal_next_log_button.disabled = true
	room_terminal_next_log_button.pressed.connect(_select_next_terminal_log)
	buttons.add_child(room_terminal_next_log_button)
	room_terminal_open_log_button = Button.new()
	room_terminal_open_log_button.text = "Open Log"
	room_terminal_open_log_button.disabled = true
	room_terminal_open_log_button.pressed.connect(_open_selected_terminal_log)
	buttons.add_child(room_terminal_open_log_button)
	room_system_button = Button.new()
	room_system_button.text = "System Status"
	room_system_button.pressed.connect(_load_system_overview)
	buttons.add_child(room_system_button)
	room_jobs_button = Button.new()
	room_jobs_button.text = "Job Queue"
	room_jobs_button.pressed.connect(_load_system_jobs)
	buttons.add_child(room_jobs_button)
	room_job_cancel_button = Button.new()
	room_job_cancel_button.text = "Cancel Job"
	room_job_cancel_button.disabled = true
	room_job_cancel_button.pressed.connect(_cancel_selected_system_job)
	buttons.add_child(room_job_cancel_button)
	room_job_log_button = Button.new()
	room_job_log_button.text = "Open Job Log"
	room_job_log_button.disabled = true
	room_job_log_button.pressed.connect(_open_selected_system_job_log)
	buttons.add_child(room_job_log_button)
	room_job_events_button = Button.new()
	room_job_events_button.text = "Job Events"
	room_job_events_button.disabled = true
	room_job_events_button.pressed.connect(_poll_selected_system_job_events)
	buttons.add_child(room_job_events_button)
	room_events_button = Button.new()
	room_events_button.text = "Event Log"
	room_events_button.pressed.connect(_load_system_events)
	buttons.add_child(room_events_button)
	room_model_button = Button.new()
	room_model_button.text = "Model Status"
	room_model_button.pressed.connect(_load_model_status)
	buttons.add_child(room_model_button)
	room_model_profiles_button = Button.new()
	room_model_profiles_button.text = "Model Profiles"
	room_model_profiles_button.pressed.connect(_load_model_profiles)
	buttons.add_child(room_model_profiles_button)
	room_model_config_button = Button.new()
	room_model_config_button.text = "Config Draft"
	room_model_config_button.pressed.connect(_create_model_config_draft)
	buttons.add_child(room_model_config_button)
	room_model_test_button = Button.new()
	room_model_test_button.text = "Test Profile"
	room_model_test_button.pressed.connect(_create_model_profile_test)
	buttons.add_child(room_model_test_button)
	room_model_key_vault_button = Button.new()
	room_model_key_vault_button.text = "Key Vault"
	room_model_key_vault_button.pressed.connect(_load_model_key_vault)
	buttons.add_child(room_model_key_vault_button)
	room_task_board_button = Button.new()
	room_task_board_button.text = "Task Board"
	room_task_board_button.pressed.connect(_load_task_board)
	buttons.add_child(room_task_board_button)
	room_create_task_button = Button.new()
	room_create_task_button.text = "Create Task"
	room_create_task_button.pressed.connect(_create_task_board_task)
	buttons.add_child(room_create_task_button)
	room_task_next_button = Button.new()
	room_task_next_button.text = "Next Task"
	room_task_next_button.disabled = true
	room_task_next_button.pressed.connect(_select_next_local_task)
	buttons.add_child(room_task_next_button)
	room_task_open_button = Button.new()
	room_task_open_button.text = "Open Task"
	room_task_open_button.disabled = true
	room_task_open_button.pressed.connect(_open_selected_task_detail)
	buttons.add_child(room_task_open_button)
	room_task_agent_button = Button.new()
	room_task_agent_button.text = "Task Agent"
	room_task_agent_button.disabled = true
	room_task_agent_button.pressed.connect(_submit_selected_task_agent_brief)
	buttons.add_child(room_task_agent_button)
	room_task_doing_button = Button.new()
	room_task_doing_button.text = "Doing"
	room_task_doing_button.disabled = true
	room_task_doing_button.pressed.connect(func(): _update_selected_task_status("in-progress"))
	buttons.add_child(room_task_doing_button)
	room_task_done_button = Button.new()
	room_task_done_button.text = "Done"
	room_task_done_button.disabled = true
	room_task_done_button.pressed.connect(func(): _update_selected_task_status("done"))
	buttons.add_child(room_task_done_button)
	room_writing_button = Button.new()
	room_writing_button.text = "Writing Desk"
	room_writing_button.pressed.connect(_load_writing_studio)
	buttons.add_child(room_writing_button)
	room_new_draft_button = Button.new()
	room_new_draft_button.text = "New Draft"
	room_new_draft_button.pressed.connect(_create_writing_draft)
	buttons.add_child(room_new_draft_button)
	room_automation_button = Button.new()
	room_automation_button.text = "Automations"
	room_automation_button.pressed.connect(_load_automation_factory)
	buttons.add_child(room_automation_button)
	room_automation_scheduler_button = Button.new()
	room_automation_scheduler_button.text = "Schedule"
	room_automation_scheduler_button.pressed.connect(_load_automation_scheduler)
	buttons.add_child(room_automation_scheduler_button)
	room_automation_draft_button = Button.new()
	room_automation_draft_button.text = "Draft Auto"
	room_automation_draft_button.pressed.connect(_create_automation_draft)
	buttons.add_child(room_automation_draft_button)
	room_permission_button = Button.new()
	room_permission_button.text = "Permissions"
	room_permission_button.pressed.connect(_load_permission_hall)
	buttons.add_child(room_permission_button)
	room_permission_secret_button = Button.new()
	room_permission_secret_button.text = "Secret Audit"
	room_permission_secret_button.pressed.connect(_load_permission_secret_audit)
	buttons.add_child(room_permission_secret_button)
	room_settings_button = Button.new()
	room_settings_button.text = "Settings"
	room_settings_button.pressed.connect(_load_settings_center)
	buttons.add_child(room_settings_button)
	room_registry_health_button = Button.new()
	room_registry_health_button.text = "Registry Health"
	room_registry_health_button.pressed.connect(_load_registry_health)
	buttons.add_child(room_registry_health_button)
	room_settings_draft_button = Button.new()
	room_settings_draft_button.text = "Draft Config"
	room_settings_draft_button.pressed.connect(_create_settings_draft)
	buttons.add_child(room_settings_draft_button)
	room_testing_button = Button.new()
	room_testing_button.text = "Test Arena"
	room_testing_button.pressed.connect(_load_testing_arena)
	buttons.add_child(room_testing_button)
	room_test_plan_button = Button.new()
	room_test_plan_button.text = "Test Plan"
	room_test_plan_button.pressed.connect(_create_test_plan)
	buttons.add_child(room_test_plan_button)
	room_vertical_proof_button = Button.new()
	room_vertical_proof_button.text = "Slice Proof"
	room_vertical_proof_button.pressed.connect(_create_vertical_slice_proof)
	buttons.add_child(room_vertical_proof_button)
	room_next_proof_button = Button.new()
	room_next_proof_button.text = "Next Proof"
	room_next_proof_button.disabled = true
	room_next_proof_button.pressed.connect(_select_next_vertical_proof)
	buttons.add_child(room_next_proof_button)
	room_open_proof_button = Button.new()
	room_open_proof_button.text = "Open Proof"
	room_open_proof_button.disabled = true
	room_open_proof_button.pressed.connect(_open_selected_vertical_proof)
	buttons.add_child(room_open_proof_button)
	room_bug_button = Button.new()
	room_bug_button.text = "Bug Clinic"
	room_bug_button.pressed.connect(_load_bug_clinic)
	buttons.add_child(room_bug_button)
	room_bug_report_button = Button.new()
	room_bug_report_button.text = "Bug Report"
	room_bug_report_button.pressed.connect(_create_bug_report)
	buttons.add_child(room_bug_report_button)
	room_project_management_button = Button.new()
	room_project_management_button.text = "Portfolio"
	room_project_management_button.pressed.connect(_load_project_management)
	buttons.add_child(room_project_management_button)
	room_project_brief_button = Button.new()
	room_project_brief_button.text = "Project Brief"
	room_project_brief_button.pressed.connect(_create_project_brief)
	buttons.add_child(room_project_brief_button)
	room_download_button = Button.new()
	room_download_button.text = "Downloads"
	room_download_button.pressed.connect(_load_download_station)
	buttons.add_child(room_download_button)
	room_download_triage_button = Button.new()
	room_download_triage_button.text = "Triage"
	room_download_triage_button.pressed.connect(_load_download_triage)
	buttons.add_child(room_download_triage_button)
	room_download_intake_button = Button.new()
	room_download_intake_button.text = "Intake Draft"
	room_download_intake_button.pressed.connect(_create_download_intake)
	buttons.add_child(room_download_intake_button)
	room_asset_button = Button.new()
	room_asset_button.text = "Asset Gallery"
	room_asset_button.pressed.connect(_load_asset_gallery)
	buttons.add_child(room_asset_button)
	room_asset_inspect_button = Button.new()
	room_asset_inspect_button.text = "Inspect Asset"
	room_asset_inspect_button.pressed.connect(_inspect_asset)
	buttons.add_child(room_asset_inspect_button)
	room_asset_note_button = Button.new()
	room_asset_note_button.text = "Asset Note"
	room_asset_note_button.pressed.connect(_create_asset_note)
	buttons.add_child(room_asset_note_button)
	room_office_button = Button.new()
	room_office_button.text = "Office Map"
	room_office_button.pressed.connect(_load_local_office_center)
	buttons.add_child(room_office_button)
	room_office_note_button = Button.new()
	room_office_note_button.text = "Office Note"
	room_office_note_button.pressed.connect(_create_office_note)
	buttons.add_child(room_office_note_button)
	room_schedule_button = Button.new()
	room_schedule_button.text = "Plan Center"
	room_schedule_button.pressed.connect(_load_schedule_plan_center)
	buttons.add_child(room_schedule_button)
	room_schedule_draft_button = Button.new()
	room_schedule_draft_button.text = "Schedule Draft"
	room_schedule_draft_button.pressed.connect(_create_schedule_draft)
	buttons.add_child(room_schedule_draft_button)
	room_learning_button = Button.new()
	room_learning_button.text = "Training"
	room_learning_button.pressed.connect(_load_learning_training)
	buttons.add_child(room_learning_button)
	room_learning_plan_button = Button.new()
	room_learning_plan_button.text = "Learn Plan"
	room_learning_plan_button.pressed.connect(_create_learning_plan)
	buttons.add_child(room_learning_plan_button)
	room_language_button = Button.new()
	room_language_button.text = "Language"
	room_language_button.pressed.connect(_load_language_learning)
	buttons.add_child(room_language_button)
	room_language_practice_button = Button.new()
	room_language_practice_button.text = "Phrase Note"
	room_language_practice_button.pressed.connect(_create_language_practice)
	buttons.add_child(room_language_practice_button)
	room_research_data_button = Button.new()
	room_research_data_button.text = "Data Center"
	room_research_data_button.pressed.connect(_load_research_data_center)
	buttons.add_child(room_research_data_button)
	room_research_data_note_button = Button.new()
	room_research_data_note_button.text = "Data Note"
	room_research_data_note_button.pressed.connect(_create_research_data_note)
	buttons.add_child(room_research_data_note_button)
	room_paper_reading_button = Button.new()
	room_paper_reading_button.text = "Papers"
	room_paper_reading_button.pressed.connect(_load_paper_reading_room)
	buttons.add_child(room_paper_reading_button)
	room_paper_citation_button = Button.new()
	room_paper_citation_button.text = "Cite Audit"
	room_paper_citation_button.pressed.connect(_load_paper_citation_audit)
	buttons.add_child(room_paper_citation_button)
	room_paper_note_button = Button.new()
	room_paper_note_button.text = "Read Note"
	room_paper_note_button.pressed.connect(_create_paper_reading_note)
	buttons.add_child(room_paper_note_button)
	room_paper_citation_note_button = Button.new()
	room_paper_citation_note_button.text = "Cite Note"
	room_paper_citation_note_button.pressed.connect(_create_paper_citation_audit_note)
	buttons.add_child(room_paper_citation_note_button)
	room_paper_extract_button = Button.new()
	room_paper_extract_button.text = "PDF Extract"
	room_paper_extract_button.disabled = true
	room_paper_extract_button.pressed.connect(_queue_paper_extraction)
	buttons.add_child(room_paper_extract_button)
	room_paper_extract_job_button = Button.new()
	room_paper_extract_job_button.text = "Check PDF"
	room_paper_extract_job_button.disabled = true
	room_paper_extract_job_button.pressed.connect(_poll_paper_extraction_job)
	buttons.add_child(room_paper_extract_job_button)
	room_release_button = Button.new()
	room_release_button.text = "Release"
	room_release_button.pressed.connect(_load_version_release_plaza)
	buttons.add_child(room_release_button)
	room_release_checklist_button = Button.new()
	room_release_checklist_button.text = "Rel Checklist"
	room_release_checklist_button.pressed.connect(_create_release_checklist)
	buttons.add_child(room_release_checklist_button)
	room_release_report_button = Button.new()
	room_release_report_button.text = "Rel Report"
	room_release_report_button.pressed.connect(_create_release_report)
	buttons.add_child(room_release_report_button)
	room_plugin_button = Button.new()
	room_plugin_button.text = "Plugins"
	room_plugin_button.pressed.connect(_load_plugin_registry)
	buttons.add_child(room_plugin_button)
	room_plugin_manifest_button = Button.new()
	room_plugin_manifest_button.text = "Manifests"
	room_plugin_manifest_button.pressed.connect(_load_plugin_manifests)
	buttons.add_child(room_plugin_manifest_button)
	room_plugin_draft_button = Button.new()
	room_plugin_draft_button.text = "Plugin Draft"
	room_plugin_draft_button.pressed.connect(_create_plugin_draft)
	buttons.add_child(room_plugin_draft_button)
	room_plugin_activation_button = Button.new()
	room_plugin_activation_button.text = "Plan Plugin"
	room_plugin_activation_button.pressed.connect(_create_plugin_activation_plan)
	buttons.add_child(room_plugin_activation_button)
	room_backup_button = Button.new()
	room_backup_button.text = "Backups"
	room_backup_button.pressed.connect(_load_backup_station)
	buttons.add_child(room_backup_button)
	room_backup_check_button = Button.new()
	room_backup_check_button.text = "Backup Check"
	room_backup_check_button.pressed.connect(_load_backup_integrity)
	buttons.add_child(room_backup_check_button)
	room_backup_plan_button = Button.new()
	room_backup_plan_button.text = "Backup Plan"
	room_backup_plan_button.pressed.connect(_create_backup_plan)
	buttons.add_child(room_backup_plan_button)
	room_goal_button = Button.new()
	room_goal_button.text = "Goal Map"
	room_goal_button.pressed.connect(_load_goal_tower)
	buttons.add_child(room_goal_button)
	room_goal_draft_button = Button.new()
	room_goal_draft_button.text = "Goal Draft"
	room_goal_draft_button.pressed.connect(_create_goal_draft)
	buttons.add_child(room_goal_draft_button)
	room_inspiration_button = Button.new()
	room_inspiration_button.text = "Ideas"
	room_inspiration_button.pressed.connect(_load_inspiration_station)
	buttons.add_child(room_inspiration_button)
	room_inspiration_note_button = Button.new()
	room_inspiration_note_button.text = "Idea Note"
	room_inspiration_note_button.pressed.connect(_create_inspiration_note)
	buttons.add_child(room_inspiration_note_button)
	room_temp_drafts_button = Button.new()
	room_temp_drafts_button.text = "Draft Box"
	room_temp_drafts_button.pressed.connect(_load_temporary_draft_box)
	buttons.add_child(room_temp_drafts_button)
	room_temp_draft_button = Button.new()
	room_temp_draft_button.text = "Scratch Note"
	room_temp_draft_button.pressed.connect(_create_temp_draft)
	buttons.add_child(room_temp_draft_button)
	room_scan_button = Button.new()
	room_scan_button.text = "Run Safe Scan"
	room_scan_button.pressed.connect(_run_safe_work_scan)
	buttons.add_child(room_scan_button)
	room_draft_button = Button.new()
	room_draft_button.text = "Prepare Draft"
	room_draft_button.pressed.connect(_prepare_work_note)
	buttons.add_child(room_draft_button)
	room_save_draft_button = Button.new()
	room_save_draft_button.text = "Confirm Save Draft"
	room_save_draft_button.disabled = true
	room_save_draft_button.pressed.connect(_confirm_save_work_note)
	buttons.add_child(room_save_draft_button)
	room_leave_button = Button.new()
	room_leave_button.text = "Leave Room"
	room_leave_button.pressed.connect(_leave_room)
	buttons.add_child(room_leave_button)

func _handle_world_click(world_pos: Vector2) -> void:
	for decor in map_decor_defs:
		var size: Vector2 = decor.get("size", Vector2(96, 36))
		var rect := Rect2(decor.get("pos", Vector2.ZERO) - size / 2.0, size)
		if rect.has_point(world_pos):
			_activate_map_decor(decor)
			return
	for district in district_defs:
		var rect := Rect2(district.portal_pos - Vector2(64, 24), Vector2(128, 48))
		if rect.has_point(world_pos):
			_travel_to_district(str(district.id))
			return
	for def in building_defs:
		var rect := Rect2(def.pos - def.size / 2.0, def.size)
		if rect.has_point(world_pos):
			_select_building(def.id)
			return
	for agent_id in agent_nodes.keys():
		if world_pos.distance_to(agent_nodes[agent_id].position) < 70.0:
			_select_agent(agent_id)
			return
	target_position = world_pos.clamp(Vector2(80, 120), MAP_SIZE - Vector2(80, 80))

func _interact_nearest() -> void:
	var nearest_decor: Dictionary = {}
	var nearest_decor_dist := 999999.0
	for decor in map_decor_defs:
		var dist := player.position.distance_to(decor.get("pos", Vector2.ZERO))
		if dist < nearest_decor_dist:
			nearest_decor_dist = dist
			nearest_decor = decor
	if nearest_decor_dist < 120.0 and not nearest_decor.is_empty():
		_activate_map_decor(nearest_decor)
		return
	var nearest_district := ""
	var nearest_portal_dist := 999999.0
	for district in district_defs:
		var portal_dist := player.position.distance_to(district.portal_pos)
		if portal_dist < nearest_portal_dist:
			nearest_portal_dist = portal_dist
			nearest_district = str(district.id)
	if nearest_portal_dist < 120.0 and nearest_district != "":
		_travel_to_district(nearest_district)
		return
	var nearest_agent := ""
	var nearest_dist := 999999.0
	for agent_id in agent_nodes.keys():
		var dist := player.position.distance_to(agent_nodes[agent_id].position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest_agent = agent_id
	if nearest_dist < 140.0:
		_select_agent(nearest_agent)
		return
	for def in building_defs:
		var dist := player.position.distance_to(def.pos)
		if dist < 170.0:
			_select_building(def.id)
			return

func _activate_map_decor(decor: Dictionary) -> void:
	var action_id := str(decor.get("action", ""))
	var name := str(decor.get("name", decor.get("id", "Landmark")))
	_set_waypoint(str(decor.get("id", "")), name, str(decor.get("description", "")), decor.get("pos", player.position))
	_record_activity("Landmark", name, "map")
	detail_title.text = name
	detail_body.text = "[b]%s[/b]\n%s\n\nAction: %s\nSafety: in-game routing only unless the selected room action already has its own backend safety boundary." % [name, decor.get("description", ""), action_id]
	if action_id == "plaza_overview":
		status_label.text = "Agent Town Godot | Central Plaza | Quest board, daily routes, agents, portals"
		target_position = decor.get("pos", target_position)
	elif action_id == "show_badges":
		_update_badge_case()
		quest_body.text = "[b]Memory Fountain[/b]\nBadge Case refreshed from local save data."
	elif action_id == "load_quests":
		_request_quests()
	elif action_id == "load_daily_routes":
		_request_daily_routes()
	elif action_id.begins_with("district:"):
		_travel_to_district(action_id.substr("district:".length()))
	elif action_id.begins_with("select_agent:"):
		_select_agent(action_id.substr("select_agent:".length()))
	elif action_id.begins_with("select_building:"):
		_select_building(action_id.substr("select_building:".length()))

func _set_waypoint(waypoint_id: String, title: String, hint: String, pos: Vector2) -> void:
	active_waypoint_id = waypoint_id
	active_waypoint_title = title
	active_waypoint_hint = hint
	active_waypoint_pos = pos
	_update_waypoint_distance()

func _set_waypoint_for_building(building_id: String, hint: String = "") -> void:
	var def := _building_def(building_id)
	var name := str(def.get("name", building_id))
	var role := str(def.get("role", "local work building"))
	if hint == "":
		hint = role
	_set_waypoint("building:%s" % building_id, name, hint, def.get("pos", player.position))

func _set_waypoint_for_district(district: Dictionary) -> void:
	_set_waypoint("district:%s" % str(district.get("id", "")), "%s District" % district.get("name", "Town"), str(district.get("role", "map region")), district.get("anchor", player.position))

func _update_waypoint_distance() -> void:
	if waypoint_body == null:
		return
	if active_waypoint_id == "":
		waypoint_body.text = "[b]Waypoint[/b]\nSelect a landmark, route, building, or district."
		return
	var distance := int(player.position.distance_to(active_waypoint_pos))
	waypoint_body.text = "[b]Waypoint:[/b] %s  |  %s px\n%s" % [active_waypoint_title, str(distance), active_waypoint_hint]

func _record_activity(title: String, body: String = "", category: String = "local") -> void:
	var entry: Dictionary = {
		"time": Time.get_datetime_string_from_system(true),
		"title": title,
		"body": body,
		"category": category,
	}
	activity_log.push_front(entry)
	while activity_log.size() > ACTIVITY_LOG_LIMIT:
		activity_log.pop_back()
	_render_activity_log()
	_save_progress()

func _render_activity_log() -> void:
	if activity_body == null:
		return
	var lines := ["[b]Activity[/b]"]
	if activity_log.is_empty():
		lines.append("No recent activity yet.")
	else:
		for raw_entry in activity_log.slice(0, min(3, activity_log.size())):
			if typeof(raw_entry) != TYPE_DICTIONARY:
				continue
			var entry: Dictionary = raw_entry
			var timestamp := str(entry.get("time", ""))
			var clock := timestamp
			if timestamp.contains("T"):
				clock = timestamp.get_slice("T", 1).substr(0, 8)
			var line := "%s | %s" % [clock, entry.get("title", "Activity")]
			var body := str(entry.get("body", ""))
			if body != "":
				line += " - %s" % body.substr(0, 42)
			lines.append(line)
	activity_body.text = "\n".join(lines)

func _select_agent(agent_id: String) -> void:
	active_agent_id = agent_id
	active_building_id = ""
	var def = agents[agent_id]
	_set_waypoint("agent:%s" % agent_id, str(def.name), "Talk, coordinate, or use nearby Agent Hub workflows.", def.pos)
	_record_activity("Agent selected", "%s | %s" % [def.name, def.role], "agent")
	detail_title.text = "%s | %s" % [def.name, def.role]
	detail_body.text = "[b]Resident selected.[/b]\nTalk to this agent. Command-like messages are routed through the backend dialogue endpoint.\n\nNearby gameplay loop: select agent -> assign work -> inspect local building state."
	dialogue_button.disabled = false
	action_button.disabled = true
	room_button.disabled = true

func _select_building(building_id: String) -> void:
	active_building_id = building_id
	active_agent_id = ""
	var def := _building_def(building_id)
	_set_waypoint_for_building(building_id, "Enter room, inspect real local data, then use safe workbench actions.")
	_record_activity("Building selected", "%s | %s" % [def.name, def.role], "building")
	detail_title.text = def.name
	detail_body.text = "[b]%s[/b]\n%s\n\nLoading real local data...\n\nQuest hint: accept a matching quest, then scan this building to complete it." % [def.name, def.role]
	dialogue_button.disabled = true
	action_button.disabled = false
	room_button.disabled = false
	pending_request = "building:%s" % building_id
	var err := http.request("%s/api/buildings/%s" % [API_BASE, building_id])
	if err != OK:
		_show_local_building_fallback(building_id)

func _travel_to_district(district_id: String) -> void:
	for district in district_defs:
		if str(district.id) != district_id:
			continue
		active_district_id = district_id
		active_agent_id = ""
		active_building_id = ""
		target_position = district.anchor.clamp(Vector2(80, 120), MAP_SIZE - Vector2(80, 80))
		player.position = target_position
		camera.position = target_position
		camera.zoom = Vector2(0.85, 0.85)
		_set_waypoint_for_district(district)
		_record_activity("District travel", "%s District" % district.name, "map")
		var building_names := []
		for building_id in district.get("buildings", []):
			var def := _building_def(str(building_id))
			building_names.append(def.get("name", str(building_id)))
		detail_title.text = "%s District" % district.name
		detail_body.text = "[b]%s[/b]\n%s\n\nConnected buildings:\n- %s\n\nThis is data-driven map routing from `godot/data/districts.json`. It only moves the in-game player/camera." % [district.name, district.get("role", ""), "\n- ".join(building_names)]
		dialogue_button.disabled = true
		action_button.disabled = true
		room_button.disabled = true
		status_label.text = "Agent Town Godot | District: %s | Click buildings or portals, E interacts" % district.name
		return

func _send_dialogue() -> void:
	if active_agent_id == "" or dialogue_input.text.strip_edges() == "":
		return
	var payload := JSON.stringify({"agent_id": active_agent_id, "message": dialogue_input.text.strip_edges()})
	pending_request = "dialogue:%s" % active_agent_id
	detail_body.text += "\n\n[b]Mayor:[/b] %s\n[i]Waiting for backend...[/i]" % dialogue_input.text.strip_edges()
	dialogue_input.text = ""
	var headers := PackedStringArray(["Content-Type: application/json"])
	var err := http.request("%s/api/dialogue" % API_BASE, headers, HTTPClient.METHOD_POST, payload)
	if err != OK:
		detail_body.text += "\nBackend request failed before sending."

func _request_health() -> void:
	pending_request = "health"
	http.request("%s/api/health" % API_BASE)

func _request_quests() -> void:
	var err := quest_http.request("%s/api/workbench/quests" % API_BASE)
	if err != OK:
		quest_body.text = "Quest backend unavailable. Start backend for live work quests."

func _request_daily_routes() -> void:
	daily_claim_button.disabled = true
	quest_body.text = "[b]Daily Routes[/b]\nLoading today's local-work routes..."
	var err := daily_http.request("%s/api/workbench/daily-routes" % API_BASE)
	if err != OK:
		quest_body.text = "Daily route backend unavailable. Start backend for live route cards."

func _request_collection_codex() -> void:
	quest_body.text = "[b]Collection Codex[/b]\nLoading collectible catalog..."
	var err := collection_http.request("%s/api/player/collection-codex" % API_BASE)
	if err != OK:
		quest_body.text = "Collection Codex backend unavailable. Badge Case still shows local saved progress."

func _run_safe_work_scan() -> void:
	_send_workbench_action("scan-current-building")

func _prepare_work_note() -> void:
	_send_workbench_action("prepare-work-note")

func _confirm_save_work_note() -> void:
	_send_workbench_action("confirm-save-work-note", pending_draft_confirmation)

func _send_workbench_action(action_id: String, confirmation: String = "") -> void:
	if active_building_id == "":
		return
	var request := {"action_id": action_id, "building_id": active_building_id}
	if confirmation != "":
		request["confirmation"] = confirmation
	var payload := JSON.stringify(request)
	var headers := PackedStringArray(["Content-Type: application/json"])
	detail_body.text += "\n\n[i]Running workbench action: %s...[/i]" % action_id
	var err := action_http.request("%s/api/workbench/action" % API_BASE, headers, HTTPClient.METHOD_POST, payload)
	if err != OK:
		detail_body.text += "\nCould not start workbench action."

func _enter_selected_room() -> void:
	if active_building_id == "":
		return
	current_room_id = active_building_id
	selected_memory_category = ""
	selected_memory_filename = ""
	selected_memory_proposal_id = ""
	pending_memory_promotion_confirmation = ""
	room_memory_detail_button.disabled = true
	room_memory_promote_button.disabled = true
	room_memory_promote_button.text = "Promote"
	selected_file_root_id = ""
	selected_file_path = ""
	selected_file_kind = ""
	room_file_open_button.disabled = true
	room_file_reveal_button.disabled = true
	room_file_preview_button.disabled = true
	room_file_tag_button.disabled = true
	room_file_organize_button.disabled = true
	selected_knowledge_doc_id = ""
	room_knowledge_detail_button.disabled = true
	selected_research_project_id = ""
	research_project_ids = []
	room_project_detail_button.disabled = true
	room_research_agent_button.disabled = true
	room_research_log_button.disabled = true
	selected_project_id = ""
	selected_project_job_id = ""
	pending_project_verification_confirmation = false
	room_local_project_detail_button.disabled = true
	room_code_task_button.disabled = true
	room_code_context_button.disabled = true
	room_code_patch_plan_button.disabled = true
	room_code_agent_button.disabled = true
	room_code_explain_button.disabled = true
	room_code_verify_button.disabled = true
	room_code_check_job_button.disabled = true
	current_agent_chat_id = ""
	last_agent_chat_tool_suggestions = []
	room_agent_chat_send_button.disabled = true
	room_agent_chat_tool_button.disabled = true
	selected_agent_roster_id = ""
	selected_agent_runner_handoff_path = ""
	room_agent_runner_launch_button.disabled = true
	room_agent_companion_button.disabled = true
	agent_task_cards = []
	selected_agent_task_id = ""
	selected_agent_task_index = 0
	agent_task_pending_action = ""
	selected_agent_task_event_cursor = 0
	_sync_agent_task_buttons()
	agent_tool_invocation_cards = []
	selected_agent_tool_invocation_id = ""
	selected_agent_tool_invocation_index = 0
	selected_agent_tool_event_cursor = 0
	_sync_agent_tool_buttons()
	selected_harbor_repo_id = ""
	room_harbor_detail_button.disabled = true
	room_harbor_github_button.disabled = true
	room_harbor_readiness_button.disabled = true
	room_harbor_draft_button.disabled = true
	room_harbor_publish_plan_button.disabled = true
	local_task_cards = []
	selected_task_id = ""
	selected_task_index = 0
	room_task_next_button.disabled = true
	room_task_open_button.disabled = true
	room_task_agent_button.disabled = true
	room_task_doing_button.disabled = true
	room_task_done_button.disabled = true
	town_capability_cards = []
	selected_town_capability_id = ""
	selected_town_capability_index = 0
	room_capability_next_button.disabled = true
	room_capability_open_button.disabled = true
	town_workflow_cards = []
	selected_town_workflow_id = ""
	selected_town_workflow_index = 0
	room_workflow_next_button.disabled = true
	room_workflow_open_button.disabled = true
	var def := _building_def(active_building_id)
	camera.zoom = Vector2(1.15, 1.15)
	target_position = def.pos + Vector2(0, def.size.y / 2.0 + 80.0)
	room_overlay.visible = true
	room_title.text = "%s Interior" % def.name
	room_body.text = "[b]%s[/b]\n%s\n\nLoading room shelves and workbench..." % [def.name, def.role]
	detail_body.text = "[b]Entered:[/b] %s\nUse the room panel for local work actions, references, and quest progress." % def.name
	_record_activity("Entered room", "%s Interior" % def.name, "room")
	_record_room_mastery(active_building_id, "visit", 1, false)
	_record_npc_chain_action("enter_room", active_building_id)
	_advance_quest_step("enter_room", active_building_id)
	_mark_daily_route_visit(active_building_id)
	_mark_workflow_route_visit(active_building_id)
	var err := room_http.request("%s/api/workbench/rooms/%s" % [API_BASE, active_building_id])
	if err != OK:
		room_body.text = "[b]%s[/b]\nRoom backend unavailable. You can still run a safe scan from the console." % def.name

func _load_research_projects() -> void:
	if current_room_id != "research-hall":
		room_body.text += "\n\n[b]Research console[/b]\nEnter Research Hall to load real project boards."
		return
	room_body.text += "\n\n[i]Loading real research projects from D:\\Research and shared memory...[/i]"
	var err := research_http.request("%s/api/research/projects" % API_BASE)
	if err != OK:
		room_body.text += "\nResearch index request failed."

func _load_selected_research_project() -> void:
	if current_room_id != "research-hall" or selected_research_project_id == "":
		return
	room_body.text += "\n\n[i]Opening project detail: %s...[/i]" % selected_research_project_id
	var err := research_http.request("%s/api/research/projects/%s" % [API_BASE, selected_research_project_id])
	if err != OK:
		room_body.text += "\nResearch detail request failed."

func _submit_research_agent_task() -> void:
	if current_room_id != "research-hall" or selected_research_project_id == "":
		room_body.text += "\n\n[b]Research console[/b]\nSelect a research project first."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"target_agent": "aris",
		"task_type": "research-brief",
		"title": "Research brief for %s" % selected_research_project_id,
		"body": "Build a bounded read-only ARIS-style brief for the selected research project.",
		"source_building": "research-hall",
		"parameters": {
			"project_id": selected_research_project_id
		}
	}
	room_body.text += "\n\n[i]Queueing safe research brief through Agent Task Queue...[/i]"
	var err := agent_task_http.request("%s/api/agent-tasks/submit" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nResearch agent task request failed."

func _create_research_log_draft() -> void:
	if current_room_id != "research-hall" or selected_research_project_id == "":
		room_body.text += "\n\n[b]Research console[/b]\nSelect a research project first."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "Research log for %s" % selected_research_project_id,
		"focus": "next-safe-action",
		"body": "Capture current project evidence, risks, and next safe action from AI Town Research Hall.",
		"source_building": "research-hall"
	}
	room_body.text += "\n\n[i]Creating project-local research log draft...[/i]"
	var err := research_http.request("%s/api/research/projects/%s/logs" % [API_BASE, selected_research_project_id], headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nResearch log draft request failed."

func _load_memory_index() -> void:
	if current_room_id != "memory-library":
		room_body.text += "\n\n[b]Memory console[/b]\nEnter Memory Library to load real shared memory shelves."
		return
	room_body.text += "\n\n[i]Loading shared memory shelves from D:\\research\\Vipin's Knowledgebase\\memory...[/i]"
	var err := memory_http.request("%s/api/memory/index" % API_BASE)
	if err != OK:
		room_body.text += "\nMemory index request failed."

func _load_selected_memory_item() -> void:
	if current_room_id != "memory-library" or selected_memory_category == "" or selected_memory_filename == "":
		return
	room_body.text += "\n\n[i]Opening memory note: %s/%s...[/i]" % [selected_memory_category, selected_memory_filename]
	var err := memory_http.request("%s/api/memory/items/%s/%s" % [API_BASE, selected_memory_category, selected_memory_filename])
	if err != OK:
		room_body.text += "\nMemory detail request failed."

func _create_memory_proposal() -> void:
	if current_room_id != "memory-library":
		room_body.text += "\n\n[b]Memory console[/b]\nEnter Memory Library to create a memory proposal."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "AI Town memory proposal",
		"body": "Record a reviewed AI Town progress note here before promoting it into shared memory.",
		"category": "sessions",
		"tags": "ai-town,proposal,memory-library",
		"source_building": "memory-library"
	}
	room_body.text += "\n\n[i]Creating project-local memory proposal...[/i]"
	var err := memory_http.request("%s/api/memory/proposals" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nMemory proposal request failed."

func _promote_memory_proposal() -> void:
	if current_room_id != "memory-library":
		room_body.text += "\n\n[b]Memory console[/b]\nEnter Memory Library to promote a reviewed proposal."
		return
	if selected_memory_proposal_id == "":
		room_body.text += "\n\nNo memory proposal is selected. Load Memory Shelves after creating a proposal."
		return
	var request := {
		"proposal_id": selected_memory_proposal_id,
		"source_building": "memory-library"
	}
	if pending_memory_promotion_confirmation != "":
		request["confirmation"] = pending_memory_promotion_confirmation
	room_body.text += "\n\n[i]Requesting shared memory promotion%s...[/i]" % (" confirmation" if pending_memory_promotion_confirmation != "" else " preview")
	var headers := PackedStringArray(["Content-Type: application/json"])
	var err := memory_http.request("%s/api/memory/promotions" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nMemory promotion request failed."

func _load_knowledge_index() -> void:
	if current_room_id != "knowledge-tower":
		room_body.text += "\n\n[b]Knowledge console[/b]\nEnter Knowledge Tower to inspect the cached allowlisted index."
		return
	room_body.text += "\n\n[i]Loading cached allowlisted knowledge index...[/i]"
	var err := knowledge_http.request("%s/api/knowledge/index" % API_BASE)
	if err != OK:
		room_body.text += "\nKnowledge index request failed."

func _refresh_knowledge_index() -> void:
	if current_room_id != "knowledge-tower":
		room_body.text += "\n\n[b]Knowledge console[/b]\nEnter Knowledge Tower to refresh the local index."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	room_body.text += "\n\n[i]Queueing bounded knowledge index refresh in the backend job queue...[/i]"
	var err := knowledge_http.request("%s/api/knowledge/index-job" % API_BASE, headers, HTTPClient.METHOD_POST, "{}")
	if err != OK:
		room_body.text += "\nKnowledge refresh request failed."

func _search_knowledge() -> void:
	if current_room_id != "knowledge-tower":
		room_body.text += "\n\n[b]Knowledge console[/b]\nEnter Knowledge Tower to search local knowledge."
		return
	room_body.text += "\n\n[i]Searching cached knowledge for AI Town and memory signals...[/i]"
	var err := knowledge_http.request("%s/api/knowledge/search?q=%s&page_size=10" % [API_BASE, "ai town memory".uri_encode()])
	if err != OK:
		room_body.text += "\nKnowledge search request failed."

func _load_selected_knowledge_item() -> void:
	if current_room_id != "knowledge-tower" or selected_knowledge_doc_id == "":
		return
	room_body.text += "\n\n[i]Opening indexed knowledge item: %s...[/i]" % selected_knowledge_doc_id
	var err := knowledge_http.request("%s/api/knowledge/items/%s" % [API_BASE, selected_knowledge_doc_id])
	if err != OK:
		room_body.text += "\nKnowledge item request failed."

func _load_file_roots() -> void:
	if current_room_id != "file-vault":
		room_body.text += "\n\n[b]File console[/b]\nEnter File Vault to browse allowlisted local folders."
		return
	room_body.text += "\n\n[i]Loading allowlisted D-drive file roots...[/i]"
	var err := file_http.request("%s/api/file-vault/roots" % API_BASE)
	if err != OK:
		room_body.text += "\nFile root request failed."

func _refresh_file_index() -> void:
	if current_room_id != "file-vault":
		room_body.text += "\n\n[b]File console[/b]\nEnter File Vault to refresh the cached file index."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	room_body.text += "\n\n[i]Queueing bounded File Vault index refresh...[/i]"
	var err := file_http.request("%s/api/file-vault/index-job" % API_BASE, headers, HTTPClient.METHOD_POST, "{}")
	if err != OK:
		room_body.text += "\nFile index refresh request failed."

func _search_file_vault() -> void:
	if current_room_id != "file-vault":
		room_body.text += "\n\n[b]File console[/b]\nEnter File Vault to search indexed files."
		return
	room_body.text += "\n\n[i]Searching cached File Vault index for AI Town docs...[/i]"
	var err := file_http.request("%s/api/file-vault/search?q=%s&page_size=10" % [API_BASE, "ai town".uri_encode()])
	if err != OK:
		room_body.text += "\nFile search request failed."

func _load_file_organize_audit() -> void:
	if current_room_id != "file-vault":
		room_body.text += "\n\n[b]File console[/b]\nEnter File Vault to audit cached organization signals."
		return
	room_body.text += "\n\n[i]Auditing cached File Vault organization signals...[/i]"
	var err := file_http.request("%s/api/file-vault/organize-audit" % API_BASE)
	if err != OK:
		room_body.text += "\nFile organization audit request failed."

func _tag_selected_file() -> void:
	if current_room_id != "file-vault" or selected_file_root_id == "" or selected_file_path == "":
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"root_id": selected_file_root_id,
		"path": selected_file_path,
		"tag": "review",
		"note": "Marked from AI Town File Vault for follow-up review."
	}
	room_body.text += "\n\n[i]Saving project-local file tag. Source file will not be modified...[/i]"
	var err := file_http.request("%s/api/file-vault/tags" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nFile tag request failed."

func _open_selected_file_folder() -> void:
	if current_room_id != "file-vault" or selected_file_root_id == "":
		return
	if selected_file_kind != "dir" and selected_file_path != "":
		room_body.text += "\n\n[b]File console[/b]\nSelected item is not a folder."
		return
	var query := ""
	if selected_file_path != "":
		query = "?path=%s" % selected_file_path.uri_encode()
	room_body.text += "\n\n[i]Opening folder: %s/%s...[/i]" % [selected_file_root_id, selected_file_path]
	var err := file_http.request("%s/api/file-vault/list/%s%s" % [API_BASE, selected_file_root_id, query])
	if err != OK:
		room_body.text += "\nFile listing request failed."

func _reveal_selected_file_item() -> void:
	if current_room_id != "file-vault" or selected_file_root_id == "":
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"root_id": selected_file_root_id,
		"path": selected_file_path,
		"mode": "reveal",
		"source_building": "file-vault"
	}
	room_body.text += "\n\n[i]Revealing allowlisted local item: %s/%s. No file contents will change...[/i]" % [selected_file_root_id, selected_file_path]
	var err := file_http.request("%s/api/file-vault/open" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nFile reveal request failed."

func _preview_selected_file() -> void:
	if current_room_id != "file-vault" or selected_file_root_id == "" or selected_file_path == "":
		return
	if selected_file_kind != "file":
		room_body.text += "\n\n[b]File console[/b]\nSelected item is not a file."
		return
	room_body.text += "\n\n[i]Previewing file: %s/%s...[/i]" % [selected_file_root_id, selected_file_path]
	var err := file_http.request("%s/api/file-vault/preview/%s?path=%s" % [API_BASE, selected_file_root_id, selected_file_path.uri_encode()])
	if err != OK:
		room_body.text += "\nFile preview request failed."

func _create_file_organize_proposal() -> void:
	if current_room_id != "file-vault" or selected_file_root_id == "":
		room_body.text += "\n\n[b]File console[/b]\nSelect a File Vault root or item first."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"root_id": selected_file_root_id,
		"path": selected_file_path,
		"title": "AI Town file organization proposal",
		"strategy": "review-and-group",
		"source_building": "file-vault"
	}
	room_body.text += "\n\n[i]Creating proposal-only file organization plan. Source files will not be modified...[/i]"
	var err := file_http.request("%s/api/file-vault/organize-proposals" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nFile organize proposal request failed."

func _load_agent_roster() -> void:
	if current_room_id != "agent-hub":
		room_body.text += "\n\n[b]Agent console[/b]\nEnter Agent Hub to inspect real local agent launchers and mailbox state."
		return
	room_body.text += "\n\n[i]Loading real local agent roster from D:\\devtools...[/i]"
	var err := agent_hub_http.request("%s/api/agent-hub/roster" % API_BASE)
	if err != OK:
		room_body.text += "\nAgent roster request failed."

func _create_agent_dispatch_draft() -> void:
	if current_room_id != "agent-hub":
		room_body.text += "\n\n[b]Agent console[/b]\nEnter Agent Hub to prepare a safe dispatch draft."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"target_agent": "codex",
		"task_title": "AI Town next implementation slice",
		"task_body": "Inspect the active Godot rebuild and propose the next safe implementation slice with tests.",
		"source_building": "agent-hub"
	}
	room_body.text += "\n\n[i]Creating project-local dispatch draft. This will not send or run an agent.[/i]"
	var err := agent_hub_http.request("%s/api/agent-hub/dispatch-drafts" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nDispatch draft request failed."

func _load_agent_runner_readiness() -> void:
	if current_room_id != "agent-hub":
		room_body.text += "\n\n[b]Agent console[/b]\nEnter Agent Hub to inspect real runner readiness."
		return
	room_body.text += "\n\n[i]Checking local agent runner readiness without launching anything...[/i]"
	var err := agent_hub_http.request("%s/api/agent-runners/readiness" % API_BASE)
	if err != OK:
		room_body.text += "\nAgent runner readiness request failed."

func _create_agent_runner_dispatch_preview() -> void:
	if current_room_id != "agent-hub":
		room_body.text += "\n\n[b]Agent console[/b]\nEnter Agent Hub to prepare a runner dispatch preview."
		return
	var target := selected_agent_roster_id
	if target == "":
		target = "codex"
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"target_agent": target,
		"task_title": "AI Town runner handoff preview",
		"task_body": "Inspect the active Godot rebuild, use shared memory, and propose the next safe implementation slice with verification.",
		"source_building": "agent-hub",
		"dry_run": true
	}
	room_body.text += "\n\n[i]Creating confirm-required runner dispatch preview for %s. No runner will be launched.[/i]" % target
	var err := agent_hub_http.request("%s/api/agent-runners/dispatch-preview" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nAgent runner dispatch preview request failed."

func _preview_agent_runner_launch_gate() -> void:
	if current_room_id != "agent-hub":
		room_body.text += "\n\n[b]Agent console[/b]\nEnter Agent Hub to inspect the runner launch gate."
		return
	if selected_agent_runner_handoff_path == "":
		room_body.text += "\n\nCreate a Runner Plan first. The launch gate only previews a selected handoff file."
		return
	var target := selected_agent_roster_id
	if target == "":
		target = "codex"
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"target_agent": target,
		"handoff_path": selected_agent_runner_handoff_path,
		"source_building": "agent-hub",
		"dry_run": true
	}
	room_body.text += "\n\n[i]Previewing runner launch gate for %s. No runner will be launched.[/i]" % target
	var err := agent_hub_http.request("%s/api/agent-runners/launch-jobs" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nAgent runner launch gate request failed."

func _start_agent_chat() -> void:
	if current_room_id != "agent-hub":
		room_body.text += "\n\n[b]Agent console[/b]\nEnter Agent Hub to open a persistent local agent chat."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"agent_id": "codex",
		"title": "AI Town operator chat",
		"source_building": "agent-hub",
		"context": {
			"room": current_room_id
		}
	}
	room_body.text += "\n\n[i]Opening project-local Agent Chat session...[/i]"
	var err := agent_hub_http.request("%s/api/agent-chat/sessions" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nAgent chat session request failed."

func _send_agent_chat_message() -> void:
	if current_room_id != "agent-hub" or current_agent_chat_id == "":
		room_body.text += "\n\n[b]Agent console[/b]\nOpen Agent Chat first."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"message": "Review current AI Town memory, knowledge, and system status; suggest safe tools I can run next, and keep this chat logged.",
		"source_building": "agent-hub",
		"context": {
			"room": current_room_id,
			"intent": "safe-local-workflow"
		}
	}
	room_body.text += "\n\n[i]Sending message to local Agent Chat session...[/i]"
	var err := agent_hub_http.request("%s/api/agent-chat/sessions/%s/messages" % [API_BASE, current_agent_chat_id], headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nAgent chat message request failed."

func _run_suggested_agent_chat_tool() -> void:
	if current_room_id != "agent-hub":
		room_body.text += "\n\n[b]Agent console[/b]\nEnter Agent Hub to run a suggested safe tool."
		return
	if last_agent_chat_tool_suggestions.is_empty():
		room_body.text += "\n\nNo suggested chat tools are available yet. Send Agent Chat first."
		return
	var tool_id := str(last_agent_chat_tool_suggestions[0])
	var parameters := {}
	if tool_id == "knowledge-search":
		parameters = {"q": "memory", "page_size": 5}
	elif tool_id == "file-search":
		parameters = {"q": "README", "page_size": 5}
	elif tool_id == "project-index":
		parameters = {"limit": 8}
	elif tool_id == "memory-index":
		parameters = {"limit_per_category": 2}
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"tool_id": tool_id,
		"target_agent": "codex",
		"parameters": parameters,
		"source_building": "agent-chat-suggestion"
	}
	room_body.text += "\n\n[i]Queueing suggested safe tool from Agent Chat: %s...[/i]" % tool_id
	var err := agent_tool_http.request("%s/api/agent-tools/invoke" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nSuggested tool invocation request failed."

func _load_agent_tasks() -> void:
	if current_room_id != "agent-hub":
		room_body.text += "\n\n[b]Agent console[/b]\nEnter Agent Hub to inspect the safe local task queue."
		return
	room_body.text += "\n\n[i]Loading safe local agent task queue...[/i]"
	var err := agent_task_http.request("%s/api/agent-tasks/queue" % API_BASE)
	if err != OK:
		room_body.text += "\nAgent task queue request failed."

func _load_agent_task_policy() -> void:
	if current_room_id != "agent-hub":
		room_body.text += "\n\n[b]Agent console[/b]\nEnter Agent Hub to inspect task concurrency policy."
		return
	room_body.text += "\n\n[i]Loading Agent Task Queue concurrency policy...[/i]"
	var err := agent_task_http.request("%s/api/agent-tasks/policy" % API_BASE)
	if err != OK:
		room_body.text += "\nAgent task policy request failed."

func _load_agent_task_logs() -> void:
	if current_room_id != "agent-hub":
		room_body.text += "\n\n[b]Agent console[/b]\nEnter Agent Hub to inspect durable agent task logs."
		return
	room_body.text += "\n\n[i]Loading durable Agent Task Queue logs...[/i]"
	var err := agent_task_http.request("%s/api/agent-tasks/logs?limit=12" % API_BASE)
	if err != OK:
		room_body.text += "\nAgent task logs request failed."

func _submit_agent_task() -> void:
	if current_room_id != "agent-hub":
		room_body.text += "\n\n[b]Agent console[/b]\nEnter Agent Hub to queue a safe local brief task."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"target_agent": "codex",
		"task_type": "memory-brief",
		"title": "Agent Hub memory brief",
		"body": "Summarize current shared memory shelves for the AI Town local-work loop.",
		"source_building": "agent-hub"
	}
	room_body.text += "\n\n[i]Queueing a bounded local read-only agent task...[/i]"
	var err := agent_task_http.request("%s/api/agent-tasks/submit" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nAgent task submit request failed."

func _select_next_agent_task() -> void:
	if agent_task_cards.is_empty():
		room_body.text += "\n\nNo agent tasks are loaded yet. Use Agent Tasks first."
		return
	selected_agent_task_index = (selected_agent_task_index + 1) % agent_task_cards.size()
	var task: Dictionary = agent_task_cards[selected_agent_task_index]
	selected_agent_task_id = str(task.get("id", ""))
	selected_agent_task_event_cursor = 0
	_render_agent_task_queue_from_cache()

func _open_selected_agent_task_result() -> void:
	if selected_agent_task_id == "":
		room_body.text += "\n\nNo agent task is selected yet. Use Agent Tasks first."
		return
	room_body.text += "\n\n[i]Opening agent task result %s...[/i]" % selected_agent_task_id
	agent_task_pending_action = "detail"
	var err := agent_task_http.request("%s/api/agent-tasks/%s" % [API_BASE, selected_agent_task_id])
	if err != OK:
		agent_task_pending_action = ""
		room_body.text += "\nAgent task detail request failed."

func _load_selected_agent_task_events() -> void:
	if selected_agent_task_id == "":
		room_body.text += "\n\nNo agent task is selected yet. Use Agent Tasks first."
		return
	room_body.text += "\n\n[i]Loading task events for %s...[/i]" % selected_agent_task_id
	agent_task_pending_action = "events"
	var err := agent_task_http.request("%s/api/agent-tasks/%s/events?since=%s&limit=24" % [API_BASE, selected_agent_task_id, str(selected_agent_task_event_cursor)])
	if err != OK:
		agent_task_pending_action = ""
		room_body.text += "\nAgent task events request failed."

func _pause_selected_agent_task() -> void:
	if selected_agent_task_id == "":
		room_body.text += "\n\nNo agent task is selected yet. Use Agent Tasks first."
		return
	room_body.text += "\n\n[i]Pausing agent task %s...[/i]" % selected_agent_task_id
	agent_task_pending_action = "pause"
	var err := agent_task_http.request("%s/api/agent-tasks/%s/pause" % [API_BASE, selected_agent_task_id], PackedStringArray(), HTTPClient.METHOD_POST)
	if err != OK:
		agent_task_pending_action = ""
		room_body.text += "\nAgent task pause request failed."

func _cancel_selected_agent_task() -> void:
	if selected_agent_task_id == "":
		room_body.text += "\n\nNo agent task is selected yet. Use Agent Tasks first."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"reason": "Cancelled from Godot Agent Hub controls.",
		"source_building": "agent-hub"
	}
	room_body.text += "\n\n[i]Cancelling agent task %s...[/i]" % selected_agent_task_id
	agent_task_pending_action = "cancel"
	var err := agent_task_http.request("%s/api/agent-tasks/%s/cancel" % [API_BASE, selected_agent_task_id], headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		agent_task_pending_action = ""
		room_body.text += "\nAgent task cancel request failed."

func _resume_selected_agent_task() -> void:
	if selected_agent_task_id == "":
		room_body.text += "\n\nNo agent task is selected yet. Use Agent Tasks first."
		return
	room_body.text += "\n\n[i]Resuming agent task %s...[/i]" % selected_agent_task_id
	agent_task_pending_action = "resume"
	var err := agent_task_http.request("%s/api/agent-tasks/%s/resume" % [API_BASE, selected_agent_task_id], PackedStringArray(), HTTPClient.METHOD_POST)
	if err != OK:
		agent_task_pending_action = ""
		room_body.text += "\nAgent task resume request failed."

func _load_agent_tools() -> void:
	if current_room_id != "agent-hub":
		room_body.text += "\n\n[b]Agent console[/b]\nEnter Agent Hub to inspect safe registered tools."
		return
	room_body.text += "\n\n[i]Loading safe agent tool catalog...[/i]"
	var err := agent_tool_http.request("%s/api/agent-tools/catalog" % API_BASE)
	if err != OK:
		room_body.text += "\nAgent tool catalog request failed."

func _select_next_agent_tool_invocation() -> void:
	if agent_tool_invocation_cards.is_empty():
		room_body.text += "\n\nNo agent tool invocations are loaded yet. Use Tool Catalog first."
		return
	selected_agent_tool_invocation_index = (selected_agent_tool_invocation_index + 1) % agent_tool_invocation_cards.size()
	var invocation: Dictionary = agent_tool_invocation_cards[selected_agent_tool_invocation_index]
	selected_agent_tool_invocation_id = str(invocation.get("id", ""))
	selected_agent_tool_event_cursor = 0
	_render_agent_tool_invocations_from_cache()

func _open_selected_agent_tool_invocation() -> void:
	if selected_agent_tool_invocation_id == "":
		room_body.text += "\n\nNo agent tool invocation is selected yet. Use Tool Catalog first."
		return
	room_body.text += "\n\n[i]Opening agent tool invocation %s...[/i]" % selected_agent_tool_invocation_id
	var err := agent_tool_http.request("%s/api/agent-tools/invocations/%s" % [API_BASE, selected_agent_tool_invocation_id])
	if err != OK:
		room_body.text += "\nAgent tool detail request failed."

func _load_selected_agent_tool_events() -> void:
	if selected_agent_tool_invocation_id == "":
		room_body.text += "\n\nNo agent tool invocation is selected yet. Use Tool Catalog first."
		return
	room_body.text += "\n\n[i]Loading agent tool events for %s...[/i]" % selected_agent_tool_invocation_id
	var err := agent_tool_http.request("%s/api/agent-tools/invocations/%s/events?since=%s&limit=24" % [API_BASE, selected_agent_tool_invocation_id, str(selected_agent_tool_event_cursor)])
	if err != OK:
		room_body.text += "\nAgent tool events request failed."

func _load_agent_tool_logs() -> void:
	if current_room_id != "agent-hub":
		room_body.text += "\n\n[b]Agent console[/b]\nEnter Agent Hub to inspect durable tool logs."
		return
	room_body.text += "\n\n[i]Loading durable Agent Tool logs...[/i]"
	var err := agent_tool_http.request("%s/api/agent-tools/logs?limit=12" % API_BASE)
	if err != OK:
		room_body.text += "\nAgent tool logs request failed."

func _run_agent_tool() -> void:
	if current_room_id != "agent-hub":
		room_body.text += "\n\n[b]Agent console[/b]\nEnter Agent Hub to run a safe registered tool."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"tool_id": "knowledge-search",
		"target_agent": "codex",
		"parameters": {
			"q": "memory",
			"page_size": 5
		},
		"source_building": "agent-hub"
	}
	room_body.text += "\n\n[i]Queueing safe agent tool invocation: knowledge-search...[/i]"
	var err := agent_tool_http.request("%s/api/agent-tools/invoke" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nAgent tool invocation request failed."

func _recruit_selected_agent_companion() -> void:
	if current_room_id != "agent-hub" or selected_agent_roster_id == "":
		room_body.text += "\n\n[b]Agent companion[/b]\nOpen Agent Roster first."
		return
	var meta := _agent_def(selected_agent_roster_id)
	var existing: Dictionary = companion_roster.get(selected_agent_roster_id, {})
	var affinity := int(existing.get("affinity", 0)) + 1
	companion_roster[selected_agent_roster_id] = {
		"id": selected_agent_roster_id,
		"name": meta.get("name", selected_agent_roster_id),
		"role": meta.get("role", ""),
		"zone": meta.get("zone", ""),
		"affinity": affinity,
		"status": "active" if active_companion_id == selected_agent_roster_id else "recruited"
	}
	active_companion_id = selected_agent_roster_id
	companion_roster[selected_agent_roster_id]["status"] = "active"
	_save_progress()
	_update_badge_case()
	room_body.text += "\n\n[b]Companion recruited:[/b] %s\nAffinity: %s\nSaved locally in the player profile. No agent runner was launched." % [meta.get("name", selected_agent_roster_id), str(affinity)]
	_record_npc_chain_action("recruit_agent", "agent-hub")

func _load_code_projects() -> void:
	if current_room_id != "code-workshop":
		room_body.text += "\n\n[b]Code console[/b]\nEnter Code Workshop to inspect real local Git projects."
		return
	room_body.text += "\n\n[i]Loading bounded local Git project index from D: roots...[/i]"
	var err := project_http.request("%s/api/projects" % API_BASE)
	if err != OK:
		room_body.text += "\nProject index request failed."

func _load_selected_code_project() -> void:
	if current_room_id != "code-workshop" or selected_project_id == "":
		return
	if selected_project_job_id != "":
		room_body.text += "\n\n[i]Checking project inspection job: %s...[/i]" % selected_project_job_id
		var poll_err := project_http.request("%s/api/jobs/%s" % [API_BASE, selected_project_job_id])
		if poll_err != OK:
			room_body.text += "\nProject inspection poll failed."
		return
	room_body.text += "\n\n[i]Queueing read-only repository inspection: %s...[/i]" % selected_project_id
	var headers := PackedStringArray(["Content-Type: application/json"])
	var err := project_http.request("%s/api/projects/%s/inspect-job" % [API_BASE, selected_project_id], headers, HTTPClient.METHOD_POST, "{}")
	if err != OK:
		room_body.text += "\nProject inspection job request failed."

func _create_code_task_draft() -> void:
	if current_room_id != "code-workshop" or selected_project_id == "":
		room_body.text += "\n\n[b]Code console[/b]\nSelect a project first with Code Projects."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"target_agent": "codex",
		"task_title": "Implement next safe slice for %s" % selected_project_id,
		"task_body": "Inspect this selected repository and draft the smallest implementation slice with tests, docs, and preservation of unrelated user changes.",
		"priority": "normal",
		"acceptance_criteria": "A human can verify the target files, safety boundary, suggested commands, docs impact, and residual risks before any code edit or Git operation.",
		"source_building": "code-workshop",
		"safety": "project-local-draft"
	}
	room_body.text += "\n\n[i]Creating project-local code task draft and memory event...[/i]"
	var err := project_http.request("%s/api/projects/%s/code-task-draft" % [API_BASE, selected_project_id], headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nCode task draft request failed."

func _create_code_context_pack() -> void:
	if current_room_id != "code-workshop" or selected_project_id == "":
		room_body.text += "\n\n[b]Code console[/b]\nSelect a project first with Code Projects."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"focus": "architecture-tests-docs",
		"target_agent": "codex",
		"source_building": "code-workshop"
	}
	room_body.text += "\n\n[i]Creating project-local code context pack...[/i]"
	var err := project_http.request("%s/api/projects/%s/context-pack" % [API_BASE, selected_project_id], headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nCode context pack request failed."

func _create_code_patch_plan() -> void:
	if current_room_id != "code-workshop" or selected_project_id == "":
		room_body.text += "\n\n[b]Code console[/b]\nSelect a project first with Code Projects."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "Safe patch plan for %s" % selected_project_id,
		"goal": "Plan a narrow implementation slice for the selected repository, including candidate files, safety boundaries, and verification commands.",
		"scope_hint": "small-safe-slice",
		"target_agent": "codex",
		"source_building": "code-workshop"
	}
	room_body.text += "\n\n[i]Creating project-local patch plan. The selected repository will not be modified...[/i]"
	var err := project_http.request("%s/api/projects/%s/patch-plan" % [API_BASE, selected_project_id], headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nCode patch plan request failed."

func _submit_code_agent_task() -> void:
	if current_room_id != "code-workshop" or selected_project_id == "":
		room_body.text += "\n\n[b]Code console[/b]\nSelect a project first with Code Projects."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"target_agent": "codex",
		"task_type": "code-review-brief",
		"title": "Code review brief for %s" % selected_project_id,
		"body": "Build a bounded read-only development analysis brief for the selected repository.",
		"source_building": "code-workshop",
		"parameters": {
			"project_id": selected_project_id
		}
	}
	room_body.text += "\n\n[i]Queueing safe code-review brief through Agent Task Queue...[/i]"
	var err := agent_task_http.request("%s/api/agent-tasks/submit" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nCode agent task request failed."

func _submit_code_explain_task() -> void:
	if current_room_id != "code-workshop" or selected_project_id == "":
		room_body.text += "\n\n[b]Code console[/b]\nSelect a project first with Code Projects."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"target_agent": "codex",
		"task_type": "code-explain-brief",
		"title": "Code explanation brief for %s" % selected_project_id,
		"body": "Explain the selected repository for onboarding: purpose, entry points, key files, safe reading path, and next steps.",
		"source_building": "code-workshop",
		"parameters": {
			"project_id": selected_project_id
		}
	}
	room_body.text += "\n\n[i]Queueing safe code explanation brief through Agent Task Queue...[/i]"
	var err := agent_task_http.request("%s/api/agent-tasks/submit" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nCode explain task request failed."

func _run_project_verification() -> void:
	if current_room_id != "code-workshop" or selected_project_id == "":
		room_body.text += "\n\n[b]Code console[/b]\nSelect a project first with Code Projects."
		return
	var request := {
		"command_label": "python-compile",
		"source_building": "code-workshop"
	}
	if pending_project_verification_confirmation:
		request["confirmation"] = "RUN_PROJECT_CHECK"
	var headers := PackedStringArray(["Content-Type: application/json"])
	room_body.text += "\n\n[i]Requesting project verification%s...[/i]" % (" run" if pending_project_verification_confirmation else " preview")
	var err := project_http.request("%s/api/projects/%s/verification-jobs" % [API_BASE, selected_project_id], headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nProject verification request failed."

func _poll_selected_project_job() -> void:
	if selected_project_job_id == "":
		room_body.text += "\n\nNo project job is selected yet."
		return
	var err := project_http.request("%s/api/jobs/%s" % [API_BASE, selected_project_job_id])
	if err != OK:
		room_body.text += "\nProject job poll failed."

func _load_harbor_repos() -> void:
	if current_room_id != "github-harbor":
		room_body.text += "\n\n[b]Harbor console[/b]\nEnter GitHub Harbor to inspect local remotes, branches, commits, and tags."
		return
	room_body.text += "\n\n[i]Loading local Git harbor metadata...[/i]"
	var err := harbor_http.request("%s/api/github-harbor/repos" % API_BASE)
	if err != OK:
		room_body.text += "\nHarbor repo request failed."

func _load_selected_harbor_repo() -> void:
	if current_room_id != "github-harbor" or selected_harbor_repo_id == "":
		return
	room_body.text += "\n\n[i]Opening harbor detail: %s...[/i]" % selected_harbor_repo_id
	var err := harbor_http.request("%s/api/github-harbor/repos/%s" % [API_BASE, selected_harbor_repo_id])
	if err != OK:
		room_body.text += "\nHarbor detail request failed."

func _load_selected_harbor_github() -> void:
	if current_room_id != "github-harbor" or selected_harbor_repo_id == "":
		room_body.text += "\n\n[b]Harbor console[/b]\nSelect a repository first with Harbor Repos."
		return
	room_body.text += "\n\n[i]Reading GitHub CLI status for %s. No GitHub write action will run...[/i]" % selected_harbor_repo_id
	var err := harbor_http.request("%s/api/github-harbor/repos/%s/github" % [API_BASE, selected_harbor_repo_id])
	if err != OK:
		room_body.text += "\nGitHub CLI snapshot request failed."

func _load_selected_harbor_publish_readiness() -> void:
	if current_room_id != "github-harbor" or selected_harbor_repo_id == "":
		room_body.text += "\n\n[b]Harbor console[/b]\nSelect a repository first with Harbor Repos."
		return
	room_body.text += "\n\n[i]Checking publish readiness for %s without staging, committing, pushing, or opening GitHub writes...[/i]" % selected_harbor_repo_id
	var err := harbor_http.request("%s/api/github-harbor/repos/%s/publish-readiness" % [API_BASE, selected_harbor_repo_id])
	if err != OK:
		room_body.text += "\nPublish readiness request failed."

func _create_harbor_draft() -> void:
	if current_room_id != "github-harbor" or selected_harbor_repo_id == "":
		room_body.text += "\n\n[b]Harbor console[/b]\nSelect a repository first with Harbor Repos."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"draft_type": "pull-request",
		"title": "AI Town GitHub handoff for %s" % selected_harbor_repo_id,
		"body": "Prepare a safe GitHub handoff from local Git metadata. Review dirty files, recent commits, remotes, verification evidence, and public text before any future PR, issue, release, tag, or push.",
		"target_branch": "main",
		"source_building": "github-harbor"
	}
	room_body.text += "\n\n[i]Creating project-local GitHub handoff draft. No Git or GitHub write action will run...[/i]"
	var err := harbor_http.request("%s/api/github-harbor/repos/%s/drafts" % [API_BASE, selected_harbor_repo_id], headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nHarbor draft request failed."

func _create_harbor_publish_plan() -> void:
	if current_room_id != "github-harbor" or selected_harbor_repo_id == "":
		room_body.text += "\n\n[b]Harbor console[/b]\nSelect a repository first with Harbor Repos."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"publish_type": "pull-request",
		"title": "AI Town publish plan for %s" % selected_harbor_repo_id,
		"body": "Review branch, remotes, dirty files, verification evidence, and PR text before any future GitHub write. This creates only a local review plan.",
		"target_branch": "main",
		"confirmation": "PLAN_GITHUB_PUBLISH",
		"source_building": "github-harbor"
	}
	room_body.text += "\n\n[i]Creating confirm-gated GitHub publish review plan. No stage, commit, tag, push, PR, issue, release, or GitHub write will run...[/i]"
	var err := harbor_http.request("%s/api/github-harbor/repos/%s/publish-plans" % [API_BASE, selected_harbor_repo_id], headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nGitHub publish plan request failed."

func _load_terminal_commands() -> void:
	if current_room_id != "terminal-control":
		room_body.text += "\n\n[b]Terminal console[/b]\nEnter Terminal Control to inspect allowlisted local command jobs."
		return
	room_body.text += "\n\n[i]Loading allowlisted command catalog and recent logs...[/i]"
	var err := terminal_http.request("%s/api/terminal/commands" % API_BASE)
	if err != OK:
		room_body.text += "\nTerminal command catalog request failed."

func _preview_selected_terminal_command() -> void:
	if current_room_id != "terminal-control" or selected_terminal_command_id == "":
		room_body.text += "\n\n[b]Terminal console[/b]\nSelect a command first with Terminal Jobs."
		return
	room_body.text += "\n\n[i]Previewing allowlisted command without running it: %s...[/i]" % selected_terminal_command_id
	var err := terminal_http.request("%s/api/terminal/commands/%s/preview" % [API_BASE, selected_terminal_command_id])
	if err != OK:
		room_body.text += "\nTerminal command preview request failed."

func _run_selected_terminal_command() -> void:
	if current_room_id != "terminal-control" or selected_terminal_command_id == "":
		room_body.text += "\n\n[b]Terminal console[/b]\nSelect a command first with Terminal Jobs."
		return
	if selected_terminal_job_id != "":
		room_body.text += "\n\n[i]Checking terminal job: %s...[/i]" % selected_terminal_job_id
		var poll_err := terminal_http.request("%s/api/jobs/%s" % [API_BASE, selected_terminal_job_id])
		if poll_err != OK:
			room_body.text += "\nTerminal job poll failed."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {"command_id": selected_terminal_command_id}
	if terminal_confirmation_required != "":
		request["confirmation"] = terminal_confirmation_required
		room_body.text += "\n\n[i]Queueing confirmed allowlisted command: %s...[/i]" % selected_terminal_command_id
	else:
		room_body.text += "\n\n[i]Requesting command preview and confirmation phrase: %s...[/i]" % selected_terminal_command_id
	var err := terminal_http.request("%s/api/terminal/run" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nTerminal command request failed."

func _select_next_terminal_log() -> void:
	if terminal_log_cards.is_empty():
		room_body.text += "\n\n[b]Terminal logs[/b]\nNo recent command logs loaded yet."
		return
	selected_terminal_log_index = (selected_terminal_log_index + 1) % terminal_log_cards.size()
	var log: Dictionary = terminal_log_cards[selected_terminal_log_index]
	detail_body.text = "[b]Terminal log selected[/b]\n%s | %s\n%s" % [log.get("label", log.get("command_id", "command")), log.get("status", ""), log.get("log_path", "")]

func _open_selected_terminal_log() -> void:
	if terminal_log_cards.is_empty():
		room_body.text += "\n\n[b]Terminal logs[/b]\nLoad Terminal Jobs after running an allowlisted command to inspect logs."
		return
	if selected_terminal_log_index < 0 or selected_terminal_log_index >= terminal_log_cards.size():
		selected_terminal_log_index = 0
	var log: Dictionary = terminal_log_cards[selected_terminal_log_index]
	_render_terminal_log_detail(log)

func _load_system_overview() -> void:
	if current_room_id != "system-monitor":
		room_body.text += "\n\n[b]System monitor[/b]\nEnter System Monitor to inspect local service health, registries, logs, and workspace status."
		return
	room_body.text += "\n\n[i]Loading local system overview...[/i]"
	var err := system_http.request("%s/api/system/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nSystem overview request failed."

func _load_system_jobs() -> void:
	if current_room_id != "system-monitor":
		room_body.text += "\n\n[b]System monitor[/b]\nEnter System Monitor to inspect backend jobs."
		return
	room_body.text += "\n\n[i]Loading backend job queue...[/i]"
	var err := system_http.request("%s/api/system/jobs" % API_BASE)
	if err != OK:
		room_body.text += "\nJob queue request failed."

func _cancel_selected_system_job() -> void:
	if current_room_id != "system-monitor":
		room_body.text += "\n\n[b]System monitor[/b]\nEnter System Monitor to request backend job cancellation."
		return
	if selected_system_job_id == "":
		room_body.text += "\n\nNo backend job is selected. Load Job Queue first."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"reason": "Requested from Godot System Monitor.",
		"source_building": "system-monitor"
	}
	room_body.text += "\n\n[i]Requesting safe cancellation metadata for job %s...[/i]" % selected_system_job_id
	var err := system_http.request("%s/api/jobs/%s/cancel" % [API_BASE, selected_system_job_id], headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nJob cancellation request failed."

func _open_selected_system_job_log() -> void:
	if current_room_id != "system-monitor":
		room_body.text += "\n\n[b]System monitor[/b]\nEnter System Monitor to inspect backend job logs."
		return
	if selected_system_job_log_id == "":
		room_body.text += "\n\nNo backend job log is selected. Load Job Queue first."
		return
	room_body.text += "\n\n[i]Opening backend job lifecycle log %s...[/i]" % selected_system_job_log_id
	var err := system_http.request("%s/api/system/job-logs/%s" % [API_BASE, selected_system_job_log_id])
	if err != OK:
		room_body.text += "\nBackend job log detail request failed."

func _poll_selected_system_job_events() -> void:
	if current_room_id != "system-monitor":
		room_body.text += "\n\n[b]System monitor[/b]\nEnter System Monitor to poll backend job events."
		return
	if selected_system_job_id == "":
		room_body.text += "\n\nNo backend job is selected. Load Job Queue first."
		return
	room_body.text += "\n\n[i]Polling backend job events for %s from cursor %s...[/i]" % [selected_system_job_id, str(selected_system_job_event_cursor)]
	var err := system_http.request("%s/api/jobs/%s/events?since=%s&limit=8" % [API_BASE, selected_system_job_id, str(selected_system_job_event_cursor)])
	if err != OK:
		room_body.text += "\nBackend job events request failed."

func _load_system_events() -> void:
	if current_room_id != "system-monitor":
		room_body.text += "\n\n[b]System monitor[/b]\nEnter System Monitor to inspect local event history."
		return
	room_body.text += "\n\n[i]Loading unified local event timeline...[/i]"
	var err := system_http.request("%s/api/system/events?limit=40" % API_BASE)
	if err != OK:
		room_body.text += "\nSystem event timeline request failed."

func _load_skill_workshop() -> void:
	if current_room_id != "skill-workshop":
		room_body.text += "\n\n[b]Skill Workshop[/b]\nEnter Skill Workshop to inspect local skill resources."
		return
	room_body.text += "\n\n[i]Loading local skill inventory. No skills will be installed, edited, or invoked...[/i]"
	var err := room_http.request("%s/api/buildings/skill-workshop" % API_BASE)
	if err != OK:
		room_body.text += "\nSkill Workshop request failed."

func _load_devtools_lab() -> void:
	if current_room_id != "devtools-lab":
		room_body.text += "\n\n[b]Devtools Lab[/b]\nEnter Devtools Lab to inspect local tool launchers."
		return
	room_body.text += "\n\n[i]Loading local devtool launcher inventory. No commands will run and PATH will not change...[/i]"
	var err := room_http.request("%s/api/buildings/devtools-lab" % API_BASE)
	if err != OK:
		room_body.text += "\nDevtools Lab request failed."

func _load_town_capability_atlas() -> void:
	if current_room_id != "town-hall":
		room_body.text += "\n\n[b]Town Hall[/b]\nEnter Town Hall to inspect the real-system capability atlas."
		return
	room_body.text += "\n\n[i]Loading Town Capability Atlas. This is descriptive only: no scans, commands, agents, edits, or external calls...[/i]"
	var err := town_http.request("%s/api/town/capability-atlas" % API_BASE)
	if err != OK:
		room_body.text += "\nTown Capability Atlas request failed."

func _select_next_town_capability() -> void:
	if town_capability_cards.is_empty():
		room_body.text += "\n\n[b]Town Capability Atlas[/b]\nLoad Atlas first."
		return
	selected_town_capability_index = (selected_town_capability_index + 1) % town_capability_cards.size()
	var entry: Dictionary = town_capability_cards[selected_town_capability_index]
	selected_town_capability_id = str(entry.get("id", ""))
	_render_town_capability_from_cache()

func _open_selected_town_capability() -> void:
	if current_room_id != "town-hall":
		room_body.text += "\n\n[b]Town Hall[/b]\nEnter Town Hall to open atlas detail."
		return
	if selected_town_capability_id == "":
		room_body.text += "\n\nNo atlas building is selected. Load Atlas first."
		return
	room_body.text += "\n\n[i]Opening capability detail for %s...[/i]" % selected_town_capability_id
	var err := town_http.request("%s/api/town/capability-atlas/%s" % [API_BASE, selected_town_capability_id])
	if err != OK:
		room_body.text += "\nTown Capability detail request failed."

func _load_town_workflow_routes() -> void:
	if current_room_id != "town-hall":
		room_body.text += "\n\n[b]Town Hall[/b]\nEnter Town Hall to inspect reusable work routes."
		return
	room_body.text += "\n\n[i]Loading reusable Town Workflow Routes. These are guidance only and do not claim progress or run tools...[/i]"
	var err := town_http.request("%s/api/town/workflow-routes" % API_BASE)
	if err != OK:
		room_body.text += "\nTown Workflow Routes request failed."

func _select_next_town_workflow() -> void:
	if town_workflow_cards.is_empty():
		room_body.text += "\n\n[b]Town Workflow Routes[/b]\nLoad Workflows first."
		return
	selected_town_workflow_index = (selected_town_workflow_index + 1) % town_workflow_cards.size()
	var route: Dictionary = town_workflow_cards[selected_town_workflow_index]
	selected_town_workflow_id = str(route.get("id", ""))
	_render_town_workflow_from_cache()

func _open_selected_town_workflow() -> void:
	if current_room_id != "town-hall":
		room_body.text += "\n\n[b]Town Hall[/b]\nEnter Town Hall to open workflow detail."
		return
	if selected_town_workflow_id == "":
		room_body.text += "\n\nNo workflow route is selected. Load Workflows first."
		return
	room_body.text += "\n\n[i]Opening workflow route detail for %s...[/i]" % selected_town_workflow_id
	var err := town_http.request("%s/api/town/workflow-routes/%s" % [API_BASE, selected_town_workflow_id])
	if err != OK:
		room_body.text += "\nTown Workflow Route detail request failed."

func _load_model_status() -> void:
	if current_room_id != "model-market":
		room_body.text += "\n\n[b]Model market[/b]\nEnter Model Market to inspect API gateway and model key status."
		return
	room_body.text += "\n\n[i]Loading model gateway status without exposing secrets...[/i]"
	var err := model_http.request("%s/api/model-gateway/status" % API_BASE)
	if err != OK:
		room_body.text += "\nModel gateway status request failed."

func _load_model_profiles() -> void:
	if current_room_id != "model-market":
		room_body.text += "\n\n[b]Model market[/b]\nEnter Model Market to inspect model profile registry."
		return
	room_body.text += "\n\n[i]Loading model profiles from registry...[/i]"
	var err := model_http.request("%s/api/model-gateway/profiles" % API_BASE)
	if err != OK:
		room_body.text += "\nModel profile request failed."

func _create_model_config_draft() -> void:
	if current_room_id != "model-market":
		room_body.text += "\n\n[b]Model market[/b]\nEnter Model Market to prepare a no-secret model config draft."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"profile_id": "deepseek-chat",
		"title": "AI Town model gateway setup",
		"include_all_profiles": true,
		"source_building": "model-market"
	}
	room_body.text += "\n\n[i]Creating no-secret model/API config draft...[/i]"
	var err := model_http.request("%s/api/model-gateway/config-drafts" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nModel config draft request failed."

func _create_model_profile_test() -> void:
	if current_room_id != "model-market":
		room_body.text += "\n\n[b]Model market[/b]\nEnter Model Market to test a model profile safely."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"profile_id": "deepseek-chat",
		"model": "",
		"live_probe": false,
		"source_building": "model-market"
	}
	room_body.text += "\n\n[i]Recording dry-run model profile test...[/i]"
	var err := model_http.request("%s/api/model-gateway/profile-tests" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nModel profile test request failed."

func _load_model_key_vault() -> void:
	if current_room_id != "model-market":
		room_body.text += "\n\n[b]Model market[/b]\nEnter Model Market to inspect the encrypted local key vault."
		return
	room_body.text += "\n\n[i]Loading encrypted local key vault metadata without raw secrets...[/i]"
	var err := model_http.request("%s/api/model-gateway/key-vault" % API_BASE)
	if err != OK:
		room_body.text += "\nModel key vault request failed."

func _load_task_board() -> void:
	if current_room_id != "task-board":
		room_body.text += "\n\n[b]Task board[/b]\nEnter Task Board to inspect local task ledger and draft signals."
		return
	room_body.text += "\n\n[i]Loading local task ledger, dispatch drafts, and memory events...[/i]"
	var err := task_http.request("%s/api/task-board/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nTask board request failed."

func _create_task_board_task() -> void:
	if current_room_id != "task-board":
		room_body.text += "\n\n[b]Task board[/b]\nEnter Task Board to create project-local task cards."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "Review next AI Town slice",
		"body": "Review the current Godot rebuild and choose the next safe, testable implementation slice.",
		"target_agent": "codex",
		"source_building": "task-board",
		"status": "ready"
	}
	room_body.text += "\n\n[i]Creating project-local task card and memory event...[/i]"
	var err := task_http.request("%s/api/task-board/tasks" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nTask creation request failed."

func _update_selected_task_status(new_status: String) -> void:
	if current_room_id != "task-board":
		room_body.text += "\n\n[b]Task board[/b]\nEnter Task Board to update project-local task status."
		return
	if selected_task_id == "":
		room_body.text += "\n\nNo local task is selected yet. Load the Task Board first."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"status": new_status,
		"note": "Marked %s from the Godot Task Board." % new_status,
		"source_building": "task-board"
	}
	room_body.text += "\n\n[i]Updating local task %s to %s...[/i]" % [selected_task_id, new_status]
	var err := task_http.request("%s/api/task-board/tasks/%s" % [API_BASE, selected_task_id], headers, HTTPClient.METHOD_PATCH, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nTask status update request failed."

func _select_next_local_task() -> void:
	if local_task_cards.is_empty():
		room_body.text += "\n\nNo local tasks are loaded yet. Use Task Board first."
		return
	selected_task_index = (selected_task_index + 1) % local_task_cards.size()
	var task: Dictionary = local_task_cards[selected_task_index]
	selected_task_id = str(task.get("id", ""))
	_render_task_board_from_cache()

func _open_selected_task_detail() -> void:
	if current_room_id != "task-board":
		room_body.text += "\n\n[b]Task board[/b]\nEnter Task Board to open a local task preview."
		return
	if selected_task_id == "":
		room_body.text += "\n\nNo local task is selected yet. Load the Task Board first."
		return
	room_body.text += "\n\n[i]Opening bounded preview for local task %s...[/i]" % selected_task_id
	var err := task_http.request("%s/api/task-board/tasks/%s" % [API_BASE, selected_task_id])
	if err != OK:
		room_body.text += "\nTask preview request failed."

func _submit_selected_task_agent_brief() -> void:
	if current_room_id != "task-board":
		room_body.text += "\n\n[b]Task board[/b]\nEnter Task Board to queue a selected task brief."
		return
	if selected_task_id == "":
		room_body.text += "\n\nNo local task is selected yet. Load the Task Board first."
		return
	var selected_task := {}
	for task in local_task_cards:
		if typeof(task) == TYPE_DICTIONARY and str(task.get("id", "")) == selected_task_id:
			selected_task = task
			break
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"target_agent": str(selected_task.get("target_agent", "codex")),
		"task_type": "task-brief",
		"title": "Task brief: %s" % selected_task.get("title", selected_task_id),
		"body": "Build a safe read-only execution brief for the selected Task Board item.",
		"source_building": "task-board",
		"parameters": {"task_id": selected_task_id},
		"start_paused": false,
	}
	room_body.text += "\n\n[i]Queueing safe agent brief for local task %s...[/i]" % selected_task_id
	var err := agent_task_http.request("%s/api/agent-tasks/submit" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nTask agent request failed."

func _load_writing_studio() -> void:
	if current_room_id != "writing-studio":
		room_body.text += "\n\n[b]Writing studio[/b]\nEnter Writing Studio to inspect project docs and local drafts."
		return
	room_body.text += "\n\n[i]Loading project documents and local writing drafts...[/i]"
	var err := writing_http.request("%s/api/writing-studio/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nWriting Studio request failed."

func _create_writing_draft() -> void:
	if current_room_id != "writing-studio":
		room_body.text += "\n\n[b]Writing studio[/b]\nEnter Writing Studio to create local Markdown drafts."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "AI Town writing draft",
		"body": "Capture the next project note, README paragraph, or release-note idea here.",
		"category": "ai-town"
	}
	room_body.text += "\n\n[i]Creating project-local writing draft and memory event...[/i]"
	var err := writing_http.request("%s/api/writing-studio/drafts" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nWriting draft request failed."

func _load_automation_factory() -> void:
	if current_room_id != "automation-factory":
		room_body.text += "\n\n[b]Automation factory[/b]\nEnter Automation Factory to inspect local scripts and blueprints."
		return
	room_body.text += "\n\n[i]Loading project script catalog and automation draft shelf...[/i]"
	var err := automation_http.request("%s/api/automation-factory/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nAutomation Factory request failed."

func _load_automation_scheduler() -> void:
	if current_room_id != "automation-factory":
		room_body.text += "\n\n[b]Automation factory[/b]\nEnter Automation Factory to inspect scheduled task state."
		return
	room_body.text += "\n\n[i]Loading read-only Windows scheduler snapshot. No tasks will be created, run, disabled, or deleted...[/i]"
	var err := automation_http.request("%s/api/automation-factory/scheduler" % API_BASE)
	if err != OK:
		room_body.text += "\nAutomation scheduler request failed."

func _create_automation_draft() -> void:
	if current_room_id != "automation-factory":
		room_body.text += "\n\n[b]Automation factory[/b]\nEnter Automation Factory to create safe automation blueprints."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "AI Town verification automation blueprint",
		"body": "Review a future workflow that runs smoke verification after safe project changes, stores logs, and requires explicit confirmation before activation.",
		"script_id": "verify-smoke-ps1",
		"schedule_hint": "manual review first; future trigger after implementation slices",
		"source_building": "automation-factory"
	}
	room_body.text += "\n\n[i]Creating project-local automation blueprint. No command or scheduler will run.[/i]"
	var err := automation_http.request("%s/api/automation-factory/drafts" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nAutomation draft request failed."

func _load_permission_hall() -> void:
	if current_room_id != "permission-hall":
		room_body.text += "\n\n[b]Permission hall[/b]\nEnter Permission Hall to inspect safety classes, scopes, and audit signals."
		return
	room_body.text += "\n\n[i]Loading read-only permission ledger and safety scopes...[/i]"
	var err := permission_http.request("%s/api/permissions/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nPermission Hall request failed."

func _load_permission_secret_audit() -> void:
	if current_room_id != "permission-hall":
		room_body.text += "\n\n[b]Secret audit[/b]\nEnter Permission Hall to inspect project-local caches and logs for secret-shaped strings."
		return
	room_body.text += "\n\n[i]Scanning allowlisted project-local caches/logs for secret-shaped strings without returning secret text...[/i]"
	var err := permission_http.request("%s/api/permissions/secret-audit" % API_BASE)
	if err != OK:
		room_body.text += "\nSecret audit request failed."

func _load_settings_center() -> void:
	if current_room_id != "settings-center":
		room_body.text += "\n\n[b]Settings center[/b]\nEnter Settings Center to inspect registries, launchers, and env requirements."
		return
	room_body.text += "\n\n[i]Loading registry, launcher, and environment configuration status...[/i]"
	var err := settings_http.request("%s/api/settings-center/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nSettings Center request failed."

func _load_registry_health() -> void:
	if current_room_id != "settings-center":
		room_body.text += "\n\n[b]Registry health[/b]\nEnter Settings Center to validate registry schema health."
		return
	room_body.text += "\n\n[i]Validating registry JSON shape without changing files...[/i]"
	var err := settings_http.request("%s/api/config/registry-health" % API_BASE)
	if err != OK:
		room_body.text += "\nRegistry Health request failed."

func _create_settings_draft() -> void:
	if current_room_id != "settings-center":
		room_body.text += "\n\n[b]Settings center[/b]\nEnter Settings Center to create config review drafts."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "Review model profile configuration",
		"body": "Review model profile env vars and startup scripts before applying any real config change. Do not write raw API keys into project files.",
		"category": "model-profiles",
		"source_building": "settings-center"
	}
	room_body.text += "\n\n[i]Creating project-local settings draft. No live config or secret will change.[/i]"
	var err := settings_http.request("%s/api/settings-center/drafts" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nSettings draft request failed."

func _load_testing_arena() -> void:
	if current_room_id != "testing-arena":
		room_body.text += "\n\n[b]Testing arena[/b]\nEnter Testing Arena to inspect smoke scripts, logs, and visual proof."
		return
	room_body.text += "\n\n[i]Loading verification scripts, visual artifact, and recent logs...[/i]"
	var err := testing_http.request("%s/api/testing-arena/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nTesting Arena request failed."

func _create_test_plan() -> void:
	if current_room_id != "testing-arena":
		room_body.text += "\n\n[b]Testing arena[/b]\nEnter Testing Arena to create test-plan drafts."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "AI Town smoke and visual verification plan",
		"body": "Verify backend syntax, FastAPI endpoints, Godot startup, whitespace, and visual smoke after the next implementation slice.",
		"target": "godot-backend-smoke",
		"source_building": "testing-arena"
	}
	room_body.text += "\n\n[i]Creating project-local test-plan draft. No tests will run.[/i]"
	var err := testing_http.request("%s/api/testing-arena/test-plans" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nTest-plan draft request failed."

func _create_vertical_slice_proof() -> void:
	if current_room_id != "testing-arena":
		room_body.text += "\n\n[b]Testing arena[/b]\nEnter Testing Arena to record vertical-slice proof."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "AI Town playable vertical slice proof",
		"source_building": "testing-arena"
	}
	room_body.text += "\n\n[i]Recording project-local vertical-slice proof from existing evidence. No commands will run.[/i]"
	var err := testing_http.request("%s/api/testing-arena/vertical-slice-proofs" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nVertical-slice proof request failed."

func _select_next_vertical_proof() -> void:
	if vertical_proof_cards.is_empty():
		room_body.text += "\n\n[b]Vertical slice proofs[/b]\nNo proof reports loaded yet."
		return
	selected_vertical_proof_index = (selected_vertical_proof_index + 1) % vertical_proof_cards.size()
	var proof: Dictionary = vertical_proof_cards[selected_vertical_proof_index]
	selected_vertical_proof_id = str(proof.get("id", ""))
	detail_body.text = "[b]Vertical proof selected[/b]\n%s\n%s" % [proof.get("title", selected_vertical_proof_id), proof.get("path", "")]

func _open_selected_vertical_proof() -> void:
	if current_room_id != "testing-arena":
		room_body.text += "\n\n[b]Testing arena[/b]\nEnter Testing Arena to open proof reports."
		return
	if selected_vertical_proof_id == "":
		if vertical_proof_cards.is_empty():
			room_body.text += "\n\n[b]Vertical slice proofs[/b]\nLoad Testing Arena or create a proof first."
			return
		selected_vertical_proof_index = 0
		selected_vertical_proof_id = str(vertical_proof_cards[0].get("id", ""))
	room_body.text += "\n\n[i]Opening vertical-slice proof preview...[/i]"
	var err := testing_http.request("%s/api/testing-arena/vertical-slice-proofs/%s" % [API_BASE, selected_vertical_proof_id])
	if err != OK:
		room_body.text += "\nVertical-slice proof preview request failed."

func _load_bug_clinic() -> void:
	if current_room_id != "bug-clinic":
		room_body.text += "\n\n[b]Bug clinic[/b]\nEnter Bug Clinic to inspect diagnostics and known issues."
		return
	room_body.text += "\n\n[i]Loading diagnostic signals, failed jobs, and bug-report drafts...[/i]"
	var err := bug_http.request("%s/api/bug-clinic/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nBug Clinic request failed."

func _create_bug_report() -> void:
	if current_room_id != "bug-clinic":
		room_body.text += "\n\n[b]Bug clinic[/b]\nEnter Bug Clinic to create bug-report drafts."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "Investigate AI Town diagnostic signal",
		"body": "Review the current diagnostic signals, reproduction path, expected behavior, and verification evidence before assigning a code fix.",
		"severity": "medium",
		"source_building": "bug-clinic"
	}
	room_body.text += "\n\n[i]Creating project-local bug-report draft. No code will change.[/i]"
	var err := bug_http.request("%s/api/bug-clinic/reports" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nBug-report draft request failed."

func _load_project_management() -> void:
	if current_room_id != "project-management-hall":
		room_body.text += "\n\n[b]Project hall[/b]\nEnter Project Management Hall to inspect portfolio status."
		return
	room_body.text += "\n\n[i]Loading project portfolio, research boards, task counts, and Git metadata...[/i]"
	var err := management_http.request("%s/api/project-management/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nProject Management request failed."

func _create_project_brief() -> void:
	if current_room_id != "project-management-hall":
		room_body.text += "\n\n[b]Project hall[/b]\nEnter Project Management Hall to create project brief drafts."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "AI Town project portfolio brief",
		"body": "Summarize active local projects, research boards, task status, and safe next actions for the AI Town rebuild.",
		"project_id": "ai-town",
		"source_building": "project-management-hall"
	}
	room_body.text += "\n\n[i]Creating project-local portfolio brief. No repo or tracker will change.[/i]"
	var err := management_http.request("%s/api/project-management/briefs" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nProject brief request failed."

func _load_download_station() -> void:
	if current_room_id != "download-station":
		room_body.text += "\n\n[b]Download station[/b]\nEnter Download Station to inspect allowlisted download folders and intake drafts."
		return
	room_body.text += "\n\n[i]Loading shallow download intake map. No files will be moved, opened, fetched, or executed...[/i]"
	var err := download_http.request("%s/api/download-station/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nDownload Station request failed."

func _load_download_triage() -> void:
	if current_room_id != "download-station":
		room_body.text += "\n\n[b]Download station[/b]\nEnter Download Station to triage recent downloads."
		return
	room_body.text += "\n\n[i]Loading read-only download triage. No files will move, open, extract, install, or execute...[/i]"
	var err := download_http.request("%s/api/download-station/triage?root_id=user-downloads&limit=12" % API_BASE)
	if err != OK:
		room_body.text += "\nDownload triage request failed."

func _create_download_intake() -> void:
	if current_room_id != "download-station":
		room_body.text += "\n\n[b]Download station[/b]\nEnter Download Station to create download intake drafts."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "AI Town download intake plan",
		"body": "Review recent downloads and route useful files into assets, docs, dependency notes, or archive plans after manual inspection.",
		"root_id": "user-downloads",
		"source_building": "download-station"
	}
	room_body.text += "\n\n[i]Creating project-local download intake draft. Files stay exactly where they are.[/i]"
	var err := download_http.request("%s/api/download-station/intake-drafts" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nDownload intake draft request failed."

func _load_asset_gallery() -> void:
	if current_room_id != "asset-gallery":
		room_body.text += "\n\n[b]Asset gallery[/b]\nEnter Asset Resource Gallery to inspect runtime assets, source art, and curation notes."
		return
	room_body.text += "\n\n[i]Loading bounded asset gallery. No assets will be edited, moved, imported, optimized, or generated...[/i]"
	var err := asset_http.request("%s/api/asset-gallery/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nAsset Gallery request failed."

func _inspect_asset() -> void:
	if current_room_id != "asset-gallery":
		room_body.text += "\n\n[b]Asset gallery[/b]\nEnter Asset Resource Gallery to inspect asset metadata."
		return
	room_body.text += "\n\n[i]Inspecting one allowlisted asset. No asset will be opened, edited, imported, optimized, or copied...[/i]"
	var err := asset_http.request("%s/api/asset-gallery/inspect" % API_BASE)
	if err != OK:
		room_body.text += "\nAsset inspection request failed."

func _create_asset_note() -> void:
	if current_room_id != "asset-gallery":
		room_body.text += "\n\n[b]Asset gallery[/b]\nEnter Asset Resource Gallery to create asset curation notes."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "AI Town visual asset curation note",
		"body": "Review whether sampled assets match the warm storybook pixel-handpainted baseline, whether their source is traceable, and what safe next step should happen before promotion.",
		"root_id": "godot-assets",
		"source_building": "asset-gallery"
	}
	room_body.text += "\n\n[i]Creating project-local asset note. Asset files stay exactly as they are.[/i]"
	var err := asset_http.request("%s/api/asset-gallery/notes" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nAsset note request failed."

func _load_local_office_center() -> void:
	if current_room_id != "local-office-center":
		room_body.text += "\n\n[b]Local office[/b]\nEnter Local Office Center to inspect office folders and local notes."
		return
	room_body.text += "\n\n[i]Loading bounded office map. No company files will be edited, opened, synced, or emailed...[/i]"
	var err := office_http.request("%s/api/local-office-center/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nLocal Office request failed."

func _create_office_note() -> void:
	if current_room_id != "local-office-center":
		room_body.text += "\n\n[b]Local office[/b]\nEnter Local Office Center to create office notes."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "AI Town local office follow-up note",
		"body": "Summarize current office context, decisions, follow-ups, and whether anything should become a Task Board item, project brief, writing draft, or temporary note.",
		"root_id": "company",
		"source_building": "local-office-center"
	}
	room_body.text += "\n\n[i]Creating project-local office note. Company files stay untouched.[/i]"
	var err := office_http.request("%s/api/local-office-center/notes" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nOffice note request failed."

func _load_schedule_plan_center() -> void:
	if current_room_id != "schedule-plan-center":
		room_body.text += "\n\n[b]Schedule center[/b]\nEnter Schedule and Plan Center to inspect planning signals and schedule drafts."
		return
	room_body.text += "\n\n[i]Loading planning signals. No calendar, scheduler, job, tracker, or service will change...[/i]"
	var err := schedule_http.request("%s/api/schedule-plan-center/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nSchedule Center request failed."

func _create_schedule_draft() -> void:
	if current_room_id != "schedule-plan-center":
		room_body.text += "\n\n[b]Schedule center[/b]\nEnter Schedule and Plan Center to create schedule drafts."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "AI Town weekly planning draft",
		"body": "Plan the next work window from current PLAN items, local tasks, office notes, and memory signals. Keep execution behind Task Board or confirm-required Terminal Control.",
		"horizon": "week",
		"source_building": "schedule-plan-center"
	}
	room_body.text += "\n\n[i]Creating project-local schedule draft. No external calendar or scheduler will change.[/i]"
	var err := schedule_http.request("%s/api/schedule-plan-center/drafts" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nSchedule draft request failed."

func _load_learning_training() -> void:
	if current_room_id != "learning-training-grounds":
		room_body.text += "\n\n[b]Training grounds[/b]\nEnter Learning Training Grounds to inspect local skills and practice tracks."
		return
	room_body.text += "\n\n[i]Loading local learning map. No skills, commands, agents, courses, or schedules will change...[/i]"
	var err := learning_http.request("%s/api/learning-training-grounds/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nLearning Training request failed."

func _create_learning_plan() -> void:
	if current_room_id != "learning-training-grounds":
		room_body.text += "\n\n[b]Training grounds[/b]\nEnter Learning Training Grounds to create learning plans."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "AI Town implementation practice plan",
		"body": "Practice one AI Town engineering skill with a small proof artifact, then route follow-up through Task Board or Schedule Center.",
		"track": "ai-town",
		"source_building": "learning-training-grounds"
	}
	room_body.text += "\n\n[i]Creating project-local learning plan. Nothing will be installed or executed.[/i]"
	var err := learning_http.request("%s/api/learning-training-grounds/plans" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nLearning plan request failed."

func _load_language_learning() -> void:
	if current_room_id != "language-learning-area":
		room_body.text += "\n\n[b]Language area[/b]\nEnter Language Learning Area to inspect multilingual UI signals and practice notes."
		return
	room_body.text += "\n\n[i]Loading local language practice map. No translators, APIs, agents, calendars, or source files will change...[/i]"
	var err := language_http.request("%s/api/language-learning-area/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nLanguage Learning request failed."

func _create_language_practice() -> void:
	if current_room_id != "language-learning-area":
		room_body.text += "\n\n[b]Language area[/b]\nEnter Language Learning Area to create practice notes."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "AI Town bilingual UI phrase practice",
		"body": "Practice a small set of AI Town UI or dialogue phrases manually before promoting wording into docs or game text.",
		"language": "zh-en",
		"source_building": "language-learning-area"
	}
	room_body.text += "\n\n[i]Creating project-local language practice note. No translation API or source file will change.[/i]"
	var err := language_http.request("%s/api/language-learning-area/practice" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nLanguage practice request failed."

func _load_research_data_center() -> void:
	if current_room_id != "research-data-center":
		room_body.text += "\n\n[b]Research data center[/b]\nEnter Research Data Center to inspect bounded dataset/result candidates."
		return
	room_body.text += "\n\n[i]Loading research data map. No experiments, dataset edits, uploads, or server calls will run...[/i]"
	var err := research_data_http.request("%s/api/research-data-center/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nResearch Data Center request failed."

func _create_research_data_note() -> void:
	if current_room_id != "research-data-center":
		room_body.text += "\n\n[b]Research data center[/b]\nEnter Research Data Center to create data audit notes."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "AI Town research data provenance note",
		"body": "Record one dataset/result artifact, its provenance, schema or metric meaning, and any reproducibility risks before promoting it into paper or experiment claims.",
		"project_id": "ai-town",
		"source_building": "research-data-center"
	}
	room_body.text += "\n\n[i]Creating project-local research data note. No datasets, experiments, or servers will change.[/i]"
	var err := research_data_http.request("%s/api/research-data-center/notes" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nResearch data note request failed."

func _load_paper_reading_room() -> void:
	if current_room_id != "paper-reading-room":
		room_body.text += "\n\n[b]Paper reading room[/b]\nEnter Paper Reading Room to inspect papers, BibTeX, and reading notes."
		return
	room_body.text += "\n\n[i]Loading bounded paper map. No large PDF parsing, downloads, bibliography edits, or search APIs will run...[/i]"
	var err := paper_reading_http.request("%s/api/paper-reading-room/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nPaper Reading Room request failed."

func _load_paper_citation_audit() -> void:
	if current_room_id != "paper-reading-room":
		room_body.text += "\n\n[b]Citation audit[/b]\nEnter Paper Reading Room to inspect bounded BibTeX citation metadata."
		return
	room_body.text += "\n\n[i]Auditing bounded allowlisted BibTeX metadata for duplicate keys and missing core fields. No bibliography files will change...[/i]"
	var err := paper_reading_http.request("%s/api/paper-reading-room/citation-audit" % API_BASE)
	if err != OK:
		room_body.text += "\nCitation audit request failed."

func _create_paper_reading_note() -> void:
	if current_room_id != "paper-reading-room":
		room_body.text += "\n\n[b]Paper reading room[/b]\nEnter Paper Reading Room to create reading notes."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "AI Town citation audit reading note",
		"body": "Summarize one paper or bibliography artifact, claim/evidence boundary, missing citation risks, and next ARIS audit action.",
		"topic": "ai-town",
		"source_building": "paper-reading-room"
	}
	room_body.text += "\n\n[i]Creating project-local paper reading note. No PDFs, BibTeX files, or research folders will change.[/i]"
	var err := paper_reading_http.request("%s/api/paper-reading-room/notes" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nPaper reading note request failed."

func _create_paper_citation_audit_note() -> void:
	if current_room_id != "paper-reading-room":
		room_body.text += "\n\n[b]Citation audit[/b]\nEnter Paper Reading Room to create citation audit notes."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "AI Town bounded citation audit note",
		"body": "Review duplicate BibTeX keys, missing title/author/year/venue fields, and next ARIS-safe bibliography cleanup steps before any manuscript edit.",
		"source_building": "paper-reading-room"
	}
	room_body.text += "\n\n[i]Creating project-local citation audit note. No BibTeX, manuscript, PDF, or research folder will change.[/i]"
	var err := paper_reading_http.request("%s/api/paper-reading-room/citation-audits" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nCitation audit note request failed."

func _queue_paper_extraction() -> void:
	if current_room_id != "paper-reading-room":
		room_body.text += "\n\n[b]Paper reading room[/b]\nEnter Paper Reading Room to extract a bounded PDF preview."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"root_id": selected_paper_root_id,
		"relative_path": selected_paper_relative_path,
		"max_pages": 3,
		"source_building": "paper-reading-room"
	}
	room_body.text += "\n\n[i]Queueing bounded PDF extraction job. The backend reads one allowlisted PDF and writes a project-local report only...[/i]"
	var err := paper_reading_http.request("%s/api/paper-reading-room/extract-jobs" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nPDF extraction job request failed."

func _poll_paper_extraction_job() -> void:
	if selected_paper_job_id == "":
		room_body.text += "\n\nNo PDF extraction job is selected yet."
		return
	var err := paper_reading_http.request("%s/api/jobs/%s" % [API_BASE, selected_paper_job_id])
	if err != OK:
		room_body.text += "\nPDF extraction job poll failed."

func _load_version_release_plaza() -> void:
	if current_room_id != "version-release-plaza":
		room_body.text += "\n\n[b]Version release plaza[/b]\nEnter Version Release Plaza to inspect release readiness."
		return
	room_body.text += "\n\n[i]Loading release readiness. No commit, tag, push, PR, release, or doc overwrite will happen...[/i]"
	var err := release_http.request("%s/api/version-release-plaza/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nVersion Release Plaza request failed."

func _create_release_checklist() -> void:
	if current_room_id != "version-release-plaza":
		room_body.text += "\n\n[b]Version release plaza[/b]\nEnter Version Release Plaza to create release checklists."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "AI Town local release readiness checklist",
		"body": "Prepare the next open-source release gate: public docs, license, screenshots, smoke evidence, git status, and confirm-required GitHub actions.",
		"release_target": "local-preview",
		"source_building": "version-release-plaza"
	}
	room_body.text += "\n\n[i]Creating project-local release checklist. Git and GitHub state will not change.[/i]"
	var err := release_http.request("%s/api/version-release-plaza/checklists" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nRelease checklist request failed."

func _create_release_report() -> void:
	if current_room_id != "version-release-plaza":
		room_body.text += "\n\n[b]Version release plaza[/b]\nEnter Version Release Plaza to create readiness reports."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "AI Town release readiness report",
		"release_target": "local-preview",
		"source_building": "version-release-plaza"
	}
	room_body.text += "\n\n[i]Creating project-local readiness report from existing evidence. No Git or GitHub state will change.[/i]"
	var err := release_http.request("%s/api/version-release-plaza/reports" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nRelease readiness report request failed."

func _load_plugin_registry() -> void:
	if current_room_id != "plugin-registry":
		room_body.text += "\n\n[b]Plugin registry[/b]\nEnter Plugin Registry to inspect extension candidates."
		return
	room_body.text += "\n\n[i]Loading extension map. No plugins, skills, registries, scripts, downloads, package managers, or agents will change...[/i]"
	var err := plugin_http.request("%s/api/plugin-registry/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nPlugin Registry request failed."

func _load_plugin_manifests() -> void:
	if current_room_id != "plugin-registry":
		room_body.text += "\n\n[b]Plugin manifests[/b]\nEnter Plugin Registry to inspect typed extension manifests."
		return
	room_body.text += "\n\n[i]Loading typed plugin manifests and activation gates without changing plugin state...[/i]"
	var err := plugin_http.request("%s/api/plugin-registry/manifests" % API_BASE)
	if err != OK:
		room_body.text += "\nPlugin manifest request failed."

func _create_plugin_draft() -> void:
	if current_room_id != "plugin-registry":
		room_body.text += "\n\n[b]Plugin registry[/b]\nEnter Plugin Registry to create plugin proposal drafts."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "AI Town extension proposal",
		"body": "Describe a safe extension idea, expected manifest or room ownership, local sources, verification proof, and promotion boundary before implementation.",
		"plugin_id": "ai-town-extension",
		"category": "workflow",
		"source_building": "plugin-registry"
	}
	room_body.text += "\n\n[i]Creating project-local plugin proposal. No plugin, skill, registry, script, package manager, or agent will change.[/i]"
	var err := plugin_http.request("%s/api/plugin-registry/drafts" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nPlugin draft request failed."

func _create_plugin_activation_plan() -> void:
	if current_room_id != "plugin-registry":
		room_body.text += "\n\n[b]Plugin activation plan[/b]\nEnter Plugin Registry to create activation review plans."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"manifest_id": "permission-secret-audit",
		"title": "AI Town plugin activation review",
		"body": "Review typed manifest permissions, files, endpoints, verification, and rollback before implementation. This plan does not activate the plugin.",
		"confirmation": "PLAN_PLUGIN_ACTIVATION",
		"source_building": "plugin-registry"
	}
	room_body.text += "\n\n[i]Creating confirm-gated activation review plan only. No plugin, registry, script, package manager, skill, download, or agent will change.[/i]"
	var err := plugin_http.request("%s/api/plugin-registry/activation-plans" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nPlugin activation plan request failed."

func _load_backup_station() -> void:
	if current_room_id != "backup-station":
		room_body.text += "\n\n[b]Backup station[/b]\nEnter Backup Station to inspect backup sources, targets, and plan drafts."
		return
	room_body.text += "\n\n[i]Loading backup map. No copy, restore, compression, upload, or scheduler will run...[/i]"
	var err := backup_http.request("%s/api/backup-station/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nBackup Station request failed."

func _load_backup_integrity() -> void:
	if current_room_id != "backup-station":
		room_body.text += "\n\n[b]Backup station[/b]\nEnter Backup Station to inspect restore-check evidence."
		return
	room_body.text += "\n\n[i]Loading read-only integrity sample. Small files may be hashed; no backup or restore will run...[/i]"
	var err := backup_http.request("%s/api/backup-station/integrity?source_id=ai-town-project&limit=12" % API_BASE)
	if err != OK:
		room_body.text += "\nBackup integrity request failed."

func _create_backup_plan() -> void:
	if current_room_id != "backup-station":
		room_body.text += "\n\n[b]Backup station[/b]\nEnter Backup Station to create backup plan drafts."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "AI Town backup and restore plan",
		"body": "Review backup scope, target folder, retention, restore check, and future confirm-required activation path before any real backup runs.",
		"source_id": "ai-town-project",
		"target_id": "project-backups",
		"source_building": "backup-station"
	}
	room_body.text += "\n\n[i]Creating project-local backup plan. No files will be copied or restored.[/i]"
	var err := backup_http.request("%s/api/backup-station/plans" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nBackup plan request failed."

func _load_goal_tower() -> void:
	if current_room_id != "goal-tower":
		room_body.text += "\n\n[b]Goal tower[/b]\nEnter Long-Term Goal Tower to inspect roadmap signals and goal drafts."
		return
	room_body.text += "\n\n[i]Loading long-term goal map from PLAN, memory signals, tasks, and portfolio status...[/i]"
	var err := goal_http.request("%s/api/goal-tower/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nGoal Tower request failed."

func _create_goal_draft() -> void:
	if current_room_id != "goal-tower":
		room_body.text += "\n\n[b]Goal tower[/b]\nEnter Long-Term Goal Tower to create goal drafts."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "AI Town long-term playable workworld milestone",
		"body": "Define the next long-term milestone for turning AI Town into a polished Godot local-work game with real files, agents, tasks, verification, and a warm storybook visual baseline.",
		"horizon": "quarter",
		"source_building": "goal-tower"
	}
	room_body.text += "\n\n[i]Creating project-local goal draft. No tracker, repo, experiment, schedule, or agent runner will change.[/i]"
	var err := goal_http.request("%s/api/goal-tower/goals" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nGoal draft request failed."

func _load_inspiration_station() -> void:
	if current_room_id != "inspiration-station":
		room_body.text += "\n\n[b]Inspiration station[/b]\nEnter Inspiration Collection Station to inspect idea signals and local notes."
		return
	room_body.text += "\n\n[i]Loading idea inbox from project docs, visual baseline, memory signals, and local drafts...[/i]"
	var err := inspiration_http.request("%s/api/inspiration-station/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nInspiration Station request failed."

func _create_inspiration_note() -> void:
	if current_room_id != "inspiration-station":
		room_body.text += "\n\n[b]Inspiration station[/b]\nEnter Inspiration Collection Station to create idea notes."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "AI Town inspiration note",
		"body": "Capture a useful design, gameplay, workflow, or visual idea for a future AI Town implementation slice.",
		"tag": "ai-town",
		"source_building": "inspiration-station"
	}
	room_body.text += "\n\n[i]Creating project-local inspiration note. Source docs and assets stay untouched.[/i]"
	var err := inspiration_http.request("%s/api/inspiration-station/notes" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nInspiration note request failed."

func _load_temporary_draft_box() -> void:
	if current_room_id != "temporary-draft-box":
		room_body.text += "\n\n[b]Temporary draft box[/b]\nEnter Temporary Draft Box to inspect local draft shelves."
		return
	room_body.text += "\n\n[i]Loading project-local draft shelves and scratch notes...[/i]"
	var err := temp_draft_http.request("%s/api/temporary-draft-box/overview" % API_BASE)
	if err != OK:
		room_body.text += "\nTemporary Draft Box request failed."

func _create_temp_draft() -> void:
	if current_room_id != "temporary-draft-box":
		room_body.text += "\n\n[b]Temporary draft box[/b]\nEnter Temporary Draft Box to create scratch notes."
		return
	var headers := PackedStringArray(["Content-Type: application/json"])
	var request := {
		"title": "AI Town temporary scratch note",
		"body": "Capture a quick unsorted note before deciding whether it belongs in Task Board, Writing Studio, Goal Tower, Bug Clinic, or Inspiration Station.",
		"route_hint": "triage-later",
		"source_building": "temporary-draft-box"
	}
	room_body.text += "\n\n[i]Creating project-local scratch note. Nothing will be promoted, sent, or overwritten.[/i]"
	var err := temp_draft_http.request("%s/api/temporary-draft-box/drafts" % API_BASE, headers, HTTPClient.METHOD_POST, JSON.stringify(request))
	if err != OK:
		room_body.text += "\nTemporary draft request failed."

func _review_room_shelves() -> void:
	if current_room_id == "town":
		return
	room_body.text += "\n\n[b]Shelves reviewed.[/b]\nYou checked the local references for this room."
	if desktop_ui_test_mode:
		_write_desktop_ui_test_state("review_shelves_clicked")
	_advance_quest_step("review_shelves", current_room_id)

func _leave_room() -> void:
	room_overlay.visible = false
	current_room_id = "town"
	camera.zoom = Vector2(0.85, 0.85)
	detail_body.text = "Back in town. Choose a building or resident to continue the local-work adventure."

func _on_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		if pending_request.begins_with("building:"):
			_show_local_building_fallback(pending_request.get_slice(":", 1))
		else:
			status_label.text = "Agent Town Godot | Backend unavailable | Start backend/start.cmd for live data"
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if pending_request == "health":
		status_label.text = "Agent Town Godot | Backend ok | Adapters: %s" % JSON.stringify(parsed.get("adapters", {}))
	elif pending_request.begins_with("building:"):
		_render_building_data(parsed)
	elif pending_request.begins_with("dialogue:"):
		var model_line := ""
		if str(parsed.get("model_profile", "")) != "":
			model_line = "\n[i]model: %s | %s[/i]" % [parsed.get("model_profile", ""), parsed.get("model_status", "")]
		detail_body.text += "\n\n[b]%s:[/b] %s%s" % [pending_request.get_slice(":", 1), parsed.get("response", "..."), model_line]
		_record_activity("Agent dialogue", "%s | %s" % [pending_request.get_slice(":", 1), parsed.get("model_status", "")], "agent")

func _on_quest_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		if not local_quest_defs.is_empty():
			_render_quests(local_quest_defs)
			quest_body.text += "\n\n[i]Backend unavailable; showing local quest registry fallback.[/i]"
		else:
			quest_body.text = "Quest backend unavailable. The town can still be explored."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		if not local_quest_defs.is_empty():
			_render_quests(local_quest_defs)
		return
	_render_quests(parsed.get("quests", []))

func _on_daily_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		quest_body.text = "Daily routes are unavailable. Backend may be offline."
		daily_claim_button.disabled = true
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		quest_body.text = "Daily route response could not be parsed."
		daily_claim_button.disabled = true
		return
	_render_daily_routes(parsed)

func _on_collection_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		quest_body.text = "Collection Codex unavailable. Badge Case still shows local saved progress."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		quest_body.text = "Collection Codex response could not be parsed."
		return
	_render_collection_codex(parsed)

func _on_action_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		detail_body.text += "\nSafe scan failed. Backend may be offline."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	var status := str(parsed.get("status", "unknown"))
	var safety := str(parsed.get("safety", "read-only"))
	detail_body.text += "\n\n[b]Workbench:[/b] %s (%s)" % [status, safety]
	if status == "preview":
		pending_draft_confirmation = str(parsed.get("confirmation_required", ""))
		room_save_draft_button.disabled = pending_draft_confirmation == ""
		var preview := str(parsed.get("preview", ""))
		var target := str(parsed.get("target_path", ""))
		_record_activity("Draft preview ready", target, "workbench")
		detail_body.text += "\n[b]Draft target:[/b] %s" % target
		if room_overlay.visible:
			room_body.text += "\n\n[b]Draft preview ready.[/b]\nTarget: %s\n\n%s" % [target, preview]
		return
	if status == "saved":
		room_save_draft_button.disabled = true
		pending_draft_confirmation = ""
		detail_body.text += "\n[b]Saved:[/b] %s" % parsed.get("target_path", "")
		_record_activity("Draft saved", str(parsed.get("target_path", "")), "workbench")
		if room_overlay.visible:
			room_body.text += "\n\n[b]Draft saved.[/b]\n%s" % parsed.get("target_path", "")
		_record_room_mastery(active_building_id, "draft", 2, true)
		return
	if status == "confirmation-required":
		pending_draft_confirmation = str(parsed.get("confirmation_required", ""))
		room_save_draft_button.disabled = pending_draft_confirmation == ""
		detail_body.text += "\nConfirmation required: %s" % pending_draft_confirmation
		return
	if parsed.has("result"):
		detail_body.text += "\n[color=#4a3a2a]%s[/color]" % JSON.stringify(parsed.result)
		_record_activity("Safe scan complete", _building_def(active_building_id).get("name", active_building_id), "workbench")
		if room_overlay.visible:
			room_body.text += "\n\n[b]Workbench scan complete.[/b]\n[color=#4a3a2a]%s[/color]" % JSON.stringify(parsed.result)
		_record_room_mastery(active_building_id, "scan", 2, true)
		_record_npc_chain_action("scan", active_building_id)
	_advance_quest_step("scan", active_building_id)
	_check_quest_completion(active_building_id)

func _on_room_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text = "Room data unavailable. Backend may be offline."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("skills"):
		_render_skill_workshop(parsed)
		_record_npc_chain_action("skill_overview", "skill-workshop")
	elif parsed.has("tools"):
		_render_devtools_lab(parsed)
		_record_npc_chain_action("devtools_overview", "devtools-lab")
	else:
		_render_room(parsed)

func _on_research_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nResearch console unavailable. Start backend for live research project boards."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("projects"):
		_render_research_project_index(parsed)
	elif parsed.has("log_path"):
		_render_research_log_created(parsed)
	elif parsed.has("experiment_entries"):
		_render_research_project_detail(parsed)

func _on_memory_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nMemory console unavailable. Start backend for live shared memory shelves."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("categories"):
		_render_memory_index(parsed)
		_record_npc_chain_action("memory_index", "memory-library")
	elif parsed.has("promotion_path") or parsed.get("status", "") == "confirmation-required" or parsed.get("status", "") == "dry-run":
		_render_memory_promotion(parsed)
	elif parsed.has("proposal_path"):
		_render_memory_proposal_created(parsed)
		_record_npc_chain_action("memory_proposal", "memory-library")
	elif parsed.has("preview"):
		_render_memory_detail(parsed)
		_record_npc_chain_action("memory_detail", "memory-library")

func _on_knowledge_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nKnowledge console unavailable. Start backend for cached local knowledge search."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("results"):
		_render_knowledge_search(parsed)
		_record_npc_chain_action("knowledge_search", "knowledge-tower")
	elif parsed.has("document"):
		_render_knowledge_item(parsed)
		_record_npc_chain_action("knowledge_detail", "knowledge-tower")
	elif parsed.has("job_id"):
		_render_knowledge_index_job(parsed)
	elif parsed.has("roots"):
		_render_knowledge_index(parsed)
		_record_npc_chain_action("knowledge_index", "knowledge-tower")

func _on_file_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nFile Vault unavailable. Start backend for live file browsing."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("roots"):
		_render_file_roots(parsed)
	elif parsed.get("mode", "") == "cached-file-organization-audit":
		_render_file_organize_audit(parsed)
	elif parsed.has("job_id"):
		_render_file_index_job(parsed)
	elif parsed.has("results"):
		_render_file_search(parsed)
	elif parsed.has("item") and parsed.has("tag_path"):
		_render_file_tag_saved(parsed)
	elif parsed.has("proposal_path"):
		_render_file_organize_proposal(parsed)
	elif parsed.has("opened_path"):
		_render_file_opened(parsed)
	elif parsed.has("items"):
		_render_file_listing(parsed)
	elif parsed.has("preview") or parsed.get("status", "") == "blocked":
		_render_file_preview(parsed)

func _on_agent_hub_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nAgent console unavailable. Start backend for live local agent metadata."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("roster"):
		_render_agent_roster(parsed)
	elif parsed.has("runners"):
		_render_agent_runner_readiness(parsed)
	elif parsed.has("handoff_path"):
		_render_agent_runner_dispatch_preview(parsed)
	elif parsed.get("mode", "") == "confirm-required-agent-runner-launch":
		_render_agent_runner_launch_gate(parsed)
	elif parsed.has("chat_session"):
		_render_agent_chat_session(parsed)
	elif parsed.has("sessions"):
		_render_agent_chat_sessions(parsed)
	elif parsed.has("target_path"):
		_render_agent_dispatch_draft(parsed)

func _on_agent_task_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		agent_task_pending_action = ""
		room_body.text += "\n\nAgent task queue unavailable. Start backend for live local task state."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		agent_task_pending_action = ""
		return
	var pending_action := agent_task_pending_action
	agent_task_pending_action = ""
	if parsed.has("task") and parsed.has("queue"):
		if pending_action == "events" or parsed.has("events"):
			_render_agent_task_events(parsed)
		elif pending_action == "pause" or pending_action == "resume" or pending_action == "cancel":
			_render_agent_task_status_changed(parsed, pending_action)
		elif str(parsed.get("status", "")) == "ok":
			_render_agent_task_detail(parsed)
		else:
			_render_agent_task_submitted(parsed)
	elif parsed.get("mode", "") == "safe-local-agent-task-concurrency-policy":
		_render_agent_task_policy(parsed)
	elif parsed.get("mode", "") == "read-only-agent-task-log-archive":
		_render_agent_task_logs(parsed)
	elif parsed.has("tasks"):
		_render_agent_task_queue(parsed)

func _on_agent_tool_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nAgent tool registry unavailable. Start backend for live local tool state."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("invocation") and parsed.has("queue"):
		if parsed.has("events"):
			_render_agent_tool_events(parsed)
		elif str(parsed.get("status", "")) == "ok":
			_render_agent_tool_invocation_detail(parsed)
		else:
			_render_agent_tool_invoked(parsed)
	elif parsed.get("mode", "") == "read-only-agent-tool-log-archive":
		_render_agent_tool_logs(parsed)
	elif parsed.has("tools"):
		_render_agent_tool_catalog(parsed)
	elif parsed.has("recent"):
		_render_agent_tool_invocations(parsed)

func _on_project_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nCode console unavailable. Start backend for live project metadata."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("projects"):
		_render_code_project_index(parsed)
	elif parsed.get("status", "") == "confirmation-required" and parsed.has("confirmation_required"):
		_render_project_verification_preview(parsed)
	elif parsed.has("job_id"):
		selected_project_job_id = str(parsed.get("job_id", ""))
		pending_project_verification_confirmation = false
		room_code_verify_button.text = "Run Check"
		room_code_check_job_button.disabled = selected_project_job_id == ""
		room_body.text += "\n\n[b]Project job queued.[/b]\nJob: %s\nKind: %s\nSafety: %s" % [selected_project_job_id, parsed.get("kind", ""), parsed.get("safety", "read-only")]
		if selected_project_job_id != "":
			project_http.request("%s/api/jobs/%s" % [API_BASE, selected_project_job_id])
	elif parsed.has("kind") and parsed.get("kind", "") == "project-inspect":
		_render_project_job(parsed)
	elif parsed.has("kind") and parsed.get("kind", "") == "project-verification":
		_render_project_verification_job(parsed)
	elif parsed.has("context_pack"):
		_render_code_context_pack(parsed)
	elif parsed.has("patch_plan"):
		_render_code_patch_plan(parsed)
	elif parsed.has("task"):
		_render_code_task_draft(parsed)
	elif parsed.has("git"):
		_render_code_project_detail(parsed)

func _on_harbor_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nHarbor console unavailable. Start backend for live Git metadata."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.get("mode", "") == "read-only-github-cli-snapshot":
		_render_harbor_github_snapshot(parsed)
		_record_npc_chain_action("harbor_github", "github-harbor")
	elif parsed.get("mode", "") == "read-only-github-publish-readiness":
		_render_harbor_publish_readiness(parsed)
		_record_npc_chain_action("harbor_github", "github-harbor")
	elif parsed.has("repos"):
		_render_harbor_index(parsed)
		_record_npc_chain_action("harbor_repos", "github-harbor")
	elif parsed.has("plan_path") or parsed.get("safety", "") == "github-publish-plan-only":
		_render_harbor_publish_plan(parsed)
		_record_npc_chain_action("harbor_draft", "github-harbor")
	elif parsed.has("draft_path"):
		_render_harbor_draft(parsed)
		_record_npc_chain_action("harbor_draft", "github-harbor")
	elif parsed.has("remotes"):
		_render_harbor_detail(parsed)
		_record_npc_chain_action("harbor_detail", "github-harbor")

func _on_terminal_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nTerminal console unavailable. Start backend for allowlisted local command jobs."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("commands"):
		_render_terminal_commands(parsed)
		_record_npc_chain_action("terminal_commands", "terminal-control")
	elif parsed.get("mode", "") == "terminal-command-preview":
		_render_terminal_command_preview(parsed)
		_record_npc_chain_action("terminal_commands", "terminal-control")
	elif parsed.get("status", "") == "confirmation-required":
		_render_terminal_confirmation(parsed)
		_record_npc_chain_action("terminal_run", "terminal-control")
	elif parsed.has("job_id"):
		selected_terminal_job_id = str(parsed.get("job_id", ""))
		terminal_confirmation_required = ""
		room_body.text += "\n\n[b]Terminal job queued.[/b]\nJob: %s\nSafety: %s" % [selected_terminal_job_id, parsed.get("safety", "confirm-required")]
		if selected_terminal_job_id != "":
			terminal_http.request("%s/api/jobs/%s" % [API_BASE, selected_terminal_job_id])
	elif parsed.has("kind") and parsed.get("kind", "") == "terminal-command":
		_render_terminal_job(parsed)
		_record_npc_chain_action("terminal_log", "terminal-control")

func _on_system_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nSystem monitor unavailable. Start backend for live service status."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("services"):
		_render_system_overview(parsed)
		_record_npc_chain_action("system_overview", "system-monitor")
	elif parsed.has("job") and parsed.has("queue"):
		_render_system_job_cancelled(parsed)
	elif parsed.get("mode", "") == "read-only-backend-job-log-detail":
		_render_system_job_log_detail(parsed)
	elif parsed.get("mode", "") == "read-only-backend-job-events":
		_render_system_job_events(parsed)
	elif parsed.has("events"):
		_render_system_events(parsed)
		_record_npc_chain_action("system_events", "system-monitor")
	elif parsed.has("recent"):
		_render_system_jobs(parsed)
		_record_npc_chain_action("system_jobs", "system-monitor")

func _on_town_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nTown Hall atlas unavailable. Start backend for live capability metadata."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.get("mode", "") == "read-only-building-capability-detail":
		_render_town_capability_detail(parsed)
	elif parsed.get("mode", "") == "read-only-building-capability-map":
		_render_town_capability_atlas(parsed)
		_record_npc_chain_action("town_capability", "town-hall")
	elif parsed.get("mode", "") == "read-only-workflow-route-detail":
		_render_town_workflow_detail(parsed)
	elif parsed.get("mode", "") == "read-only-workflow-route-registry":
		_render_town_workflow_routes(parsed)
		_record_npc_chain_action("town_workflows", "town-hall")

func _on_model_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nModel gateway unavailable. Start backend for model/API status."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("draft_path"):
		_render_model_config_draft(parsed)
	elif parsed.has("report_path"):
		_render_model_profile_test(parsed)
		_record_npc_chain_action("model_test", "model-market")
	elif parsed.has("vault_path") and parsed.has("entries"):
		_render_model_key_vault(parsed)
		_record_npc_chain_action("model_key_vault", "model-market")
	else:
		_render_model_gateway(parsed)
		if parsed.has("profiles"):
			_record_npc_chain_action("model_profiles", "model-market")
		else:
			_record_npc_chain_action("model_status", "model-market")

func _on_task_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nTask Board unavailable. Start backend for local task ledger."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("local_tasks"):
		_render_task_board(parsed)
		_record_npc_chain_action("task_overview", "task-board")
	elif parsed.get("status", "") == "ok" and parsed.has("preview") and parsed.has("task"):
		_render_task_detail(parsed)
		_record_npc_chain_action("task_detail", "task-board")
	elif parsed.has("task"):
		if parsed.get("status", "") == "updated":
			_render_task_status_updated(parsed)
		else:
			_render_task_created(parsed)
			_record_npc_chain_action("task_create", "task-board")

func _on_writing_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nWriting Studio unavailable. Start backend for local writing drafts."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("documents"):
		_render_writing_studio(parsed)
		_record_npc_chain_action("writing_overview", "writing-studio")
	elif parsed.has("draft_path"):
		_render_writing_draft_created(parsed)
		_record_npc_chain_action("writing_draft", "writing-studio")

func _on_automation_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nAutomation Factory unavailable. Start backend for local automation blueprints."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.get("mode", "") == "read-only-windows-scheduler-snapshot":
		_render_automation_scheduler(parsed)
		_record_npc_chain_action("automation_scheduler", "automation-factory")
	elif parsed.has("scripts"):
		_render_automation_factory(parsed)
		_record_npc_chain_action("automation_overview", "automation-factory")
	elif parsed.has("draft_path"):
		_render_automation_draft_created(parsed)
		_record_npc_chain_action("automation_draft", "automation-factory")

func _on_permission_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nPermission Hall unavailable. Start backend for safety policy data."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.get("mode", "") == "read-only-secret-exposure-audit":
		_render_permission_secret_audit(parsed)
	else:
		_render_permission_hall(parsed)
		_record_npc_chain_action("permission_overview", "permission-hall")

func _on_settings_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nSettings Center unavailable. Start backend for config status."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.get("mode", "") == "read-only-schema-validation":
		_render_registry_health(parsed)
	elif parsed.has("registries"):
		_render_settings_center(parsed)
		_record_npc_chain_action("settings_overview", "settings-center")
	elif parsed.has("draft_path"):
		_render_settings_draft_created(parsed)
		_record_npc_chain_action("settings_draft", "settings-center")

func _on_testing_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nTesting Arena unavailable. Start backend for verification status."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("scripts"):
		_render_testing_arena(parsed)
	elif parsed.has("proof") and parsed.has("preview"):
		_render_vertical_slice_proof_detail(parsed)
	elif parsed.has("report_path"):
		_render_vertical_slice_proof(parsed)
	elif parsed.has("draft_path"):
		_render_test_plan_created(parsed)

func _on_bug_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nBug Clinic unavailable. Start backend for diagnostic status."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("diagnostics"):
		_render_bug_clinic(parsed)
		_record_npc_chain_action("bug_overview", "bug-clinic")
	elif parsed.has("draft_path"):
		_render_bug_report_created(parsed)
		_record_npc_chain_action("bug_report", "bug-clinic")

func _on_management_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nProject Management Hall unavailable. Start backend for portfolio status."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("projects"):
		_render_project_management(parsed)
		_record_npc_chain_action("project_management_overview", "project-management-hall")
	elif parsed.has("draft_path"):
		_render_project_brief_created(parsed)
		_record_npc_chain_action("project_brief", "project-management-hall")

func _on_download_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nDownload Station unavailable. Start backend for download intake status."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.get("mode", "") == "read-only-download-triage":
		_render_download_triage(parsed)
		_record_npc_chain_action("download_triage", "download-station")
	elif parsed.has("roots"):
		_render_download_station(parsed)
		_record_npc_chain_action("download_overview", "download-station")
	elif parsed.has("draft_path"):
		_render_download_intake_created(parsed)
		_record_npc_chain_action("download_intake", "download-station")

func _on_asset_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nAsset Resource Gallery unavailable. Start backend for asset curation status."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.get("mode", "") == "read-only-asset-inspection":
		_render_asset_inspection(parsed)
		_record_npc_chain_action("asset_inspect", "asset-gallery")
	elif parsed.has("assets"):
		_render_asset_gallery(parsed)
		_record_npc_chain_action("asset_overview", "asset-gallery")
	elif parsed.has("draft_path"):
		_render_asset_note_created(parsed)
		_record_npc_chain_action("asset_note", "asset-gallery")

func _on_office_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nLocal Office Center unavailable. Start backend for office workspace status."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("recent_items"):
		_render_local_office_center(parsed)
		_record_npc_chain_action("office_overview", "local-office-center")
	elif parsed.has("draft_path"):
		_render_office_note_created(parsed)
		_record_npc_chain_action("office_note", "local-office-center")

func _on_schedule_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nSchedule and Plan Center unavailable. Start backend for planning signals."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("planning_rules"):
		_render_schedule_plan_center(parsed)
		_record_npc_chain_action("schedule_overview", "schedule-plan-center")
	elif parsed.has("draft_path"):
		_render_schedule_draft_created(parsed)
		_record_npc_chain_action("schedule_draft", "schedule-plan-center")

func _on_learning_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nLearning Training Grounds unavailable. Start backend for training resources."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("tracks"):
		_render_learning_training(parsed)
		_record_npc_chain_action("learning_overview", "learning-training-grounds")
	elif parsed.has("draft_path"):
		_render_learning_plan_created(parsed)
		_record_npc_chain_action("learning_plan", "learning-training-grounds")

func _on_language_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nLanguage Learning Area unavailable. Start backend for language practice resources."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("supported_languages"):
		_render_language_learning(parsed)
		_record_npc_chain_action("language_overview", "language-learning-area")
	elif parsed.has("draft_path"):
		_render_language_practice_created(parsed)
		_record_npc_chain_action("language_practice", "language-learning-area")

func _on_research_data_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nResearch Data Center unavailable. Start backend for research data resources."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("candidates"):
		_render_research_data_center(parsed)
		_record_npc_chain_action("research_data_overview", "research-data-center")
	elif parsed.has("draft_path"):
		_render_research_data_note_created(parsed)
		_record_npc_chain_action("research_data_note", "research-data-center")

func _on_paper_reading_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nPaper Reading Room unavailable. Start backend for paper reading resources."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.get("kind", "") == "paper-pdf-extraction" and parsed.get("status", "") == "saved":
		_render_paper_extraction_result(parsed)
		_record_npc_chain_action("paper_extract", "paper-reading-room")
	elif parsed.get("mode", "") == "read-only-citation-audit":
		_render_paper_citation_audit(parsed)
		_record_npc_chain_action("paper_note", "paper-reading-room")
	elif parsed.get("safety", "") == "citation-audit-note-only":
		_render_paper_citation_audit_note(parsed)
		_record_npc_chain_action("paper_note", "paper-reading-room")
	elif parsed.has("safety") and parsed.get("status", "") in ["dry-run", "not-available", "unsupported", "too-large"]:
		_render_paper_extraction_availability(parsed)
		_record_npc_chain_action("paper_extract", "paper-reading-room")
	elif parsed.has("kind") and parsed.has("status") and parsed.get("status", "") in ["queued", "running", "done", "failed", "missing"]:
		_render_paper_extraction_job(parsed)
		_record_npc_chain_action("paper_extract", "paper-reading-room")
	elif parsed.has("papers"):
		_render_paper_reading_room(parsed)
		_record_npc_chain_action("paper_overview", "paper-reading-room")
	elif parsed.has("draft_path"):
		_render_paper_reading_note_created(parsed)
		_record_npc_chain_action("paper_note", "paper-reading-room")

func _on_release_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nVersion Release Plaza unavailable. Start backend for release readiness resources."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("release_gates"):
		_render_version_release_plaza(parsed)
		_record_npc_chain_action("release_overview", "version-release-plaza")
	elif parsed.has("report_path"):
		_render_release_report_created(parsed)
		_record_npc_chain_action("release_report", "version-release-plaza")
	elif parsed.has("draft_path"):
		_render_release_checklist_created(parsed)
		_record_npc_chain_action("release_checklist", "version-release-plaza")

func _on_plugin_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nPlugin Registry unavailable. Start backend for extension resources."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.get("mode", "") == "read-only-typed-plugin-manifest-audit":
		_render_plugin_manifests(parsed)
		_record_npc_chain_action("plugin_manifests", "plugin-registry")
	elif parsed.has("plan_path") or parsed.get("status", "") == "confirmation-required":
		_render_plugin_activation_plan(parsed)
	elif parsed.has("extension_gates"):
		_render_plugin_registry(parsed)
		_record_npc_chain_action("plugin_overview", "plugin-registry")
	elif parsed.has("draft_path"):
		_render_plugin_draft_created(parsed)
		_record_npc_chain_action("plugin_draft", "plugin-registry")

func _on_backup_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nBackup Station unavailable. Start backend for backup map status."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.get("mode", "") == "read-only-backup-integrity-snapshot":
		_render_backup_integrity(parsed)
		_record_npc_chain_action("backup_integrity", "backup-station")
	elif parsed.has("sources"):
		_render_backup_station(parsed)
		_record_npc_chain_action("backup_overview", "backup-station")
	elif parsed.has("draft_path"):
		_render_backup_plan_created(parsed)
		_record_npc_chain_action("backup_plan", "backup-station")

func _on_goal_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nGoal Tower unavailable. Start backend for long-term goal status."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("plan_tasks"):
		_render_goal_tower(parsed)
		_record_npc_chain_action("goal_overview", "goal-tower")
	elif parsed.has("draft_path"):
		_render_goal_draft_created(parsed)
		_record_npc_chain_action("goal_draft", "goal-tower")

func _on_inspiration_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nInspiration Station unavailable. Start backend for idea inbox status."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("signals"):
		_render_inspiration_station(parsed)
		_record_npc_chain_action("inspiration_overview", "inspiration-station")
	elif parsed.has("draft_path"):
		_render_inspiration_note_created(parsed)
		_record_npc_chain_action("inspiration_note", "inspiration-station")

func _on_temp_draft_http_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		room_body.text += "\n\nTemporary Draft Box unavailable. Start backend for draft shelf status."
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if parsed.has("shelves"):
		_render_temporary_draft_box(parsed)
		_record_npc_chain_action("temp_drafts_overview", "temporary-draft-box")
	elif parsed.has("draft_path"):
		_render_temp_draft_created(parsed)
		_record_npc_chain_action("temp_draft", "temporary-draft-box")

func _render_harbor_index(data: Dictionary) -> void:
	selected_harbor_repo_id = ""
	var lines := [
		"[b]GitHub Harbor Docks[/b]",
		"Repos: %s | mode=%s" % [str(data.get("count", 0)), data.get("mode", "read-only")],
		"%s" % data.get("safe_note", ""),
		""
	]
	for repo in data.get("repos", []):
		if typeof(repo) != TYPE_DICTIONARY:
			continue
		var repo_id := str(repo.get("id", ""))
		if selected_harbor_repo_id == "" and repo_id != "":
			selected_harbor_repo_id = repo_id
		lines.append("[color=#4a3a2a]%s[/color] (%s)" % [repo.get("name", "repo"), repo_id])
		lines.append("  branch: %s | remote=%s | tags=%s" % [repo.get("branch", ""), str(repo.get("has_remote", false)), str(repo.get("tag_count_sampled", 0))])
		var remotes: Array = repo.get("remotes", [])
		if not remotes.is_empty():
			lines.append("  %s" % str(remotes[0]))
	room_body.text = "\n".join(lines)
	room_harbor_detail_button.disabled = selected_harbor_repo_id == ""
	room_harbor_github_button.disabled = selected_harbor_repo_id == ""
	room_harbor_readiness_button.disabled = selected_harbor_repo_id == ""
	room_harbor_draft_button.disabled = selected_harbor_repo_id == ""
	room_harbor_publish_plan_button.disabled = selected_harbor_repo_id == ""
	if selected_harbor_repo_id != "":
		detail_body.text = "[b]GitHub Harbor[/b]\nSelected first dock: %s. Use Harbor Detail for local Git, GH Status for read-only GitHub CLI metadata, Publish Ready for local release checks, or PR Plan for a confirm-gated local handoff." % selected_harbor_repo_id

func _render_harbor_detail(repo: Dictionary) -> void:
	var lines := [
		"[b]%s Harbor Detail[/b]" % repo.get("name", repo.get("id", "Repository")),
		"Path: %s" % repo.get("path", ""),
		"Branch: %s | Dirty files: %s" % [repo.get("git", {}).get("branch", ""), str(repo.get("git", {}).get("dirty_count", 0))],
		"",
		"[b]Remotes[/b]"
	]
	for remote in repo.get("remotes", []):
		lines.append("- %s" % str(remote))
	lines.append("")
	lines.append("[b]Branches[/b]")
	for branch in repo.get("branches", []):
		lines.append("- %s" % str(branch))
	lines.append("")
	lines.append("[b]Tags[/b]")
	for tag in repo.get("tags", []):
		lines.append("- %s" % str(tag))
	lines.append("")
	lines.append("[b]Release Notes Draft[/b]")
	lines.append(str(repo.get("release_notes_draft", "")))
	room_body.text = "\n".join(lines)
	room_harbor_detail_button.disabled = selected_harbor_repo_id == ""
	room_harbor_github_button.disabled = selected_harbor_repo_id == ""
	room_harbor_readiness_button.disabled = selected_harbor_repo_id == ""
	room_harbor_draft_button.disabled = selected_harbor_repo_id == ""
	room_harbor_publish_plan_button.disabled = selected_harbor_repo_id == ""

func _render_harbor_github_snapshot(data: Dictionary) -> void:
	var repo: Dictionary = data.get("repository", {})
	var auth: Dictionary = data.get("auth", {})
	var lines := [
		"[b]GitHub Harbor CLI Snapshot[/b]",
		"Project: %s | Status: %s" % [data.get("project_name", ""), data.get("status", "")],
		"Safety: %s" % data.get("safety", ""),
		"Repo: %s" % repo.get("name_with_owner", repo.get("remote_slug", "")),
		"URL: %s" % repo.get("url", ""),
		"Default branch: %s | Private: %s" % [repo.get("default_branch", ""), str(repo.get("private", ""))],
		"Auth ok: %s | Issues: %s (%s) | Releases: %s (%s)" % [str(auth.get("ok", false)), str(data.get("issue_count", 0)), data.get("issue_status", ""), str(data.get("release_count", 0)), data.get("release_status", "")],
		"",
		"[b]Issues[/b]"
	]
	for issue in data.get("issues", []):
		if typeof(issue) != TYPE_DICTIONARY:
			continue
		lines.append("#%s %s [%s]" % [str(issue.get("number", "")), issue.get("title", ""), issue.get("state", "")])
	if data.get("issues", []).is_empty():
		lines.append("- No issues returned, or GitHub CLI/auth is unavailable.")
	lines.append("")
	lines.append("[b]Releases[/b]")
	for release in data.get("releases", []):
		if typeof(release) != TYPE_DICTIONARY:
			continue
		lines.append("%s %s" % [release.get("tagName", ""), release.get("name", "")])
	for line in data.get("release_lines", []):
		lines.append(str(line))
	if data.get("releases", []).is_empty() and data.get("release_lines", []).is_empty():
		lines.append("- No releases returned, or GitHub CLI/auth is unavailable.")
	lines.append("")
	lines.append("[b]CLI Notes[/b]")
	for line in auth.get("summary", []):
		lines.append(str(line))
	var issue_error := str(data.get("issue_error", ""))
	var release_error := str(data.get("release_error", ""))
	if issue_error != "":
		lines.append("Issue list note: %s" % issue_error)
	if release_error != "":
		lines.append("Release list note: %s" % release_error)
	lines.append("")
	lines.append(str(data.get("safe_note", "")))
	room_body.text = "\n".join(lines)
	room_harbor_detail_button.disabled = selected_harbor_repo_id == ""
	room_harbor_github_button.disabled = selected_harbor_repo_id == ""
	room_harbor_readiness_button.disabled = selected_harbor_repo_id == ""
	room_harbor_draft_button.disabled = selected_harbor_repo_id == ""
	room_harbor_publish_plan_button.disabled = selected_harbor_repo_id == ""

func _render_harbor_publish_readiness(data: Dictionary) -> void:
	var lines := [
		"[b]GitHub Publish Readiness[/b]",
		"Project: %s | Status: %s | Safety: %s" % [data.get("project_name", ""), data.get("status", ""), data.get("safety", "")],
		"Branch: %s | Remote: %s | Dirty files: %s" % [data.get("branch", ""), data.get("remote_slug", ""), str(data.get("dirty_count", 0))],
		"Checks: %s / %s | confirmation=%s" % [str(data.get("checks_passed", 0)), str(data.get("checks_total", 0)), data.get("confirmation_required", "")],
		"Upstream: %s | Ahead/behind: %s" % [data.get("upstream", ""), data.get("ahead_behind", "")],
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Readiness Checks[/b]"
	]
	for check in data.get("checks", []):
		if typeof(check) == TYPE_DICTIONARY:
			lines.append("- %s | pass=%s | %s" % [check.get("label", ""), str(check.get("pass", false)), check.get("detail", "")])
	var blockers: Array = data.get("blockers", [])
	var warnings: Array = data.get("warnings", [])
	if not blockers.is_empty():
		lines.append("")
		lines.append("[b]Blockers[/b]")
		for blocker in blockers:
			lines.append("- %s" % str(blocker))
	if not warnings.is_empty():
		lines.append("")
		lines.append("[b]Warnings[/b]")
		for warning in warnings:
			lines.append("- %s" % str(warning))
	lines.append("")
	lines.append("[b]Diff Stat[/b]")
	lines.append(str(data.get("diff_stat", "No diff stat.")))
	room_body.text = "\n".join(lines)
	room_harbor_detail_button.disabled = selected_harbor_repo_id == ""
	room_harbor_github_button.disabled = selected_harbor_repo_id == ""
	room_harbor_readiness_button.disabled = selected_harbor_repo_id == ""
	room_harbor_draft_button.disabled = selected_harbor_repo_id == ""
	room_harbor_publish_plan_button.disabled = selected_harbor_repo_id == ""
	quest_body.text = "[b]GitHub publish readiness[/b]\n%s | checks=%s/%s | dirty=%s" % [data.get("status", ""), str(data.get("checks_passed", 0)), str(data.get("checks_total", 0)), str(data.get("dirty_count", 0))]

func _render_harbor_draft(data: Dictionary) -> void:
	var draft: Dictionary = data.get("draft", {})
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]GitHub Harbor Draft Saved[/b]",
		"Type: %s | Safety: %s" % [draft.get("draft_type", ""), data.get("safety", "")],
		"Project: %s | Branch: %s -> %s" % [draft.get("project_name", ""), draft.get("branch", ""), draft.get("target_branch", "")],
		"Dirty files: %s | Remotes: %s | Commits: %s" % [str(draft.get("dirty_count", 0)), str(draft.get("remote_count", 0)), str(draft.get("commit_count", 0))],
		"Draft: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]GitHub handoff draft saved[/b]\n%s\nProject: %s" % [data.get("draft_path", ""), draft.get("project_name", "")]

func _render_harbor_publish_plan(data: Dictionary) -> void:
	var readiness: Dictionary = data.get("readiness", {})
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]GitHub Publish Plan[/b]",
		"Status: %s | Safety: %s" % [data.get("status", ""), data.get("safety", "")],
		"Type: %s | Project: %s" % [data.get("publish_type", ""), readiness.get("project_name", "")],
		"Readiness: %s | Checks: %s / %s" % [readiness.get("status", ""), str(readiness.get("checks_passed", 0)), str(readiness.get("checks_total", 0))],
		"Plan: %s" % data.get("plan_path", ""),
		"Confirmation required: %s" % data.get("confirmation_required", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	if data.get("status", "") == "saved":
		quest_body.text = "[b]GitHub publish plan saved[/b]\n%s" % data.get("plan_path", "")
	else:
		quest_body.text = "[b]GitHub publish plan requires confirmation[/b]\n%s" % data.get("confirmation_required", "")

func _render_terminal_commands(data: Dictionary) -> void:
	selected_terminal_command_id = ""
	selected_terminal_job_id = ""
	terminal_confirmation_required = ""
	terminal_log_cards = []
	selected_terminal_log_index = -1
	var lines := [
		"[b]Terminal Control Jobs[/b]",
		"Commands: %s | mode=%s" % [str(data.get("count", 0)), data.get("mode", "confirm-required")],
		"Logs: %s" % data.get("log_dir", ""),
		""
	]
	for command in data.get("commands", []):
		if typeof(command) != TYPE_DICTIONARY:
			continue
		var command_id := str(command.get("id", ""))
		if selected_terminal_command_id == "" and command_id != "":
			selected_terminal_command_id = command_id
		lines.append("[color=#4a3a2a]%s[/color] (%s)" % [command.get("label", "command"), command_id])
		lines.append("  %s" % command.get("description", ""))
		lines.append("  cwd: %s | timeout=%ss | preview=%s" % [command.get("cwd", ""), str(command.get("timeout", 0)), command.get("preview_status", "")])
	var recent_logs: Array = data.get("recent_logs", [])
	if not recent_logs.is_empty():
		lines.append("")
		lines.append("[b]Recent Logs[/b]")
		for log in recent_logs:
			if typeof(log) == TYPE_DICTIONARY:
				terminal_log_cards.append(log)
				lines.append("- %s | %s | %s" % [log.get("label", log.get("command_id", "command")), log.get("status", ""), log.get("log_path", "")])
	room_body.text = "\n".join(lines)
	room_terminal_preview_button.disabled = selected_terminal_command_id == ""
	room_terminal_run_button.disabled = selected_terminal_command_id == ""
	room_terminal_next_log_button.disabled = terminal_log_cards.is_empty()
	room_terminal_open_log_button.disabled = terminal_log_cards.is_empty()
	if selected_terminal_command_id != "":
		detail_body.text = "[b]Terminal Control[/b]\nSelected command: %s. Press Preview Cmd to inspect argv/cwd/safety, then Run Command to request the confirmation gate." % selected_terminal_command_id

func _render_terminal_command_preview(data: Dictionary) -> void:
	terminal_confirmation_required = str(data.get("confirmation_required", ""))
	var lines := [
		"[b]Terminal Command Preview[/b]",
		"Status: %s | Command: %s" % [data.get("status", ""), data.get("label", data.get("command_id", ""))],
		"Safety: %s | Confirmation: %s" % [data.get("safety", ""), data.get("confirmation_required", "")],
		"CWD allowed: %s | Timeout: %ss" % [str(data.get("cwd_allowed", false)), str(data.get("timeout", 0))],
		"CWD: %s" % data.get("cwd", ""),
		"Argv: %s" % JSON.stringify(data.get("args", [])),
		"Command line: %s" % data.get("command_line", ""),
		"",
		"[b]Expected Effects[/b]"
	]
	for effect in data.get("expected_effects", []):
		lines.append("- %s" % str(effect))
	var blocked: Array = data.get("blocked_reasons", [])
	if not blocked.is_empty():
		lines.append("")
		lines.append("[b]Blocked Reasons[/b]")
		for reason in blocked:
			lines.append("- %s" % str(reason))
	lines.append("")
	lines.append("%s" % data.get("safe_note", ""))
	room_body.text = "\n".join(lines)
	room_terminal_run_button.disabled = data.get("status", "") == "blocked"
	room_terminal_preview_button.disabled = false

func _render_terminal_confirmation(data: Dictionary) -> void:
	terminal_confirmation_required = str(data.get("confirmation_required", ""))
	var lines := [
		"[b]Command Confirmation Required[/b]",
		"Command: %s" % data.get("label", data.get("command_id", "")),
		"Safety: %s" % data.get("safety", ""),
		"CWD: %s" % data.get("cwd", ""),
		"Preview: %s" % data.get("preview", ""),
		"",
		"Press Run Command again to send the in-game confirmation phrase."
	]
	room_body.text = "\n".join(lines)
	room_terminal_run_button.disabled = terminal_confirmation_required == ""

func _render_terminal_job(job: Dictionary) -> void:
	var status := str(job.get("status", "unknown"))
	if status == "done" or status == "failed" or status == "missing":
		selected_terminal_job_id = ""
	var result: Dictionary = {}
	if typeof(job.get("result", null)) == TYPE_DICTIONARY:
		result = job.get("result", {})
	var lines := [
		"[b]Terminal Command Job[/b]",
		"Job: %s" % job.get("id", selected_terminal_job_id),
		"Status: %s | Safety: %s" % [status, job.get("safety", "confirm-required")],
		"Label: %s" % job.get("label", ""),
		"Error: %s" % job.get("error", "")
	]
	if not result.is_empty():
		lines.append("")
		lines.append("[b]Result[/b]")
		lines.append("Command: %s" % result.get("command_id", ""))
		lines.append("Return code: %s | Duration: %ss" % [str(result.get("returncode", "")), str(result.get("duration_seconds", ""))])
		lines.append("Log: %s" % result.get("log_path", ""))
		lines.append("")
		lines.append("[b]stdout[/b]")
		lines.append(str(result.get("stdout", "")))
		if str(result.get("stderr", "")) != "":
			lines.append("")
			lines.append("[b]stderr[/b]")
			lines.append(str(result.get("stderr", "")))
	room_body.text = "\n".join(lines)
	_record_activity("Terminal job", "%s | %s" % [job.get("label", ""), status], "terminal")

func _render_terminal_log_detail(log: Dictionary) -> void:
	var lines := [
		"[b]Terminal Log Detail[/b]",
		"Command: %s" % log.get("label", log.get("command_id", "")),
		"Status: %s | Return code: %s" % [log.get("status", ""), str(log.get("returncode", ""))],
		"Duration: %ss | Safety: %s" % [str(log.get("duration_seconds", "")), log.get("safety", "confirm-required-allowlisted")],
		"CWD: %s" % log.get("cwd", ""),
		"Log: %s" % log.get("log_path", ""),
		"",
		"[b]stdout[/b]",
		str(log.get("stdout", "")).substr(0, 1800),
	]
	var stderr := str(log.get("stderr", ""))
	if stderr != "":
		lines.append("")
		lines.append("[b]stderr[/b]")
		lines.append(stderr.substr(0, 1000))
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Terminal log[/b]\n%s | %s" % [log.get("label", log.get("command_id", "")), log.get("status", "")]
	_record_activity("Terminal log opened", "%s | %s" % [log.get("command_id", ""), log.get("status", "")], "terminal")

func _render_town_capability_atlas(data: Dictionary) -> void:
	town_capability_cards = []
	selected_town_capability_id = ""
	selected_town_capability_index = 0
	var entries: Array = data.get("entries", [])
	var lines := [
		"[b]Town Capability Atlas[/b]",
		"Mode: %s" % data.get("mode", ""),
		"Buildings connected: %s/%s" % [str(data.get("connected_count", 0)), str(data.get("building_count", 0))],
		str(data.get("safe_note", "")),
		"",
		"[b]Mapped Buildings[/b]"
	]
	for entry in entries:
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		town_capability_cards.append(entry)
		var entry_id := str(entry.get("id", ""))
		if selected_town_capability_id == "" and entry_id != "":
			selected_town_capability_id = entry_id
		var caps: Array = entry.get("capabilities", [])
		var cap_text := ", ".join(caps.slice(0, min(2, caps.size())))
		lines.append("[color=#4a3a2a]%s[/color] (%s)" % [entry.get("name", entry_id), entry_id])
		lines.append("  %s | backend=%s | endpoints=%s" % [cap_text, entry.get("backend", ""), str(entry.get("endpoints", []).size())])
	room_body.text = "\n".join(lines)
	room_capability_next_button.disabled = town_capability_cards.size() <= 1
	room_capability_open_button.disabled = selected_town_capability_id == ""
	if selected_town_capability_id != "":
		detail_body.text = "[b]Town Capability Atlas[/b]\nSelected: %s. Use Next Atlas to cycle, Open Atlas for full paths/endpoints/tools/APIs." % selected_town_capability_id
	_record_activity("Town atlas loaded", "%s/%s buildings" % [str(data.get("connected_count", 0)), str(data.get("building_count", 0))], "town")

func _render_town_capability_from_cache() -> void:
	if town_capability_cards.is_empty():
		return
	var entry: Dictionary = town_capability_cards[selected_town_capability_index]
	selected_town_capability_id = str(entry.get("id", selected_town_capability_id))
	var caps: Array = entry.get("capabilities", [])
	var paths: Array = entry.get("real_paths", [])
	var endpoints: Array = entry.get("endpoints", [])
	detail_body.text = "[b]Atlas selected[/b]\n%s (%s)\nCapabilities: %s\nPaths: %s | Endpoints: %s" % [
		entry.get("name", selected_town_capability_id),
		selected_town_capability_id,
		", ".join(caps.slice(0, min(4, caps.size()))),
		str(paths.size()),
		str(endpoints.size()),
	]
	room_body.text += "\n\n[b]Selected atlas building:[/b] %s (%s)" % [entry.get("name", selected_town_capability_id), selected_town_capability_id]
	room_capability_open_button.disabled = selected_town_capability_id == ""

func _render_town_capability_detail(data: Dictionary) -> void:
	if data.get("status", "") != "ok" or typeof(data.get("entry", null)) != TYPE_DICTIONARY:
		room_body.text = "[b]Town Capability Detail[/b]\nStatus: %s\nBuilding: %s\n%s" % [data.get("status", ""), data.get("building_id", ""), data.get("safe_note", "")]
		return
	var entry: Dictionary = data.get("entry", {})
	selected_town_capability_id = str(entry.get("id", selected_town_capability_id))
	var lines := [
		"[b]%s[/b]" % entry.get("name", selected_town_capability_id),
		"Building ID: %s | Backend: %s | Safety: %s" % [entry.get("id", ""), entry.get("backend", ""), entry.get("safety", "")],
		"Role: %s" % entry.get("role", ""),
		"Connected: %s" % str(entry.get("has_real_connection", false)),
		"",
		"[b]Capabilities[/b]"
	]
	for item in entry.get("capabilities", []):
		lines.append("- %s" % str(item))
	lines.append("")
	lines.append("[b]Endpoints[/b]")
	for item in entry.get("endpoints", []):
		lines.append("- %s" % str(item))
	lines.append("")
	lines.append("[b]Real Paths[/b]")
	for item in entry.get("real_paths", []):
		lines.append("- %s" % str(item))
	lines.append("")
	lines.append("[b]Tools / APIs[/b]")
	var tools: Array = entry.get("tools", [])
	var apis: Array = entry.get("apis", [])
	lines.append("Tools: %s" % (", ".join(tools) if not tools.is_empty() else "none listed"))
	lines.append("APIs: %s" % (", ".join(apis) if not apis.is_empty() else "none listed"))
	lines.append("")
	lines.append("[b]Safety[/b]")
	lines.append(str(data.get("safe_note", "")))
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Capability detail[/b]\n%s connects to %s paths and %s endpoints." % [entry.get("name", selected_town_capability_id), str(entry.get("real_paths", []).size()), str(entry.get("endpoints", []).size())]
	_record_activity("Atlas detail opened", "%s | %s" % [entry.get("name", ""), entry.get("backend", "")], "town")

func _render_town_workflow_routes(data: Dictionary) -> void:
	town_workflow_cards = []
	selected_town_workflow_id = ""
	selected_town_workflow_index = 0
	var routes: Array = data.get("routes", [])
	var lines := [
		"[b]Town Workflow Routes[/b]",
		"Mode: %s | Status: %s" % [data.get("mode", ""), data.get("status", "")],
		"Routes: %s | Connected buildings: %s" % [str(data.get("route_count", 0)), str(data.get("connected_building_count", 0))],
		str(data.get("safe_note", "")),
		"",
		"[b]Routes[/b]"
	]
	for route in routes:
		if typeof(route) != TYPE_DICTIONARY:
			continue
		town_workflow_cards.append(route)
		var route_id := str(route.get("id", ""))
		if selected_town_workflow_id == "" and route_id != "":
			selected_town_workflow_id = route_id
		lines.append("%s [color=#4a3a2a]%s[/color] (%s)" % [_workflow_route_marker(route_id), route.get("title", route_id), route_id])
		lines.append("  %s" % route.get("purpose", ""))
		lines.append("  buildings: %s | artifacts: %s | %s" % [", ".join(route.get("building_ids", [])), str(route.get("expected_artifacts", []).size()), _workflow_route_progress_summary(route_id)])
	room_body.text = "\n".join(lines)
	room_workflow_next_button.disabled = town_workflow_cards.size() <= 1
	room_workflow_open_button.disabled = selected_town_workflow_id == ""
	if selected_town_workflow_id != "":
		detail_body.text = "[b]Town Workflow Routes[/b]\nSelected: %s. Use Next Flow to cycle, Open Flow for building-by-building guidance." % selected_town_workflow_id
	_record_activity("Workflow routes loaded", "%s route(s)" % str(data.get("route_count", 0)), "town")

func _render_town_workflow_from_cache() -> void:
	if town_workflow_cards.is_empty():
		return
	var route: Dictionary = town_workflow_cards[selected_town_workflow_index]
	selected_town_workflow_id = str(route.get("id", selected_town_workflow_id))
	detail_body.text = "[b]Workflow selected[/b]\n%s (%s)\n%s\nBuildings: %s" % [
		route.get("title", selected_town_workflow_id),
		selected_town_workflow_id,
		route.get("purpose", ""),
		", ".join(route.get("building_ids", [])),
	]
	room_body.text += "\n\n[b]Selected workflow route:[/b] %s (%s)" % [route.get("title", selected_town_workflow_id), selected_town_workflow_id]
	room_workflow_open_button.disabled = selected_town_workflow_id == ""

func _render_town_workflow_detail(data: Dictionary) -> void:
	if data.get("status", "") != "ok" or typeof(data.get("route", null)) != TYPE_DICTIONARY:
		room_body.text = "[b]Town Workflow Route Detail[/b]\nStatus: %s\nRoute: %s\n%s" % [data.get("status", ""), data.get("route_id", ""), data.get("safe_note", "")]
		return
	var route: Dictionary = data.get("route", {})
	selected_town_workflow_id = str(route.get("id", selected_town_workflow_id))
	_sync_town_workflow_cache(route)
	var next_stop := _workflow_route_next_stop(selected_town_workflow_id)
	if next_stop != "":
		_set_waypoint_for_building(next_stop, "Town Workflow next stop. Use Flow Stop or walk there.")
	var lines := [
		"[b]%s[/b]" % route.get("title", selected_town_workflow_id),
		"Route ID: %s | District: %s | Companion: %s" % [route.get("id", ""), route.get("district_id", ""), route.get("recommended_companion", "")],
		"Safety: %s" % route.get("safety", ""),
		"Purpose: %s" % route.get("purpose", ""),
		"Progress: %s" % _workflow_route_progress_summary(selected_town_workflow_id),
		"Next stop: %s" % _workflow_route_next_stop_label(next_stop),
		"",
		"[b]Expected Artifacts[/b]"
	]
	for artifact in route.get("expected_artifacts", []):
		lines.append("- %s" % str(artifact))
	lines.append("")
	lines.append("[b]Steps[/b]")
	for step in route.get("steps", []):
		if typeof(step) != TYPE_DICTIONARY:
			continue
		lines.append("- %s: %s" % [step.get("building_name", step.get("building_id", "")), step.get("label", "")])
		lines.append("  %s" % step.get("action_hint", ""))
		lines.append("  endpoints=%s | paths=%s | safety=%s" % [str(step.get("endpoint_count", 0)), str(step.get("real_path_count", 0)), step.get("safety", "")])
		var refs: Array = step.get("capability_refs", [])
		if not refs.is_empty():
			lines.append("  refs: %s" % ", ".join(refs.slice(0, min(3, refs.size()))))
	lines.append("")
	lines.append("[b]Safety[/b]")
	lines.append(str(data.get("safe_note", "")))
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Workflow route[/b]\n%s: %s step(s), %s expected artifact(s)." % [route.get("title", selected_town_workflow_id), str(route.get("step_count", 0)), str(route.get("expected_artifacts", []).size())]
	_record_activity("Workflow route opened", "%s | %s" % [route.get("title", ""), route.get("safety", "")], "town")

func _sync_town_workflow_cache(route: Dictionary) -> void:
	var route_id := str(route.get("id", ""))
	if route_id == "":
		return
	for i in range(town_workflow_cards.size()):
		var item = town_workflow_cards[i]
		if typeof(item) == TYPE_DICTIONARY and str(item.get("id", "")) == route_id:
			town_workflow_cards[i] = route
			selected_town_workflow_index = i
			return
	town_workflow_cards.append(route)
	selected_town_workflow_index = town_workflow_cards.size() - 1

func _claim_selected_town_workflow() -> void:
	if current_room_id != "town-hall":
		room_body.text += "\n\n[b]Town Hall[/b]\nEnter Town Hall to claim a workflow route."
		return
	if selected_town_workflow_id == "":
		room_body.text += "\n\nNo workflow route is selected. Load Workflows first."
		return
	var route := _selected_town_workflow()
	if route.is_empty():
		room_body.text += "\n\nOpen this workflow route first so its steps can be saved locally."
		return
	if not workflow_route_claims.has(selected_town_workflow_id) or typeof(workflow_route_claims[selected_town_workflow_id]) != TYPE_DICTIONARY:
		workflow_route_claims[selected_town_workflow_id] = {
			"status": "claimed",
			"title": route.get("title", selected_town_workflow_id),
			"claimed_at": Time.get_datetime_string_from_system(true),
			"completed_at": "",
			"building_ids": route.get("building_ids", []),
			"visited_buildings": {},
		}
	if current_room_id != "town":
		_mark_workflow_route_visit(current_room_id, false)
	quest_body.text = "[b]Workflow claimed:[/b] %s\nSaved only in this local player profile.\n%s" % [route.get("title", selected_town_workflow_id), route.get("safety", "local-save-only")]
	_record_activity("Workflow claimed", str(route.get("title", selected_town_workflow_id)), "workflow")
	_save_progress()
	_update_badge_case()
	_render_town_workflow_from_cache()

func _selected_town_workflow() -> Dictionary:
	for route in town_workflow_cards:
		if typeof(route) == TYPE_DICTIONARY and str(route.get("id", "")) == selected_town_workflow_id:
			return route
	return {}

func _workflow_route_marker(route_id: String) -> String:
	if _workflow_route_is_completed(route_id):
		return "[x]"
	if not _workflow_route_claim(route_id).is_empty():
		return "[*]"
	return "[ ]"

func _workflow_route_claim(route_id: String) -> Dictionary:
	var claim = workflow_route_claims.get(route_id, {})
	if typeof(claim) != TYPE_DICTIONARY:
		return {}
	return claim

func _workflow_route_is_completed(route_id: String) -> bool:
	return str(_workflow_route_claim(route_id).get("status", "")) == "completed"

func _workflow_route_progress_summary(route_id: String) -> String:
	var route := _workflow_route_by_id(route_id)
	var building_ids: Array = route.get("building_ids", [])
	var claim := _workflow_route_claim(route_id)
	if claim.is_empty():
		return "unclaimed | artifacts: %s" % str(route.get("expected_artifacts", []).size())
	var visited = claim.get("visited_buildings", {})
	if typeof(visited) != TYPE_DICTIONARY:
		visited = {}
	var done := 0
	for building_id in building_ids:
		if visited.get(str(building_id), false):
			done += 1
	return "%s | buildings %s/%s" % [str(claim.get("status", "claimed")), str(done), str(building_ids.size())]

func _workflow_route_by_id(route_id: String) -> Dictionary:
	for route in town_workflow_cards:
		if typeof(route) == TYPE_DICTIONARY and str(route.get("id", "")) == route_id:
			return route
	return {}

func _workflow_route_next_stop(route_id: String) -> String:
	var route := _workflow_route_by_id(route_id)
	var building_ids: Array = route.get("building_ids", [])
	var claim := _workflow_route_claim(route_id)
	if claim.is_empty() or str(claim.get("status", "")) == "completed":
		return ""
	var visited = claim.get("visited_buildings", {})
	if typeof(visited) != TYPE_DICTIONARY:
		visited = {}
	for building_id in building_ids:
		var building := str(building_id)
		if not visited.get(building, false):
			return building
	return ""

func _workflow_route_next_stop_label(building_id: String) -> String:
	if building_id == "":
		return "workflow complete or not claimed"
	var def := _building_def(building_id)
	return "%s (%s)" % [def.get("name", building_id), building_id]

func _guide_to_town_workflow_next_stop() -> void:
	if selected_town_workflow_id == "":
		room_body.text += "\n\nNo workflow route is selected. Load Workflows first."
		return
	var building_id := _workflow_route_next_stop(selected_town_workflow_id)
	if building_id == "":
		room_body.text += "\n\n[b]Workflow route[/b]\n%s" % _workflow_route_progress_summary(selected_town_workflow_id)
		return
	var def := _building_def(building_id)
	active_building_id = building_id
	room_button.disabled = false
	action_button.disabled = false
	_set_waypoint_for_building(building_id, "Town Workflow next stop. Press Enter Room to record the visit.")
	target_position = def.get("pos", target_position) + Vector2(0, def.get("size", Vector2.ZERO).y / 2.0 + 72.0)
	camera.zoom = Vector2(0.95, 0.95)
	detail_title.text = "Workflow Guide"
	detail_body.text = "[b]Next workflow stop:[/b] %s\n%s\n\nPress Enter Room to record this workflow visit." % [def.get("name", building_id), def.get("role", "local work building")]
	quest_body.text = "[b]Workflow guide[/b]\n%s\nNext stop: %s" % [_selected_town_workflow().get("title", selected_town_workflow_id), _workflow_route_next_stop_label(building_id)]

func _mark_workflow_route_visit(building_id: String, show_message: bool = true) -> void:
	var changed := false
	for route_id in workflow_route_claims.keys():
		var claim = workflow_route_claims[route_id]
		if typeof(claim) != TYPE_DICTIONARY:
			continue
		if str(claim.get("status", "")) == "completed":
			continue
		var building_ids: Array = claim.get("building_ids", [])
		if not building_ids.has(building_id):
			continue
		var visited = claim.get("visited_buildings", {})
		if typeof(visited) != TYPE_DICTIONARY:
			visited = {}
		if not visited.get(building_id, false):
			visited[building_id] = true
			claim["visited_buildings"] = visited
			changed = true
		if _daily_route_all_buildings_visited(building_ids, visited):
			_complete_workflow_route(str(route_id), claim)
			changed = true
		if show_message and selected_town_workflow_id == str(route_id):
			quest_body.text = "[b]Workflow progress:[/b] %s\n%s" % [claim.get("title", route_id), _workflow_route_progress_summary(str(route_id))]
	if changed:
		_record_activity("Workflow route visit", _building_def(building_id).get("name", building_id), "workflow")
		_save_progress()
		_update_badge_case()

func _complete_workflow_route(route_id: String, claim: Dictionary) -> void:
	claim["status"] = "completed"
	claim["completed_at"] = Time.get_datetime_string_from_system(true)
	var badge_id := "workflow-%s" % route_id
	earned_badges[badge_id] = {
		"name": "%s Complete" % claim.get("title", route_id),
		"collection": "Workflow Routes",
		"quest": claim.get("title", route_id),
	}
	detail_body.text += "\n\n[b]Workflow route complete:[/b] %s" % claim.get("title", route_id)
	_record_activity("Workflow route complete", str(claim.get("title", route_id)), "workflow")

func _workflow_route_badge_lines() -> Array:
	var lines := []
	for route_id in workflow_route_claims.keys():
		var claim = workflow_route_claims[route_id]
		if typeof(claim) != TYPE_DICTIONARY:
			continue
		lines.append("%s: %s" % [claim.get("title", route_id), claim.get("status", "claimed")])
	return lines

func _render_system_overview(data: Dictionary) -> void:
	var warnings: Array = data.get("warnings", [])
	var jobs: Dictionary = data.get("jobs", {})
	var registries: Dictionary = data.get("registries", {})
	var environment: Dictionary = data.get("environment", {})
	var event_timeline: Dictionary = data.get("event_timeline", {})
	var persistent_job_logs: Array = data.get("persistent_job_logs", [])
	var lines := [
		"[b]System Monitor[/b]",
		"Mode: %s | Warnings: %s" % [data.get("mode", "read-only"), str(warnings.size())],
		"Registries: buildings=%s agents=%s" % [str(registries.get("buildings", 0)), str(registries.get("agents", 0))],
		"Jobs: %s | logs=%s | %s" % [str(jobs.get("count", 0)), str(jobs.get("persistent_log_count", persistent_job_logs.size())), JSON.stringify(jobs.get("counts", {}))],
		"Events: %s | %s" % [str(event_timeline.get("count", 0)), JSON.stringify(event_timeline.get("counts", {}))],
		"DeepSeek configured: %s | base=%s" % [str(environment.get("deepseek_key_configured", false)), environment.get("deepseek_base_url", "")],
		""
	]
	if not warnings.is_empty():
		lines.append("[b]Warnings[/b]")
		for warning in warnings:
			lines.append("- %s" % str(warning))
		lines.append("")
	lines.append("[b]Services[/b]")
	for service in data.get("services", []):
		if typeof(service) == TYPE_DICTIONARY:
			lines.append("- %s: %s | %s" % [service.get("name", service.get("id", "service")), service.get("status", ""), service.get("detail", "")])
	lines.append("")
	lines.append("[b]Workspace[/b]")
	for item in data.get("workspace", []):
		if typeof(item) == TYPE_DICTIONARY:
			lines.append("- %s: exists=%s kind=%s sample=%s | %s" % [item.get("name", ""), str(item.get("exists", false)), item.get("kind", ""), str(item.get("sample_count", 0)), item.get("path", "")])
	var recent_events: Array = event_timeline.get("recent", [])
	if not recent_events.is_empty():
		lines.append("")
		lines.append("[b]Recent System Events[/b]")
		for event in recent_events.slice(0, min(5, recent_events.size())):
			if typeof(event) == TYPE_DICTIONARY:
				lines.append("- %s | %s | %s" % [event.get("kind", "event"), event.get("status", ""), event.get("title", "")])
	if not persistent_job_logs.is_empty():
		lines.append("")
		lines.append("[b]Persistent Job Logs[/b]")
		for log in persistent_job_logs.slice(0, min(5, persistent_job_logs.size())):
			if typeof(log) == TYPE_DICTIONARY:
				lines.append("- %s | %s | %s" % [log.get("status", ""), log.get("label", log.get("id", "job")), log.get("log_path", "")])
	var logs: Array = data.get("recent_terminal_logs", [])
	if not logs.is_empty():
		lines.append("")
		lines.append("[b]Recent Terminal Logs[/b]")
		for log in logs:
			if typeof(log) == TYPE_DICTIONARY:
				lines.append("- %s | %s | %s" % [log.get("label", log.get("command_id", "command")), log.get("status", ""), log.get("log_path", "")])
	room_body.text = "\n".join(lines)

func _render_system_jobs(data: Dictionary) -> void:
	system_job_cards.clear()
	selected_system_job_id = ""
	selected_system_job_log_id = ""
	selected_system_job_event_cursor = 0
	var lines := [
		"[b]Backend Job Queue[/b]",
		"Total: %s | %s" % [str(data.get("count", 0)), JSON.stringify(data.get("counts", {}))],
		"%s" % data.get("safe_note", ""),
		""
	]
	for job in data.get("recent", []):
		if typeof(job) != TYPE_DICTIONARY:
			continue
		system_job_cards.append(job)
		if selected_system_job_id == "":
			selected_system_job_id = str(job.get("id", ""))
		if selected_system_job_log_id == "" and str(job.get("log_path", "")) != "":
			selected_system_job_log_id = _log_id_from_path(str(job.get("log_path", "")))
		lines.append("[color=#4a3a2a]%s[/color] %s" % [job.get("status", ""), job.get("label", job.get("id", "job"))])
		lines.append("  %s | safety=%s | id=%s" % [job.get("kind", ""), job.get("safety", ""), job.get("id", "")])
		lines.append("  cancelable=%s | rollback=%s" % [str(job.get("cancelable", false)), str(job.get("rollback_note", "")).substr(0, 100)])
		if str(job.get("log_path", "")) != "":
			lines.append("  log: %s" % job.get("log_path", ""))
		if str(job.get("error", "")) != "":
			lines.append("  error: %s" % job.get("error", ""))
	var persistent_logs: Array = data.get("persistent_logs", [])
	if not persistent_logs.is_empty():
		lines.append("")
		lines.append("[b]Persistent Logs[/b]")
		for log in persistent_logs.slice(0, min(6, persistent_logs.size())):
			if typeof(log) == TYPE_DICTIONARY:
				if selected_system_job_log_id == "":
					selected_system_job_log_id = _log_id_from_path(str(log.get("log_path", "")))
				lines.append("- %s | %s | %s" % [log.get("status", ""), log.get("label", log.get("id", "job")), log.get("log_path", "")])
	var selected_cancelable := false
	if not system_job_cards.is_empty():
		selected_cancelable = bool(system_job_cards[0].get("cancelable", false))
	room_job_cancel_button.disabled = selected_system_job_id == "" or not selected_cancelable
	room_job_log_button.disabled = selected_system_job_log_id == ""
	room_job_events_button.disabled = selected_system_job_id == ""
	room_body.text = "\n".join(lines)

func _log_id_from_path(path: String) -> String:
	var normalized := path.replace("\\", "/")
	var parts := normalized.split("/")
	if parts.is_empty():
		return ""
	var file_name := parts[parts.size() - 1]
	if file_name.ends_with(".json"):
		return file_name.substr(0, file_name.length() - 5)
	return file_name

func _render_system_job_log_detail(data: Dictionary) -> void:
	var job: Dictionary = data.get("job", {})
	var lines := [
		"[b]Backend Job Log Detail[/b]",
		"Job: %s | %s | %s" % [job.get("id", ""), job.get("kind", ""), job.get("status", "")],
		"Label: %s" % job.get("label", ""),
		"Safety: %s | Cancel requested=%s" % [job.get("safety", ""), str(job.get("cancel_requested", false))],
		"Log: %s (%s bytes)" % [data.get("log_path", ""), str(data.get("bytes", 0))],
		"Rollback: %s" % job.get("rollback_note", ""),
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Events[/b]"
	]
	var events: Array = data.get("events", [])
	for event in events.slice(0, min(10, events.size())):
		if typeof(event) == TYPE_DICTIONARY:
			lines.append("- %s | %s" % [str(event.get("at", "")), event.get("message", "")])
	if events.is_empty():
		lines.append("- No lifecycle events recorded.")
	if str(job.get("error", "")) != "":
		lines.append("")
		lines.append("[b]Error[/b]")
		lines.append(str(job.get("error", "")).substr(0, 1200))
	var result_preview := str(data.get("result_preview", ""))
	if result_preview != "":
		lines.append("")
		lines.append("[b]Result Preview[/b]")
		lines.append(result_preview.substr(0, 1800))
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Backend job log[/b]\n%s | %s" % [job.get("label", ""), job.get("status", "")]

func _render_system_job_events(data: Dictionary) -> void:
	selected_system_job_event_cursor = int(data.get("next_cursor", selected_system_job_event_cursor))
	var lines := [
		"[b]Backend Job Events[/b]",
		"Job: %s | status=%s | source=%s" % [data.get("job_id", selected_system_job_id), data.get("status", ""), data.get("source", "")],
		"Events: %s returned / %s total | next cursor=%s | more=%s" % [str(data.get("returned", 0)), str(data.get("event_count", 0)), str(data.get("next_cursor", 0)), str(data.get("has_more", false))],
		"Log: %s" % data.get("log_path", ""),
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Lifecycle Events[/b]"
	]
	var events: Array = data.get("events", [])
	if events.is_empty():
		lines.append("- No new events at this cursor.")
	for event in events:
		if typeof(event) == TYPE_DICTIONARY:
			lines.append("- %s | %s" % [str(event.get("at", "")), event.get("message", "")])
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Backend job events[/b]\n%s returned | cursor %s" % [str(data.get("returned", 0)), str(data.get("next_cursor", 0))]

func _render_system_job_cancelled(data: Dictionary) -> void:
	var job: Dictionary = data.get("job", {})
	var queue: Dictionary = data.get("queue", {})
	_render_system_jobs(queue)
	room_body.text = "[b]Job cancellation request recorded[/b]\nJob: %s | Status: %s\nRollback: %s\n\n%s" % [
		job.get("id", selected_system_job_id),
		job.get("status", ""),
		job.get("rollback_note", ""),
		room_body.text,
	]
	_record_activity("Job cancellation", "%s | %s" % [job.get("id", ""), job.get("status", "")], "system")

func _render_system_events(data: Dictionary) -> void:
	var lines := [
		"[b]System Event Timeline[/b]",
		"Mode: %s" % data.get("mode", "read-only-local-event-timeline"),
		"Events: %s returned of %s | %s" % [str(data.get("returned", 0)), str(data.get("count", 0)), JSON.stringify(data.get("counts", {}))],
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Recent Events[/b]"
	]
	var events: Array = data.get("events", [])
	if events.is_empty():
		lines.append("No local events have been recorded yet.")
	else:
		for event in events.slice(0, min(18, events.size())):
			if typeof(event) != TYPE_DICTIONARY:
				continue
			var at_text := str(event.get("at", ""))
			lines.append("[color=#4a3a2a]%s[/color] %s | %s | %s" % [event.get("kind", "event"), event.get("status", ""), event.get("title", ""), event.get("source", "")])
			var detail := str(event.get("detail", ""))
			var path := str(event.get("path", ""))
			if detail != "":
				lines.append("  %s" % detail.substr(0, 130))
			if path != "":
				lines.append("  %s" % path)
			lines.append("  at=%s | safety=%s" % [at_text, event.get("safety", "")])
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]System events[/b]\n%s local event(s) across tasks, tools, logs, and memory." % str(data.get("count", 0))
	_record_activity("System event timeline", "%s local events" % str(data.get("count", 0)), "system")

func _render_skill_workshop(data: Dictionary) -> void:
	var lines := [
		"[b]Skill Lantern Workshop[/b]",
		"Skills: %s | Categories: %s" % [str(data.get("total_skills", 0)), str(data.get("categories", 0))],
		"Mode: read-only-local-skill-inventory",
		"",
		"[b]Sampled Skills[/b]"
	]
	for skill in data.get("skills", []).slice(0, min(18, data.get("skills", []).size())):
		if typeof(skill) == TYPE_DICTIONARY:
			lines.append("- %s | %s" % [skill.get("name", "skill"), skill.get("category", "")])
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Skill inventory[/b]\n%s skill(s) across %s categories." % [str(data.get("total_skills", 0)), str(data.get("categories", 0))]

func _render_devtools_lab(data: Dictionary) -> void:
	var lines := [
		"[b]Devtools Gear Lab[/b]",
		"Tools: %s" % str(data.get("count", 0)),
		"Mode: read-only-local-devtools-inventory",
		"",
		"[b]Local Launchers[/b]"
	]
	for tool in data.get("tools", []):
		if typeof(tool) == TYPE_DICTIONARY:
			lines.append("- %s | %s" % [tool.get("name", "tool"), tool.get("path", "")])
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Devtools inventory[/b]\n%s local launcher(s) mapped without executing them." % str(data.get("count", 0))

func _render_model_gateway(data: Dictionary) -> void:
	var lines := [
		"[b]%s[/b]" % data.get("name", "Model Market"),
		"Mode: %s" % data.get("mode", "read-only-no-secret-display"),
		"Profiles: %s | Configured: %s" % [str(data.get("count", 0)), str(data.get("configured_count", 0))],
		"Active dialogue: %s | %s" % [data.get("active_dialogue_provider", ""), data.get("active_dialogue_status", "")],
		"Registry: %s" % data.get("profile_path", ""),
		"Secret policy: %s" % data.get("secret_policy", "Raw keys are never returned."),
		""
	]
	var warnings: Array = data.get("warnings", [])
	if not warnings.is_empty():
		lines.append("[b]Warnings[/b]")
		for warning in warnings:
			lines.append("- %s" % str(warning))
		lines.append("")
	lines.append("[b]Profiles[/b]")
	for profile in data.get("profiles", []):
		if typeof(profile) != TYPE_DICTIONARY:
			continue
		lines.append("[color=#4a3a2a]%s[/color] (%s)" % [profile.get("name", "model"), profile.get("id", "")])
		lines.append("  status=%s | provider=%s | env=%s configured=%s" % [profile.get("status", ""), profile.get("provider", ""), profile.get("key_env", ""), str(profile.get("key_configured", false))])
		lines.append("  vault=%s | source=%s | fingerprint=%s" % [str(profile.get("vault_configured", false)), profile.get("credential_source", "missing"), profile.get("key_fingerprint", "")])
		lines.append("  base=%s | models=%s" % [profile.get("base_url", ""), ", ".join(profile.get("models", []))])
	var vault: Dictionary = data.get("key_vault", {})
	if not vault.is_empty():
		lines.append("")
		lines.append("[b]Key Vault[/b]")
		lines.append("mode=%s | entries=%s | encryption=%s" % [vault.get("mode", ""), str(vault.get("count", 0)), vault.get("encryption", "")])
		lines.append("confirmation=%s | path=%s" % [vault.get("confirmation_required", ""), vault.get("vault_path", "")])
	var drafts: Array = data.get("config_drafts", [])
	if not drafts.is_empty():
		lines.append("")
		lines.append("[b]Config Drafts[/b]")
		for draft in drafts.slice(0, min(5, drafts.size())):
			if typeof(draft) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [draft.get("title", ""), draft.get("path", "")])
	var tests: Array = data.get("profile_tests", [])
	if not tests.is_empty():
		lines.append("")
		lines.append("[b]Profile Tests[/b]")
		for test in tests.slice(0, min(5, tests.size())):
			if typeof(test) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [test.get("title", ""), test.get("path", "")])
	room_body.text = "\n".join(lines)

func _render_model_key_vault(data: Dictionary) -> void:
	var lines := [
		"[b]%s[/b]" % data.get("name", "Model Key Vault"),
		"Mode: %s | encryption=%s" % [data.get("mode", ""), data.get("encryption", "")],
		"Entries: %s | confirmation=%s" % [str(data.get("count", 0)), data.get("confirmation_required", "")],
		"Vault: %s" % data.get("vault_path", ""),
		"%s" % data.get("secret_policy", ""),
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Stored Key Metadata[/b]"
	]
	var entries: Array = data.get("entries", [])
	if entries.is_empty():
		lines.append("- No encrypted model keys saved in the local vault yet.")
	else:
		for entry in entries:
			if typeof(entry) != TYPE_DICTIONARY:
				continue
			lines.append("- %s | %s | source=%s" % [entry.get("profile_id", ""), entry.get("label", ""), entry.get("source", "")])
			lines.append("  env=%s | fingerprint=%s | length=%s" % [entry.get("key_env", ""), entry.get("fingerprint", ""), str(entry.get("length", 0))])
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Model key vault[/b]\n%s stored key metadata entr%s; raw secrets are never rendered." % [str(data.get("count", 0)), "y" if int(data.get("count", 0)) == 1 else "ies"]

func _render_model_config_draft(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Model Config Draft Created[/b]",
		"Safety: %s" % data.get("safety", ""),
		"Draft: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Model config draft saved[/b]\n%s" % data.get("draft_path", "")

func _render_model_profile_test(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var result: Dictionary = data.get("result", {})
	var lines := [
		"[b]Model Profile Test Recorded[/b]",
		"Safety: %s" % data.get("safety", ""),
		"Test status: %s | live=%s" % [data.get("test_status", ""), str(data.get("live_probe", false))],
		"Report: %s" % data.get("report_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Route[/b]",
		"profile=%s | provider=%s | model=%s" % [result.get("profile_id", ""), result.get("provider", ""), result.get("model", "")],
		"endpoint=%s" % result.get("endpoint", ""),
		"configured=%s | safety=%s" % [str(result.get("configured", false)), result.get("safety", "")],
	]
	var response := str(result.get("response", ""))
	var error := str(result.get("error", ""))
	if response != "":
		lines.append("")
		lines.append("[b]Response[/b]")
		lines.append(response.substr(0, 240))
	if error != "":
		lines.append("")
		lines.append("[b]Error[/b]")
		lines.append(error.substr(0, 240))
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Model profile test saved[/b]\n%s" % data.get("report_path", "")
	_record_activity("Model profile test", "%s | %s" % [result.get("profile_id", ""), data.get("test_status", "")], "model")

func _render_file_roots(data: Dictionary) -> void:
	selected_file_root_id = ""
	selected_file_path = ""
	selected_file_kind = ""
	var lines := [
		"[b]File Vault Roots[/b]",
		"Roots: %s | mode=%s" % [str(data.get("count", 0)), data.get("mode", "read-only-whitelist-lazy")],
		"%s" % data.get("safe_note", ""),
		""
	]
	var index: Dictionary = data.get("index", {})
	var incremental: Dictionary = index.get("incremental_summary", {})
	if not incremental.is_empty():
		lines.append("Index: %s item(s) | new=%s changed=%s reused=%s removed=%s preserved=%s" % [
			str(index.get("item_count", 0)),
			str(incremental.get("new_count", 0)),
			str(incremental.get("changed_count", 0)),
			str(incremental.get("reused_count", 0)),
			str(incremental.get("removed_count", 0)),
			str(incremental.get("preserved_count", 0)),
		])
		lines.append("Index mode: %s" % index.get("mode", ""))
		lines.append("")
	for root in data.get("roots", []):
		if typeof(root) != TYPE_DICTIONARY:
			continue
		var root_id := str(root.get("id", ""))
		if selected_file_root_id == "" and root_id != "" and root.get("exists", false):
			selected_file_root_id = root_id
			selected_file_kind = "dir"
		lines.append("[color=#4a3a2a]%s[/color] (%s)" % [root.get("name", "root"), root_id])
		lines.append("  exists=%s | %s" % [str(root.get("exists", false)), root.get("path", "")])
		var sample: Array = root.get("sample", [])
		if not sample.is_empty():
			var names := []
			for item in sample.slice(0, min(5, sample.size())):
				if typeof(item) == TYPE_DICTIONARY:
					names.append("%s:%s" % [item.get("kind", ""), item.get("name", "")])
			lines.append("  sample: %s" % ", ".join(names))
	room_body.text = "\n".join(lines)
	room_file_open_button.disabled = selected_file_root_id == ""
	room_file_reveal_button.disabled = selected_file_root_id == ""
	room_file_preview_button.disabled = true
	room_file_tag_button.disabled = true
	room_file_organize_button.disabled = selected_file_root_id == ""
	if selected_file_root_id != "":
		detail_body.text = "[b]File Vault[/b]\nSelected root: %s. Use Open Folder for a lazy listing or Reveal Item to open it in Explorer." % selected_file_root_id
	_record_npc_chain_action("file_roots", "file-vault")

func _render_file_listing(data: Dictionary) -> void:
	var root_id := str(data.get("root_id", ""))
	selected_file_root_id = root_id
	selected_file_path = ""
	selected_file_kind = ""
	var lines := [
		"[b]%s Folder[/b]" % data.get("root_name", root_id),
		"Path: /%s" % data.get("relative_path", ""),
		"Items: %s | offset=%s | limit=%s | more=%s" % [str(data.get("count", 0)), str(data.get("offset", 0)), str(data.get("limit", 0)), str(data.get("has_more", false))],
		""
	]
	var parent_path := str(data.get("parent_relative_path", ""))
	if str(data.get("relative_path", "")) != "":
		lines.append("[..] parent: /%s" % parent_path)
	for item in data.get("items", []):
		if typeof(item) != TYPE_DICTIONARY:
			continue
		var item_path := str(item.get("relative_path", ""))
		if selected_file_path == "":
			selected_file_path = item_path
			selected_file_kind = str(item.get("kind", ""))
		var marker := "[D]" if item.get("kind", "") == "dir" else "[F]"
		var preview := " preview" if item.get("previewable", false) else ""
		lines.append("%s %s%s" % [marker, item_path, preview])
	room_body.text = "\n".join(lines)
	room_file_open_button.disabled = selected_file_root_id == "" or (selected_file_kind != "dir" and selected_file_path != "")
	room_file_reveal_button.disabled = selected_file_root_id == ""
	room_file_preview_button.disabled = selected_file_root_id == "" or selected_file_kind != "file"
	room_file_tag_button.disabled = selected_file_root_id == "" or selected_file_path == ""
	room_file_organize_button.disabled = selected_file_root_id == ""
	if selected_file_path != "":
		detail_body.text = "[b]File Vault[/b]\nSelected %s: %s/%s" % [selected_file_kind, selected_file_root_id, selected_file_path]

func _render_file_index_job(data: Dictionary) -> void:
	var lines := [
		"[b]File Vault Index Refresh Queued[/b]",
		"Job: %s | kind: %s" % [data.get("job_id", ""), data.get("kind", "")],
		"Safety: %s" % data.get("safety", ""),
		"",
		"Use Search Files after a moment, or System Monitor jobs to inspect status."
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]File index refresh queued[/b]\n%s" % data.get("job_id", "")

func _render_file_organize_audit(data: Dictionary) -> void:
	var lines := [
		"[b]File Organization Audit[/b]",
		"Status: %s | cache=%s | source=%s" % [data.get("status", ""), str(data.get("cache_ready", false)), data.get("source", "")],
		"Items: %s | roots=%s | tagged=%s | untagged=%s | drafts=%s" % [str(data.get("item_count", 0)), str(data.get("root_count", 0)), str(data.get("tagged_count", 0)), str(data.get("untagged_count", 0)), str(data.get("draft_count", 0))],
		"Cache: %s" % data.get("cache_path", ""),
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Groups[/b]"
	]
	for group in data.get("group_counts", []):
		if typeof(group) == TYPE_DICTIONARY:
			lines.append("- %s: %s" % [group.get("id", ""), str(group.get("count", 0))])
	lines.append("")
	lines.append("[b]Needs Review[/b]")
	var review_items: Array = data.get("review_items", [])
	if review_items.is_empty():
		lines.append("- No cached review-group items.")
	else:
		for item in review_items.slice(0, min(8, review_items.size())):
			if typeof(item) == TYPE_DICTIONARY:
				lines.append("- %s/%s (%s)" % [item.get("root_id", ""), item.get("relative_path", ""), item.get("kind", "")])
	var duplicate_names: Array = data.get("duplicate_names", [])
	if not duplicate_names.is_empty():
		lines.append("")
		lines.append("[b]Duplicate Names[/b]")
		for item in duplicate_names.slice(0, min(5, duplicate_names.size())):
			if typeof(item) == TYPE_DICTIONARY:
				lines.append("- %s: %s match(es)" % [item.get("name", ""), str(item.get("count", 0))])
	var stale_tags: Array = data.get("stale_tags", [])
	if not stale_tags.is_empty():
		lines.append("")
		lines.append("[b]Stale Tags[/b]")
		for item in stale_tags.slice(0, min(5, stale_tags.size())):
			if typeof(item) == TYPE_DICTIONARY:
				lines.append("- %s/%s" % [item.get("root_id", ""), item.get("relative_path", "")])
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]File organization audit[/b]\n%s cached item(s), status=%s" % [str(data.get("item_count", 0)), data.get("status", "")]
	_record_activity("File organization audit", "status=%s items=%s" % [data.get("status", ""), str(data.get("item_count", 0))], "file-vault")

func _render_file_search(data: Dictionary) -> void:
	selected_file_root_id = ""
	selected_file_path = ""
	selected_file_kind = ""
	var lines := [
		"[b]File Vault Search[/b]",
		"Query: %s | results=%s | cache=%s" % [data.get("query", ""), str(data.get("total", 0)), str(data.get("cache_ready", false))],
		"Cache: %s" % data.get("cache_path", ""),
		""
	]
	if not bool(data.get("cache_ready", true)):
		lines.append("Cache is empty. Use File Index to refresh it asynchronously.")
	for item in data.get("results", []):
		if typeof(item) != TYPE_DICTIONARY:
			continue
		if selected_file_path == "":
			selected_file_root_id = str(item.get("root_id", ""))
			selected_file_path = str(item.get("relative_path", ""))
			selected_file_kind = str(item.get("kind", ""))
		var marker := "[D]" if item.get("kind", "") == "dir" else "[F]"
		var tag_text := ""
		var tags: Array = item.get("tags", [])
		if not tags.is_empty():
			tag_text = " tags=%s" % ",".join(tags)
		lines.append("%s %s/%s%s" % [marker, item.get("root_id", ""), item.get("relative_path", ""), tag_text])
	room_body.text = "\n".join(lines)
	room_file_open_button.disabled = selected_file_root_id == "" or (selected_file_kind != "dir" and selected_file_path != "")
	room_file_reveal_button.disabled = selected_file_root_id == ""
	room_file_preview_button.disabled = selected_file_root_id == "" or selected_file_kind != "file"
	room_file_tag_button.disabled = selected_file_root_id == "" or selected_file_path == ""
	room_file_organize_button.disabled = selected_file_root_id == ""
	if selected_file_path != "":
		detail_body.text = "[b]File Vault[/b]\nSelected indexed %s: %s/%s" % [selected_file_kind, selected_file_root_id, selected_file_path]

func _render_file_tag_saved(data: Dictionary) -> void:
	var item: Dictionary = data.get("item", {})
	var lines := [
		"[b]File Tag Saved[/b]",
		"Safety: %s" % data.get("safety", ""),
		"Item: %s/%s" % [item.get("root_id", ""), item.get("relative_path", "")],
		"Tags: %s" % ", ".join(item.get("tags", [])),
		"Tag ledger: %s" % data.get("tag_path", "")
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]File tag saved[/b]\n%s/%s" % [item.get("root_id", ""), item.get("relative_path", "")]
	_record_npc_chain_action("tag_file", "file-vault")

func _render_file_opened(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]File Vault Item Revealed[/b]",
		"Status: %s | Safety: %s" % [data.get("status", ""), data.get("safety", "")],
		"Action: %s | Kind: %s" % [data.get("open_action", ""), data.get("kind", "")],
		"Item: %s/%s" % [data.get("root_id", ""), data.get("relative_path", "")],
		"Path: %s" % data.get("opened_path", ""),
		"Memory event: %s" % memory.get("path", ""),
	]
	var error := str(data.get("error", ""))
	if error != "":
		lines.append("Error: %s" % error)
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]File item revealed[/b]\n%s/%s" % [data.get("root_id", ""), data.get("relative_path", "")]
	_record_activity("File revealed", "%s/%s" % [data.get("root_id", ""), data.get("relative_path", "")], "file-vault")

func _render_file_organize_proposal(data: Dictionary) -> void:
	var target: Dictionary = data.get("target", {})
	var lines := [
		"[b]File Organize Proposal Saved[/b]",
		"Safety: %s" % data.get("safety", ""),
		"Target: %s/%s (%s)" % [target.get("root_id", ""), target.get("relative_path", ""), target.get("kind", "")],
		"Sampled: %s item(s)" % str(target.get("sample_count", 0)),
		"Proposal: %s" % data.get("proposal_path", ""),
		"",
		"[b]Suggested groups[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]File organize proposal saved[/b]\n%s" % data.get("proposal_path", "")

func _render_file_preview(data: Dictionary) -> void:
	if data.get("status", "") == "blocked":
		room_body.text = "[b]Preview blocked[/b]\n%s\nBytes: %s | extension: %s" % [data.get("reason", ""), str(data.get("bytes", 0)), data.get("extension", "")]
		return
	var lines := [
		"[b]File Preview[/b]",
		"%s/%s" % [data.get("root_id", ""), data.get("relative_path", "")],
		"Bytes: %s | chars=%s | truncated=%s" % [str(data.get("bytes", 0)), str(data.get("preview_chars", 0)), str(data.get("truncated", false))],
		"",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	_record_npc_chain_action("preview_file", "file-vault")

func _render_task_board(data: Dictionary) -> void:
	local_task_cards = []
	for task in data.get("local_tasks", []):
		if typeof(task) == TYPE_DICTIONARY:
			local_task_cards.append(task)
	var existing_task_id := selected_task_id
	selected_task_id = ""
	selected_task_index = 0
	for i in range(local_task_cards.size()):
		var task: Dictionary = local_task_cards[i]
		var task_id := str(task.get("id", ""))
		if task_id != "" and (existing_task_id == "" or task_id == existing_task_id):
			selected_task_id = task_id
			selected_task_index = i
			break
	_render_task_board_from_cache(data)

func _render_task_board_from_cache(data: Dictionary = {}) -> void:
	room_task_next_button.disabled = local_task_cards.size() <= 1
	room_task_open_button.disabled = selected_task_id == ""
	room_task_agent_button.disabled = selected_task_id == ""
	room_task_doing_button.disabled = selected_task_id == ""
	room_task_done_button.disabled = selected_task_id == ""
	var lines := [
		"[b]Task Board[/b]",
		"Mode: %s" % data.get("mode", "project-local-ledger"),
		"Local tasks: %s | %s" % [str(data.get("local_task_count", local_task_cards.size())), JSON.stringify(data.get("status_counts", {}))],
		"Dispatch drafts: %s | Memory events: %s" % [str(data.get("dispatch_draft_count", 0)), str(data.get("memory_event_count", 0))],
		"Ledger: %s" % data.get("ledger_path", ""),
		"%s" % data.get("safe_note", ""),
		""
	]
	lines.append("[b]Local Tasks[/b]")
	for task in local_task_cards:
		var task_id := str(task.get("id", ""))
		var marker := " "
		if task_id == selected_task_id:
			marker = "*"
		lines.append("%s %s | %s | agent=%s" % [marker, task.get("title", "Task"), task.get("status", ""), task.get("target_agent", "")])
		if str(task.get("draft_path", "")) != "":
			lines.append("  %s" % task.get("draft_path", ""))
	if selected_task_id != "":
		lines.append("")
		lines.append("[b]Selected task[/b] %s/%s - %s" % [str(selected_task_index + 1), str(local_task_cards.size()), selected_task_id])
		lines.append("Use Next Task to choose, then Doing or Done to update the project-local task ledger.")
	var drafts: Array = data.get("dispatch_drafts", [])
	if not drafts.is_empty():
		lines.append("")
		lines.append("[b]Dispatch Drafts[/b]")
		for draft in drafts.slice(0, min(5, drafts.size())):
			if typeof(draft) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [draft.get("title", ""), draft.get("path", "")])
	room_body.text = "\n".join(lines)

func _render_task_status_updated(data: Dictionary) -> void:
	var task: Dictionary = data.get("task", {})
	var memory: Dictionary = data.get("memory_event", {})
	selected_task_id = str(task.get("id", selected_task_id))
	for i in range(local_task_cards.size()):
		var cached: Dictionary = local_task_cards[i]
		if str(cached.get("id", "")) == selected_task_id:
			local_task_cards[i] = task
			selected_task_index = i
			break
	var lines := [
		"[b]Task Status Updated[/b]",
		"Task: %s" % task.get("title", ""),
		"Status: %s | Safety: %s" % [task.get("status", ""), data.get("safety", "")],
		"Note: %s" % task.get("status_note", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"Reload Task Board to inspect the updated ledger counts."
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Task status updated[/b]\n%s -> %s" % [task.get("title", ""), task.get("status", "")]
	room_task_next_button.disabled = local_task_cards.size() <= 1
	room_task_open_button.disabled = selected_task_id == ""
	room_task_agent_button.disabled = selected_task_id == ""
	room_task_doing_button.disabled = false
	room_task_done_button.disabled = task.get("status", "") == "done"

func _render_task_detail(data: Dictionary) -> void:
	var task: Dictionary = data.get("task", {})
	selected_task_id = str(task.get("id", selected_task_id))
	var lines := [
		"[b]Task Detail[/b]",
		"%s | %s | agent=%s" % [task.get("title", "Task"), task.get("status", ""), task.get("target_agent", "")],
		"Source: %s | Safety: %s" % [task.get("source", ""), data.get("safety", "")],
		"Draft: %s | exists=%s | bytes=%s | truncated=%s" % [data.get("draft_path", ""), str(data.get("draft_exists", false)), str(data.get("bytes", 0)), str(data.get("truncated", false))],
		"",
		"[b]Preview[/b]",
		str(data.get("preview", "")),
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Task preview[/b]\n%s" % task.get("title", selected_task_id)
	room_task_open_button.disabled = selected_task_id == ""
	room_task_agent_button.disabled = selected_task_id == ""
	room_task_doing_button.disabled = selected_task_id == ""
	room_task_done_button.disabled = task.get("status", "") == "done"

func _render_task_created(data: Dictionary) -> void:
	var task: Dictionary = data.get("task", {})
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Task Card Created[/b]",
		"Task: %s" % task.get("title", ""),
		"Agent: %s | Status: %s | Safety: %s" % [task.get("target_agent", ""), task.get("status", ""), task.get("safety", "")],
		"Draft: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Task Board updated[/b]\n%s\nStatus: %s" % [task.get("title", ""), task.get("status", "")]

func _render_writing_studio(data: Dictionary) -> void:
	var lines := [
		"[b]Writing Studio[/b]",
		"Mode: %s" % data.get("mode", "project-local-drafts"),
		"Documents: %s | Drafts: %s" % [str(data.get("document_count", 0)), str(data.get("draft_count", 0))],
		"Draft dir: %s" % data.get("draft_dir", ""),
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Project Documents[/b]"
	]
	for doc in data.get("documents", []):
		if typeof(doc) == TYPE_DICTIONARY:
			lines.append("- %s | %s" % [doc.get("title", doc.get("name", "doc")), doc.get("relative_path", "")])
	var drafts: Array = data.get("drafts", [])
	if not drafts.is_empty():
		lines.append("")
		lines.append("[b]Drafts[/b]")
		for draft in drafts.slice(0, min(8, drafts.size())):
			if typeof(draft) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [draft.get("title", ""), draft.get("path", "")])
	room_body.text = "\n".join(lines)

func _render_writing_draft_created(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Writing Draft Created[/b]",
		"Safety: %s" % data.get("safety", ""),
		"Draft: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Writing draft saved[/b]\n%s" % data.get("draft_path", "")

func _render_automation_factory(data: Dictionary) -> void:
	var lines := [
		"[b]Automation Factory[/b]",
		"Mode: %s" % data.get("mode", "script-catalog-blueprints-scheduler-readonly"),
		"Scripts: %s | Scheduled sample: %s | Drafts: %s" % [str(data.get("script_count", 0)), str(data.get("scheduled_task_count", 0)), str(data.get("draft_count", 0))],
		"Draft dir: %s" % data.get("draft_dir", ""),
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Script Catalog[/b]"
	]
	for script in data.get("scripts", []):
		if typeof(script) == TYPE_DICTIONARY:
			lines.append("- %s | %s | %s" % [script.get("name", script.get("id", "script")), script.get("safety", ""), script.get("relative_path", "")])
	var scheduler: Dictionary = data.get("scheduler", {})
	var tasks: Array = scheduler.get("tasks", [])
	if not tasks.is_empty():
		lines.append("")
		lines.append("[b]Scheduled Task Sample[/b]")
		for task in tasks.slice(0, min(6, tasks.size())):
			if typeof(task) == TYPE_DICTIONARY:
				lines.append("- %s%s | %s" % [task.get("path", "\\"), task.get("name", ""), task.get("state", "")])
	var drafts: Array = data.get("drafts", [])
	if not drafts.is_empty():
		lines.append("")
		lines.append("[b]Blueprint Drafts[/b]")
		for draft in drafts.slice(0, min(8, drafts.size())):
			if typeof(draft) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [draft.get("title", ""), draft.get("path", "")])
	room_body.text = "\n".join(lines)

func _render_automation_scheduler(data: Dictionary) -> void:
	var lines := [
		"[b]Automation Scheduler Snapshot[/b]",
		"Status: %s | Tasks sampled: %s / limit %s" % [data.get("status", ""), str(data.get("task_count", 0)), str(data.get("sample_limit", 0))],
		"Exit: %s | Error: %s" % [str(data.get("exit_code", "")), data.get("error", "")],
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Scheduled Tasks[/b]"
	]
	for task in data.get("tasks", []):
		if typeof(task) == TYPE_DICTIONARY:
			lines.append("- %s%s | %s" % [task.get("path", "\\"), task.get("name", ""), task.get("state", "")])
			var description := str(task.get("description", ""))
			if description != "":
				lines.append("  %s" % description.substr(0, 150))
	if data.get("tasks", []).is_empty():
		lines.append("- No scheduled tasks returned, or scheduler query is unavailable.")
	room_body.text = "\n".join(lines)

func _render_automation_draft_created(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var script: Dictionary = data.get("script", {})
	var lines := [
		"[b]Automation Blueprint Created[/b]",
		"Safety: %s" % data.get("safety", ""),
		"Script: %s | %s" % [script.get("name", "none"), script.get("safety", "")],
		"Draft: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Automation blueprint saved[/b]\n%s" % data.get("draft_path", "")

func _render_permission_hall(data: Dictionary) -> void:
	var lines := [
		"[b]Permission Hall[/b]",
		"Mode: %s" % data.get("mode", "read-only-policy-ledger"),
		"%s" % data.get("safe_note", ""),
		"Safety counts: %s" % JSON.stringify(data.get("safety_counts", {})),
		"",
		"[b]Confirmation Gates[/b]"
	]
	for gate in data.get("confirmation_gates", []):
		if typeof(gate) == TYPE_DICTIONARY:
			lines.append("- %s | phrase=%s | %s" % [gate.get("scope", ""), gate.get("phrase", ""), gate.get("endpoint", "")])
	lines.append("")
	lines.append("[b]Blocked / Future-Gated Actions[/b]")
	for action in data.get("blocked_actions", []):
		if typeof(action) == TYPE_DICTIONARY:
			lines.append("- %s | %s | %s" % [action.get("label", ""), action.get("status", ""), action.get("reason", "")])
	lines.append("")
	lines.append("[b]Writable Scopes[/b]")
	for scope in data.get("writable_scopes", []):
		if typeof(scope) == TYPE_DICTIONARY:
			lines.append("- %s | exists=%s | %s" % [scope.get("name", ""), str(scope.get("exists", false)), scope.get("path", "")])
	var receipts: Dictionary = data.get("permission_receipts", {})
	if not receipts.is_empty():
		lines.append("")
		lines.append("[b]Permission Receipts[/b]")
		lines.append("Receipts: %s | %s" % [str(receipts.get("count", 0)), JSON.stringify(receipts.get("counts", {}))])
		var receipt_items: Array = receipts.get("receipts", [])
		for receipt in receipt_items.slice(0, min(10, receipt_items.size())):
			if typeof(receipt) == TYPE_DICTIONARY:
				lines.append("- %s | %s | %s" % [receipt.get("kind", ""), receipt.get("status", ""), receipt.get("title", "")])
				var detail := str(receipt.get("detail", ""))
				if detail != "":
					lines.append("  %s" % detail.substr(0, 120))
				lines.append("  %s" % receipt.get("path", ""))
	var secret_audit: Dictionary = data.get("secret_audit", {})
	if not secret_audit.is_empty():
		lines.append("")
		lines.append("[b]Secret Exposure Audit[/b]")
		lines.append("Status: %s | findings=%s | scanned=%s | skipped=%s" % [secret_audit.get("status", "unknown"), str(secret_audit.get("finding_count", 0)), str(secret_audit.get("scanned_files", 0)), str(secret_audit.get("skipped_files", 0))])
		lines.append("Patterns: %s" % JSON.stringify(secret_audit.get("pattern_counts", {})))
		lines.append("Use Secret Audit for bounded file-level counts and line numbers; no secret text is displayed.")
	var events: Array = data.get("audit_events", [])
	if not events.is_empty():
		lines.append("")
		lines.append("[b]Recent Audit Signals[/b]")
		for event in events.slice(0, min(8, events.size())):
			if typeof(event) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [event.get("title", event.get("id", "event")), event.get("path", "")])
	room_body.text = "\n".join(lines)

func _render_permission_secret_audit(data: Dictionary) -> void:
	var lines := [
		"[b]Secret Exposure Audit[/b]",
		"Mode: %s" % data.get("mode", "read-only-secret-exposure-audit"),
		"Status: %s | findings=%s | returned=%s | scanned=%s | skipped=%s" % [data.get("status", "unknown"), str(data.get("finding_count", 0)), str(data.get("returned", 0)), str(data.get("scanned_files", 0)), str(data.get("skipped_files", 0))],
		"Bytes scanned: %s | max/file=%s" % [str(data.get("scanned_bytes", 0)), str(data.get("max_bytes_per_file", 0))],
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Pattern Counts[/b]",
		JSON.stringify(data.get("pattern_counts", {})),
		"",
		"[b]Audit Sources[/b]"
	]
	for source in data.get("sources", []):
		if typeof(source) == TYPE_DICTIONARY:
			lines.append("- %s | %s | exists=%s | %s" % [source.get("name", source.get("id", "")), source.get("kind", ""), str(source.get("exists", false)), source.get("path", "")])
	var findings: Array = data.get("findings", [])
	lines.append("")
	lines.append("[b]Findings[/b]")
	if findings.is_empty():
		lines.append("No secret-shaped strings were found in the bounded project-local audit set.")
	else:
		for finding in findings.slice(0, min(12, findings.size())):
			if typeof(finding) == TYPE_DICTIONARY:
				lines.append("- %s | findings=%s | %s" % [finding.get("path", ""), str(finding.get("finding_count", 0)), JSON.stringify(finding.get("pattern_counts", {}))])
				lines.append("  lines=%s" % JSON.stringify(finding.get("line_numbers", {})))
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Secret audit[/b]\n%s | findings=%s | scanned=%s" % [data.get("status", "unknown"), str(data.get("finding_count", 0)), str(data.get("scanned_files", 0))]
	_record_npc_chain_action("permission_secret_audit", "permission-hall")

func _render_settings_center(data: Dictionary) -> void:
	var workspace_registry: Dictionary = data.get("workspace_registry", {})
	var registry_health: Dictionary = data.get("registry_health", {})
	var lines := [
		"[b]Settings Center[/b]",
		"Mode: %s" % data.get("mode", "read-only-plus-draft"),
		"Registries: %s | Launchers: %s | Env vars: %s" % [str(data.get("registry_count", 0)), str(data.get("launcher_count", 0)), str(data.get("env_count", 0))],
		"Registry Health: %s | errors=%s | warnings=%s" % [registry_health.get("status", "unknown"), str(registry_health.get("error_count", 0)), str(registry_health.get("warning_count", 0))],
		"Workspaces: %s enabled / %s total | File Vault=%s | Projects=%s" % [str(workspace_registry.get("enabled_count", 0)), str(workspace_registry.get("count", 0)), str(workspace_registry.get("file_vault_count", 0)), str(workspace_registry.get("project_browser_count", 0))],
		"Draft dir: %s" % data.get("draft_dir", ""),
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Registries[/b]"
	]
	for registry in data.get("registries", []):
		if typeof(registry) == TYPE_DICTIONARY:
			lines.append("- %s | exists=%s | count=%s" % [registry.get("name", ""), str(registry.get("exists", false)), str(registry.get("count", 0))])
			lines.append("  %s" % registry.get("path", ""))
	var workspaces: Array = workspace_registry.get("workspaces", [])
	if not workspaces.is_empty():
		lines.append("")
		lines.append("[b]Workspace Registry[/b]")
		for workspace in workspaces.slice(0, min(8, workspaces.size())):
			if typeof(workspace) == TYPE_DICTIONARY:
				lines.append("- %s | %s | file=%s | project=%s | exists=%s" % [workspace.get("name", ""), workspace.get("kind", ""), str(workspace.get("file_vault", false)), str(workspace.get("project_browser", false)), str(workspace.get("exists", false))])
	lines.append("")
	lines.append("[b]Environment Requirements[/b]")
	for env_item in data.get("env_requirements", []):
		if typeof(env_item) == TYPE_DICTIONARY:
			var extra := ""
			if env_item.has("value_preview"):
				extra = " | %s" % env_item.get("value_preview", "")
			lines.append("- %s | %s | configured=%s%s" % [env_item.get("name", ""), env_item.get("kind", ""), str(env_item.get("configured", false)), extra])
	lines.append("")
	lines.append("[b]Launchers[/b]")
	for launcher in data.get("launchers", []):
		if typeof(launcher) == TYPE_DICTIONARY:
			lines.append("- %s | exists=%s | %s" % [launcher.get("name", ""), str(launcher.get("exists", false)), launcher.get("safety", "")])
	var drafts: Array = data.get("drafts", [])
	if not drafts.is_empty():
		lines.append("")
		lines.append("[b]Settings Drafts[/b]")
		for draft in drafts.slice(0, min(6, drafts.size())):
			if typeof(draft) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [draft.get("title", ""), draft.get("path", "")])
	room_body.text = "\n".join(lines)

func _render_registry_health(data: Dictionary) -> void:
	var lines := [
		"[b]Registry Health[/b]",
		"Mode: %s" % data.get("mode", "read-only-schema-validation"),
		"Status: %s | registries=%s | errors=%s | warnings=%s | missing=%s" % [data.get("status", "unknown"), str(data.get("registry_count", 0)), str(data.get("error_count", 0)), str(data.get("warning_count", 0)), str(data.get("missing_count", 0))],
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Registry Checks[/b]"
	]
	for registry in data.get("registries", []):
		if typeof(registry) == TYPE_DICTIONARY:
			lines.append("- %s | %s | count=%s" % [registry.get("name", ""), registry.get("status", ""), str(registry.get("count", 0))])
			var errors: Array = registry.get("errors", [])
			var warnings: Array = registry.get("warnings", [])
			for error in errors.slice(0, min(2, errors.size())):
				lines.append("  error: %s" % str(error))
			for warning in warnings.slice(0, min(2, warnings.size())):
				lines.append("  warning: %s" % str(warning))
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Registry health[/b]\n%s | errors=%s | warnings=%s" % [data.get("status", "unknown"), str(data.get("error_count", 0)), str(data.get("warning_count", 0))]
	_record_npc_chain_action("registry_health", "settings-center")

func _render_settings_draft_created(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Settings Draft Created[/b]",
		"Safety: %s" % data.get("safety", ""),
		"Draft: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Settings draft saved[/b]\n%s" % data.get("draft_path", "")

func _render_testing_arena(data: Dictionary) -> void:
	vertical_proof_cards = []
	selected_vertical_proof_index = -1
	selected_vertical_proof_id = ""
	var artifact: Dictionary = data.get("visual_artifact", {})
	var manifest: Dictionary = data.get("visual_manifest", {})
	var lines := [
		"[b]Testing Arena[/b]",
		"Mode: %s" % data.get("mode", "read-only-plus-test-plan-drafts"),
		"Scripts: %s | Drafts: %s | Proofs: %s | Visual: %s" % [str(data.get("script_count", 0)), str(data.get("draft_count", 0)), str(data.get("vertical_slice_proof_count", 0)), artifact.get("status", "unknown")],
		"Visual artifact: %s (%s bytes)" % [artifact.get("path", ""), str(artifact.get("bytes", 0))],
		"Room manifest: %s | %s/%s rooms | hashes failed=%s" % [manifest.get("status", "unknown"), str(manifest.get("valid_screenshot_count", 0)), str(manifest.get("registry_room_count", 0)), str(manifest.get("hash_mismatch_count", 0))],
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Verification Scripts[/b]"
	]
	for script in data.get("scripts", []):
		if typeof(script) == TYPE_DICTIONARY:
			lines.append("- %s | exists=%s | %s" % [script.get("name", ""), str(script.get("exists", false)), script.get("path", "")])
	if not manifest.is_empty():
		lines.append("")
		lines.append("[b]All-Room Visual Manifest[/b]")
		lines.append("- coverage_ok=%s | valid=%s/%s | missing files=%s | small files=%s" % [str(manifest.get("coverage_ok", false)), str(manifest.get("valid_screenshot_count", 0)), str(manifest.get("registry_room_count", 0)), str(manifest.get("missing_file_count", 0)), str(manifest.get("small_file_count", 0))])
		lines.append("- %s" % manifest.get("manifest_path", ""))
	var logs: Array = data.get("recent_terminal_logs", [])
	if not logs.is_empty():
		lines.append("")
		lines.append("[b]Recent Terminal Logs[/b]")
		for log in logs.slice(0, min(5, logs.size())):
			if typeof(log) == TYPE_DICTIONARY:
				lines.append("- %s | %s | rc=%s" % [log.get("label", log.get("command_id", "command")), log.get("status", ""), str(log.get("returncode", ""))])
	var verification: Array = data.get("verification_log", [])
	if not verification.is_empty():
		lines.append("")
		lines.append("[b]Verification Log[/b]")
		for item in verification.slice(0, min(6, verification.size())):
			if typeof(item) == TYPE_DICTIONARY:
				lines.append("- %s" % item.get("title", ""))
	var drafts: Array = data.get("drafts", [])
	if not drafts.is_empty():
		lines.append("")
		lines.append("[b]Test Plans[/b]")
		for draft in drafts.slice(0, min(5, drafts.size())):
			if typeof(draft) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [draft.get("title", ""), draft.get("path", "")])
	var proofs: Array = data.get("vertical_slice_proofs", [])
	if not proofs.is_empty():
		lines.append("")
		lines.append("[b]Vertical Slice Proofs[/b]")
		for proof in proofs.slice(0, min(5, proofs.size())):
			if typeof(proof) == TYPE_DICTIONARY:
				vertical_proof_cards.append(proof)
				lines.append("- %s | %s" % [proof.get("title", ""), proof.get("path", "")])
	room_body.text = "\n".join(lines)
	room_next_proof_button.disabled = vertical_proof_cards.is_empty()
	room_open_proof_button.disabled = vertical_proof_cards.is_empty()
	_record_npc_chain_action("testing_overview", "testing-arena")

func _render_test_plan_created(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Test Plan Draft Created[/b]",
		"Safety: %s" % data.get("safety", ""),
		"Draft: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Test plan saved[/b]\n%s" % data.get("draft_path", "")
	_record_npc_chain_action("test_plan", "testing-arena")

func _render_vertical_slice_proof(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Vertical Slice Proof Recorded[/b]",
		"Safety: %s" % data.get("safety", ""),
		"Checks: %s / %s" % [str(data.get("checks_passed", 0)), str(data.get("checks_total", 0))],
		"Report: %s" % data.get("report_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Missing / Follow-up Signals[/b]"
	]
	var missing: Array = data.get("missing", [])
	if missing.is_empty():
		lines.append("All sampled vertical-slice checks passed.")
	else:
		for item in missing:
			if typeof(item) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [item.get("name", ""), item.get("detail", "")])
	lines.append("")
	lines.append("[b]Visual Evidence[/b]")
	var artifacts: Array = data.get("visual_artifacts", [])
	for artifact in artifacts.slice(0, min(8, artifacts.size())):
		if typeof(artifact) == TYPE_DICTIONARY:
			lines.append("- %s | exists=%s | bytes=%s" % [artifact.get("name", ""), str(artifact.get("exists", false)), str(artifact.get("bytes", 0))])
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Vertical slice proof saved[/b]\n%s" % data.get("report_path", "")
	_record_activity("Vertical slice proof", "%s/%s checks" % [str(data.get("checks_passed", 0)), str(data.get("checks_total", 0))], "testing")

func _render_vertical_slice_proof_detail(data: Dictionary) -> void:
	var proof: Dictionary = data.get("proof", {})
	var lines := [
		"[b]Vertical Slice Proof Preview[/b]",
		"Safety: %s" % data.get("safety", ""),
		"Proof: %s" % proof.get("title", data.get("proof_id", "")),
		"Path: %s" % proof.get("path", ""),
		"Preview chars: %s | truncated=%s" % [str(data.get("preview_chars", 0)), str(data.get("truncated", false))],
		"",
		"[b]Report Preview[/b]",
		str(data.get("preview", "")),
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Vertical proof opened[/b]\n%s" % proof.get("path", "")
	_record_activity("Vertical proof opened", str(proof.get("title", data.get("proof_id", ""))), "testing")

func _render_bug_clinic(data: Dictionary) -> void:
	var testing: Dictionary = data.get("testing_arena", {})
	var artifact: Dictionary = testing.get("visual_artifact", {})
	var lines := [
		"[b]Bug Clinic[/b]",
		"Mode: %s" % data.get("mode", "read-only-plus-bug-report-drafts"),
		"Failed jobs: %s | Failed command logs: %s | Reports: %s" % [str(data.get("failed_job_count", 0)), str(data.get("failed_terminal_log_count", 0)), str(data.get("bug_report_count", 0))],
		"Visual proof: %s | verification entries=%s" % [artifact.get("status", "unknown"), str(testing.get("verification_log_count", 0))],
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Diagnostics[/b]"
	]
	for diagnostic in data.get("diagnostics", []):
		if typeof(diagnostic) == TYPE_DICTIONARY:
			lines.append("- %s | %s" % [diagnostic.get("title", diagnostic.get("id", "diagnostic")), diagnostic.get("status", "")])
			lines.append("  %s" % diagnostic.get("detail", ""))
	var failed_jobs: Array = data.get("failed_jobs", [])
	if not failed_jobs.is_empty():
		lines.append("")
		lines.append("[b]Failed Jobs[/b]")
		for job in failed_jobs.slice(0, min(5, failed_jobs.size())):
			if typeof(job) == TYPE_DICTIONARY:
				lines.append("- %s | %s | %s" % [job.get("kind", ""), job.get("status", ""), job.get("error", "")])
	var signals: Array = data.get("diagnostic_events", [])
	if not signals.is_empty():
		lines.append("")
		lines.append("[b]Diagnostic Signals[/b]")
		for diagnostic_signal in signals.slice(0, min(6, signals.size())):
			if typeof(diagnostic_signal) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [diagnostic_signal.get("title", ""), diagnostic_signal.get("path", "")])
	var reports: Array = data.get("bug_reports", [])
	if not reports.is_empty():
		lines.append("")
		lines.append("[b]Bug Reports[/b]")
		for report in reports.slice(0, min(5, reports.size())):
			if typeof(report) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [report.get("title", ""), report.get("path", "")])
	room_body.text = "\n".join(lines)

func _render_bug_report_created(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Bug Report Draft Created[/b]",
		"Severity: %s | Safety: %s" % [data.get("severity", ""), data.get("safety", "")],
		"Draft: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Bug report saved[/b]\n%s" % data.get("draft_path", "")

func _render_project_management(data: Dictionary) -> void:
	var lines := [
		"[b]Project Management Hall[/b]",
		"Mode: %s" % data.get("mode", "read-only-plus-project-brief-drafts"),
		"Repos: %s | Research: %s | Tasks: %s | Briefs: %s" % [str(data.get("project_count", 0)), str(data.get("research_project_count", 0)), str(data.get("local_task_count", 0)), str(data.get("brief_count", 0))],
		"Task status: %s" % JSON.stringify(data.get("task_status_counts", {})),
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Local Projects[/b]"
	]
	for project in data.get("projects", []):
		if typeof(project) == TYPE_DICTIONARY:
			lines.append("- %s | %s | branch=%s" % [project.get("name", project.get("id", "project")), project.get("family", ""), project.get("branch", "")])
	var research: Array = data.get("research_projects", [])
	if not research.is_empty():
		lines.append("")
		lines.append("[b]Research Boards[/b]")
		for item in research.slice(0, min(6, research.size())):
			if typeof(item) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [item.get("name", item.get("id", "research")), item.get("theme", item.get("next_action", ""))])
	var briefs: Array = data.get("briefs", [])
	if not briefs.is_empty():
		lines.append("")
		lines.append("[b]Project Briefs[/b]")
		for brief in briefs.slice(0, min(5, briefs.size())):
			if typeof(brief) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [brief.get("title", ""), brief.get("path", "")])
	room_body.text = "\n".join(lines)

func _render_project_brief_created(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Project Brief Draft Created[/b]",
		"Safety: %s" % data.get("safety", ""),
		"Draft: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Project brief saved[/b]\n%s" % data.get("draft_path", "")

func _render_download_station(data: Dictionary) -> void:
	var lines := [
		"[b]Download Station[/b]",
		"Mode: %s" % data.get("mode", "read-only-download-triage-plus-intake-drafts"),
		"Roots: %s | Triage: %s | Recent files: %s | Drafts: %s" % [str(data.get("root_count", 0)), str(data.get("triage_item_count", 0)), str(data.get("latest_file_count", 0)), str(data.get("draft_count", 0))],
		"File types: %s" % JSON.stringify(data.get("type_counts", {})),
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Intake Roots[/b]"
	]
	for root in data.get("roots", []):
		if typeof(root) == TYPE_DICTIONARY:
			lines.append("- %s | exists=%s | files=%s" % [root.get("name", root.get("id", "root")), str(root.get("exists", false)), str(root.get("sample_count", 0))])
			lines.append("  %s" % root.get("path", ""))
	var triage: Dictionary = data.get("triage", {})
	if int(triage.get("item_count", 0)) > 0:
		lines.append("")
		lines.append("[b]Triage Preview[/b]")
		lines.append("Risks: %s" % JSON.stringify(triage.get("risk_counts", {})))
		var triage_items: Array = triage.get("items", [])
		for item in triage_items.slice(0, min(4, triage_items.size())):
			if typeof(item) == TYPE_DICTIONARY:
				lines.append("- %s | %s | %s" % [item.get("name", "file"), item.get("kind", ""), JSON.stringify(item.get("risks", []))])
	var recent: Array = data.get("latest_files", [])
	if not recent.is_empty():
		lines.append("")
		lines.append("[b]Recent Downloads / Imports[/b]")
		for item in recent.slice(0, min(10, recent.size())):
			if typeof(item) == TYPE_DICTIONARY:
				lines.append("- %s | %s | %s bytes | %s" % [item.get("name", "file"), item.get("kind", "other"), str(item.get("bytes", 0)), item.get("root_name", "")])
	var drafts: Array = data.get("drafts", [])
	if not drafts.is_empty():
		lines.append("")
		lines.append("[b]Intake Drafts[/b]")
		for draft in drafts.slice(0, min(5, drafts.size())):
			if typeof(draft) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [draft.get("title", ""), draft.get("path", "")])
	room_body.text = "\n".join(lines)

func _render_download_triage(data: Dictionary) -> void:
	var root: Dictionary = data.get("root", {})
	var lines := [
		"[b]Download Triage[/b]",
		"Status: %s | Root: %s | Items: %s / limit %s" % [data.get("status", ""), root.get("name", ""), str(data.get("item_count", 0)), str(data.get("sample_limit", 0))],
		"Types: %s" % JSON.stringify(data.get("type_counts", {})),
		"Risks: %s" % JSON.stringify(data.get("risk_counts", {})),
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Recent Files[/b]"
	]
	for item in data.get("items", []):
		if typeof(item) == TYPE_DICTIONARY:
			var digest := str(item.get("sha256", ""))
			if digest.length() > 12:
				digest = digest.substr(0, 12)
			lines.append("- %s | %s | %s | %s" % [item.get("name", "file"), item.get("kind", ""), JSON.stringify(item.get("risks", [])), item.get("suggested_route", "")])
			if digest != "":
				lines.append("  sha256: %s..." % digest)
	lines.append("")
	lines.append("[b]Intake Routes[/b]")
	for route in data.get("intake_routes", []):
		lines.append("- %s" % str(route))
	if data.get("items", []).is_empty():
		lines.append("- No recent files returned, or the download root is missing.")
	room_body.text = "\n".join(lines)

func _render_download_intake_created(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var root: Dictionary = data.get("root", {})
	var lines := [
		"[b]Download Intake Draft Created[/b]",
		"Safety: %s" % data.get("safety", ""),
		"Root: %s | %s" % [root.get("name", ""), root.get("path", "")],
		"Draft: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Download intake draft saved[/b]\n%s" % data.get("draft_path", "")

func _render_asset_gallery(data: Dictionary) -> void:
	var lines := [
		"[b]Asset Resource Gallery[/b]",
		"Mode: %s" % data.get("mode", "read-only-asset-curation-plus-notes"),
		"Roots: %s | Assets sampled: %s | Inspect: %s | Notes: %s" % [str(data.get("root_count", 0)), str(data.get("asset_count", 0)), data.get("inspection_status", ""), str(data.get("note_count", 0))],
		"Asset types: %s" % JSON.stringify(data.get("kind_counts", {})),
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Style Contracts[/b]"
	]
	for contract in data.get("style_contracts", []):
		lines.append("- %s" % str(contract))
	lines.append("")
	lines.append("[b]Asset Roots[/b]")
	for root in data.get("roots", []):
		if typeof(root) == TYPE_DICTIONARY:
			lines.append("- %s | exists=%s | sample=%s" % [root.get("name", root.get("id", "root")), str(root.get("exists", false)), str(root.get("sample_count", 0))])
			lines.append("  %s" % root.get("path", ""))
	var assets: Array = data.get("assets", [])
	if not assets.is_empty():
		lines.append("")
		lines.append("[b]Sampled Assets[/b]")
		for item in assets.slice(0, min(12, assets.size())):
			if typeof(item) == TYPE_DICTIONARY:
				lines.append("- %s | %s | %s" % [item.get("relative_path", item.get("name", "asset")), item.get("kind", "other"), item.get("root_name", "")])
	var inspection: Dictionary = data.get("inspection", {})
	if inspection.get("status", "") == "ok":
		var inspected_asset: Dictionary = inspection.get("asset", {})
		var image: Dictionary = inspection.get("image", {})
		lines.append("")
		lines.append("[b]Inspection Preview[/b]")
		lines.append("%s | %s | %sx%s | %s" % [inspected_asset.get("relative_path", ""), inspected_asset.get("kind", ""), str(image.get("width", 0)), str(image.get("height", 0)), inspection.get("hash_status", "")])
	var notes: Array = data.get("notes", [])
	if not notes.is_empty():
		lines.append("")
		lines.append("[b]Asset Notes[/b]")
		for note in notes.slice(0, min(5, notes.size())):
			if typeof(note) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [note.get("title", ""), note.get("path", "")])
	room_body.text = "\n".join(lines)

func _render_asset_inspection(data: Dictionary) -> void:
	var asset: Dictionary = data.get("asset", {})
	var image: Dictionary = data.get("image", {})
	var digest := str(data.get("sha256", ""))
	if digest.length() > 16:
		digest = digest.substr(0, 16)
	var lines := [
		"[b]Asset Inspection[/b]",
		"Status: %s | Safety: %s" % [data.get("status", ""), data.get("safety", "")],
		"Asset: %s" % asset.get("relative_path", asset.get("name", "")),
		"Root: %s | Kind: %s | Bytes: %s" % [asset.get("root_name", ""), asset.get("kind", ""), str(asset.get("bytes", 0))],
		"Image: %sx%s %s" % [str(image.get("width", 0)), str(image.get("height", 0)), image.get("format", "")],
		"Hash: %s | %s" % [digest, data.get("hash_status", "")],
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Curation Checks[/b]"
	]
	for check in data.get("curation_checks", []):
		lines.append("- %s" % str(check))
	room_body.text = "\n".join(lines)

func _render_asset_note_created(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var root: Dictionary = data.get("root", {})
	var lines := [
		"[b]Asset Curation Note Created[/b]",
		"Safety: %s" % data.get("safety", ""),
		"Root: %s | %s" % [root.get("name", ""), root.get("path", "")],
		"Note: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Asset curation note saved[/b]\n%s" % data.get("draft_path", "")

func _render_local_office_center(data: Dictionary) -> void:
	var lines := [
		"[b]Local Office Center[/b]",
		"Mode: %s" % data.get("mode", "read-only-office-map-plus-notes"),
		"Roots: %s | Recent items: %s | Notes: %s" % [str(data.get("root_count", 0)), str(data.get("recent_item_count", 0)), str(data.get("note_count", 0))],
		"Office types: %s" % JSON.stringify(data.get("type_counts", {})),
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Office Workflows[/b]"
	]
	for workflow in data.get("workflows", []):
		lines.append("- %s" % str(workflow))
	lines.append("")
	lines.append("[b]Office Roots[/b]")
	for root in data.get("roots", []):
		if typeof(root) == TYPE_DICTIONARY:
			lines.append("- %s | exists=%s | sample=%s" % [root.get("name", root.get("id", "root")), str(root.get("exists", false)), str(root.get("sample_count", 0))])
			lines.append("  %s" % root.get("path", ""))
	var recent: Array = data.get("recent_items", [])
	if not recent.is_empty():
		lines.append("")
		lines.append("[b]Recent Office Context[/b]")
		for item in recent.slice(0, min(10, recent.size())):
			if typeof(item) == TYPE_DICTIONARY:
				lines.append("- %s | %s | %s" % [item.get("relative_path", item.get("name", "item")), item.get("kind", "other"), item.get("root_name", "")])
	var notes: Array = data.get("notes", [])
	if not notes.is_empty():
		lines.append("")
		lines.append("[b]Office Notes[/b]")
		for note in notes.slice(0, min(5, notes.size())):
			if typeof(note) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [note.get("title", ""), note.get("path", "")])
	room_body.text = "\n".join(lines)

func _render_office_note_created(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var root: Dictionary = data.get("root", {})
	var lines := [
		"[b]Office Note Created[/b]",
		"Safety: %s" % data.get("safety", ""),
		"Root: %s | %s" % [root.get("name", ""), root.get("path", "")],
		"Note: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Office note saved[/b]\n%s" % data.get("draft_path", "")

func _render_schedule_plan_center(data: Dictionary) -> void:
	var lines := [
		"[b]Schedule and Plan Center[/b]",
		"Mode: %s" % data.get("mode", "read-only-planning-signals-plus-drafts"),
		"Signals: %s | Open PLAN: %s | Local tasks: %s | Drafts: %s" % [str(data.get("signal_count", 0)), str(data.get("open_plan_task_count", 0)), str(data.get("local_task_count", 0)), str(data.get("schedule_draft_count", 0))],
		"Task status: %s" % JSON.stringify(data.get("task_status_counts", {})),
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Planning Rules[/b]"
	]
	for rule in data.get("planning_rules", []):
		lines.append("- %s" % str(rule))
	var open_tasks: Array = data.get("open_plan_tasks", [])
	if not open_tasks.is_empty():
		lines.append("")
		lines.append("[b]Open PLAN Tasks[/b]")
		for task in open_tasks.slice(0, min(8, open_tasks.size())):
			if typeof(task) == TYPE_DICTIONARY:
				lines.append("- %s" % task.get("title", "task"))
	var signals: Array = data.get("signals", [])
	if not signals.is_empty():
		lines.append("")
		lines.append("[b]Planning Signals[/b]")
		for plan_signal in signals.slice(0, min(5, signals.size())):
			if typeof(plan_signal) == TYPE_DICTIONARY:
				lines.append("- %s | exists=%s" % [plan_signal.get("title", "signal"), str(plan_signal.get("exists", false))])
				var preview := str(plan_signal.get("preview", ""))
				if preview != "":
					lines.append("  %s" % preview.substr(0, 180))
	var drafts: Array = data.get("schedule_drafts", [])
	if not drafts.is_empty():
		lines.append("")
		lines.append("[b]Schedule Drafts[/b]")
		for draft in drafts.slice(0, min(5, drafts.size())):
			if typeof(draft) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [draft.get("title", ""), draft.get("path", "")])
	room_body.text = "\n".join(lines)

func _render_schedule_draft_created(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Schedule Draft Created[/b]",
		"Horizon: %s | Safety: %s" % [data.get("horizon", ""), data.get("safety", "")],
		"Draft: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Schedule draft saved[/b]\n%s" % data.get("draft_path", "")

func _render_learning_training(data: Dictionary) -> void:
	var lines := [
		"[b]Learning Training Grounds[/b]",
		"Mode: %s" % data.get("mode", "read-only-learning-map-plus-plans"),
		"Skills: %s | Categories: %s | Plans: %s | Schedule drafts: %s" % [str(data.get("skill_count", 0)), str(data.get("category_count", 0)), str(data.get("learning_plan_count", 0)), str(data.get("schedule_draft_count", 0))],
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Tracks[/b]"
	]
	for track in data.get("tracks", []):
		if typeof(track) == TYPE_DICTIONARY:
			lines.append("- %s | %s" % [track.get("name", track.get("id", "track")), track.get("focus", "")])
	var skills: Array = data.get("skills", [])
	if not skills.is_empty():
		lines.append("")
		lines.append("[b]Sample Skills[/b]")
		for skill in skills.slice(0, min(12, skills.size())):
			if typeof(skill) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [skill.get("name", "skill"), skill.get("category", "")])
	var plans: Array = data.get("learning_plans", [])
	if not plans.is_empty():
		lines.append("")
		lines.append("[b]Learning Plans[/b]")
		for plan in plans.slice(0, min(5, plans.size())):
			if typeof(plan) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [plan.get("title", ""), plan.get("path", "")])
	room_body.text = "\n".join(lines)

func _render_learning_plan_created(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Learning Plan Created[/b]",
		"Track: %s | Safety: %s" % [data.get("track", ""), data.get("safety", "")],
		"Plan: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Learning plan saved[/b]\n%s" % data.get("draft_path", "")

func _render_language_learning(data: Dictionary) -> void:
	var lines := [
		"[b]Language Learning Area[/b]",
		"Mode: %s" % data.get("mode", "read-only-language-signals-plus-practice-notes"),
		"Tracks: %s | Signals: %s | Practice notes: %s | Learning plans: %s" % [str(data.get("supported_count", 0)), str(data.get("signal_count", 0)), str(data.get("practice_note_count", 0)), str(data.get("learning_plan_count", 0))],
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Language Tracks[/b]"
	]
	for lang in data.get("supported_languages", []):
		if typeof(lang) == TYPE_DICTIONARY:
			lines.append("- %s | %s" % [lang.get("name", lang.get("id", "language")), lang.get("focus", "")])
	var loops: Array = data.get("practice_loops", [])
	if not loops.is_empty():
		lines.append("")
		lines.append("[b]Practice Loops[/b]")
		for loop in loops:
			lines.append("- %s" % str(loop))
	var notes: Array = data.get("practice_notes", [])
	if not notes.is_empty():
		lines.append("")
		lines.append("[b]Practice Notes[/b]")
		for note in notes.slice(0, min(5, notes.size())):
			if typeof(note) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [note.get("title", ""), note.get("path", "")])
	room_body.text = "\n".join(lines)

func _render_language_practice_created(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Language Practice Created[/b]",
		"Language: %s | Safety: %s" % [data.get("language", ""), data.get("safety", "")],
		"Note: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Language practice saved[/b]\n%s" % data.get("draft_path", "")

func _render_research_data_center(data: Dictionary) -> void:
	var lines := [
		"[b]Research Data Center[/b]",
		"Mode: %s" % data.get("mode", "read-only-research-data-map-plus-local-notes"),
		"Roots: %s | Candidates: %s | Notes: %s" % [str(data.get("root_count", 0)), str(data.get("candidate_count", 0)), str(data.get("note_count", 0))],
		"Types: %s" % JSON.stringify(data.get("kind_counts", {})),
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Research Roots[/b]"
	]
	for root in data.get("roots", []):
		if typeof(root) == TYPE_DICTIONARY:
			lines.append("- %s | exists=%s | candidates=%s" % [root.get("project_name", root.get("project_id", "research")), str(root.get("exists", false)), str(root.get("candidate_count", 0))])
			lines.append("  %s" % root.get("path", ""))
	var candidates: Array = data.get("candidates", [])
	if not candidates.is_empty():
		lines.append("")
		lines.append("[b]Latest Data / Result Candidates[/b]")
		for candidate in candidates.slice(0, min(10, candidates.size())):
			if typeof(candidate) == TYPE_DICTIONARY:
				lines.append("- %s | %s | %s" % [candidate.get("relative_path", candidate.get("name", "candidate")), candidate.get("kind", "other"), candidate.get("project_name", "")])
	var prompts: Array = data.get("audit_prompts", [])
	if not prompts.is_empty():
		lines.append("")
		lines.append("[b]Audit Prompts[/b]")
		for prompt in prompts:
			lines.append("- %s" % str(prompt))
	var notes: Array = data.get("notes", [])
	if not notes.is_empty():
		lines.append("")
		lines.append("[b]Research Data Notes[/b]")
		for note in notes.slice(0, min(5, notes.size())):
			if typeof(note) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [note.get("title", ""), note.get("path", "")])
	room_body.text = "\n".join(lines)

func _render_research_data_note_created(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Research Data Note Created[/b]",
		"Project: %s | Safety: %s" % [data.get("project_id", ""), data.get("safety", "")],
		"Note: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Research data note saved[/b]\n%s" % data.get("draft_path", "")

func _render_paper_reading_room(data: Dictionary) -> void:
	selected_paper_root_id = ""
	selected_paper_relative_path = ""
	var lines := [
		"[b]Paper Reading Room[/b]",
		"Mode: %s" % data.get("mode", "bounded-paper-map-plus-local-reading-notes"),
		"Roots: %s | Paper/reference candidates: %s | Reading notes: %s" % [str(data.get("root_count", 0)), str(data.get("paper_count", 0)), str(data.get("reading_note_count", 0))],
		"Types: %s" % JSON.stringify(data.get("kind_counts", {})),
		"PDF parser: %s" % JSON.stringify(data.get("parser", {})),
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Paper Roots[/b]"
	]
	var citation_audit: Dictionary = data.get("citation_audit", {})
	if not citation_audit.is_empty():
		lines.append("[b]Citation Audit[/b]")
		lines.append("Status: %s | Bib files=%s | entries=%s | findings=%s" % [citation_audit.get("status", ""), str(citation_audit.get("bib_file_count", 0)), str(citation_audit.get("entry_count", 0)), str(citation_audit.get("finding_count", 0))])
		lines.append("")
	for root in data.get("roots", []):
		if typeof(root) == TYPE_DICTIONARY:
			lines.append("- %s | exists=%s | candidates=%s" % [root.get("name", root.get("id", "root")), str(root.get("exists", false)), str(root.get("candidate_count", 0))])
			lines.append("  %s" % root.get("path", ""))
	var papers: Array = data.get("papers", [])
	if not papers.is_empty():
		lines.append("")
		lines.append("[b]Recent Papers / References[/b]")
		for paper in papers.slice(0, min(10, papers.size())):
			if typeof(paper) == TYPE_DICTIONARY:
				lines.append("- %s | %s | %s" % [paper.get("relative_path", paper.get("name", "paper")), paper.get("kind", "other"), paper.get("root_name", "")])
				if selected_paper_relative_path == "" and paper.get("kind", "") == "paper-pdf":
					selected_paper_root_id = str(paper.get("root_id", ""))
					selected_paper_relative_path = str(paper.get("relative_path", ""))
	var loops: Array = data.get("reading_loops", [])
	if not loops.is_empty():
		lines.append("")
		lines.append("[b]Reading Loops[/b]")
		for loop in loops:
			lines.append("- %s" % str(loop))
	var notes: Array = data.get("reading_notes", [])
	if not notes.is_empty():
		lines.append("")
		lines.append("[b]Reading Notes[/b]")
		for note in notes.slice(0, min(5, notes.size())):
			if typeof(note) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [note.get("title", ""), note.get("path", "")])
	room_body.text = "\n".join(lines)
	room_paper_extract_button.disabled = selected_paper_relative_path == ""
	room_paper_extract_job_button.disabled = selected_paper_job_id == ""
	if selected_paper_relative_path != "":
		detail_body.text = "[b]Paper Reading Room[/b]\nSelected PDF: %s\nUse PDF Extract to queue a bounded backend extraction report." % selected_paper_relative_path

func _render_paper_citation_audit(data: Dictionary) -> void:
	var lines := [
		"[b]Citation Audit[/b]",
		"Mode: %s" % data.get("mode", "read-only-citation-audit"),
		"Status: %s | Bib files=%s | entries=%s | findings=%s" % [data.get("status", ""), str(data.get("bib_file_count", 0)), str(data.get("entry_count", 0)), str(data.get("finding_count", 0))],
		"Duplicate keys: %s | missing-field findings=%s | skipped=%s" % [str(data.get("duplicate_key_count", 0)), str(data.get("missing_field_finding_count", 0)), str(data.get("skipped_files", 0))],
		"Required: %s | Venue fields: %s" % [JSON.stringify(data.get("required_fields", [])), JSON.stringify(data.get("venue_fields", []))],
		"%s" % data.get("safe_note", ""),
		"",
		"[b]BibTeX Files[/b]"
	]
	for file in data.get("files", []):
		if typeof(file) == TYPE_DICTIONARY:
			lines.append("- %s | entries=%s | missing=%s" % [file.get("relative_path", ""), str(file.get("entry_count", 0)), str(file.get("missing_field_count", 0))])
	var duplicates: Array = data.get("duplicates", [])
	if not duplicates.is_empty():
		lines.append("")
		lines.append("[b]Duplicate Keys[/b]")
		for item in duplicates.slice(0, min(8, duplicates.size())):
			if typeof(item) == TYPE_DICTIONARY:
				lines.append("- %s | count=%s | %s" % [item.get("key", ""), str(item.get("count", 0)), JSON.stringify(item.get("locations", []))])
	var missing: Array = data.get("missing_field_findings", [])
	if not missing.is_empty():
		lines.append("")
		lines.append("[b]Missing Fields[/b]")
		for item in missing.slice(0, min(12, missing.size())):
			if typeof(item) == TYPE_DICTIONARY:
				lines.append("- %s | %s | %s:%s" % [item.get("key", ""), JSON.stringify(item.get("missing", [])), item.get("relative_path", ""), str(item.get("line", 0))])
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Citation audit[/b]\n%s | findings=%s | entries=%s" % [data.get("status", ""), str(data.get("finding_count", 0)), str(data.get("entry_count", 0))]

func _render_paper_extraction_job(job: Dictionary) -> void:
	selected_paper_job_id = str(job.get("id", selected_paper_job_id))
	var lines := [
		"[b]PDF Extraction Job[/b]",
		"Job: %s | Status: %s | Kind: %s" % [selected_paper_job_id, job.get("status", ""), job.get("kind", "")],
		"Label: %s" % job.get("label", ""),
		"Safety: %s" % job.get("safety", ""),
		"Error: %s" % job.get("error", ""),
	]
	var result = job.get("result", null)
	if typeof(result) == TYPE_DICTIONARY:
		lines.append("")
		lines.append("[b]Result[/b]")
		lines.append("Report: %s" % result.get("report_path", ""))
		lines.append("Pages: %s / %s | warnings=%s" % [str(result.get("pages_read", 0)), str(result.get("page_count", 0)), str(result.get("warning_count", 0))])
		lines.append("")
		lines.append("[b]Text Preview[/b]")
		lines.append(str(result.get("text_preview", "")))
	room_body.text = "\n".join(lines)
	room_paper_extract_job_button.disabled = selected_paper_job_id == ""
	if job.get("status", "") == "done" and typeof(result) == TYPE_DICTIONARY:
		quest_body.text = "[b]PDF extraction report ready[/b]\n%s" % result.get("report_path", "")

func _render_paper_extraction_availability(data: Dictionary) -> void:
	var candidate: Dictionary = data.get("candidate", {})
	var lines := [
		"[b]PDF Extraction Preview[/b]",
		"Status: %s | Safety: %s" % [data.get("status", ""), data.get("safety", "")],
		"Message: %s" % data.get("message", ""),
		"Parser: %s" % JSON.stringify(data.get("parser", {})),
		"",
		"[b]Selected Candidate[/b]",
		"%s" % candidate.get("relative_path", candidate.get("name", "No PDF selected")),
		"Kind: %s | Root: %s" % [candidate.get("kind", ""), candidate.get("root_name", "")],
	]
	room_body.text = "\n".join(lines)

func _render_paper_extraction_result(data: Dictionary) -> void:
	var lines := [
		"[b]PDF Extraction Result[/b]",
		"Safety: %s" % data.get("safety", ""),
		"Report: %s" % data.get("report_path", ""),
		"Pages: %s / %s | warnings=%s" % [str(data.get("pages_read", 0)), str(data.get("page_count", 0)), str(data.get("warning_count", 0))],
		"",
		"[b]Text Preview[/b]",
		str(data.get("text_preview", "")),
	]
	room_body.text = "\n".join(lines)

func _render_paper_reading_note_created(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Paper Reading Note Created[/b]",
		"Topic: %s | Safety: %s" % [data.get("topic", ""), data.get("safety", "")],
		"Note: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Paper reading note saved[/b]\n%s" % data.get("draft_path", "")

func _render_paper_citation_audit_note(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var audit: Dictionary = data.get("audit", {})
	var lines := [
		"[b]Citation Audit Note[/b]",
		"Status: %s | Safety: %s" % [data.get("status", ""), data.get("safety", "")],
		"Audit: %s | findings=%s | entries=%s" % [audit.get("status", ""), str(audit.get("finding_count", 0)), str(audit.get("entry_count", 0))],
		"Note: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	if data.get("status", "") == "saved":
		quest_body.text = "[b]Citation audit note saved[/b]\n%s" % data.get("draft_path", "")
	else:
		quest_body.text = "[b]Citation audit dry run[/b]\nfindings=%s" % str(audit.get("finding_count", 0))

func _render_version_release_plaza(data: Dictionary) -> void:
	var git: Dictionary = data.get("git", {})
	var manifest: Dictionary = data.get("visual_manifest", {})
	var build: Dictionary = data.get("build_readiness", {})
	var export_tool: Dictionary = data.get("export_tool", {})
	var packaged: Dictionary = data.get("packaged_launch", {})
	var release_manifest: Dictionary = data.get("release_manifest", {})
	var lines := [
		"[b]Version Release Plaza[/b]",
		"Mode: %s" % data.get("mode", "release-readiness-preview-plus-local-checklists"),
		"Required ready: %s / %s | Missing: %s | Drafts: %s | Reports: %s | Proofs: %s" % [str(data.get("ready_required_count", 0)), str(data.get("required_count", 0)), str(data.get("missing_required_count", 0)), str(data.get("draft_count", 0)), str(data.get("report_count", 0)), str(data.get("vertical_slice_proof_count", 0))],
		"Git: %s | status entries=%s | remotes=%s | tags=%s" % [git.get("branch", ""), str(git.get("status_count", 0)), str(git.get("remote_count", 0)), str(git.get("tag_count_sampled", 0))],
		"Visual manifest: %s | %s/%s rooms" % [manifest.get("status", "unknown"), str(manifest.get("valid_screenshot_count", 0)), str(manifest.get("registry_room_count", 0))],
		"Build readiness: %s | %s/%s checks | %s" % [build.get("status", "unknown"), str(build.get("checks_passed", 0)), str(build.get("checks_total", 0)), build.get("export", {}).get("export_path", "")],
		"Export tool: %s | blockers=%s | exe=%s" % [export_tool.get("status", "missing"), str(export_tool.get("blocker_count", 0)), str(export_tool.get("output_exists", false))],
		"Packaged launch: %s | %s/%s checks | %s" % [packaged.get("status", "unknown"), str(packaged.get("checks_passed", 0)), str(packaged.get("checks_total", 0)), packaged.get("launcher_path", "")],
		"Release manifest: %s | files=%s | exe=%s bytes" % [release_manifest.get("status", "unknown"), str(release_manifest.get("file_count", 0)), str(release_manifest.get("exe_bytes", 0))],
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Release Artifacts[/b]"
	]
	for artifact in data.get("files", []):
		if typeof(artifact) == TYPE_DICTIONARY:
			lines.append("- %s | %s | required=%s" % [artifact.get("name", artifact.get("id", "artifact")), artifact.get("status", ""), str(artifact.get("required", false))])
			lines.append("  %s" % artifact.get("path", ""))
	var missing: Array = data.get("missing_required", [])
	if not missing.is_empty():
		lines.append("")
		lines.append("[b]Missing Required[/b]")
		for artifact in missing:
			if typeof(artifact) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [artifact.get("name", ""), artifact.get("path", "")])
	var gates: Array = data.get("release_gates", [])
	if not gates.is_empty():
		lines.append("")
		lines.append("[b]Release Gates[/b]")
		for gate in gates:
			lines.append("- %s" % str(gate))
	var drafts: Array = data.get("drafts", [])
	if not drafts.is_empty():
		lines.append("")
		lines.append("[b]Release Drafts[/b]")
		for draft in drafts.slice(0, min(5, drafts.size())):
			if typeof(draft) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [draft.get("title", ""), draft.get("path", "")])
	var reports: Array = data.get("reports", [])
	if not reports.is_empty():
		lines.append("")
		lines.append("[b]Release Reports[/b]")
		for report in reports.slice(0, min(5, reports.size())):
			if typeof(report) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [report.get("title", ""), report.get("path", "")])
	var proofs: Array = data.get("vertical_slice_proofs", [])
	if not proofs.is_empty():
		lines.append("")
		lines.append("[b]Vertical Slice Proofs[/b]")
		for proof in proofs.slice(0, min(5, proofs.size())):
			if typeof(proof) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [proof.get("title", ""), proof.get("path", "")])
	room_body.text = "\n".join(lines)

func _render_release_checklist_created(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Release Checklist Created[/b]",
		"Target: %s | Safety: %s" % [data.get("release_target", ""), data.get("safety", "")],
		"Draft: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Release checklist saved[/b]\n%s" % data.get("draft_path", "")

func _render_release_report_created(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Release Readiness Report Created[/b]",
		"Target: %s | Safety: %s" % [data.get("release_target", ""), data.get("safety", "")],
		"Gates: %s / %s" % [str(data.get("gates_passed", 0)), str(data.get("gates_total", 0))],
		"Report: %s" % data.get("report_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Release report saved[/b]\n%s" % data.get("report_path", "")

func _render_plugin_registry(data: Dictionary) -> void:
	var lines := [
		"[b]Plugin Registry[/b]",
		"Mode: %s" % data.get("mode", "read-only-extension-map-plus-local-plugin-drafts"),
		"Roots: %s | Registries: %s | Manifests: %s | Candidates: %s | Drafts: %s" % [str(data.get("root_count", 0)), str(data.get("registry_count", 0)), str(data.get("manifest_count", 0)), str(data.get("candidate_count", 0)), str(data.get("draft_count", 0))],
		"Types: %s" % JSON.stringify(data.get("kind_counts", {})),
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Runtime Registries[/b]"
	]
	for registry in data.get("registries", []):
		if typeof(registry) == TYPE_DICTIONARY:
			lines.append("- %s | %s | count=%s" % [registry.get("name", registry.get("id", "registry")), registry.get("status", ""), str(registry.get("count", 0))])
			lines.append("  %s" % registry.get("path", ""))
	lines.append("")
	lines.append("[b]Extension Roots[/b]")
	for root in data.get("roots", []):
		if typeof(root) == TYPE_DICTIONARY:
			lines.append("- %s | exists=%s | candidates=%s" % [root.get("name", root.get("id", "root")), str(root.get("exists", false)), str(root.get("candidate_count", 0))])
	var manifest_catalog: Dictionary = data.get("manifest_catalog", {})
	if not manifest_catalog.is_empty():
		lines.append("")
		lines.append("[b]Typed Plugin Manifests[/b]")
		lines.append("Manifests: %s | warnings=%s | activation=%s" % [str(manifest_catalog.get("manifest_count", 0)), str(manifest_catalog.get("warning_count", 0)), JSON.stringify(manifest_catalog.get("activation_counts", {}))])
		for manifest in manifest_catalog.get("manifests", []).slice(0, min(5, manifest_catalog.get("manifests", []).size())):
			if typeof(manifest) == TYPE_DICTIONARY:
				lines.append("- %s | %s | %s | %s" % [manifest.get("name", manifest.get("id", "")), manifest.get("category", ""), manifest.get("owner_building", ""), manifest.get("status", "")])
	var candidates: Array = data.get("candidates", [])
	if not candidates.is_empty():
		lines.append("")
		lines.append("[b]Sampled Candidates[/b]")
		for candidate in candidates.slice(0, min(12, candidates.size())):
			if typeof(candidate) == TYPE_DICTIONARY:
				lines.append("- %s | %s | %s" % [candidate.get("relative_path", candidate.get("name", "candidate")), candidate.get("kind", "other"), candidate.get("root_name", "")])
	var gates: Array = data.get("extension_gates", [])
	if not gates.is_empty():
		lines.append("")
		lines.append("[b]Extension Gates[/b]")
		for gate in gates:
			lines.append("- %s" % str(gate))
	var drafts: Array = data.get("drafts", [])
	if not drafts.is_empty():
		lines.append("")
		lines.append("[b]Plugin Drafts[/b]")
		for draft in drafts.slice(0, min(5, drafts.size())):
			if typeof(draft) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [draft.get("title", ""), draft.get("path", "")])
	room_body.text = "\n".join(lines)

func _render_plugin_manifests(data: Dictionary) -> void:
	var lines := [
		"[b]Plugin Manifests[/b]",
		"Mode: %s" % data.get("mode", "read-only-typed-plugin-manifest-audit"),
		"Manifests: %s | warnings=%s | confirmation=%s" % [str(data.get("manifest_count", 0)), str(data.get("warning_count", 0)), data.get("confirmation_required", "")],
		"Categories: %s" % JSON.stringify(data.get("category_counts", {})),
		"Activation: %s" % JSON.stringify(data.get("activation_counts", {})),
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Manifest Entries[/b]"
	]
	for manifest in data.get("manifests", []):
		if typeof(manifest) == TYPE_DICTIONARY:
			lines.append("- %s | %s | owner=%s | safety=%s" % [manifest.get("name", manifest.get("id", "")), manifest.get("category", ""), manifest.get("owner_building", ""), manifest.get("safety", "")])
			lines.append("  activation=%s | permissions=%s | files=%s | verification=%s" % [manifest.get("activation_mode", ""), str(manifest.get("permissions", []).size()), str(manifest.get("files", []).size()), str(manifest.get("verification", []).size())])
	var warnings: Array = data.get("warnings", [])
	if not warnings.is_empty():
		lines.append("")
		lines.append("[b]Warnings[/b]")
		for warning in warnings.slice(0, min(8, warnings.size())):
			lines.append("- %s" % str(warning))
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Plugin manifests[/b]\n%s typed manifest(s), warnings=%s" % [str(data.get("manifest_count", 0)), str(data.get("warning_count", 0))]

func _render_plugin_draft_created(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Plugin Draft Created[/b]",
		"Plugin: %s | Category: %s | Safety: %s" % [data.get("plugin_id", ""), data.get("category", ""), data.get("safety", "")],
		"Draft: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Plugin proposal saved[/b]\n%s" % data.get("draft_path", "")

func _render_plugin_activation_plan(data: Dictionary) -> void:
	var manifest: Dictionary = data.get("manifest", {})
	var lines := [
		"[b]Plugin Activation Plan[/b]",
		"Status: %s | Safety: %s" % [data.get("status", ""), data.get("safety", "activation-plan-only")],
		"Manifest: %s | %s" % [data.get("manifest_id", ""), manifest.get("name", "")],
		"Owner: %s | Activation: %s" % [manifest.get("owner_building", ""), manifest.get("activation_mode", "")],
		"Plan: %s" % data.get("plan_path", ""),
		"Confirmation required: %s" % data.get("confirmation_required", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	if data.get("status", "") == "saved":
		quest_body.text = "[b]Plugin activation plan saved[/b]\n%s" % data.get("plan_path", "")
	else:
		quest_body.text = "[b]Plugin activation requires confirmation[/b]\n%s" % data.get("confirmation_required", "")

func _render_backup_station(data: Dictionary) -> void:
	var lines := [
		"[b]Backup Station[/b]",
		"Mode: %s" % data.get("mode", "read-only-backup-map-integrity-plus-plan-drafts"),
		"Sources: %s | Integrity samples: %s | Targets: %s | Plans: %s" % [str(data.get("source_count", 0)), str(data.get("integrity_item_count", 0)), str(data.get("target_count", 0)), str(data.get("plan_count", 0))],
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Backup Sources[/b]"
	]
	for source in data.get("sources", []):
		if typeof(source) == TYPE_DICTIONARY:
			lines.append("- %s | %s | exists=%s | sample=%s" % [source.get("name", source.get("id", "source")), source.get("priority", ""), str(source.get("exists", false)), str(source.get("sample_count", 0))])
			lines.append("  %s" % source.get("path", ""))
	var integrity: Dictionary = data.get("integrity", {})
	var integrity_items: Array = integrity.get("items", [])
	if not integrity_items.is_empty():
		lines.append("")
		lines.append("[b]Restore Check Sample[/b]")
		for item in integrity_items.slice(0, min(4, integrity_items.size())):
			if typeof(item) == TYPE_DICTIONARY:
				lines.append("- %s | %s bytes | %s" % [item.get("relative_path", ""), str(item.get("bytes", 0)), item.get("hash_status", "")])
	lines.append("")
	lines.append("[b]Backup Targets[/b]")
	for target in data.get("targets", []):
		if typeof(target) == TYPE_DICTIONARY:
			lines.append("- %s | exists=%s | sample=%s" % [target.get("name", target.get("id", "target")), str(target.get("exists", false)), str(target.get("sample_count", 0))])
			lines.append("  %s" % target.get("path", ""))
	var plans: Array = data.get("plans", [])
	if not plans.is_empty():
		lines.append("")
		lines.append("[b]Backup Plans[/b]")
		for plan in plans.slice(0, min(5, plans.size())):
			if typeof(plan) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [plan.get("title", ""), plan.get("path", "")])
	room_body.text = "\n".join(lines)

func _render_backup_integrity(data: Dictionary) -> void:
	var source: Dictionary = data.get("source", {})
	var lines := [
		"[b]Backup Integrity Snapshot[/b]",
		"Status: %s | Source: %s | Items: %s / limit %s" % [data.get("status", ""), source.get("name", ""), str(data.get("item_count", 0)), str(data.get("sample_limit", 0))],
		"Bytes hashed: %s | skipped=%s" % [str(data.get("bytes_hashed", 0)), str(data.get("skip_count", 0))],
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Hashed / Sampled Files[/b]"
	]
	for item in data.get("items", []):
		if typeof(item) == TYPE_DICTIONARY:
			var digest := str(item.get("sha256", ""))
			if digest.length() > 16:
				digest = digest.substr(0, 16)
			lines.append("- %s | %s bytes | %s | %s" % [item.get("relative_path", ""), str(item.get("bytes", 0)), item.get("hash_status", ""), digest])
	lines.append("")
	lines.append("[b]Restore Checks[/b]")
	for check in data.get("restore_checks", []):
		lines.append("- %s" % str(check))
	if data.get("items", []).is_empty():
		lines.append("- No files sampled, or source is missing.")
	room_body.text = "\n".join(lines)

func _render_backup_plan_created(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var source: Dictionary = data.get("source", {})
	var target: Dictionary = data.get("target", {})
	var lines := [
		"[b]Backup Plan Draft Created[/b]",
		"Safety: %s" % data.get("safety", ""),
		"Source: %s | %s" % [source.get("name", ""), source.get("path", "")],
		"Target: %s | %s" % [target.get("name", ""), target.get("path", "")],
		"Draft: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Backup plan draft saved[/b]\n%s" % data.get("draft_path", "")

func _render_goal_tower(data: Dictionary) -> void:
	var lines := [
		"[b]Long-Term Goal Tower[/b]",
		"Mode: %s" % data.get("mode", "read-only-goal-map-plus-drafts"),
		"Open PLAN tasks: %s | Done: %s | Goal drafts: %s" % [str(data.get("open_plan_task_count", 0)), str(data.get("done_plan_task_count", 0)), str(data.get("draft_count", 0))],
		"Portfolio projects: %s | Research boards: %s | Local tasks: %s" % [str(data.get("portfolio_project_count", 0)), str(data.get("research_project_count", 0)), str(data.get("local_task_count", 0))],
		"Task status: %s" % JSON.stringify(data.get("task_status_counts", {})),
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Open PLAN Tasks[/b]"
	]
	for task in data.get("open_plan_tasks", []):
		if typeof(task) == TYPE_DICTIONARY:
			lines.append("- %s" % task.get("title", "task"))
	lines.append("")
	lines.append("[b]Goal Signals[/b]")
	for goal_signal in data.get("signals", []):
		if typeof(goal_signal) == TYPE_DICTIONARY:
			lines.append("- %s | exists=%s" % [goal_signal.get("title", "signal"), str(goal_signal.get("exists", false))])
			lines.append("  %s" % goal_signal.get("path", ""))
	var drafts: Array = data.get("drafts", [])
	if not drafts.is_empty():
		lines.append("")
		lines.append("[b]Goal Drafts[/b]")
		for draft in drafts.slice(0, min(5, drafts.size())):
			if typeof(draft) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [draft.get("title", ""), draft.get("path", "")])
	room_body.text = "\n".join(lines)

func _render_goal_draft_created(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Goal Draft Created[/b]",
		"Horizon: %s | Safety: %s" % [data.get("horizon", ""), data.get("safety", "")],
		"Draft: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Goal draft saved[/b]\n%s" % data.get("draft_path", "")

func _render_inspiration_station(data: Dictionary) -> void:
	var lines := [
		"[b]Inspiration Collection Station[/b]",
		"Mode: %s" % data.get("mode", "read-only-idea-inbox-plus-notes"),
		"Signals: %s | Nearby drafts: %s | Notes: %s" % [str(data.get("signal_count", 0)), str(data.get("nearby_draft_count", 0)), str(data.get("note_count", 0))],
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Idea Signals[/b]"
	]
	for idea_signal in data.get("signals", []):
		if typeof(idea_signal) == TYPE_DICTIONARY:
			lines.append("- %s | exists=%s" % [idea_signal.get("title", "signal"), str(idea_signal.get("exists", false))])
			var preview := str(idea_signal.get("preview", ""))
			if preview != "":
				lines.append("  %s" % preview.substr(0, 180))
	var drafts: Array = data.get("nearby_drafts", [])
	if not drafts.is_empty():
		lines.append("")
		lines.append("[b]Nearby Drafts[/b]")
		for draft in drafts.slice(0, min(5, drafts.size())):
			if typeof(draft) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [draft.get("title", ""), draft.get("path", "")])
	var notes: Array = data.get("notes", [])
	if not notes.is_empty():
		lines.append("")
		lines.append("[b]Inspiration Notes[/b]")
		for note in notes.slice(0, min(5, notes.size())):
			if typeof(note) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [note.get("title", ""), note.get("path", "")])
	room_body.text = "\n".join(lines)

func _render_inspiration_note_created(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Inspiration Note Created[/b]",
		"Tag: %s | Safety: %s" % [data.get("tag", ""), data.get("safety", "")],
		"Note: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Inspiration note saved[/b]\n%s" % data.get("draft_path", "")

func _render_temporary_draft_box(data: Dictionary) -> void:
	var lines := [
		"[b]Temporary Draft Box[/b]",
		"Mode: %s" % data.get("mode", "project-local-draft-inbox"),
		"Shelves: %s | Known drafts: %s | Temporary: %s" % [str(data.get("shelf_count", 0)), str(data.get("total_known_drafts", 0)), str(data.get("temp_draft_count", 0))],
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Draft Shelves[/b]"
	]
	for shelf in data.get("shelves", []):
		if typeof(shelf) == TYPE_DICTIONARY:
			lines.append("- %s | %s | count=%s | exists=%s" % [shelf.get("id", "shelf"), shelf.get("kind", "draft"), str(shelf.get("count", 0)), str(shelf.get("exists", false))])
	var temp_drafts: Array = data.get("temp_drafts", [])
	if not temp_drafts.is_empty():
		lines.append("")
		lines.append("[b]Temporary Drafts[/b]")
		for draft in temp_drafts.slice(0, min(6, temp_drafts.size())):
			if typeof(draft) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [draft.get("title", ""), draft.get("path", "")])
	room_body.text = "\n".join(lines)

func _render_temp_draft_created(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Temporary Draft Created[/b]",
		"Route hint: %s | Safety: %s" % [data.get("route_hint", ""), data.get("safety", "")],
		"Draft: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Temporary draft saved[/b]\n%s" % data.get("draft_path", "")

func _render_project_job(job: Dictionary) -> void:
	var status := str(job.get("status", "unknown"))
	if status == "done" and typeof(job.get("result", null)) == TYPE_DICTIONARY:
		selected_project_job_id = ""
		_render_code_project_detail(job.get("result", {}))
		return
	if status == "failed" or status == "missing":
		selected_project_job_id = ""
	var lines := [
		"[b]Project Inspection Job[/b]",
		"Job: %s" % job.get("id", selected_project_job_id),
		"Status: %s | Safety: %s" % [status, job.get("safety", "read-only")],
		"Label: %s" % job.get("label", ""),
		"Error: %s" % job.get("error", "")
	]
	room_body.text = "\n".join(lines)

func _render_project_verification_preview(data: Dictionary) -> void:
	pending_project_verification_confirmation = true
	room_code_verify_button.text = "Confirm Check"
	var command: Dictionary = data.get("command", {})
	var lines := [
		"[b]Project Verification Preview[/b]",
		"Project: %s" % data.get("project_name", ""),
		"Path: %s" % data.get("project_path", ""),
		"Command: %s | %s" % [command.get("label", ""), command.get("command", "")],
		"Safety: %s" % data.get("safety", ""),
		"Confirmation required: %s" % data.get("confirmation_required", ""),
		"Log dir: %s" % data.get("log_dir", ""),
		"",
		"[b]Available Commands[/b]"
	]
	for item in data.get("commands", []):
		if typeof(item) == TYPE_DICTIONARY:
			lines.append("- %s: %s" % [item.get("label", ""), item.get("command", "")])
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Project check needs confirmation[/b]\nPress Confirm Check to run `%s`." % command.get("label", "")

func _render_project_verification_job(job: Dictionary) -> void:
	var status := str(job.get("status", "unknown"))
	if status == "done" or status == "failed" or status == "missing":
		selected_project_job_id = ""
		room_code_check_job_button.disabled = true
	var result: Dictionary = job.get("result", {})
	var lines := [
		"[b]Project Verification Job[/b]",
		"Job: %s | %s" % [job.get("id", selected_project_job_id), status],
		"Safety: %s" % job.get("safety", ""),
		"Label: %s" % job.get("label", ""),
		"Error: %s" % job.get("error", "")
	]
	if typeof(result) == TYPE_DICTIONARY and not result.is_empty():
		var command: Dictionary = result.get("command", {})
		lines.append("")
		lines.append("[b]Result[/b]")
		lines.append("Status: %s | return=%s | duration=%ss" % [result.get("status", ""), str(result.get("returncode", "")), str(result.get("duration_seconds", ""))])
		lines.append("Project: %s" % result.get("project_name", ""))
		lines.append("Command: %s | %s" % [command.get("label", ""), command.get("command", "")])
		lines.append("Log: %s" % result.get("log_path", ""))
		var stdout := str(result.get("stdout", ""))
		var stderr := str(result.get("stderr", ""))
		if stdout != "":
			lines.append("")
			lines.append("[b]Stdout[/b]")
			lines.append(stdout.substr(0, 1200))
		if stderr != "":
			lines.append("")
			lines.append("[b]Stderr[/b]")
			lines.append(stderr.substr(0, 1200))
	room_body.text = "\n".join(lines)
	if typeof(result) == TYPE_DICTIONARY and result.has("status"):
		quest_body.text = "[b]Project verification[/b]\n%s | %s" % [result.get("project_name", ""), result.get("status", "")]
		_record_activity("Project verification", "%s | %s" % [result.get("project_name", ""), result.get("status", "")], "code")

func _render_code_task_draft(data: Dictionary) -> void:
	var task: Dictionary = data.get("task", {})
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Code Task Draft Created[/b]",
		"Task: %s" % task.get("title", ""),
		"Agent: %s | Status: %s | Safety: %s" % [task.get("target_agent", ""), task.get("status", ""), task.get("safety", "")],
		"Project: %s" % task.get("project_name", ""),
		"Priority: %s | Dirty files: %s | Candidate files: %s" % [task.get("priority", ""), str(task.get("dirty_count", 0)), str(task.get("candidate_file_count", 0))],
		"Suggested commands: %s" % str(task.get("verification_commands", []).size()),
		"Draft: %s" % data.get("draft_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Local task recorded:[/b] %s\nStatus: %s\nProject: %s" % [task.get("title", ""), task.get("status", ""), task.get("project_name", "")]
	_record_npc_chain_action("code_task", "code-workshop")

func _render_code_context_pack(data: Dictionary) -> void:
	var pack: Dictionary = data.get("context_pack", {})
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Code Context Pack Created[/b]",
		"Project: %s" % pack.get("project_name", ""),
		"Focus: %s | Safety: %s" % [pack.get("focus", ""), data.get("safety", "")],
		"Files sampled: %s | Suggested commands: %s" % [str(pack.get("file_count", 0)), str(pack.get("commands", []).size())],
		"Context pack: %s" % data.get("context_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Code context saved[/b]\n%s\nProject: %s" % [data.get("context_path", ""), pack.get("project_name", "")]

func _render_code_patch_plan(data: Dictionary) -> void:
	var plan: Dictionary = data.get("patch_plan", {})
	var task: Dictionary = data.get("task", {})
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Code Patch Plan Created[/b]",
		"Project: %s" % plan.get("project_name", ""),
		"Agent: %s | Scope: %s | Safety: %s" % [plan.get("target_agent", ""), plan.get("scope_hint", ""), data.get("safety", "")],
		"Candidate files: %s | Suggested commands: %s | Dirty files: %s" % [str(plan.get("candidate_file_count", 0)), str(plan.get("command_count", 0)), str(plan.get("dirty_count", 0))],
		"Patch plan: %s" % data.get("patch_plan_path", ""),
		"Task: %s | %s" % [task.get("id", ""), task.get("status", "")],
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Code patch plan saved[/b]\n%s\nProject: %s" % [data.get("patch_plan_path", ""), plan.get("project_name", "")]
	_record_npc_chain_action("patch_plan", "code-workshop")

func _render_code_project_index(data: Dictionary) -> void:
	selected_project_id = ""
	selected_project_job_id = ""
	pending_project_verification_confirmation = false
	room_code_verify_button.text = "Run Check"
	var lines := [
		"[b]Local Code Projects[/b]",
		"Sampled Git repos: %s | mode=%s" % [str(data.get("count", 0)), data.get("mode", "read-only")],
		""
	]
	for project in data.get("projects", []):
		if typeof(project) != TYPE_DICTIONARY:
			continue
		var project_id := str(project.get("id", ""))
		if selected_project_id == "" and project_id != "":
			selected_project_id = project_id
		lines.append("[color=#4a3a2a]%s[/color] (%s)" % [project.get("name", "repo"), project_id])
		lines.append("  %s | branch: %s | dirty=%s" % [project.get("family", ""), project.get("branch", ""), str(project.get("dirty_count", 0))])
		lines.append("  %s" % project.get("path", ""))
	room_body.text = "\n".join(lines)
	room_local_project_detail_button.disabled = selected_project_id == ""
	room_code_task_button.disabled = selected_project_id == ""
	room_code_context_button.disabled = selected_project_id == ""
	room_code_patch_plan_button.disabled = selected_project_id == ""
	room_code_agent_button.disabled = selected_project_id == ""
	room_code_explain_button.disabled = selected_project_id == ""
	room_code_verify_button.disabled = selected_project_id == ""
	room_code_check_job_button.disabled = selected_project_job_id == ""
	if selected_project_id != "":
		detail_body.text = "[b]Code console[/b]\nSelected first repo: %s. Use Repo Detail for Git/README, Explain Code for onboarding, Context Pack for a local brief, Patch Plan for a safe implementation handoff, Run Check for confirm-required verification, or Code Agent for read-only development analysis." % selected_project_id
	_record_npc_chain_action("code_projects", "code-workshop")

func _render_code_project_detail(project: Dictionary) -> void:
	pending_project_verification_confirmation = false
	room_code_verify_button.text = "Run Check"
	var git: Dictionary = project.get("git", {})
	var lines := [
		"[b]%s[/b]" % project.get("name", project.get("id", "Repository")),
		"Path: %s" % project.get("path", ""),
		"Family: %s | Branch: %s | Dirty files: %s" % [project.get("family", ""), git.get("branch", ""), str(git.get("dirty_count", 0))],
		"",
		"[b]Recent Commits[/b]"
	]
	for commit in project.get("recent_commits", []):
		lines.append("- %s" % str(commit))
	lines.append("")
	lines.append("[b]Important Files[/b]")
	for item in project.get("important_files", []):
		if typeof(item) == TYPE_DICTIONARY:
			lines.append("- %s | %s" % [item.get("name", ""), item.get("path", "")])
	lines.append("")
	lines.append("[b]Git Status[/b]")
	lines.append(str(git.get("status_text", "")))
	if str(project.get("readme_preview", "")) != "":
		lines.append("")
		lines.append("[b]README Preview[/b]")
		lines.append(str(project.get("readme_preview", "")))
	if str(project.get("todo_preview", "")) != "":
		lines.append("")
		lines.append("[b]TODO/Plan Preview[/b]")
		lines.append(str(project.get("todo_preview", "")))
	room_body.text = "\n".join(lines)
	room_local_project_detail_button.disabled = selected_project_id == ""
	room_code_task_button.disabled = selected_project_id == ""
	room_code_context_button.disabled = selected_project_id == ""
	room_code_patch_plan_button.disabled = selected_project_id == ""
	room_code_agent_button.disabled = selected_project_id == ""
	room_code_explain_button.disabled = selected_project_id == ""
	room_code_verify_button.disabled = selected_project_id == ""
	room_code_check_job_button.disabled = selected_project_job_id == ""

func _render_agent_roster(data: Dictionary) -> void:
	selected_agent_roster_id = ""
	var lines := [
		"[b]Real Agent Roster[/b]",
		"Launchers: %s/%s | companions=%s | dispatch=%s" % [str(data.get("launcher_count", 0)), str(data.get("agent_count", 0)), str(data.get("companion_count", 0)), data.get("dispatch_mode", "draft-only")],
		"%s" % data.get("safe_note", ""),
		""
	]
	for agent in data.get("roster", []):
		if typeof(agent) != TYPE_DICTIONARY:
			continue
		var agent_id := str(agent.get("id", ""))
		if selected_agent_roster_id == "" and agent_id != "":
			selected_agent_roster_id = agent_id
		lines.append("[color=#4a3a2a]%s[/color] (%s)" % [agent.get("name", agent.get("id", "agent")), agent.get("id", "")])
		lines.append("  %s | zone: %s" % [agent.get("role", ""), agent.get("zone", "")])
		lines.append("  launcher_exists=%s | %s" % [str(agent.get("launcher_exists", false)), agent.get("launcher", "")])
	var companions: Array = data.get("companions", [])
	if not companions.is_empty():
		lines.append("")
		lines.append("[b]Recruitable Companions[/b]")
		for companion in companions:
			if typeof(companion) == TYPE_DICTIONARY:
				var owned := companion_roster.has(str(companion.get("id", "")))
				lines.append("- %s | %s | tools=%s | owned=%s" % [companion.get("display_name", companion.get("name", "")), companion.get("agent_kind", ""), ",".join(companion.get("tool_hints", [])), str(owned)])
	if data.has("task_queue"):
		var queue: Dictionary = data.get("task_queue", {})
		lines.append("")
		lines.append("[b]Safe Local Task Queue[/b]")
		lines.append("%s tasks | %s" % [str(queue.get("count", 0)), JSON.stringify(queue.get("counts", {}))])
	if data.has("tool_queue"):
		var tool_queue: Dictionary = data.get("tool_queue", {})
		var tool_catalog: Array = tool_queue.get("catalog", [])
		lines.append("")
		lines.append("[b]Safe Agent Tool Queue[/b]")
		lines.append("%s invocations | tools=%s | %s" % [str(tool_queue.get("count", 0)), str(tool_catalog.size()), JSON.stringify(tool_queue.get("counts", {}))])
	if data.has("chat_sessions"):
		lines.append("")
		lines.append("[b]Agent Chat Sessions[/b]")
		lines.append("%s local chat log(s) | %s" % [str(data.get("chat_count", 0)), data.get("chat_dir", "")])
	if data.has("runner_readiness"):
		var readiness: Dictionary = data.get("runner_readiness", {})
		lines.append("")
		lines.append("[b]Runner Readiness[/b]")
		lines.append("%s/%s ready | handoff=%s" % [str(readiness.get("ready_count", data.get("runner_ready_count", 0))), str(readiness.get("runner_count", data.get("agent_count", 0))), data.get("runner_handoff_dir", "")])
		lines.append("Use Runner Ready for full preflight, then Runner Plan to write a confirm-required handoff.")
	room_body.text = "\n".join(lines)
	room_agent_companion_button.disabled = selected_agent_roster_id == ""
	_update_badge_case()
	_record_npc_chain_action("agent_roster", "agent-hub")

func _render_agent_runner_readiness(data: Dictionary) -> void:
	selected_agent_roster_id = ""
	var lines := [
		"[b]Agent Runner Readiness[/b]",
		"Mode: %s" % data.get("mode", "read-only-agent-runner-readiness"),
		"Ready: %s/%s | devtools=%s" % [str(data.get("ready_count", 0)), str(data.get("runner_count", 0)), str(data.get("devtools_exists", false))],
		"Handoff dir: %s" % data.get("handoff_dir", ""),
		"%s" % data.get("safe_note", ""),
		""
	]
	for runner in data.get("runners", []):
		if typeof(runner) != TYPE_DICTIONARY:
			continue
		var runner_id := str(runner.get("id", ""))
		if selected_agent_roster_id == "" and runner_id != "":
			selected_agent_roster_id = runner_id
		lines.append("[color=#4a3a2a]%s[/color] (%s)" % [runner.get("name", runner_id), runner_id])
		lines.append("  ready=%s | %s | gate=%s" % [str(runner.get("runner_ready", false)), runner.get("readiness", ""), runner.get("permission_gate", "")])
		lines.append("  launcher=%s" % runner.get("launcher", ""))
		var blockers: Array = runner.get("blockers", [])
		if not blockers.is_empty():
			lines.append("  blockers: %s" % JSON.stringify(blockers))
		var digest := str(runner.get("launcher_sha256", ""))
		if digest != "":
			lines.append("  sha256=%s" % digest.substr(0, 16))
	room_body.text = "\n".join(lines)
	room_agent_companion_button.disabled = selected_agent_roster_id == ""

func _render_agent_runner_dispatch_preview(data: Dictionary) -> void:
	selected_agent_roster_id = str(data.get("target_agent", selected_agent_roster_id))
	selected_agent_runner_handoff_path = str(data.get("handoff_path", ""))
	room_agent_runner_launch_button.disabled = selected_agent_runner_handoff_path == ""
	var lines := [
		"[b]Runner Dispatch Preview[/b]",
		"Target: %s | ready=%s | %s" % [data.get("target_agent", ""), str(data.get("runner_ready", false)), data.get("readiness", "")],
		"Safety: %s" % data.get("mode", ""),
		"Handoff: %s" % data.get("handoff_path", ""),
		"JSON: %s" % data.get("json_path", ""),
		"Command preview: %s" % data.get("command_preview", ""),
		"%s" % data.get("safe_note", ""),
		""
	]
	var blockers: Array = data.get("blockers", [])
	if not blockers.is_empty():
		lines.append("[b]Blockers[/b]")
		for blocker in blockers:
			lines.append("- %s" % str(blocker))
		lines.append("")
	lines.append("[b]Preview[/b]")
	lines.append(str(data.get("preview", "")).substr(0, 1800))
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Runner dispatch preview[/b]\n%s\nNo runner launched." % data.get("handoff_path", "")

func _render_agent_runner_launch_gate(data: Dictionary) -> void:
	var command: Dictionary = data.get("command", {})
	var lines := [
		"[b]Runner Launch Gate[/b]",
		"Status: %s | mode: %s" % [data.get("status", ""), data.get("mode", "")],
		"Confirmation required: %s" % data.get("confirmation_required", ""),
		"Ready: %s | %s" % [str(data.get("runner_ready", false)), data.get("readiness", "")],
		"Launcher: %s" % command.get("launcher", ""),
		"Handoff: %s" % command.get("handoff_path", ""),
		"Args: %s" % JSON.stringify(command.get("argv", [])),
		"%s" % data.get("safe_note", ""),
		""
	]
	var blockers: Array = data.get("blockers", [])
	if not blockers.is_empty():
		lines.append("[b]Blockers[/b]")
		for blocker in blockers:
			lines.append("- %s" % str(blocker))
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Runner launch gate[/b]\n%s\nNo runner launched." % data.get("confirmation_required", "")

func _render_agent_chat_sessions(data: Dictionary) -> void:
	var lines := [
		"[b]Agent Chat Sessions[/b]",
		"Sessions: %s | %s" % [str(data.get("count", 0)), data.get("chat_dir", "")],
		"%s" % data.get("safe_note", ""),
		""
	]
	for session in data.get("sessions", []):
		if typeof(session) == TYPE_DICTIONARY:
			lines.append("- %s | %s | messages=%s" % [session.get("title", session.get("id", "")), session.get("agent_name", ""), str(session.get("message_count", 0))])
			lines.append("  %s" % session.get("path", ""))
	room_body.text = "\n".join(lines)

func _render_agent_chat_session(data: Dictionary) -> void:
	var summary: Dictionary = data.get("chat_session", {})
	var session: Dictionary = data.get("session", {})
	current_agent_chat_id = str(summary.get("id", ""))
	room_agent_chat_send_button.disabled = current_agent_chat_id == ""
	last_agent_chat_tool_suggestions = []
	var lines := [
		"[b]Agent Chat[/b]",
		"Session: %s | Agent: %s" % [summary.get("title", ""), summary.get("agent_name", summary.get("agent_id", ""))],
		"Messages: %s | Safety: %s" % [str(summary.get("message_count", 0)), data.get("safety", session.get("safety", ""))],
		"Path: %s" % summary.get("path", session.get("path", "")),
		""
	]
	var messages: Array = session.get("messages", [])
	for message in messages.slice(max(0, messages.size() - 8), messages.size()):
		if typeof(message) == TYPE_DICTIONARY:
			lines.append("[color=#4a3a2a]%s[/color]: %s" % [message.get("role", ""), str(message.get("content", ""))])
			var suggestions: Array = message.get("tool_suggestions", [])
			if not suggestions.is_empty():
				last_agent_chat_tool_suggestions = suggestions
				lines.append("  tools: %s" % JSON.stringify(suggestions))
	var assistant_message: Dictionary = data.get("message", {})
	if not assistant_message.is_empty():
		var assistant_suggestions: Array = assistant_message.get("tool_suggestions", [])
		if not assistant_suggestions.is_empty():
			last_agent_chat_tool_suggestions = assistant_suggestions
		quest_body.text = "[b]Agent chat updated[/b]\n%s" % str(assistant_message.get("content", "")).substr(0, 500)
	room_agent_chat_tool_button.disabled = last_agent_chat_tool_suggestions.is_empty()
	if not last_agent_chat_tool_suggestions.is_empty():
		lines.append("")
		lines.append("[b]Suggested tool[/b] %s" % str(last_agent_chat_tool_suggestions[0]))
		lines.append("Use Run Suggested to queue this safe registered tool.")
	room_body.text = "\n".join(lines)

func _render_agent_dispatch_draft(data: Dictionary) -> void:
	var lines := [
		"[b]Dispatch Draft Created[/b]",
		"Target: %s | safety: %s" % [data.get("target_agent", ""), data.get("safety", "")],
		"Path: %s" % data.get("target_path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)

func _render_agent_task_policy(data: Dictionary) -> void:
	var lines := [
		"[b]Agent Task Queue Policy[/b]",
		"Mode: %s" % data.get("mode", "safe-local-agent-task-concurrency-policy"),
		"Max running: %s | running=%s | queued=%s | paused=%s | slots=%s | saturated=%s" % [
			str(data.get("max_running", 0)),
			str(data.get("running_count", 0)),
			str(data.get("queued_count", 0)),
			str(data.get("paused_count", 0)),
			str(data.get("available_slots", 0)),
			str(data.get("saturated", false)),
		],
		"Config: %s | executor=%s" % [data.get("env_var", ""), data.get("executor", "")],
		"%s" % data.get("safe_note", ""),
	]
	var dispatched: Array = data.get("dispatched", [])
	if not dispatched.is_empty():
		lines.append("")
		lines.append("[b]Recently dispatched[/b]")
		for task_id in dispatched:
			lines.append("- %s" % str(task_id))
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Agent task policy[/b]\nmax=%s running=%s queued=%s" % [str(data.get("max_running", 0)), str(data.get("running_count", 0)), str(data.get("queued_count", 0))]

func _render_agent_task_logs(data: Dictionary) -> void:
	var lines := [
		"[b]Agent Task Log Archive[/b]",
		"Mode: %s" % data.get("mode", "read-only-agent-task-log-archive"),
		"Logs: %s | dir=%s" % [str(data.get("count", 0)), data.get("log_dir", "")],
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Recent Durable Logs[/b]"
	]
	var logs: Array = data.get("logs", [])
	if logs.is_empty():
		lines.append("- No durable task logs found yet. Queue Agent to create one.")
	else:
		for log in logs.slice(0, min(12, logs.size())):
			if typeof(log) == TYPE_DICTIONARY:
				lines.append("- %s | %s | %s | %s" % [log.get("log_id", ""), log.get("status", ""), log.get("task_type", ""), log.get("title", "")])
				var summary := str(log.get("result_summary", ""))
				if summary != "":
					lines.append("  %s" % summary.substr(0, 180))
				lines.append("  events=%s | bytes=%s | %s" % [str(log.get("event_count", 0)), str(log.get("bytes", 0)), log.get("log_path", "")])
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Agent task logs[/b]\n%s durable log(s)" % str(data.get("count", 0))

func _render_agent_task_queue(data: Dictionary) -> void:
	agent_task_cards = []
	for task in data.get("tasks", []):
		if typeof(task) == TYPE_DICTIONARY:
			agent_task_cards.append(task)
	var previous_task_id := selected_agent_task_id
	selected_agent_task_id = ""
	selected_agent_task_index = 0
	selected_agent_task_event_cursor = 0
	for i in range(agent_task_cards.size()):
		var task: Dictionary = agent_task_cards[i]
		var task_id := str(task.get("id", ""))
		if task_id != "" and (previous_task_id == "" or task_id == previous_task_id):
			selected_agent_task_id = task_id
			selected_agent_task_index = i
			break
	_render_agent_task_queue_from_cache(data)

func _render_agent_task_queue_from_cache(data: Dictionary = {}) -> void:
	_sync_agent_task_buttons()
	var lines := [
		"[b]Safe Local Agent Task Queue[/b]",
		"Mode: %s" % data.get("mode", "safe-local-agent-task-queue"),
		"Tasks: %s | %s" % [str(data.get("count", agent_task_cards.size())), JSON.stringify(data.get("counts", {}))],
		"Log dir: %s" % data.get("log_dir", ""),
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Task Types[/b]"
	]
	var policy: Dictionary = data.get("policy", {})
	if not policy.is_empty():
		lines.insert(3, "Policy: max=%s running=%s queued=%s slots=%s saturated=%s" % [
			str(policy.get("max_running", 0)),
			str(policy.get("running_count", 0)),
			str(policy.get("queued_count", 0)),
			str(policy.get("available_slots", 0)),
			str(policy.get("saturated", false)),
		])
	for item in data.get("catalog", []):
		if typeof(item) == TYPE_DICTIONARY:
			lines.append("- %s | %s" % [item.get("name", item.get("id", "")), item.get("safety", "")])
	if not agent_task_cards.is_empty():
		lines.append("")
		lines.append("[b]Recent Tasks[/b]")
		for task in agent_task_cards.slice(0, min(10, agent_task_cards.size())):
			if typeof(task) == TYPE_DICTIONARY:
				var task_id := str(task.get("id", ""))
				var marker := " "
				if task_id == selected_agent_task_id:
					marker = "*"
				lines.append("%s %s | %s | %s | %s" % [marker, task.get("title", task.get("id", "")), task.get("status", ""), task.get("task_type", ""), task.get("result_summary", "")])
				var log_path := str(task.get("log_path", ""))
				if log_path != "":
					lines.append("  log: %s" % log_path)
				var rollback_note := str(task.get("rollback_note", ""))
				if rollback_note != "":
					lines.append("  safety: %s" % rollback_note)
	if selected_agent_task_id != "":
		lines.append("")
		lines.append("[b]Selected agent task[/b] %s/%s - %s" % [str(selected_agent_task_index + 1), str(agent_task_cards.size()), selected_agent_task_id])
		lines.append("Use Next Result to choose, Open Result to inspect, or Pause/Resume/Cancel for queued tasks.")
	room_body.text = "\n".join(lines)

func _selected_agent_task_status() -> String:
	if selected_agent_task_id == "":
		return ""
	for task in agent_task_cards:
		if typeof(task) == TYPE_DICTIONARY and str(task.get("id", "")) == selected_agent_task_id:
			return str(task.get("status", ""))
	return ""

func _sync_agent_task_buttons() -> void:
	room_agent_task_next_button.disabled = agent_task_cards.size() <= 1
	room_agent_task_open_button.disabled = selected_agent_task_id == ""
	room_agent_task_events_button.disabled = selected_agent_task_id == ""
	var status := _selected_agent_task_status()
	room_agent_task_pause_button.disabled = selected_agent_task_id == "" or not (status == "queued" or status == "running")
	room_agent_task_cancel_button.disabled = selected_agent_task_id == "" or not (status == "queued" or status == "paused" or status == "running")
	room_agent_task_resume_button.disabled = selected_agent_task_id == "" or status != "paused"

func _render_agent_task_submitted(data: Dictionary) -> void:
	var task: Dictionary = data.get("task", {})
	var queue: Dictionary = data.get("queue", {})
	var parameters: Dictionary = task.get("parameters", {})
	selected_agent_task_id = str(task.get("id", selected_agent_task_id))
	_update_agent_task_cache_from_queue(queue, task)
	_sync_agent_task_buttons()
	var lines := [
		"[b]Agent Task Queued[/b]",
		"Task: %s" % task.get("title", task.get("id", "")),
		"Status: %s | type: %s | target: %s" % [task.get("status", ""), task.get("task_type", ""), task.get("target_agent", "")],
		"Safety: %s" % task.get("safety", ""),
		"Project: %s" % parameters.get("project_id", ""),
		"Local task: %s" % parameters.get("task_id", ""),
		"Queue: %s tasks | %s" % [str(queue.get("count", 0)), JSON.stringify(queue.get("counts", {}))],
		"",
		"Use Agent Tasks to refresh the queue and see the result log."
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Agent task queued[/b]\n%s" % task.get("id", "")

func _update_agent_task_cache_from_queue(queue: Dictionary, fallback_task: Dictionary = {}) -> void:
	if queue.has("tasks"):
		agent_task_cards = []
		for task in queue.get("tasks", []):
			if typeof(task) == TYPE_DICTIONARY:
				agent_task_cards.append(task)
	if selected_agent_task_id == "" and not fallback_task.is_empty():
		selected_agent_task_id = str(fallback_task.get("id", ""))
	for i in range(agent_task_cards.size()):
		var cached_task: Dictionary = agent_task_cards[i]
		if str(cached_task.get("id", "")) == selected_agent_task_id:
			if not fallback_task.is_empty():
				for key in fallback_task.keys():
					cached_task[key] = fallback_task[key]
				agent_task_cards[i] = cached_task
			selected_agent_task_index = i
			break

func _render_agent_task_status_changed(data: Dictionary, action: String) -> void:
	var task: Dictionary = data.get("task", {})
	var queue: Dictionary = data.get("queue", {})
	selected_agent_task_id = str(task.get("id", selected_agent_task_id))
	_update_agent_task_cache_from_queue(queue, task)
	_sync_agent_task_buttons()
	var action_label := "updated"
	if action == "pause":
		action_label = "paused"
	elif action == "resume":
		action_label = "resumed"
	elif action == "cancel":
		action_label = "cancelled"
	var lines := [
		"[b]Agent Task %s[/b]" % action_label.capitalize(),
		"Task: %s" % task.get("title", task.get("id", "")),
		"Status: %s | type: %s | target: %s" % [task.get("status", ""), task.get("task_type", ""), task.get("target_agent", "")],
		"Cancel requested: %s | rollback: %s" % [str(task.get("cancel_requested", false)), task.get("rollback_note", "")],
		"Queue: %s tasks | %s" % [str(queue.get("count", agent_task_cards.size())), JSON.stringify(queue.get("counts", {}))],
		"",
		"Use Open Result to inspect the task timeline and latest result."
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Agent task %s[/b]\n%s" % [action_label, task.get("id", "")]

func _render_agent_task_events(data: Dictionary) -> void:
	var task: Dictionary = data.get("task", {})
	var queue: Dictionary = data.get("queue", {})
	selected_agent_task_id = str(task.get("id", selected_agent_task_id))
	_update_agent_task_cache_from_queue(queue, task)
	_sync_agent_task_buttons()
	var previous_cursor := selected_agent_task_event_cursor
	selected_agent_task_event_cursor = int(data.get("next_cursor", selected_agent_task_event_cursor))
	var lines := [
		"[b]Agent Task Events[/b]",
		"Task: %s" % task.get("title", task.get("id", "")),
		"Status: %s | type: %s | target: %s" % [task.get("status", ""), task.get("task_type", ""), task.get("target_agent", "")],
		"Events: %s total | cursor %s -> %s | more=%s" % [str(data.get("event_count", 0)), str(previous_cursor), str(selected_agent_task_event_cursor), str(data.get("has_more", false))],
		"%s" % data.get("safe_note", ""),
		""
	]
	var events: Array = data.get("events", [])
	if events.is_empty():
		lines.append("No new task events. Use Task Events again to poll later.")
	else:
		for event in events:
			if typeof(event) == TYPE_DICTIONARY:
				lines.append("- #%s %s | %s" % [str(event.get("index", "")), event.get("at", ""), event.get("message", "")])
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Agent task events[/b]\n%s/%s" % [str(selected_agent_task_event_cursor), str(data.get("event_count", 0))]
	_record_npc_chain_action("agent_events", "agent-hub")

func _render_agent_task_detail(data: Dictionary) -> void:
	var task: Dictionary = data.get("task", {})
	var queue: Dictionary = data.get("queue", {})
	selected_agent_task_id = str(task.get("id", selected_agent_task_id))
	var found_cached_task := false
	for i in range(agent_task_cards.size()):
		var cached_task: Dictionary = agent_task_cards[i]
		if str(cached_task.get("id", "")) == selected_agent_task_id:
			agent_task_cards[i] = task
			selected_agent_task_index = i
			found_cached_task = true
			break
	if not found_cached_task and selected_agent_task_id != "":
		agent_task_cards.append(task)
		selected_agent_task_index = agent_task_cards.size() - 1
	_sync_agent_task_buttons()
	var parameters: Dictionary = task.get("parameters", {})
	var raw_result = task.get("result", {})
	var result := {}
	if typeof(raw_result) == TYPE_DICTIONARY:
		result = raw_result
	var lines := [
		"[b]Agent Task Result[/b]",
		"Task: %s" % task.get("title", task.get("id", "")),
		"Status: %s | type: %s | target: %s" % [task.get("status", ""), task.get("task_type", ""), task.get("target_agent", "")],
		"Safety: %s" % task.get("safety", ""),
		"Summary: %s" % task.get("result_summary", ""),
		"Log: %s" % task.get("log_path", ""),
		"Cancel requested: %s | rollback: %s" % [str(task.get("cancel_requested", false)), task.get("rollback_note", "")],
		"Queue: %s tasks | %s" % [str(queue.get("count", agent_task_cards.size())), JSON.stringify(queue.get("counts", {}))],
		"Parameters: %s" % JSON.stringify(parameters),
		"",
		"[b]Result[/b]",
		"Kind: %s" % result.get("kind", ""),
		"Summary: %s" % result.get("summary", "")
	]
	var concepts: Array = result.get("concepts", [])
	if not concepts.is_empty():
		lines.append("")
		lines.append("[b]Concepts[/b]")
		for concept in concepts.slice(0, min(8, concepts.size())):
			lines.append("- %s" % str(concept))
	var entry_points: Array = result.get("entry_points", [])
	if not entry_points.is_empty():
		lines.append("")
		lines.append("[b]Entry Points[/b]")
		for entry in entry_points.slice(0, min(8, entry_points.size())):
			if typeof(entry) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [entry.get("name", ""), entry.get("path", "")])
	var key_files: Array = result.get("key_files", [])
	if not key_files.is_empty():
		lines.append("")
		lines.append("[b]Key Files[/b]")
		for item in key_files.slice(0, min(6, key_files.size())):
			if typeof(item) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [item.get("name", ""), item.get("relative_path", "")])
				var preview := str(item.get("preview", ""))
				if preview != "":
					lines.append("  %s" % preview.substr(0, 160))
	var risks: Array = result.get("risks", [])
	if not risks.is_empty():
		lines.append("")
		lines.append("[b]Risks[/b]")
		for risk in risks.slice(0, min(8, risks.size())):
			lines.append("- %s" % str(risk))
	var next_steps: Array = result.get("recommended_next_steps", [])
	if not next_steps.is_empty():
		lines.append("")
		lines.append("[b]Recommended Next Steps[/b]")
		for step in next_steps.slice(0, min(8, next_steps.size())):
			lines.append("- %s" % str(step))
	var events: Array = task.get("events", [])
	if not events.is_empty():
		lines.append("")
		lines.append("[b]Task Timeline[/b]")
		for event in events.slice(max(0, events.size() - 8), events.size()):
			if typeof(event) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [event.get("at", ""), event.get("message", "")])
	var file_previews: Array = result.get("file_previews", [])
	if not file_previews.is_empty():
		lines.append("")
		lines.append("[b]File Previews[/b]")
		for preview in file_previews.slice(0, min(8, file_previews.size())):
			if typeof(preview) == TYPE_DICTIONARY:
				lines.append("- %s" % preview.get("path", ""))
	var preview_text := str(result.get("preview", ""))
	if preview_text != "":
		lines.append("")
		lines.append("[b]Preview[/b]")
		lines.append(preview_text.substr(0, 1200))
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Agent task result[/b]\n%s\n%s" % [task.get("title", ""), task.get("status", "")]

func _render_agent_tool_catalog(data: Dictionary) -> void:
	var queue: Dictionary = data.get("queue", {})
	_cache_agent_tool_invocations(queue.get("recent", []))
	var lines := [
		"[b]Safe Agent Tool Catalog[/b]",
		"Tools: %s | invocations=%s" % [str(data.get("count", 0)), str(queue.get("count", 0))],
		"Mode: %s" % data.get("mode", "safe-agent-tool-registry"),
		"",
		"[b]Registered Tools[/b]"
	]
	for tool in data.get("tools", []):
		if typeof(tool) == TYPE_DICTIONARY:
			lines.append("- %s (%s) | %s" % [tool.get("name", tool.get("id", "tool")), tool.get("id", ""), tool.get("safety", "")])
			lines.append("  %s" % tool.get("description", ""))
	var recent: Array = queue.get("recent", [])
	if not recent.is_empty():
		lines.append("")
		lines.append("[b]Recent Invocations[/b]")
		for item in recent.slice(0, min(5, recent.size())):
			if typeof(item) == TYPE_DICTIONARY:
				var invocation_id := str(item.get("id", ""))
				var marker := " "
				if invocation_id == selected_agent_tool_invocation_id:
					marker = "*"
				lines.append("%s %s | %s | %s" % [marker, item.get("tool_id", ""), item.get("status", ""), item.get("result_summary", "")])
	if selected_agent_tool_invocation_id != "":
		lines.append("")
		lines.append("[b]Selected tool invocation[/b] %s/%s - %s" % [str(selected_agent_tool_invocation_index + 1), str(agent_tool_invocation_cards.size()), selected_agent_tool_invocation_id])
		lines.append("Use Next Tool to choose, then Open Tool to inspect the full result.")
	room_body.text = "\n".join(lines)

func _render_agent_tool_invoked(data: Dictionary) -> void:
	var invocation: Dictionary = data.get("invocation", {})
	var queue: Dictionary = data.get("queue", {})
	selected_agent_tool_invocation_id = str(invocation.get("id", selected_agent_tool_invocation_id))
	_cache_agent_tool_invocations(queue.get("recent", []), invocation)
	_sync_agent_tool_buttons()
	var lines := [
		"[b]Agent Tool Invocation Queued[/b]",
		"Tool: %s | target: %s" % [invocation.get("tool_id", ""), invocation.get("target_agent", "")],
		"Status: %s | safety: %s" % [invocation.get("status", ""), invocation.get("safety", "")],
		"Queue: %s invocations | %s" % [str(queue.get("count", 0)), JSON.stringify(queue.get("counts", {}))],
		"",
		"Use Tool Catalog after a moment to inspect recent results and logs."
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Agent tool queued[/b]\n%s" % invocation.get("id", "")

func _render_agent_tool_invocations(data: Dictionary) -> void:
	_cache_agent_tool_invocations(data.get("recent", []))
	_render_agent_tool_invocations_from_cache(data)

func _render_agent_tool_invocations_from_cache(data: Dictionary = {}) -> void:
	_sync_agent_tool_buttons()
	var lines := [
		"[b]Agent Tool Invocations[/b]",
		"Count: %s | %s" % [str(data.get("count", agent_tool_invocation_cards.size())), JSON.stringify(data.get("counts", {}))],
		"Log dir: %s" % data.get("log_dir", ""),
		"%s" % data.get("safe_note", ""),
		""
	]
	for item in agent_tool_invocation_cards.slice(0, min(10, agent_tool_invocation_cards.size())):
		if typeof(item) == TYPE_DICTIONARY:
			var invocation_id := str(item.get("id", ""))
			var marker := " "
			if invocation_id == selected_agent_tool_invocation_id:
				marker = "*"
			lines.append("%s %s | %s | %s" % [marker, item.get("tool_id", ""), item.get("status", ""), item.get("result_summary", "")])
			if str(item.get("log_path", "")) != "":
				lines.append("  log: %s" % item.get("log_path", ""))
	if selected_agent_tool_invocation_id != "":
		lines.append("")
		lines.append("[b]Selected tool invocation[/b] %s/%s - %s" % [str(selected_agent_tool_invocation_index + 1), str(agent_tool_invocation_cards.size()), selected_agent_tool_invocation_id])
		lines.append("Use Next Tool to choose, then Open Tool to inspect the full result.")
	room_body.text = "\n".join(lines)

func _render_agent_tool_logs(data: Dictionary) -> void:
	var lines := [
		"[b]Agent Tool Log Archive[/b]",
		"Mode: %s" % data.get("mode", "read-only-agent-tool-log-archive"),
		"Logs: %s | dir=%s" % [str(data.get("count", 0)), data.get("log_dir", "")],
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Recent Durable Tool Logs[/b]"
	]
	var logs: Array = data.get("logs", [])
	if logs.is_empty():
		lines.append("- No durable tool logs found yet. Run Tool to create one.")
	else:
		for log in logs.slice(0, min(12, logs.size())):
			if typeof(log) == TYPE_DICTIONARY:
				lines.append("- %s | %s | %s | %s" % [log.get("log_id", ""), log.get("status", ""), log.get("tool_id", ""), log.get("tool_name", "")])
				var summary := str(log.get("result_summary", ""))
				if summary != "":
					lines.append("  %s" % summary.substr(0, 180))
				lines.append("  events=%s | bytes=%s | %s" % [str(log.get("event_count", 0)), str(log.get("bytes", 0)), log.get("log_path", "")])
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Agent tool logs[/b]\n%s durable log(s)" % str(data.get("count", 0))

func _cache_agent_tool_invocations(items: Array, fallback_invocation: Dictionary = {}) -> void:
	var previous_id := selected_agent_tool_invocation_id
	agent_tool_invocation_cards = []
	for item in items:
		if typeof(item) == TYPE_DICTIONARY:
			agent_tool_invocation_cards.append(item)
	if not fallback_invocation.is_empty():
		var fallback_id := str(fallback_invocation.get("id", ""))
		var found := false
		for i in range(agent_tool_invocation_cards.size()):
			var cached: Dictionary = agent_tool_invocation_cards[i]
			if str(cached.get("id", "")) == fallback_id:
				for key in fallback_invocation.keys():
					cached[key] = fallback_invocation[key]
				agent_tool_invocation_cards[i] = cached
				found = true
				break
		if not found:
			agent_tool_invocation_cards.push_front(fallback_invocation)
	selected_agent_tool_invocation_id = ""
	selected_agent_tool_invocation_index = 0
	selected_agent_tool_event_cursor = 0
	for i in range(agent_tool_invocation_cards.size()):
		var invocation: Dictionary = agent_tool_invocation_cards[i]
		var invocation_id := str(invocation.get("id", ""))
		if invocation_id != "" and (previous_id == "" or invocation_id == previous_id):
			selected_agent_tool_invocation_id = invocation_id
			selected_agent_tool_invocation_index = i
			break
	_sync_agent_tool_buttons()

func _sync_agent_tool_buttons() -> void:
	room_agent_tool_next_button.disabled = agent_tool_invocation_cards.size() <= 1
	room_agent_tool_open_button.disabled = selected_agent_tool_invocation_id == ""
	room_agent_tool_events_button.disabled = selected_agent_tool_invocation_id == ""

func _render_agent_tool_invocation_detail(data: Dictionary) -> void:
	var invocation: Dictionary = data.get("invocation", {})
	var queue: Dictionary = data.get("queue", {})
	selected_agent_tool_invocation_id = str(invocation.get("id", selected_agent_tool_invocation_id))
	_cache_agent_tool_invocations(queue.get("recent", []), invocation)
	_sync_agent_tool_buttons()
	var result = invocation.get("result", {})
	var lines := [
		"[b]Agent Tool Result[/b]",
		"Tool: %s (%s)" % [invocation.get("tool_name", ""), invocation.get("tool_id", "")],
		"Status: %s | target: %s | safety: %s" % [invocation.get("status", ""), invocation.get("target_agent", ""), invocation.get("safety", "")],
		"Summary: %s" % invocation.get("result_summary", ""),
		"Log: %s" % invocation.get("log_path", ""),
		"Parameters: %s" % JSON.stringify(invocation.get("parameters", {})),
		"Queue: %s invocations | %s" % [str(queue.get("count", agent_tool_invocation_cards.size())), JSON.stringify(queue.get("counts", {}))]
	]
	var events: Array = invocation.get("events", [])
	if not events.is_empty():
		lines.append("")
		lines.append("[b]Tool Timeline[/b]")
		for event in events.slice(max(0, events.size() - 8), events.size()):
			if typeof(event) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [event.get("at", ""), event.get("message", "")])
	lines.append("")
	lines.append("[b]Result Preview[/b]")
	if typeof(result) == TYPE_DICTIONARY:
		lines.append(JSON.stringify(result).substr(0, 1600))
	else:
		lines.append(str(result).substr(0, 1600))
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Agent tool result[/b]\n%s\n%s" % [invocation.get("tool_id", ""), invocation.get("status", "")]

func _render_agent_tool_events(data: Dictionary) -> void:
	var invocation: Dictionary = data.get("invocation", {})
	var queue: Dictionary = data.get("queue", {})
	selected_agent_tool_invocation_id = str(invocation.get("id", selected_agent_tool_invocation_id))
	_cache_agent_tool_invocations(queue.get("recent", []), invocation)
	_sync_agent_tool_buttons()
	var previous_cursor := selected_agent_tool_event_cursor
	selected_agent_tool_event_cursor = int(data.get("next_cursor", selected_agent_tool_event_cursor))
	var lines := [
		"[b]Agent Tool Events[/b]",
		"Tool: %s (%s)" % [invocation.get("tool_name", ""), invocation.get("tool_id", "")],
		"Status: %s | target: %s | safety: %s" % [invocation.get("status", ""), invocation.get("target_agent", ""), invocation.get("safety", "")],
		"Events: %s total | cursor %s -> %s | more=%s" % [str(data.get("event_count", 0)), str(previous_cursor), str(selected_agent_tool_event_cursor), str(data.get("has_more", false))],
		"%s" % data.get("safe_note", ""),
		""
	]
	var events: Array = data.get("events", [])
	if events.is_empty():
		lines.append("No new tool events. Use Tool Events again to poll later.")
	else:
		for event in events:
			if typeof(event) == TYPE_DICTIONARY:
				lines.append("- #%s %s | %s" % [str(event.get("index", "")), event.get("at", ""), event.get("message", "")])
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Agent tool events[/b]\n%s/%s" % [str(selected_agent_tool_event_cursor), str(data.get("event_count", 0))]
	_record_npc_chain_action("agent_events", "agent-hub")

func _render_memory_index(index: Dictionary) -> void:
	selected_memory_category = ""
	selected_memory_filename = ""
	selected_memory_proposal_id = ""
	pending_memory_promotion_confirmation = ""
	room_memory_promote_button.text = "Promote"
	var lines := [
		"[b]Shared Memory Shelves[/b]",
		"Root: %s | exists=%s | agentmemory service=%s | mode=%s" % [index.get("root", ""), str(index.get("root_exists", false)), str(index.get("agentmemory_service", false)), index.get("mode", "read-only")],
		""
	]
	for shelf in index.get("categories", []):
		if typeof(shelf) != TYPE_DICTIONARY:
			continue
		lines.append("[color=#4a3a2a]%s[/color]: %s notes" % [shelf.get("category", "memory"), str(shelf.get("count", 0))])
		var sample_names := []
		for item in shelf.get("items", []):
			if typeof(item) != TYPE_DICTIONARY:
				continue
			if selected_memory_category == "":
				selected_memory_category = str(item.get("category", shelf.get("category", "")))
				selected_memory_filename = str(item.get("filename", ""))
			sample_names.append(str(item.get("title", item.get("name", ""))))
			if sample_names.size() >= 3:
				break
		if not sample_names.is_empty():
			lines.append("  %s" % " | ".join(sample_names))
	lines.append("")
	lines.append("[b]Recent[/b]")
	for item in index.get("recent", []):
		if typeof(item) == TYPE_DICTIONARY:
			lines.append("- %s/%s: %s" % [item.get("category", ""), item.get("filename", ""), item.get("title", item.get("name", ""))])
	lines.append("")
	lines.append("[b]Agent-related memory[/b]")
	for item in index.get("agent_related", []):
		if typeof(item) == TYPE_DICTIONARY:
			lines.append("- %s/%s: %s" % [item.get("category", ""), item.get("filename", ""), item.get("title", item.get("name", ""))])
	var proposals: Array = index.get("proposals", [])
	if not proposals.is_empty():
		lines.append("")
		lines.append("[b]Memory Proposals[/b]")
		for proposal in proposals.slice(0, min(5, proposals.size())):
			if typeof(proposal) == TYPE_DICTIONARY:
				if selected_memory_proposal_id == "":
					selected_memory_proposal_id = str(proposal.get("id", ""))
				lines.append("- %s | id=%s" % [proposal.get("title", ""), proposal.get("id", "")])
				lines.append("  %s" % proposal.get("path", ""))
	var promotions: Array = index.get("promotions", [])
	if not promotions.is_empty():
		lines.append("")
		lines.append("[b]Recent Promotion Receipts[/b]")
		for promotion in promotions.slice(0, min(3, promotions.size())):
			if typeof(promotion) == TYPE_DICTIONARY:
				lines.append("- %s | %s" % [promotion.get("title", ""), promotion.get("path", "")])
	room_body.text = "\n".join(lines)
	room_memory_detail_button.disabled = selected_memory_category == "" or selected_memory_filename == ""
	room_memory_promote_button.disabled = selected_memory_proposal_id == ""
	if selected_memory_category != "":
		detail_body.text = "[b]Memory console[/b]\nSelected first note: %s/%s. Use Memory Detail to read its bounded preview." % [selected_memory_category, selected_memory_filename]
	if selected_memory_proposal_id != "":
		quest_body.text = "[b]Memory promotion ready[/b]\nSelected proposal `%s`. Promote Memory first previews, then asks for confirmation." % selected_memory_proposal_id

func _render_memory_detail(item: Dictionary) -> void:
	var lines := [
		"[b]%s[/b]" % item.get("title", item.get("name", "Memory Note")),
		"%s/%s | %s bytes | truncated=%s" % [item.get("category", ""), item.get("filename", ""), str(item.get("bytes", 0)), str(item.get("truncated", false))],
		"Path: %s" % item.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(item.get("preview", ""))
	]
	room_body.text = "\n".join(lines)

func _render_memory_proposal_created(data: Dictionary) -> void:
	var memory: Dictionary = data.get("memory_event", {})
	selected_memory_proposal_id = str(data.get("proposal_id", ""))
	pending_memory_promotion_confirmation = ""
	room_memory_promote_button.disabled = selected_memory_proposal_id == ""
	room_memory_promote_button.text = "Promote"
	var lines := [
		"[b]Memory Proposal Created[/b]",
		"Category: %s | Safety: %s" % [data.get("category", ""), data.get("safety", "")],
		"Proposal: %s" % data.get("proposal_path", ""),
		"Target hint: %s" % data.get("target_hint", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Memory proposal saved[/b]\n%s" % data.get("proposal_path", "")

func _render_memory_promotion(data: Dictionary) -> void:
	var status := str(data.get("status", ""))
	if status == "confirmation-required":
		pending_memory_promotion_confirmation = str(data.get("confirmation_required", ""))
		room_memory_promote_button.text = "Confirm"
	else:
		pending_memory_promotion_confirmation = ""
		room_memory_promote_button.text = "Promote"
	var memory: Dictionary = data.get("memory_event", {})
	var lines := [
		"[b]Memory Promotion[/b]",
		"Status: %s | Safety: %s" % [status, data.get("safety", "")],
		"Confirmation required: %s" % data.get("confirmation_required", ""),
		"Target: %s" % data.get("target_path", data.get("promotion_path", "")),
		"Receipt: %s" % data.get("receipt_path", ""),
		"Memory event: %s" % memory.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	if status == "confirmation-required":
		quest_body.text = "[b]Memory promotion needs confirmation[/b]\nPress Confirm Promote to write this reviewed note into shared memory."
	elif status == "saved":
		quest_body.text = "[b]Shared memory updated[/b]\n%s" % data.get("promotion_path", data.get("target_path", ""))
		_record_npc_chain_action("memory_promote", "memory-library")
	else:
		quest_body.text = "[b]Memory promotion[/b]\n%s" % status

func _render_knowledge_index(data: Dictionary) -> void:
	selected_knowledge_doc_id = ""
	room_knowledge_detail_button.disabled = true
	var lines := [
		"[b]Knowledge Tower Index[/b]",
		"Mode: %s" % data.get("mode", "allowlisted-incremental-cache"),
		"Documents: %s | Roots: %s" % [str(data.get("document_count", 0)), str(data.get("root_count", 0))],
		"Cache: %s" % data.get("cache_path", ""),
		"%s" % data.get("safe_note", ""),
		"",
		"[b]Allowlisted Roots[/b]"
	]
	for root in data.get("roots", []):
		if typeof(root) == TYPE_DICTIONARY:
			lines.append("- %s | exists=%s | indexed=%s | depth=%s" % [root.get("name", root.get("id", "root")), str(root.get("exists", false)), str(root.get("indexed_count", 0)), str(root.get("max_depth", 0))])
			lines.append("  %s" % root.get("path", ""))
	lines.append("")
	lines.append("[b]Ignored Dirs[/b]")
	lines.append(", ".join(data.get("ignore_dirs", [])))
	room_body.text = "\n".join(lines)
	detail_body.text = "[b]Knowledge console[/b]\nUse Search Wiki to query the cached allowlisted knowledge index."

func _render_knowledge_search(data: Dictionary) -> void:
	selected_knowledge_doc_id = ""
	var lines := [
		"[b]Knowledge Search[/b]",
		"Query: %s | results=%s | page=%s" % [data.get("query", ""), str(data.get("total", 0)), str(data.get("page", 1))],
		"Cache: %s" % data.get("cache_path", ""),
		""
	]
	if not bool(data.get("cache_ready", true)):
		lines.append("Cache is empty. Ask the backend to run the Knowledge Index refresh job first.")
	for item in data.get("results", []):
		if typeof(item) != TYPE_DICTIONARY:
			continue
		var doc_id := str(item.get("id", ""))
		if selected_knowledge_doc_id == "" and doc_id != "":
			selected_knowledge_doc_id = doc_id
		lines.append("[color=#4a3a2a]%s[/color] (%s)" % [item.get("title", item.get("name", "doc")), item.get("root_name", "")])
		lines.append("  %s | %s bytes" % [item.get("relative_path", ""), str(item.get("bytes", 0))])
		var preview := str(item.get("preview", ""))
		if preview != "":
			lines.append("  %s" % preview.substr(0, 180))
	room_body.text = "\n".join(lines)
	room_knowledge_detail_button.disabled = selected_knowledge_doc_id == ""
	if selected_knowledge_doc_id != "":
		detail_body.text = "[b]Knowledge console[/b]\nSelected first search result: %s. Use Open Knowledge for a bounded preview." % selected_knowledge_doc_id

func _render_knowledge_index_job(data: Dictionary) -> void:
	var lines := [
		"[b]Knowledge Index Refresh Queued[/b]",
		"Job: %s | kind: %s" % [data.get("job_id", ""), data.get("kind", "")],
		"Safety: %s" % data.get("safety", ""),
		"",
		"Use System Monitor jobs or Knowledge Index after a moment to inspect refreshed cache state."
	]
	room_body.text = "\n".join(lines)
	quest_body.text = "[b]Knowledge refresh queued[/b]\n%s" % data.get("job_id", "")

func _render_knowledge_item(data: Dictionary) -> void:
	var doc: Dictionary = data.get("document", {})
	var lines := [
		"[b]%s[/b]" % doc.get("title", doc.get("name", "Knowledge Item")),
		"%s | %s bytes | truncated=%s" % [doc.get("root_name", ""), str(data.get("bytes", doc.get("bytes", 0))), str(data.get("truncated", false))],
		"Path: %s" % doc.get("path", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)

func _render_research_project_index(index: Dictionary) -> void:
	research_project_ids = []
	selected_research_project_id = ""
	var lines := [
		"[b]Research Project Boards[/b]",
		"Root: %s | exists=%s | mode=%s" % [index.get("research_root", ""), str(index.get("research_root_exists", false)), index.get("mode", "read-only")],
		""
	]
	for project in index.get("projects", []):
		if typeof(project) != TYPE_DICTIONARY:
			continue
		var project_id := str(project.get("id", ""))
		if project_id != "":
			research_project_ids.append(project_id)
			if selected_research_project_id == "":
				selected_research_project_id = project_id
		var local_path := "missing local folder"
		for root in project.get("local_dirs", []):
			if typeof(root) == TYPE_DICTIONARY and root.get("exists", false):
				local_path = str(root.get("path", local_path))
				break
		lines.append("[color=#4a3a2a]P%s %s[/color] (%s)" % [str(project.get("priority", "?")), project.get("name", project_id), project_id])
		lines.append("  %s" % project.get("theme", ""))
		lines.append("  local: %s" % local_path)
		lines.append("  next: %s" % project.get("next_action", ""))
		lines.append("")
	room_body.text = "\n".join(lines)
	room_project_detail_button.disabled = selected_research_project_id == ""
	room_research_agent_button.disabled = selected_research_project_id == ""
	room_research_log_button.disabled = selected_research_project_id == ""
	if selected_research_project_id != "":
		detail_body.text = "[b]Research console[/b]\nSelected first project board: %s. Use Project Detail for status docs, Research Log for a project-local draft, or Research Agent for a safe ARIS-style brief." % selected_research_project_id
	_record_npc_chain_action("research_projects", "research-hall")

func _render_research_project_detail(project: Dictionary) -> void:
	var lines := [
		"[b]%s[/b]" % project.get("name", project.get("id", "Research Project")),
		"%s" % project.get("theme", ""),
		"Priority: P%s | Server: %s" % [str(project.get("priority", "?")), project.get("server", "")],
		"Next: %s" % project.get("next_action", ""),
		"",
		"[b]Status Docs[/b]"
	]
	for doc in project.get("status_docs", []):
		if typeof(doc) != TYPE_DICTIONARY:
			continue
		lines.append("- %s | exists=%s" % [doc.get("path", doc.get("name", "doc")), str(doc.get("exists", false))])
		for excerpt in doc.get("excerpt", []):
			lines.append("  %s" % excerpt)
	lines.append("")
	lines.append("[b]Experiment Entry Candidates[/b]")
	for root in project.get("experiment_entries", []):
		if typeof(root) != TYPE_DICTIONARY:
			continue
		lines.append("- root: %s | exists=%s" % [root.get("root", ""), str(root.get("exists", false))])
		for candidate in root.get("candidates", []):
			if typeof(candidate) == TYPE_DICTIONARY:
				lines.append("  %s [%s]" % [candidate.get("relative_path", candidate.get("name", "")), candidate.get("kind", "")])
	room_body.text = "\n".join(lines)
	room_project_detail_button.disabled = selected_research_project_id == ""
	room_research_agent_button.disabled = selected_research_project_id == ""
	room_research_log_button.disabled = selected_research_project_id == ""
	_record_npc_chain_action("project_detail", "research-hall")

func _render_research_log_created(data: Dictionary) -> void:
	var lines := [
		"[b]Research Log Draft Created[/b]",
		"Project: %s (%s)" % [data.get("project_name", ""), data.get("project_id", "")],
		"Path: %s" % data.get("log_path", ""),
		"Safety: %s" % data.get("safety", ""),
		"",
		"[b]Preview[/b]",
		str(data.get("preview", ""))
	]
	room_body.text = "\n".join(lines)
	detail_body.text = "[b]Research log drafted[/b]\n%s" % data.get("log_path", "")
	_record_npc_chain_action("research_log", "research-hall")

func _render_room(room: Dictionary) -> void:
	room_title.text = "%s - %s" % [room.get("room_title", "Room"), room.get("npc", "Agent")]
	_paint_room_stage(room)
	var lines := [
		"[b]Atmosphere[/b]: %s" % room.get("atmosphere", ""),
		"[b]Workbench[/b]: %s" % room.get("workbench", "Workbench"),
		"",
		"[b]Shelves[/b]"
	]
	for card in room.get("cards", []):
		if typeof(card) == TYPE_DICTIONARY:
			lines.append("- [color=#4a3a2a]%s[/color]: %s" % [card.get("title", "Item"), card.get("body", "")])
	var npc_lines := _npc_quest_chain_lines(str(room.get("building_id", active_building_id)))
	if not npc_lines.is_empty():
		lines.append("")
		lines.append("[b]NPC Quest Chain[/b]")
		lines.append_array(npc_lines)
	lines.append("")
	var action_hint := "safe read-only scan"
	if str(room.get("building_id", "")) == "automation-factory":
		action_hint = "inspect scripts or create a project-local automation blueprint"
	elif str(room.get("building_id", "")) == "knowledge-tower":
		action_hint = "refresh/search cached knowledge roots or open a bounded document preview"
	elif str(room.get("building_id", "")) == "permission-hall":
		action_hint = "inspect safety classes, confirmation gates, and audit signals"
	elif str(room.get("building_id", "")) == "settings-center":
		action_hint = "inspect registries or create a project-local settings draft"
	elif str(room.get("building_id", "")) == "testing-arena":
		action_hint = "inspect verification evidence or create a project-local test plan"
	elif str(room.get("building_id", "")) == "bug-clinic":
		action_hint = "inspect diagnostics or create a project-local bug report"
	elif str(room.get("building_id", "")) == "project-management-hall":
		action_hint = "inspect portfolio status or create a project-local brief"
	elif str(room.get("building_id", "")) == "asset-gallery":
		action_hint = "inspect asset roots or create a project-local curation note"
	elif str(room.get("building_id", "")) == "local-office-center":
		action_hint = "inspect office folders or create a project-local office note"
	elif str(room.get("building_id", "")) == "schedule-plan-center":
		action_hint = "inspect planning signals or create a project-local schedule draft"
	elif str(room.get("building_id", "")) == "learning-training-grounds":
		action_hint = "inspect training tracks or create a project-local learning plan"
	elif str(room.get("building_id", "")) == "language-learning-area":
		action_hint = "inspect language tracks or create a project-local phrase note"
	elif str(room.get("building_id", "")) == "research-data-center":
		action_hint = "inspect research data candidates or create a project-local provenance note"
	elif str(room.get("building_id", "")) == "paper-reading-room":
		action_hint = "inspect paper/reference candidates or create a project-local reading note"
	elif str(room.get("building_id", "")) == "version-release-plaza":
		action_hint = "inspect release readiness or create a project-local release checklist"
	elif str(room.get("building_id", "")) == "plugin-registry":
		action_hint = "inspect extension candidates or create a project-local plugin proposal"
	lines.append("[b]Available action[/b]: %s" % action_hint)
	room_body.text = "\n".join(lines)

func _npc_quest_chain_lines(building_id: String) -> Array:
	var lines := []
	if not npc_quest_defs.has(building_id):
		return lines
	var chains: Array = npc_quest_defs.get(building_id, [])
	for chain in chains.slice(0, 2):
		if typeof(chain) != TYPE_DICTIONARY:
			continue
		var chain_id := str(chain.get("id", ""))
		var done_stages := _npc_chain_done_stages(chain_id)
		var complete := _npc_chain_is_complete(chain, done_stages)
		lines.append("- %s: %s" % [chain.get("npc", "NPC"), chain.get("title", "Quest Chain")])
		lines.append("  %s" % chain.get("summary", ""))
		lines.append("  Reward: %s | Safety: %s | Status: %s" % [chain.get("reward", ""), chain.get("safety", ""), "complete" if complete else "active"])
		for stage in chain.get("stages", []):
			if typeof(stage) == TYPE_DICTIONARY:
				var stage_id := str(stage.get("id", "stage"))
				var marker := "[x]" if done_stages.get(stage_id, false) == true else "[ ]"
				lines.append("  %s %s" % [marker, stage.get("label", stage_id)])
	return lines

func _npc_chain_done_stages(chain_id: String) -> Dictionary:
	var entry = npc_chain_progress.get(chain_id, {})
	if typeof(entry) != TYPE_DICTIONARY:
		return {}
	var raw_done = entry.get("stages", {})
	if typeof(raw_done) != TYPE_DICTIONARY:
		return {}
	var done: Dictionary = raw_done
	return done

func _npc_chain_is_complete(chain: Dictionary, done_stages: Dictionary) -> bool:
	var stages: Array = chain.get("stages", [])
	if stages.is_empty():
		return false
	for stage in stages:
		if typeof(stage) != TYPE_DICTIONARY:
			continue
		var stage_id := str(stage.get("id", ""))
		if stage_id == "" or done_stages.get(stage_id, false) != true:
			return false
	return true

func _record_npc_chain_action(action_id: String, building_id: String = "") -> void:
	if action_id == "":
		return
	if building_id == "":
		building_id = current_room_id
	if building_id == "" or not npc_quest_defs.has(building_id):
		return
	var chains: Array = npc_quest_defs.get(building_id, [])
	var changed := false
	var completed_lines := []
	for chain in chains:
		if typeof(chain) != TYPE_DICTIONARY:
			continue
		var chain_id := str(chain.get("id", ""))
		if chain_id == "":
			continue
		var matched_stages := []
		for stage in chain.get("stages", []):
			if typeof(stage) == TYPE_DICTIONARY and str(stage.get("action", "")) == action_id:
				matched_stages.append(stage)
		if matched_stages.is_empty():
			continue
		var entry = npc_chain_progress.get(chain_id, {})
		if typeof(entry) != TYPE_DICTIONARY:
			entry = {}
		var raw_done = entry.get("stages", {})
		var done: Dictionary = {}
		if typeof(raw_done) == TYPE_DICTIONARY:
			done = raw_done
		var stage_changed := false
		for stage in matched_stages:
			var stage_id := str(stage.get("id", ""))
			if stage_id != "" and done.get(stage_id, false) != true:
				done[stage_id] = true
				stage_changed = true
		if not stage_changed:
			continue
		var was_complete: bool = entry.get("completed", false) == true
		var now_complete: bool = _npc_chain_is_complete(chain, done)
		entry = {
			"id": chain_id,
			"building_id": building_id,
			"title": chain.get("title", chain_id),
			"npc": chain.get("npc", "NPC"),
			"stages": done,
			"completed": now_complete,
			"last_action": action_id,
			"updated_at": Time.get_datetime_string_from_system(true),
		}
		npc_chain_progress[chain_id] = entry
		changed = true
		if now_complete and not was_complete:
			var badge_id := "npc-chain-%s" % chain_id
			earned_badges[badge_id] = {
				"name": chain.get("reward", chain.get("title", chain_id)),
				"collection": "NPC Chains",
				"quest": chain.get("title", chain_id),
			}
			completed_lines.append("%s: %s" % [chain.get("npc", "NPC"), chain.get("reward", chain_id)])
			_record_activity("NPC chain complete", "%s | %s" % [chain.get("npc", "NPC"), chain.get("title", chain_id)], "quest")
	if not changed:
		return
	_save_progress()
	_update_badge_case()
	if not completed_lines.is_empty():
		detail_body.text += "\n[b]NPC chain complete:[/b] %s" % "; ".join(completed_lines)

func _npc_chain_badge_lines() -> Array:
	var lines := []
	for chain_id in npc_chain_progress.keys():
		var entry = npc_chain_progress[chain_id]
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var done = entry.get("stages", {})
		var done_count := 0
		if typeof(done) == TYPE_DICTIONARY:
			done_count = done.keys().size()
		var status := "complete" if entry.get("completed", false) == true else "active"
		lines.append("%s - %s/%s stage(s), %s" % [entry.get("title", chain_id), str(done_count), str(_npc_chain_stage_total(str(entry.get("building_id", "")), chain_id)), status])
	return lines

func _npc_chain_stage_total(building_id: String, chain_id: String) -> int:
	if building_id == "" or not npc_quest_defs.has(building_id):
		return 0
	for chain in npc_quest_defs.get(building_id, []):
		if typeof(chain) == TYPE_DICTIONARY and str(chain.get("id", "")) == chain_id:
			var stages: Array = chain.get("stages", [])
			return stages.size()
	return 0

func _paint_room_stage(room: Dictionary) -> void:
	for child in room_stage.get_children():
		child.queue_free()
	var building_id := str(room.get("building_id", active_building_id))
	var def := _building_def(building_id)
	var accent: Color = def.get("color", Color("#dcd6f7"))
	var scene: Dictionary = room_scene_defs.get(building_id, {})
	var accent_soft := Color(accent, 0.46)
	var accent_light := Color(accent).lightened(0.22)
	_add_stage_rect(Vector2(0, 0), Vector2(580, 210), COLOR_PARCHMENT_DARK, "")
	_add_stage_rect(Vector2(8, 8), Vector2(564, 194), COLOR_PARCHMENT, "")
	_add_stage_rect(Vector2(20, 22), Vector2(540, 164), accent_soft, "")
	_add_stage_rect(Vector2(30, 32), Vector2(520, 144), Color("#fff8e6"), "")
	_add_stage_rect(Vector2(36, 168), Vector2(508, 12), Color("#cfa879"), "")
	_add_stage_label(Vector2(40, 12), Vector2(360, 18), str(room.get("room_title", def.get("name", "Room"))), COLOR_INK, 13)
	_add_stage_rect(Vector2(466, 12), Vector2(70, 18), COLOR_GOLD, "safe", COLOR_INK)
	if not scene.is_empty():
		_add_stage_rect(Vector2(42, 92), Vector2(486, 18), Color(COLOR_MAGIC_BLUE, 0.78), str(scene.get("floor_label", "safe local-work path")).substr(0, 78), COLOR_INK)
		for i in range(9):
			var stone_x := 50 + i * 52
			var stone_y := 119 + (6 if i % 2 == 0 else 22)
			_add_stage_rect(Vector2(stone_x, stone_y), Vector2(36, 16), Color("#d6c59c"), "")
		_add_stage_rect(Vector2(30, 112), Vector2(516, 58), Color(COLOR_SOFT_GREEN, 0.52), "", COLOR_INK)
		_add_stage_rect(Vector2(44, 38), Vector2(112, 48), Color(COLOR_WOOD).lightened(0.08), "NPC\n%s" % room.get("npc", "Guide"), COLOR_PARCHMENT)
		_add_stage_rect(Vector2(168, 52), Vector2(392, 6), Color("#fff0bd"), "")
		var props: Array = scene.get("props", [])
		for prop in props.slice(0, min(4, props.size())):
			if typeof(prop) != TYPE_DICTIONARY:
				continue
			var prop_pos := Vector2(float(prop.get("x", 54)), float(prop.get("y", 114)))
			_add_room_prop(prop_pos, str(prop.get("label", "Room prop")), accent_light)
		var stations: Array = scene.get("stations", [])
		for station in stations:
			if typeof(station) == TYPE_DICTIONARY:
				_add_room_station_button(station)
		_add_stage_rect(Vector2(42, 176), Vector2(486, 18), Color(COLOR_MAGIC_BLUE, 0.72), str(scene.get("ambient", "read, draft, confirm")).substr(0, 82), COLOR_INK)
		return
	_add_stage_rect(Vector2(32, 118), Vector2(516, 56), COLOR_SOFT_GREEN, "stone floor path")
	_add_stage_rect(Vector2(40, 38), Vector2(118, 58), COLOR_WOOD, "NPC\n%s" % room.get("npc", "Agent"), COLOR_PARCHMENT)
	_add_stage_rect(Vector2(220, 42), Vector2(142, 62), Color("#7b5532"), "Workbench\n%s" % room.get("workbench", "Desk"), COLOR_PARCHMENT)
	var cards: Array = room.get("cards", [])
	for i in range(min(cards.size(), 4)):
		var card = cards[i]
		var label := "Shelf %d" % (i + 1)
		if typeof(card) == TYPE_DICTIONARY:
			label = str(card.get("title", label))
		_add_stage_rect(Vector2(392, 18 + i * 34), Vector2(138, 28), Color(accent).lightened(0.18), label, COLOR_INK)
	_add_stage_rect(Vector2(40, 176), Vector2(490, 18), COLOR_MAGIC_BLUE, "local computer room: read, draft, confirm", COLOR_INK)

func _add_stage_label(pos: Vector2, size: Vector2, text: String, text_color: Color, font_size: int = 12) -> void:
	var label := Label.new()
	label.text = text
	label.position = pos
	label.size = size
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", text_color)
	room_stage.add_child(label)

func _add_room_prop(pos: Vector2, label: String, fill: Color) -> void:
	var lower := label.to_lower()
	var color := fill
	var size := Vector2(108, 28)
	if lower.contains("crystal") or lower.contains("lamp") or lower.contains("lantern"):
		color = Color("#ffd87a")
		size = Vector2(96, 28)
	elif lower.contains("gear") or lower.contains("clock") or lower.contains("gauge"):
		color = Color("#b9d8ff")
	elif lower.contains("scroll") or lower.contains("card") or lower.contains("note") or lower.contains("draft"):
		color = Color("#fff0bd")
	elif lower.contains("shelf") or lower.contains("crate") or lower.contains("cabinet"):
		color = Color("#c9955a")
	_add_stage_rect(pos + Vector2(3, 4), size, Color("#7b5532", 0.24), "")
	_add_stage_rect(pos, size, color, label.substr(0, 20), COLOR_INK)

func _add_room_station_button(station: Dictionary) -> void:
	var button := Button.new()
	button.text = str(station.get("label", "Station"))
	button.position = Vector2(float(station.get("x", 40)), float(station.get("y", 32)))
	button.size = Vector2(float(station.get("w", 110)), float(station.get("h", 42)))
	button.tooltip_text = "%s | %s" % [station.get("role", "safe-room-station"), station.get("action", "")]
	button.add_theme_font_size_override("font_size", 12)
	button.add_theme_color_override("font_color", COLOR_INK)
	button.add_theme_color_override("font_hover_color", COLOR_INK)
	button.add_theme_color_override("font_pressed_color", COLOR_INK)
	var base_color := Color(str(station.get("color", "#d9a441")))
	var style := StyleBoxFlat.new()
	style.bg_color = base_color
	style.border_color = COLOR_WOOD
	style.set_border_width_all(2)
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_left = 6
	style.corner_radius_bottom_right = 6
	style.shadow_color = Color("#5f4325", 0.28)
	style.shadow_size = 3
	var hover := style.duplicate()
	hover.bg_color = base_color.lightened(0.12)
	hover.border_color = COLOR_GOLD
	hover.shadow_size = 5
	var pressed := style.duplicate()
	pressed.bg_color = base_color.darkened(0.08)
	pressed.shadow_size = 1
	button.add_theme_stylebox_override("normal", style)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)
	button.pressed.connect(_room_scene_station_pressed.bind(str(station.get("action", "")), str(station.get("label", "Station"))))
	room_stage.add_child(button)

func _room_scene_station_pressed(action_id: String, label: String) -> void:
	if action_id == "":
		return
	detail_body.text = "[b]Room station:[/b] %s\nAction: %s" % [label, action_id]
	_run_room_scene_action(action_id)

func _run_room_scene_action(action_id: String) -> void:
	match action_id:
		"enter_room":
			_record_npc_chain_action("enter_room", current_room_id)
		"file_roots":
			_load_file_roots()
		"preview_file":
			_preview_selected_file()
		"tag_file":
			_tag_selected_file()
		"research_projects":
			_load_research_projects()
		"project_detail":
			_load_selected_research_project()
		"research_log":
			_create_research_log_draft()
		"code_projects":
			_load_code_projects()
		"code_task":
			_create_code_task_draft()
		"explain_code":
			_submit_code_explain_task()
		"patch_plan":
			_create_code_patch_plan()
		"run_check":
			_run_project_verification()
		"agent_roster":
			_load_agent_roster()
		"recruit_agent":
			_recruit_selected_agent_companion()
		"agent_events":
			if selected_agent_task_id != "":
				_load_selected_agent_task_events()
			elif selected_agent_tool_invocation_id != "":
				_load_selected_agent_tool_events()
			else:
				_load_agent_tasks()
		"testing_overview":
			_load_testing_arena()
		"test_plan":
			_create_test_plan()
		"memory_index":
			_load_memory_index()
		"memory_detail":
			_load_selected_memory_item()
		"memory_proposal":
			_create_memory_proposal()
		"memory_promote":
			_promote_memory_proposal()
		"knowledge_index":
			_load_knowledge_index()
		"knowledge_search":
			_search_knowledge()
		"knowledge_detail":
			_load_selected_knowledge_item()
		"harbor_repos":
			_load_harbor_repos()
		"harbor_detail":
			_load_selected_harbor_repo()
		"harbor_github":
			_load_selected_harbor_github()
		"harbor_publish_readiness":
			_load_selected_harbor_publish_readiness()
		"harbor_draft":
			_create_harbor_draft()
		"terminal_commands":
			_load_terminal_commands()
		"terminal_run":
			_run_selected_terminal_command()
		"terminal_log":
			_open_selected_terminal_log()
		"model_status":
			_load_model_status()
		"model_profiles":
			_load_model_profiles()
		"model_test":
			_create_model_profile_test()
		"model_key_vault":
			_load_model_key_vault()
		"paper_overview":
			_load_paper_reading_room()
		"paper_note":
			_create_paper_reading_note()
		"paper_extract":
			_queue_paper_extraction()
		"download_overview":
			_load_download_station()
		"download_triage":
			_load_download_triage()
		"download_intake":
			_create_download_intake()
		"backup_overview":
			_load_backup_station()
		"backup_integrity":
			_load_backup_integrity()
		"backup_plan":
			_create_backup_plan()
		"inspiration_overview":
			_load_inspiration_station()
		"inspiration_note":
			_create_inspiration_note()
		"office_overview":
			_load_local_office_center()
		"office_note":
			_create_office_note()
		"schedule_overview":
			_load_schedule_plan_center()
		"schedule_draft":
			_create_schedule_draft()
		"learning_overview":
			_load_learning_training()
		"learning_plan":
			_create_learning_plan()
		"language_overview":
			_load_language_learning()
		"language_practice":
			_create_language_practice()
		"research_data_overview":
			_load_research_data_center()
		"research_data_note":
			_create_research_data_note()
		"release_overview":
			_load_version_release_plaza()
		"release_checklist":
			_create_release_checklist()
		"release_report":
			_create_release_report()
		"system_overview":
			_load_system_overview()
		"system_jobs":
			_load_system_jobs()
		"system_events":
			_load_system_events()
		"permission_overview":
			_load_permission_hall()
		"permission_secret_audit":
			_load_permission_secret_audit()
		"settings_overview":
			_load_settings_center()
		"registry_health":
			_load_registry_health()
		"settings_draft":
			_create_settings_draft()
		"task_overview":
			_load_task_board()
		"task_create":
			_create_task_board_task()
		"task_detail":
			_open_selected_task_detail()
		"writing_overview":
			_load_writing_studio()
		"writing_draft":
			_create_writing_draft()
		"automation_overview":
			_load_automation_factory()
		"automation_scheduler":
			_load_automation_scheduler()
		"automation_draft":
			_create_automation_draft()
		"bug_overview":
			_load_bug_clinic()
		"bug_report":
			_create_bug_report()
		"project_management_overview":
			_load_project_management()
		"project_brief":
			_create_project_brief()
		"asset_overview":
			_load_asset_gallery()
		"asset_inspect":
			_inspect_asset()
		"asset_note":
			_create_asset_note()
		"skill_overview":
			_load_skill_workshop()
		"skill_scan":
			_run_safe_work_scan()
			_record_npc_chain_action("skill_scan", "skill-workshop")
		"devtools_overview":
			_load_devtools_lab()
		"devtools_scan":
			_run_safe_work_scan()
			_record_npc_chain_action("devtools_scan", "devtools-lab")
		"town_capability":
			_load_town_capability_atlas()
		"town_workflows":
			_load_town_workflow_routes()
		"plugin_overview":
			_load_plugin_registry()
		"plugin_manifests":
			_load_plugin_manifests()
		"plugin_draft":
			_create_plugin_draft()
		"goal_overview":
			_load_goal_tower()
		"goal_draft":
			_create_goal_draft()
		"temp_drafts_overview":
			_load_temporary_draft_box()
		"temp_draft":
			_create_temp_draft()
		"scan":
			_run_safe_work_scan()
		_:
			detail_body.text += "\nNo station action is bound yet."

func _add_stage_rect(pos: Vector2, size: Vector2, color: Color, text: String = "", text_color: Color = Color("#1a1a2e")) -> void:
	var rect := ColorRect.new()
	rect.position = pos
	rect.size = size
	rect.color = color
	room_stage.add_child(rect)
	if text != "":
		var label := Label.new()
		label.text = text
		label.position = pos + Vector2(6, 4)
		label.size = size - Vector2(12, 8)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.add_theme_font_size_override("font_size", 12)
		label.add_theme_color_override("font_color", text_color)
		room_stage.add_child(label)

func _update_badge_case() -> void:
	if badge_body == null:
		return
	var names := []
	for badge_id in earned_badges.keys():
		var badge = earned_badges[badge_id]
		if typeof(badge) == TYPE_DICTIONARY:
			names.append("%s [%s]" % [badge.get("name", badge_id), badge.get("collection", "Set")])
		else:
			names.append(str(badge_id))
	if names.is_empty():
		badge_body.text = "[b]Badge Case[/b]\nNo badges yet."
	else:
		badge_body.text = "[b]Badge Case[/b]\n%s" % ", ".join(names)
	var companion_lines := []
	for companion_id in companion_roster.keys():
		var companion = companion_roster[companion_id]
		if typeof(companion) != TYPE_DICTIONARY:
			continue
		var marker := "* " if str(companion_id) == active_companion_id else "- "
		companion_lines.append("%s%s Lv.%s" % [marker, companion.get("name", companion_id), str(companion.get("affinity", 1))])
	if companion_lines.is_empty():
		badge_body.text += "\n\n[b]Companions[/b]\nNo agent companions yet."
	else:
		badge_body.text += "\n\n[b]Companions[/b]\n%s" % "\n".join(companion_lines.slice(0, 4))
	var route_lines := _daily_route_badge_lines()
	if route_lines.is_empty():
		badge_body.text += "\n\n[b]Daily Routes[/b]\nNo route claimed today."
	else:
		badge_body.text += "\n\n[b]Daily Routes[/b]\n%s" % "\n".join(route_lines.slice(0, 3))
	var workflow_lines := _workflow_route_badge_lines()
	if workflow_lines.is_empty():
		badge_body.text += "\n\n[b]Workflow Routes[/b]\nClaim a Town Hall workflow to start a longer local-work chain."
	else:
		badge_body.text += "\n\n[b]Workflow Routes[/b]\n%s" % "\n".join(workflow_lines.slice(0, 4))
	var mastery_lines := _room_mastery_lines()
	if mastery_lines.is_empty():
		badge_body.text += "\n\n[b]Room Mastery[/b]\nEnter rooms and use safe workbenches to grow mastery."
	else:
		badge_body.text += "\n\n[b]Room Mastery[/b]\n%s" % "\n".join(mastery_lines.slice(0, 5))
	var npc_lines := _npc_chain_badge_lines()
	if npc_lines.is_empty():
		badge_body.text += "\n\n[b]NPC Chains[/b]\nMeet room NPCs and finish safe local-work stages."
	else:
		badge_body.text += "\n\n[b]NPC Chains[/b]\n%s" % "\n".join(npc_lines.slice(0, 5))

func _collection_item_owned(item: Dictionary) -> bool:
	var owned_kind := str(item.get("owned_kind", "badge"))
	if owned_kind == "companion":
		return companion_roster.has(str(item.get("source_id", "")))
	if owned_kind == "daily-route":
		var route_id := str(item.get("source_id", ""))
		for badge_id in earned_badges.keys():
			if str(badge_id).ends_with("-%s" % route_id):
				return true
		var claim = daily_route_claims.get(route_id, {})
		return typeof(claim) == TYPE_DICTIONARY and claim.get("complete", false) == true
	if owned_kind == "workflow-route":
		var workflow_id := str(item.get("source_id", ""))
		for badge_id in earned_badges.keys():
			if str(badge_id) == "workflow-%s" % workflow_id:
				return true
		var workflow_claim = workflow_route_claims.get(workflow_id, {})
		return typeof(workflow_claim) == TYPE_DICTIONARY and str(workflow_claim.get("status", "")) == "completed"
	return earned_badges.has(str(item.get("id", "")))

func _render_collection_codex(data: Dictionary) -> void:
	var collections: Array = data.get("collections", [])
	var lines := [
		"[b]Collection Codex[/b]",
		"Mode: %s | Sets: %s | Items: %s" % [data.get("mode", ""), str(data.get("collection_count", 0)), str(data.get("item_count", 0))],
		"Ownership is merged from this local player save; catalog data comes from read-only registries.",
	]
	for collection in collections:
		if typeof(collection) != TYPE_DICTIONARY:
			continue
		var items: Array = collection.get("items", [])
		var owned_count := 0
		var sample_lines := []
		for item in items:
			if typeof(item) != TYPE_DICTIONARY:
				continue
			var owned := _collection_item_owned(item)
			if owned:
				owned_count += 1
			if sample_lines.size() < 3:
				var mark := "[x]" if owned else "[ ]"
				sample_lines.append("%s %s" % [mark, item.get("name", item.get("id", ""))])
		lines.append("")
		lines.append("[b]%s[/b] %s/%s" % [collection.get("name", collection.get("id", "")), str(owned_count), str(items.size())])
		if sample_lines.is_empty():
			lines.append("- No items registered yet.")
		else:
			lines.append_array(sample_lines)
	lines.append("")
	lines.append("[i]%s[/i]" % data.get("safe_note", "Read-only collection catalog."))
	quest_body.text = "\n".join(lines)
	_update_badge_case()
	_record_activity("Collection Codex", "%s set(s), %s item(s)" % [str(data.get("collection_count", 0)), str(data.get("item_count", 0))], "progress")

func _room_mastery_level(xp: int) -> int:
	if xp >= 9:
		return 3
	if xp >= 4:
		return 2
	if xp >= 1:
		return 1
	return 0

func _record_room_mastery(building_id: String, event_id: String, amount: int = 1, show_message: bool = false) -> void:
	if building_id == "":
		return
	var current = room_mastery.get(building_id, {})
	if typeof(current) != TYPE_DICTIONARY:
		current = {}
	var def := _building_def(building_id)
	var visits := int(current.get("visits", 0))
	var actions := int(current.get("actions", 0))
	var xp := int(current.get("xp", 0))
	var old_level := int(current.get("level", 0))
	if event_id == "visit":
		visits += 1
	else:
		actions += 1
	xp += max(amount, 0)
	var new_level := _room_mastery_level(xp)
	current = {
		"name": def.name,
		"xp": xp,
		"level": new_level,
		"visits": visits,
		"actions": actions,
		"last_event": event_id,
		"updated_at": Time.get_datetime_string_from_system(true),
	}
	room_mastery[building_id] = current
	if new_level > old_level:
		var badge_id := "mastery-%s-l%s" % [building_id, str(new_level)]
		earned_badges[badge_id] = {
			"name": "%s Mastery Lv.%s" % [def.name, str(new_level)],
			"collection": "Room Mastery",
			"quest": "Room progression",
		}
		_record_activity("Room mastery up", "%s Lv.%s" % [def.name, str(new_level)], "mastery")
		if show_message:
			detail_body.text += "\n[b]Room mastery up:[/b] %s Lv.%s" % [def.name, str(new_level)]
	elif show_message:
		detail_body.text += "\n[b]Room mastery:[/b] %s Lv.%s (%s XP)" % [def.name, str(new_level), str(xp)]
	_save_progress()
	_update_badge_case()

func _room_mastery_lines() -> Array:
	var lines := []
	for building_id in room_mastery.keys():
		var entry = room_mastery[building_id]
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		lines.append("Lv.%s %s - %s XP, %s visits, %s actions" % [
			str(entry.get("level", 0)),
			entry.get("name", building_id),
			str(entry.get("xp", 0)),
			str(entry.get("visits", 0)),
			str(entry.get("actions", 0)),
		])
	return lines

func _capture_visual_smoke() -> void:
	var capture_room := OS.get_environment("AGENT_TOWN_CAPTURE_ROOM")
	if capture_room == "":
		capture_room = "file-vault"
	var output_name := OS.get_environment("AGENT_TOWN_CAPTURE_OUTPUT")
	if output_name == "":
		output_name = "visual-smoke.png"
	if capture_room == "map":
		room_overlay.visible = false
		active_building_id = ""
		current_room_id = ""
		detail_title.text = "Central Plaza"
		detail_body.text = "[b]Visual smoke[/b]\nRendering data-driven plaza landmarks without network calls."
		target_position = Vector2(745, 445)
		player.position = target_position
		camera.position = target_position
		camera.zoom = Vector2(0.9, 0.9)
		await get_tree().process_frame
		await get_tree().process_frame
		_save_visual_capture(output_name)
		return
	var payload := _visual_smoke_room_payload(capture_room)
	active_building_id = str(payload.get("building_id", capture_room))
	current_room_id = active_building_id
	var def := _building_def(active_building_id)
	room_overlay.visible = true
	room_title.text = "%s Interior" % def.name
	detail_title.text = def.name
	detail_body.text = "[b]Visual smoke[/b]\nRendering %s room without network calls." % def.name
	_render_room(payload)
	await get_tree().process_frame
	await get_tree().process_frame
	_save_visual_capture(output_name)

func _save_visual_capture(output_name: String) -> void:
	var output_dir := ProjectSettings.globalize_path("res://../screenshots")
	DirAccess.make_dir_recursive_absolute(output_dir)
	var output_file := ProjectSettings.globalize_path("res://../screenshots/%s" % output_name)
	var texture := get_viewport().get_texture()
	if texture == null:
		push_error("Viewport texture is unavailable; visual capture requires a non-headless render driver.")
		get_tree().quit(1)
		return
	var image := texture.get_image()
	var err := image.save_png(output_file)
	if err != OK:
		push_error("Failed to save visual smoke screenshot: %s" % err)
		get_tree().quit(1)
		return
	print("Saved visual smoke screenshot: %s" % output_file)
	get_tree().quit(0)

func _visual_smoke_room_payload(building_id: String) -> Dictionary:
	if building_id == "town-hall":
		return {
			"building_id": "town-hall",
			"room_title": "Town Hall",
			"npc": "Opus",
			"atmosphere": "architectural ledgers, district maps, safety seals, and capability pins tied to real local systems",
			"workbench": "Capability Atlas Table",
			"cards": [
				{"title": "Capability Atlas", "body": "18+ buildings mapped to real paths, endpoints, tools, agents, or APIs"},
				{"title": "Code Workshop", "body": "projects, context packs, patch plans, and verification jobs"},
				{"title": "Memory Library", "body": "shared memory index, proposals, and confirm-required promotions"},
				{"title": "System Monitor", "body": "service health, job cancellation, persistent logs, and event polling"},
				{"title": "Model Market", "body": "provider readiness, NPC routing, profile tests, and encrypted key vault"},
				{"title": "Safety", "body": "read-only atlas; no scans, commands, agents, edits, or external calls"},
			],
		}
	if building_id == "research-hall":
		return {
			"building_id": "research-hall",
			"room_title": "Research Hall",
			"npc": "ARIS",
			"atmosphere": "glass domes, paper scrolls, and project boards for real research work",
			"workbench": "Research Project Console",
			"cards": [
				{"title": "Project Boards", "body": "D:\\Research roots and shared memory status"},
				{"title": "Research Agent", "body": "safe read-only ARIS-style project briefs"},
				{"title": "Research Log", "body": "project-local evidence and next-action drafts"},
				{"title": "Safety", "body": "no experiments, no servers, no dataset mutation"},
			],
		}
	if building_id == "memory-library":
		return {
			"building_id": "memory-library",
			"room_title": "Memory Library",
			"npc": "Sonnet",
			"atmosphere": "shelf ladders, glowing index cards, proposal trays, and shared-memory seals",
			"workbench": "Shared Memory Desk",
			"cards": [
				{"title": "Memory Shelves", "body": "decisions, facts, lessons, preferences, sessions, workflows"},
				{"title": "Memory Detail", "body": "bounded previews from shared memory"},
				{"title": "Memory Proposal", "body": "project-local reviewed update drafts"},
				{"title": "Promote Memory", "body": "two-step PROMOTE_MEMORY confirmation gate"},
				{"title": "Receipts", "body": "promotion audit notes under workspace\\memory-promotions"},
			],
		}
	if building_id == "code-workshop":
		return {
			"building_id": "code-workshop",
			"room_title": "Code Workshop",
			"npc": "Codex",
			"atmosphere": "gear benches, blue code screens, and agent handoff scrolls",
			"workbench": "Repository Workbench",
			"cards": [
				{"title": "Code Projects", "body": "bounded D-drive Git discovery"},
				{"title": "Code Task", "body": "rich local task drafts with candidate files"},
				{"title": "Explain Code", "body": "read-only onboarding briefs with entry points"},
				{"title": "Run Check", "body": "confirm-required project verification jobs"},
				{"title": "Context Pack", "body": "repo briefs under workspace\\code-contexts"},
				{"title": "Patch Plan", "body": "safe implementation handoff plans"},
			],
		}
	if building_id == "agent-hub":
		return {
			"building_id": "agent-hub",
			"room_title": "Agent Hub",
			"npc": "Guild Clerk",
			"atmosphere": "adventurer-guild desks wired into safe local agent queues",
			"workbench": "Agent Task And Tool Queue",
			"cards": [
				{"title": "Agent Roster", "body": "local launcher visibility and companion metadata"},
				{"title": "Task Queue", "body": "pause/resume, result detail, event polling"},
				{"title": "Task Policy", "body": "max-running concurrency and backpressure state"},
				{"title": "Task Logs", "body": "durable JSON evidence under workspace\\agent-task-logs"},
				{"title": "Tool Registry", "body": "safe registered tools with JSON logs"},
				{"title": "Tool Logs", "body": "durable JSON evidence under workspace\\agent-tool-logs"},
				{"title": "Agent Chat", "body": "project-local chat sessions and suggestions"},
			],
		}
	if building_id == "testing-arena":
		return {
			"building_id": "testing-arena",
			"room_title": "Testing Arena",
			"npc": "Verifier",
			"atmosphere": "practice mats, smoke scripts, screenshot boards, and proof lanterns",
			"workbench": "Verification Bench",
			"cards": [
				{"title": "Smoke", "body": "Python, FastAPI, and Godot startup checks"},
				{"title": "Visual Proof", "body": "room screenshots under screenshots"},
				{"title": "Test Plans", "body": "project-local verification drafts"},
				{"title": "Slice Proof", "body": "vertical slice evidence report"},
				{"title": "Logs", "body": "recent terminal and backend job evidence"},
			],
		}
	if building_id == "system-monitor":
		return {
			"building_id": "system-monitor",
			"room_title": "System Monitor",
			"npc": "Monitor Keeper",
			"atmosphere": "status lanterns, event boards, and registry gauges for the local backend",
			"workbench": "Runtime Evidence Console",
			"cards": [
				{"title": "System Status", "body": "services, registries, workspace state"},
				{"title": "Job Queue", "body": "backend async jobs and failures"},
				{"title": "Cancel Job", "body": "queued-job cancel metadata and rollback notes"},
				{"title": "Job Events", "body": "cursor polling for selected backend job lifecycle updates"},
				{"title": "Persistent Logs", "body": "project-local backend job lifecycle evidence"},
				{"title": "Event Log", "body": "local task, tool, memory, and terminal timeline"},
				{"title": "Safety", "body": "read-only aggregation; no commands or agents"},
			],
		}
	if building_id == "terminal-control":
		return {
			"building_id": "terminal-control",
			"room_title": "Terminal Control Room",
			"npc": "Shell Warden",
			"atmosphere": "sealed command consoles, confirm gates, stdout scrolls, and log crystals",
			"workbench": "Allowlisted Command Console",
			"cards": [
				{"title": "Terminal Jobs", "body": "allowlisted project-local commands only"},
				{"title": "Preview Cmd", "body": "dry-run argv, cwd, timeout, and safety effects"},
				{"title": "Run Command", "body": "confirmation phrase and async job"},
				{"title": "Next Log", "body": "cycle recent command logs"},
				{"title": "Open Log", "body": "bounded stdout and stderr evidence"},
			],
		}
	if building_id == "permission-hall":
		return {
			"building_id": "permission-hall",
			"room_title": "Permission Hall",
			"npc": "Gate Archivist",
			"atmosphere": "sealed ledgers, confirmation sigils, write-scope maps, and receipt bells",
			"workbench": "Safety Receipt Ledger",
			"cards": [
				{"title": "Permissions", "body": "safety classes and confirmation gates"},
				{"title": "Write Scopes", "body": "project-local folders and allowlisted roots"},
				{"title": "Receipts", "body": "recent commands, writes, tools, and model tests"},
				{"title": "Secret Audit", "body": "bounded no-secret cache and log exposure counts"},
				{"title": "Blocked Actions", "body": "destructive and external writes stay gated"},
			],
		}
	if building_id == "settings-center":
		return {
			"building_id": "settings-center",
			"room_title": "Settings Center",
			"npc": "Config Keeper",
			"atmosphere": "registry shelves, launcher plaques, env scrolls, and schema health gauges",
			"workbench": "Configuration Review Desk",
			"cards": [
				{"title": "Settings", "body": "registries, launchers, workspace roots, and env requirements"},
				{"title": "Registry Health", "body": "read-only JSON shape validation for nine active registries"},
				{"title": "Draft Config", "body": "project-local review drafts only"},
				{"title": "Safety", "body": "no registry edits, launcher edits, secret display, or process changes"},
			],
		}
	if building_id == "model-market":
		return {
			"building_id": "model-market",
			"room_title": "Model Market",
			"npc": "DeepSeek",
			"atmosphere": "proxy crystals, sealed key boxes, model scrolls, and no-secret status boards",
			"workbench": "Model Gateway",
			"cards": [
				{"title": "Model Status", "body": "configured/missing provider readiness"},
				{"title": "Model Profiles", "body": "registry-driven OpenAI-compatible routes"},
				{"title": "Key Vault", "body": "encrypted local keys with fingerprints only"},
				{"title": "Config Draft", "body": "placeholder env templates only"},
				{"title": "Test Profile", "body": "dry-run readiness reports with memory events"},
				{"title": "Dialogue Route", "body": "NPC chat uses active model gateway profile"},
			],
		}
	if building_id == "github-harbor":
		return {
			"building_id": "github-harbor",
			"room_title": "GitHub Harbor",
			"npc": "Harbor Master",
			"atmosphere": "dock ledgers, remote flags, issue buoys, and sealed release crates",
			"workbench": "GitHub Readiness Dock",
			"cards": [
				{"title": "Harbor Repos", "body": "bounded local Git remotes and tags"},
				{"title": "Harbor Detail", "body": "branches, commits, and release-note draft text"},
				{"title": "GH Status", "body": "read-only GitHub CLI repo, issue, and release snapshot"},
				{"title": "Publish Ready", "body": "read-only branch, remote, dirty, and verification checks"},
				{"title": "PR Plan", "body": "confirm-gated project-local publish review plan"},
				{"title": "Harbor Draft", "body": "project-local PR/issue/release handoff drafts"},
				{"title": "Safety", "body": "no stage, commit, tag, push, PR, issue, or release write"},
			],
		}
	if building_id == "paper-reading-room":
		return {
			"building_id": "paper-reading-room",
			"room_title": "Paper Reading Room",
			"npc": "Citation Keeper",
			"atmosphere": "quiet paper desks, citation lanterns, PDF scrolls, and BibTeX drawers",
			"workbench": "Literature Audit Desk",
			"cards": [
				{"title": "Papers", "body": "bounded local PDF, BibTeX, manuscript, and note map"},
				{"title": "Cite Audit", "body": "bounded BibTeX duplicate and missing-field report"},
				{"title": "Cite Note", "body": "project-local citation hygiene review note"},
				{"title": "PDF Extract", "body": "async bounded PDF text report under workspace"},
				{"title": "Check PDF", "body": "poll backend extraction job and show text preview"},
				{"title": "Read Note", "body": "project-local claim/evidence reading notes"},
				{"title": "Safety", "body": "no bibliography edits, downloads, search APIs, or research mutation"},
			],
		}
	if building_id == "automation-factory":
		return {
			"building_id": "automation-factory",
			"room_title": "Automation Factory",
			"npc": "Clockwork Planner",
			"atmosphere": "clockwork benches, script drawers, scheduler gauges, and sealed activation levers",
			"workbench": "Automation Planning Bench",
			"cards": [
				{"title": "Automations", "body": "project script catalog plus scheduler sample"},
				{"title": "Schedule", "body": "read-only Windows Scheduled Tasks snapshot"},
				{"title": "Draft Auto", "body": "project-local automation blueprints"},
				{"title": "Jobs", "body": "backend job queue context only"},
				{"title": "Safety", "body": "no scheduler install, run, disable, delete, or service stop"},
			],
		}
	if building_id == "backup-station":
		return {
			"building_id": "backup-station",
			"room_title": "Backup Station",
			"npc": "Vault Keeper",
			"atmosphere": "snapshot vaults, restore maps, checksum lanterns, and sealed backup plans",
			"workbench": "Restore Safety Desk",
			"cards": [
				{"title": "Backups", "body": "source and target folder snapshots"},
				{"title": "Backup Check", "body": "read-only metadata and small-file SHA-256 samples"},
				{"title": "Backup Plan", "body": "project-local restore plan drafts"},
				{"title": "Targets", "body": "D:\\Backups, workspace staging, devtools backups"},
				{"title": "Safety", "body": "no copy, delete, compress, restore, upload, schedule, or prune"},
			],
		}
	if building_id == "download-station":
		return {
			"building_id": "download-station",
			"room_title": "Download Station",
			"npc": "Import Clerk",
			"atmosphere": "parcel shelves, intake stamps, quarantine labels, and asset crates",
			"workbench": "Download Intake Desk",
			"cards": [
				{"title": "Downloads", "body": "allowlisted download and import roots"},
				{"title": "Triage", "body": "read-only risk flags, routes, and small-file hashes"},
				{"title": "Intake Draft", "body": "project-local routing notes"},
				{"title": "Routes", "body": "assets, docs, archive review, manual security review"},
				{"title": "Safety", "body": "no move, open, delete, install, extract, execute, or fetch"},
			],
		}
	if building_id == "asset-gallery":
		return {
			"building_id": "asset-gallery",
			"room_title": "Asset Resource Gallery",
			"npc": "Palette Curator",
			"atmosphere": "framed screenshots, source-art drawers, color swatches, and style seals",
			"workbench": "Visual Asset Desk",
			"cards": [
				{"title": "Asset Gallery", "body": "runtime assets, source art, screenshots, and notes"},
				{"title": "Inspect Asset", "body": "read-only hash and image dimension metadata"},
				{"title": "Asset Note", "body": "project-local curation and source-trace notes"},
				{"title": "Style Contract", "body": "warm storybook pixel-handpainted baseline"},
				{"title": "Safety", "body": "no edit, move, copy, import, optimize, generate, or publish"},
			],
		}
	if building_id == "version-release-plaza":
		return {
			"building_id": "version-release-plaza",
			"room_title": "Version Release Plaza",
			"npc": "Release Steward",
			"atmosphere": "banner boards, changelog tables, screenshot frames, and sealed GitHub gates",
			"workbench": "Release Readiness Desk",
			"cards": [
				{"title": "Artifacts", "body": "README, license, roadmap, security, and contribution files"},
				{"title": "Git Snapshot", "body": "branch, remotes, tags, and dirty state disclosed only"},
				{"title": "Slice Proofs", "body": "Testing Arena evidence linked into release reports"},
				{"title": "Rel Report", "body": "project-local readiness report with safety receipts"},
				{"title": "Safety", "body": "no stage, commit, tag, push, PR, release, or remote change"},
			],
		}
	var def := _building_def(building_id)
	var scene: Dictionary = room_scene_defs.get(building_id, {})
	var chains: Array = npc_quest_defs.get(building_id, [])
	var npc_name := str(def.get("agent", "Guide"))
	if not chains.is_empty() and typeof(chains[0]) == TYPE_DICTIONARY:
		npc_name = str(chains[0].get("npc", npc_name))
	var room_title := str(def.get("name", building_id))
	if not scene.is_empty():
		room_title = str(scene.get("title", room_title))
	return {
		"building_id": building_id,
		"room_title": room_title,
		"npc": npc_name,
		"atmosphere": str(scene.get("ambient", "registry-driven local work room")),
		"workbench": str(scene.get("floor_label", "Safe Local Workbench")),
		"cards": [
			{"title": "Registry Room", "body": "loaded from godot/data/room_scenes.json"},
			{"title": "NPC Chain", "body": "loaded from godot/data/npc_quests.json"},
			{"title": "Safe Actions", "body": "station hotspots call bound Godot actions only"},
			{"title": "Visual QA", "body": "captured through AGENT_TOWN_CAPTURE_ROOM"},
		],
	}

func _enter_desktop_ui_test_room() -> void:
	active_building_id = "testing-arena"
	current_room_id = "testing-arena"
	desktop_test_button = null
	var def := _building_def(active_building_id)
	camera.zoom = Vector2(1.0, 1.0)
	target_position = def.pos + Vector2(0, def.size.y / 2.0 + 80.0)
	room_overlay.visible = true
	room_title.text = "%s Interior" % def.name
	detail_title.text = def.name
	detail_body.text = "[b]Desktop UI test[/b]\nWindow-scoped automation target is ready."
	room_body.text = "[b]Desktop UI test ready[/b]\nClick Review Shelves to verify a real desktop click changes the room state."
	_render_room({
		"building_id": "testing-arena",
		"room_title": "Testing Arena",
		"npc": "Codex",
		"atmosphere": "a stable local test stage for screenshot and click automation",
		"workbench": "Desktop UI Harness",
		"cards": [
			{"title": "Before", "body": "capture the focused Godot window"},
			{"title": "Click", "body": "press Review Shelves inside the window"},
			{"title": "After", "body": "capture and compare visual state"},
			{"title": "Marker", "body": "write a local state proof file"},
		],
	})
	_add_desktop_ui_test_button()
	_write_desktop_ui_test_state("ready")

func _add_desktop_ui_test_button() -> void:
	desktop_test_button = Button.new()
	desktop_test_button.text = "Click"
	desktop_test_button.position = Vector2(392, 62)
	desktop_test_button.size = Vector2(138, 36)
	desktop_test_button.tooltip_text = "Desktop UI test target"
	desktop_test_button.pressed.connect(_desktop_ui_test_button_pressed)
	room_stage.add_child(desktop_test_button)

func _desktop_ui_test_button_pressed() -> void:
	if desktop_test_button != null:
		desktop_test_button.text = "Clicked"
		desktop_test_button.modulate = Color("#b8e0d2")
	room_body.text = "[b]Desktop UI test clicked[/b]\nThe visible test button received a real desktop click."
	_write_desktop_ui_test_state("desktop_click_received")

func _write_desktop_ui_test_state(event: String) -> void:
	var output_dir := ProjectSettings.globalize_path("res://../screenshots")
	DirAccess.make_dir_recursive_absolute(output_dir)
	var output_file := ProjectSettings.globalize_path("res://../screenshots/desktop-ui-state.json")
	var file := FileAccess.open(output_file, FileAccess.WRITE)
	if file == null:
		return
	var payload := {
		"event": event,
		"room_id": current_room_id,
		"window_title": ProjectSettings.get_setting("application/config/name", "Agent Town Godot"),
		"timestamp": Time.get_datetime_string_from_system(true),
	}
	file.store_string(JSON.stringify(payload, "\t"))

func _load_progress() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	accepted_quests = parsed.get("accepted_quests", {})
	completed_quests = parsed.get("completed_quests", {})
	quest_steps = parsed.get("quest_steps", {})
	earned_badges = parsed.get("earned_badges", {})
	daily_route_claims = parsed.get("daily_route_claims", {})
	daily_route_date = str(parsed.get("daily_route_date", ""))
	workflow_route_claims = parsed.get("workflow_route_claims", {})
	room_mastery = parsed.get("room_mastery", {})
	npc_chain_progress = parsed.get("npc_chain_progress", {})
	activity_log = parsed.get("activity_log", [])
	if typeof(activity_log) != TYPE_ARRAY:
		activity_log = []
	companion_roster = parsed.get("companion_roster", {})
	active_companion_id = str(parsed.get("active_companion_id", ""))
	_render_activity_log()

func _save_progress() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return
	var payload := {
		"accepted_quests": accepted_quests,
		"completed_quests": completed_quests,
		"quest_steps": quest_steps,
		"earned_badges": earned_badges,
		"daily_route_claims": daily_route_claims,
		"daily_route_date": daily_route_date,
		"workflow_route_claims": workflow_route_claims,
		"room_mastery": room_mastery,
		"npc_chain_progress": npc_chain_progress,
		"activity_log": activity_log,
		"companion_roster": companion_roster,
		"active_companion_id": active_companion_id,
		"current_room_id": current_room_id,
	}
	file.store_string(JSON.stringify(payload, "\t"))

func _render_daily_routes(data: Dictionary) -> void:
	for child in quest_list.get_children():
		child.queue_free()
	daily_routes.clear()
	active_daily_route_id = ""
	daily_route_date = str(data.get("date", Time.get_date_string_from_system(true)))
	var routes: Array = data.get("routes", [])
	var claims: Dictionary = daily_route_claims.get(daily_route_date, {})
	var lines := [
		"[b]Daily Routes[/b] %s" % daily_route_date,
		"%s" % data.get("safe_note", "Routes are safe local-work plans."),
		"Routes loaded: %s" % str(routes.size()),
	]
	for route in routes:
		if typeof(route) != TYPE_DICTIONARY:
			continue
		var route_id := str(route.get("id", ""))
		if route_id == "":
			continue
		daily_routes[route_id] = route
		var claimed := claims.has(route_id)
		var completed := _daily_route_is_completed(route_id)
		if active_daily_route_id == "" and claimed and not completed:
			active_daily_route_id = route_id
		var marker := _daily_route_marker(route_id)
		lines.append("%s %s - %s" % [marker, route.get("title", "Daily Route"), _daily_route_progress_summary(route_id)])
		var button := Button.new()
		button.text = "%s %s" % [marker, route.get("title", "Daily Route")]
		button.tooltip_text = "%s\nBuildings: %s\nSafety: %s" % [route.get("reward", ""), ", ".join(route.get("building_ids", [])), route.get("safety", "safe")]
		button.pressed.connect(func(id = route_id): _select_daily_route(id))
		quest_list.add_child(button)
	for route in routes:
		if active_daily_route_id != "":
			break
		if typeof(route) == TYPE_DICTIONARY:
			var route_id := str(route.get("id", ""))
			if route_id != "" and not claims.has(route_id):
				active_daily_route_id = route_id
				break
	if active_daily_route_id == "" and not routes.is_empty():
		for route in routes:
			if typeof(route) == TYPE_DICTIONARY:
				active_daily_route_id = str(route.get("id", ""))
				break
	quest_body.text = "\n".join(lines)
	daily_claim_button.disabled = active_daily_route_id == "" or claims.has(active_daily_route_id)
	_update_daily_route_buttons()
	if active_daily_route_id != "":
		_show_daily_route_detail(active_daily_route_id)
	_update_badge_case()

func _select_daily_route(route_id: String) -> void:
	if not daily_routes.has(route_id):
		return
	active_daily_route_id = route_id
	_show_daily_route_detail(route_id)
	var claims: Dictionary = daily_route_claims.get(daily_route_date, {})
	daily_claim_button.disabled = claims.has(route_id)
	_update_daily_route_buttons()

func _show_daily_route_detail(route_id: String) -> void:
	var route: Dictionary = daily_routes.get(route_id, {})
	if route.is_empty():
		return
	var next_stop := _daily_route_next_stop(route_id)
	if next_stop != "":
		_set_waypoint_for_building(next_stop, "Selected Daily Route next stop. Use Next Stop or walk there.")
	var lines := [
		"[b]%s[/b]" % route.get("title", "Daily Route"),
		"District: %s" % route.get("district_id", ""),
		"Buildings: %s" % ", ".join(route.get("building_ids", [])),
		"Companion: %s" % route.get("recommended_companion", ""),
		"Reward: %s" % route.get("reward", ""),
		"Safety: %s" % route.get("safety", ""),
		"Progress: %s" % _daily_route_progress_summary(route_id),
		"Next stop: %s" % _daily_route_next_stop_label(next_stop),
		"",
		"[b]Route Steps[/b]",
	]
	for step in route.get("steps", []):
		lines.append("- %s" % str(step))
	var signals: Array = route.get("status_signals", [])
	if not signals.is_empty():
		lines.append("")
		lines.append("[b]Status Signals[/b]")
		for route_signal in signals:
			lines.append("- %s" % str(route_signal))
	detail_title.text = "Daily Route"
	detail_body.text = "\n".join(lines)

func _claim_active_daily_route() -> void:
	if active_daily_route_id == "" or not daily_routes.has(active_daily_route_id):
		return
	if daily_route_date == "":
		daily_route_date = Time.get_date_string_from_system(true)
	if not daily_route_claims.has(daily_route_date) or typeof(daily_route_claims[daily_route_date]) != TYPE_DICTIONARY:
		daily_route_claims[daily_route_date] = {}
	var route: Dictionary = daily_routes[active_daily_route_id]
	daily_route_claims[daily_route_date][active_daily_route_id] = {
		"status": "claimed",
		"title": route.get("title", "Daily Route"),
		"claimed_at": Time.get_datetime_string_from_system(true),
		"completed_at": "",
		"district_id": route.get("district_id", ""),
		"building_ids": route.get("building_ids", []),
		"visited_buildings": {},
	}
	if current_room_id != "town":
		_mark_daily_route_visit(current_room_id, false)
	quest_body.text = "[b]Daily route claimed:[/b] %s\nSaved to this player profile for %s.\n\n%s" % [route.get("title", "Daily Route"), daily_route_date, route.get("reward", "")]
	_record_activity("Daily route claimed", str(route.get("title", "Daily Route")), "route")
	daily_claim_button.disabled = true
	_update_daily_route_buttons()
	_save_progress()
	_update_badge_case()

func _update_daily_route_buttons() -> void:
	if daily_next_button == null:
		return
	var has_claim := not _daily_route_claim(active_daily_route_id).is_empty()
	daily_next_button.disabled = active_daily_route_id == "" or not has_claim or _daily_route_next_stop(active_daily_route_id) == ""
	if daily_claim_button != null:
		var claims: Dictionary = daily_route_claims.get(daily_route_date, {})
		daily_claim_button.disabled = active_daily_route_id == "" or claims.has(active_daily_route_id)

func _daily_route_marker(route_id: String) -> String:
	if _daily_route_is_completed(route_id):
		return "[x]"
	var claims: Dictionary = daily_route_claims.get(daily_route_date, {})
	if claims.has(route_id):
		return "[*]"
	return "[ ]"

func _daily_route_claim(route_id: String) -> Dictionary:
	var claims = daily_route_claims.get(daily_route_date, {})
	if typeof(claims) != TYPE_DICTIONARY:
		return {}
	var claim = claims.get(route_id, {})
	if typeof(claim) != TYPE_DICTIONARY:
		return {}
	return claim

func _daily_route_is_completed(route_id: String) -> bool:
	return str(_daily_route_claim(route_id).get("status", "")) == "completed"

func _daily_route_progress_summary(route_id: String) -> String:
	var route: Dictionary = daily_routes.get(route_id, {})
	var building_ids: Array = route.get("building_ids", [])
	var claim := _daily_route_claim(route_id)
	if claim.is_empty():
		return "unclaimed | reward: %s" % route.get("reward", "")
	var visited = claim.get("visited_buildings", {})
	if typeof(visited) != TYPE_DICTIONARY:
		visited = {}
	var done := 0
	for building_id in building_ids:
		if visited.get(str(building_id), false):
			done += 1
	var status := str(claim.get("status", "claimed"))
	return "%s | buildings %s/%s" % [status, str(done), str(building_ids.size())]

func _daily_route_next_stop(route_id: String) -> String:
	var route: Dictionary = daily_routes.get(route_id, {})
	var building_ids: Array = route.get("building_ids", [])
	var claim := _daily_route_claim(route_id)
	if claim.is_empty() or str(claim.get("status", "")) == "completed":
		return ""
	var visited = claim.get("visited_buildings", {})
	if typeof(visited) != TYPE_DICTIONARY:
		visited = {}
	for building_id in building_ids:
		var building := str(building_id)
		if not visited.get(building, false):
			return building
	return ""

func _daily_route_next_stop_label(building_id: String) -> String:
	if building_id == "":
		return "route complete or not claimed"
	var def := _building_def(building_id)
	return "%s (%s)" % [def.get("name", building_id), building_id]

func _guide_to_daily_route_next_stop() -> void:
	if active_daily_route_id == "":
		return
	var building_id := _daily_route_next_stop(active_daily_route_id)
	if building_id == "":
		_show_daily_route_detail(active_daily_route_id)
		_update_daily_route_buttons()
		return
	var def := _building_def(building_id)
	active_building_id = building_id
	room_button.disabled = false
	action_button.disabled = false
	_set_waypoint_for_building(building_id, "Daily Route next stop. Press Enter Room to record the visit.")
	target_position = def.get("pos", target_position) + Vector2(0, def.get("size", Vector2.ZERO).y / 2.0 + 72.0)
	camera.zoom = Vector2(0.95, 0.95)
	detail_title.text = "Route Guide"
	detail_body.text = "[b]Next stop:[/b] %s\n%s\n\nPress Enter Room to record this Daily Route stop." % [def.get("name", building_id), def.get("role", "local work building")]
	quest_body.text = "[b]Daily route guide[/b]\n%s\nNext stop: %s" % [daily_routes.get(active_daily_route_id, {}).get("title", "Daily Route"), _daily_route_next_stop_label(building_id)]

func _daily_route_badge_lines() -> Array:
	var today := daily_route_date
	if today == "":
		today = Time.get_date_string_from_system(true)
	var claims = daily_route_claims.get(today, {})
	if typeof(claims) != TYPE_DICTIONARY:
		return []
	var lines := []
	for route_id in claims.keys():
		var claim = claims[route_id]
		if typeof(claim) != TYPE_DICTIONARY:
			continue
		lines.append("%s: %s" % [claim.get("title", route_id), claim.get("status", "claimed")])
	return lines

func _mark_daily_route_visit(building_id: String, show_message: bool = true) -> void:
	if daily_route_date == "":
		daily_route_date = Time.get_date_string_from_system(true)
	var claims = daily_route_claims.get(daily_route_date, {})
	if typeof(claims) != TYPE_DICTIONARY:
		return
	var changed := false
	for route_id in claims.keys():
		var claim = claims[route_id]
		if typeof(claim) != TYPE_DICTIONARY:
			continue
		if str(claim.get("status", "")) == "completed":
			continue
		var route: Dictionary = daily_routes.get(str(route_id), {})
		var building_ids: Array = route.get("building_ids", claim.get("building_ids", []))
		if not building_ids.has(building_id):
			continue
		var visited = claim.get("visited_buildings", {})
		if typeof(visited) != TYPE_DICTIONARY:
			visited = {}
		if not visited.get(building_id, false):
			visited[building_id] = true
			claim["visited_buildings"] = visited
			changed = true
		if _daily_route_all_buildings_visited(building_ids, visited):
			_complete_daily_route(str(route_id), claim, route)
			changed = true
		if show_message and active_daily_route_id == str(route_id):
			quest_body.text = "[b]Daily route progress:[/b] %s\n%s" % [claim.get("title", route_id), _daily_route_progress_summary(str(route_id))]
	if changed:
		_record_activity("Daily route visit", _building_def(building_id).get("name", building_id), "route")
		_save_progress()
		_update_badge_case()
		_update_daily_route_buttons()
		if active_daily_route_id != "":
			_show_daily_route_detail(active_daily_route_id)

func _daily_route_all_buildings_visited(building_ids: Array, visited: Dictionary) -> bool:
	if building_ids.is_empty():
		return false
	for building_id in building_ids:
		if not visited.get(str(building_id), false):
			return false
	return true

func _complete_daily_route(route_id: String, claim: Dictionary, route: Dictionary) -> void:
	claim["status"] = "completed"
	claim["completed_at"] = Time.get_datetime_string_from_system(true)
	var badge_id := "daily-%s-%s" % [daily_route_date, route_id]
	earned_badges[badge_id] = {
		"name": "%s Complete" % claim.get("title", route.get("title", "Daily Route")),
		"collection": "Daily Routes",
		"quest": route.get("title", claim.get("title", route_id)),
	}
	detail_body.text += "\n\n[b]Daily route complete:[/b] %s" % claim.get("title", route_id)
	_record_activity("Daily route complete", str(claim.get("title", route_id)), "route")

func _render_quests(quests: Array) -> void:
	for child in quest_list.get_children():
		child.queue_free()
	quest_defs.clear()
	quest_body.text = "[b]Local work quests[/b]\nAccept one, visit its building, then run a safe scan.\nQuests loaded: %s" % str(quests.size())
	for quest in quests:
		if typeof(quest) != TYPE_DICTIONARY:
			continue
		var quest_id := str(quest.get("id", ""))
		quest_defs[quest_id] = quest
		var button := Button.new()
		var prefix := "%s: " % quest.get("giver", "Agent")
		if completed_quests.has(quest_id):
			prefix = "Done - "
			button.disabled = true
		elif accepted_quests.has(quest_id):
			prefix = "Active - "
			button.disabled = true
		button.text = "%s%s" % [prefix, quest.get("title", "Quest")]
		button.tooltip_text = "%s\nReward: %s\nSafety: %s\nNext: %s" % [quest.get("summary", ""), quest.get("reward", ""), quest.get("safety", ""), quest.get("next_hint", "")]
		button.pressed.connect(func(id = quest_id): _accept_quest(id))
		quest_list.add_child(button)
	_update_badge_case()

func _accept_quest(quest_id: String) -> void:
	if not quest_defs.has(quest_id):
		return
	accepted_quests[quest_id] = true
	var quest = quest_defs[quest_id]
	_advance_quest_step("accept", quest.get("target_building", ""), quest_id)
	quest_body.text = "[b]Accepted:[/b] %s\nChapter: %s\nTarget: %s\n%s\n\n%s" % [quest.get("title", "Quest"), quest.get("chapter", "Town Chapter"), quest.get("target_building", ""), quest.get("summary", ""), _quest_step_summary(quest_id)]
	_record_activity("Quest accepted", str(quest.get("title", "Quest")), "quest")
	for child in quest_list.get_children():
		if child is Button and child.text.contains(quest.get("title", "Quest")):
			child.text = "Active - %s" % quest.get("title", "Quest")
			child.disabled = true
	_save_progress()

func _advance_quest_step(step_id: String, building_id: String, forced_quest_id: String = "") -> void:
	for quest_id in accepted_quests.keys():
		if forced_quest_id != "" and quest_id != forced_quest_id:
			continue
		if completed_quests.has(quest_id):
			continue
		var quest = quest_defs.get(quest_id, {})
		if quest.get("target_building", "") != building_id and forced_quest_id == "":
			continue
		if not quest_steps.has(quest_id) or typeof(quest_steps[quest_id]) != TYPE_DICTIONARY:
			quest_steps[quest_id] = {}
		quest_steps[quest_id][step_id] = true
		quest_body.text = "[b]Quest progress:[/b] %s\n%s" % [quest.get("title", "Quest"), _quest_step_summary(quest_id)]
	_save_progress()

func _quest_step_summary(quest_id: String) -> String:
	var quest = quest_defs.get(quest_id, {})
	var done = quest_steps.get(quest_id, {})
	var lines := []
	for step in quest.get("steps", []):
		if typeof(step) != TYPE_DICTIONARY:
			continue
		var marker := "[ ]"
		if done.get(step.get("id", ""), false):
			marker = "[x]"
		lines.append("%s %s" % [marker, step.get("label", step.get("id", ""))])
	return "\n".join(lines)

func _quest_all_steps_done(quest_id: String) -> bool:
	var quest = quest_defs.get(quest_id, {})
	var done = quest_steps.get(quest_id, {})
	for step in quest.get("steps", []):
		if typeof(step) == TYPE_DICTIONARY and not done.get(step.get("id", ""), false):
			return false
	return true

func _check_quest_completion(building_id: String) -> void:
	for quest_id in accepted_quests.keys():
		if completed_quests.has(quest_id):
			continue
		var quest = quest_defs.get(quest_id, {})
		if quest.get("target_building", "") == building_id:
			if not _quest_all_steps_done(quest_id):
				quest_body.text = "[b]Quest not complete yet:[/b] %s\n%s" % [quest.get("title", "Quest"), _quest_step_summary(quest_id)]
				continue
			completed_quests[quest_id] = true
			var badge_id := str(quest.get("badge_id", quest_id))
			earned_badges[badge_id] = {
				"name": quest.get("reward", "Badge"),
				"collection": quest.get("collection", "Town Tools"),
				"quest": quest.get("title", "Quest"),
			}
			quest_body.text = "[b]Quest complete:[/b] %s\nReward gained: %s\nNext: %s" % [quest.get("title", "Quest"), quest.get("reward", "Badge"), quest.get("next_hint", "Keep exploring.")]
			detail_body.text += "\n\n[b]Quest complete:[/b] %s -> %s" % [quest.get("title", "Quest"), quest.get("reward", "Badge")]
			_record_activity("Quest complete", "%s -> %s" % [quest.get("title", "Quest"), quest.get("reward", "Badge")], "quest")
			_update_badge_case()
			_save_progress()

func _render_building_data(data: Dictionary) -> void:
	var lines := ["[b]%s[/b]" % data.get("name", active_building_id)]
	for key in data.keys():
		if key == "name":
			continue
		lines.append("[color=#4a3a2a]%s[/color]: %s" % [key, JSON.stringify(data[key])])
	detail_body.text = "\n".join(lines)

func _show_local_building_fallback(building_id: String) -> void:
	var def := _building_def(building_id)
	detail_body.text = "[b]%s[/b]\n%s\n\nBackend endpoint is not available yet. This building is reserved in the Godot world and will bind to the local work bridge." % [def.name, def.role]

func _building_def(building_id: String) -> Dictionary:
	for def in building_defs:
		if def.id == building_id:
			return def
	return {"id": building_id, "name": building_id, "role": "local workspace"}

func _agent_def(agent_id: String) -> Dictionary:
	for def in agent_defs:
		if str(def.get("id", "")) == agent_id:
			return def
	return {"id": agent_id, "name": agent_id, "role": "Agent", "zone": "Agent Hub"}

func _update_sprite_frame(sprite: Sprite2D, movement: Vector2) -> void:
	if sprite.texture == null:
		return
	var frame_w := sprite.texture.get_width() / 4.0
	var frame_h := sprite.texture.get_height() / 4.0
	var row := 0
	if abs(movement.x) > abs(movement.y):
		row = 2 if movement.x > 0.0 else 1
	else:
		row = 0 if movement.y > 0.0 else 3
	var col := int(Time.get_ticks_msec() / 160) % 4
	sprite.region_rect = Rect2(col * frame_w, row * frame_h, frame_w, frame_h)
