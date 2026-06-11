$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$Godot = Join-Path $Root "tools\godot\Godot_v4.6.3-stable_win64_console.exe"

Write-Host "[smoke] Python compile"
Push-Location $Root
python -m py_compile backend\main.py
Pop-Location

Write-Host "[smoke] FastAPI endpoints"
Push-Location (Join-Path $Root "backend")
@'
from fastapi.testclient import TestClient
from pathlib import Path
import json
import re
import time
from main import app, JOBS, redact_secret_text

client = TestClient(app)
redacted_probe = redact_secret_text('OPENAI_API_KEY=sk-testSecretValue1234567890\nAUTH_TOKEN=abc123456789')
assert 'sk-testSecretValue' not in redacted_probe
assert 'OPENAI_API_KEY=[redacted-secret]' in redacted_probe
assert 'AUTH_TOKEN=[redacted-secret]' in redacted_probe
paths = [
    "/api/health",
    "/api/buildings/memory-library",
    "/api/buildings/skill-workshop",
    "/api/buildings/knowledge-tower",
    "/api/buildings/devtools-lab",
    "/api/buildings/town-hall",
    "/api/buildings/file-vault",
    "/api/buildings/research-hall",
    "/api/buildings/agent-hub",
    "/api/buildings/resource-market",
    "/api/workbench/quests",
    "/api/workbench/rooms/file-vault",
    "/api/system/events",
    "/api/permissions/overview",
    "/api/permissions/receipts",
    "/api/permissions/secret-audit",
    "/api/config/plugin-manifests",
    "/api/plugin-registry/manifests",
    "/api/plugin-registry/overview",
    "/api/testing-arena/overview",
    "/api/testing-arena/visual-manifest",
    "/api/version-release-plaza/overview",
    "/api/version-release-plaza/build-readiness",
    "/api/version-release-plaza/export-tool",
    "/api/version-release-plaza/packaged-launch",
    "/api/version-release-plaza/release-manifest",
    "/api/model-gateway/status",
    "/api/inventory",
]
for path in paths:
    response = client.get(path)
    assert response.status_code == 200, (path, response.status_code, response.text[:200])

automation = client.get("/api/automation-factory/overview").json()
assert automation["mode"] == "script-catalog-blueprints-scheduler-readonly"
assert "scheduler" in automation
scheduler = client.get("/api/automation-factory/scheduler").json()
assert scheduler["mode"] == "read-only-windows-scheduler-snapshot"
assert "does not create" in scheduler["safe_note"]
assert "tasks" in scheduler

backup_overview = client.get("/api/backup-station/overview").json()
assert backup_overview["mode"] == "read-only-backup-map-integrity-plus-plan-drafts"
assert "integrity" in backup_overview
backup_integrity = client.get("/api/backup-station/integrity?source_id=ai-town-project&limit=4").json()
assert backup_integrity["mode"] == "read-only-backup-integrity-snapshot"
assert backup_integrity["safety" if "safety" in backup_integrity else "status"] is not None
assert "copy, delete, compress" in backup_integrity["safe_note"]
assert "items" in backup_integrity

download_overview = client.get("/api/download-station/overview").json()
assert download_overview["mode"] == "read-only-download-triage-plus-intake-drafts"
assert "triage" in download_overview
download_triage = client.get("/api/download-station/triage?root_id=user-downloads&limit=4").json()
assert download_triage["mode"] == "read-only-download-triage"
assert "move, open, delete" in download_triage["safe_note"]
assert "items" in download_triage

collection_codex = client.get("/api/player/collection-codex").json()
assert collection_codex["mode"] == "read-only-collection-codex"
assert collection_codex["collection_count"] >= 6
assert collection_codex["item_count"] >= 10
assert "Godot local player save" in collection_codex["safe_note"]
collections_by_id = {collection["id"]: collection for collection in collection_codex["collections"]}
assert "workflow-routes" in collections_by_id
assert collections_by_id["workflow-routes"]["count"] >= 4

registry_health = client.get("/api/config/registry-health").json()
assert registry_health["mode"] == "read-only-schema-validation"
assert registry_health["status"] == "ok"
assert registry_health["registry_count"] >= 10
assert registry_health["error_count"] == 0
assert registry_health["missing_count"] == 0
assert "does not edit registry files" in registry_health["safe_note"]
assert any(item["id"] == "workflow-routes" for item in registry_health["registries"])
assert any(item["id"] == "plugin-manifests" for item in registry_health["registries"])

plugin_manifests = client.get("/api/plugin-registry/manifests").json()
assert plugin_manifests["mode"] == "read-only-typed-plugin-manifest-audit"
assert plugin_manifests["manifest_count"] >= 4
assert plugin_manifests["warning_count"] == 0
assert plugin_manifests["confirmation_required"] == "PLAN_PLUGIN_ACTIVATION"
plugin_overview = client.get("/api/plugin-registry/overview").json()
assert plugin_overview["manifest_count"] == plugin_manifests["manifest_count"]
assert plugin_overview["manifest_catalog"]["mode"] == "read-only-typed-plugin-manifest-audit"
response = client.post(
    "/api/plugin-registry/activation-plans",
    json={"manifest_id": "permission-secret-audit"},
)
assert response.status_code == 200, response.text
activation_gate = response.json()
assert activation_gate["status"] == "confirmation-required"
assert activation_gate["confirmation_required"] == "PLAN_PLUGIN_ACTIVATION"
assert activation_gate["safety"] == "activation-plan-only"

capability_atlas = client.get("/api/town/capability-atlas").json()
assert capability_atlas["mode"] == "read-only-building-capability-map"
assert capability_atlas["building_count"] >= 30
assert capability_atlas["connected_count"] >= 18
assert "does not scan new roots" in capability_atlas["safe_note"]
atlas_entries = {entry["id"]: entry for entry in capability_atlas["entries"]}
assert atlas_entries["code-workshop"]["has_real_connection"] is True
assert "/api/projects/{project_id}/context-pack" in atlas_entries["code-workshop"]["endpoints"]
assert "Git project discovery" in atlas_entries["code-workshop"]["capabilities"]
capability_detail = client.get("/api/town/capability-atlas/code-workshop").json()
assert capability_detail["mode"] == "read-only-building-capability-detail"
assert capability_detail["status"] == "ok"
assert capability_detail["entry"]["id"] == "code-workshop"
assert "does not scan new roots" in capability_detail["safe_note"]
town_hall = client.get("/api/buildings/town-hall").json()
assert town_hall["capability_count"] == capability_atlas["connected_count"]
assert town_hall["capability_atlas"]["mode"] == "read-only-building-capability-map"
workflow_routes = client.get("/api/town/workflow-routes").json()
assert workflow_routes["mode"] == "read-only-workflow-route-registry"
assert workflow_routes["status"] == "ok"
assert workflow_routes["route_count"] >= 4
assert workflow_routes["connected_building_count"] >= 10
assert workflow_routes["missing_buildings"] == []
assert "do not claim progress" in workflow_routes["safe_note"]
route_entries = {route["id"]: route for route in workflow_routes["routes"]}
assert "code-to-release-handoff" in route_entries
assert route_entries["code-to-release-handoff"]["step_count"] >= 4
workflow_detail = client.get("/api/town/workflow-routes/code-to-release-handoff").json()
assert workflow_detail["mode"] == "read-only-workflow-route-detail"
assert workflow_detail["status"] == "ok"
assert workflow_detail["route"]["id"] == "code-to-release-handoff"
assert workflow_detail["route"]["steps"][0]["has_real_connection"] is True
assert town_hall["workflow_route_count"] == workflow_routes["route_count"]
assert town_hall["workflow_routes"]["mode"] == "read-only-workflow-route-registry"

asset_overview = client.get("/api/asset-gallery/overview").json()
assert asset_overview["mode"] == "read-only-asset-curation-plus-notes"
assert "inspection" in asset_overview
asset_inspection = client.get("/api/asset-gallery/inspect").json()
assert asset_inspection["mode"] == "read-only-asset-inspection"
assert asset_inspection["safety"] == "asset-inspection-read-only"
assert "edit, move, delete" in asset_inspection["safe_note"]

visual_manifest = client.get("/api/testing-arena/visual-manifest").json()
assert visual_manifest["mode"] == "read-only-room-visual-manifest-audit"
assert visual_manifest["status"] == "ok"
assert visual_manifest["coverage_ok"] is True
assert visual_manifest["registry_room_count"] >= 35
assert visual_manifest["entry_count"] == visual_manifest["registry_room_count"]
assert visual_manifest["valid_screenshot_count"] == visual_manifest["registry_room_count"]
assert visual_manifest["missing_file_count"] == 0
assert visual_manifest["hash_mismatch_count"] == 0
assert visual_manifest["small_file_count"] == 0
assert visual_manifest["min_bytes"] > 10000
assert "does not capture screenshots" in visual_manifest["safe_note"]

job_id = "smoke-cancel"
now = time.time()
JOBS[job_id] = {
    "id": job_id,
    "kind": "smoke-test",
    "label": "Smoke cancellable job",
    "status": "queued",
    "safety": "read-only",
    "created_at": now,
    "updated_at": now,
    "result": None,
    "error": "",
    "events": [],
    "cancel_requested": False,
    "cancelable": True,
    "rollback_note": "No rollback needed yet.",
}
try:
    response = client.post(
        f"/api/jobs/{job_id}/cancel",
        json={"reason": "smoke test", "source_building": "system-monitor"},
    )
    assert response.status_code == 200, response.text
    cancelled = response.json()
    assert cancelled["job"]["status"] == "cancelled"
    assert "no rollback" in cancelled["job"]["rollback_note"].lower()
    assert "log_path" in cancelled["job"]
    assert Path(cancelled["job"]["log_path"]).exists()
    job_events = client.get(f"/api/jobs/{job_id}/events?since=0&limit=2").json()
    assert job_events["mode"] == "read-only-backend-job-events"
    assert job_events["status"] == "cancelled"
    assert job_events["event_count"] >= 1
    assert job_events["returned"] >= 1
    assert job_events["next_cursor"] >= 1
    assert "does not replay jobs" in job_events["safe_note"]
    jobs = client.get("/api/system/jobs").json()
    assert "cancellation metadata" in jobs["safe_note"]
    assert "persistent job logs" in jobs["safe_note"]
    assert jobs["persistent_log_count"] >= 1
    job_logs = client.get("/api/system/job-logs").json()
    assert job_logs["mode"] == "read-only-backend-job-log-index"
    assert job_logs["count"] >= 1
    assert "does not replay jobs" in job_logs["safe_note"]
    log_id = Path(cancelled["job"]["log_path"]).stem
    log_detail = client.get(f"/api/system/job-logs/{log_id}").json()
    assert log_detail["mode"] == "read-only-backend-job-log-detail"
    assert log_detail["status"] == "ok"
    assert log_detail["job"]["status"] == "cancelled"
    assert log_detail["event_count"] >= 1
    assert "does not replay jobs" in log_detail["safe_note"]
finally:
    JOBS.pop(job_id, None)

persisted_events = client.get(f"/api/jobs/{job_id}/events?since=0&limit=2").json()
assert persisted_events["mode"] == "read-only-backend-job-events"
assert persisted_events["source"] == "persistent-log"
assert persisted_events["status"] == "cancelled"
assert persisted_events["event_count"] >= 1

quests = client.get("/api/workbench/quests").json()["quests"]
assert len(quests) >= 5
assert all("badge_id" in quest and "next_hint" in quest for quest in quests)
assert all(len(quest.get("steps", [])) >= 4 for quest in quests)
npc_chains = client.get("/api/config/npc-quests").json()
assert npc_chains["count"] >= 35
assert sum(len(chain.get("stages", [])) for chain in npc_chains["chains"]) >= 140
room_scenes = client.get("/api/config/room-scenes").json()
assert room_scenes["count"] >= 35
assert room_scenes["station_count"] >= 141
assert {"download-station", "backup-station", "inspiration-station", "local-office-center", "schedule-plan-center", "learning-training-grounds", "language-learning-area", "research-data-center", "version-release-plaza", "system-monitor", "permission-hall", "settings-center", "task-board", "writing-studio", "automation-factory", "bug-clinic", "project-management-hall", "asset-gallery", "skill-workshop", "devtools-lab", "town-hall", "plugin-registry", "goal-tower", "temporary-draft-box"}.issubset({scene["id"] for scene in room_scenes["scenes"]})

project_root = Path("..").resolve()
scene_registry = json.loads((project_root / "godot" / "data" / "room_scenes.json").read_text(encoding="utf-8"))
npc_registry = json.loads((project_root / "godot" / "data" / "npc_quests.json").read_text(encoding="utf-8"))
main_gd = (project_root / "godot" / "scripts" / "Main.gd").read_text(encoding="utf-8")
action_match = re.search(r"func _run_room_scene_action\(action_id: String\) -> void:(.*?)(?:\nfunc _add_stage_rect|\Z)", main_gd, re.S)
assert action_match, "Missing _run_room_scene_action block in Godot client"
bound_actions = set(re.findall(r'^\s*"([^"]+)":\s*$', action_match.group(1), re.M))
scene_ids = [scene["id"] for scene in scene_registry]
chain_building_ids = [chain["building_id"] for chain in npc_registry]
assert len(scene_ids) == len(set(scene_ids)), "Duplicate room scene ids"
assert len(chain_building_ids) == len(set(chain_building_ids)), "Duplicate NPC chain building ids"
assert set(scene_ids) == set(chain_building_ids), sorted(set(scene_ids) ^ set(chain_building_ids))
room_actions = set()
for scene in scene_registry:
    stations = scene.get("stations", [])
    assert len(stations) >= 3, scene["id"]
    station_ids = [station["id"] for station in stations]
    assert len(station_ids) == len(set(station_ids)), f"Duplicate station id in {scene['id']}"
    for station in stations:
        action = station.get("action")
        assert action, f"Missing action in {scene['id']}:{station.get('id')}"
        room_actions.add(action)
        x, y = int(station.get("x", -1)), int(station.get("y", -1))
        w, h = int(station.get("w", 0)), int(station.get("h", 0))
        assert 0 <= x <= 580 and 0 <= y <= 210 and w > 0 and h > 0, f"Bad station bounds in {scene['id']}:{station.get('id')}"
        assert x + w <= 580 and y + h <= 210, f"Station exceeds room stage in {scene['id']}:{station.get('id')}"
npc_actions = set()
for chain in npc_registry:
    stages = chain.get("stages", [])
    assert len(stages) >= 4, chain["building_id"]
    stage_ids = [stage["id"] for stage in stages]
    assert len(stage_ids) == len(set(stage_ids)), f"Duplicate stage id in {chain['building_id']}"
    for stage in stages:
        action = stage.get("action")
        assert action, f"Missing NPC action in {chain['building_id']}:{stage.get('id')}"
        npc_actions.add(action)
missing_actions = sorted((room_actions | npc_actions) - bound_actions)
assert not missing_actions, f"Godot room actions missing bindings: {missing_actions}"
assert "No station action is bound yet." in action_match.group(1)

response = client.post(
    "/api/workbench/action",
    json={"action_id": "scan-current-building", "building_id": "file-vault"},
)
assert response.status_code == 200, response.text
assert response.json()["safety"] == "read-only"

roots = client.get("/api/file-vault/roots").json()["roots"]
root = next(root for root in roots if root.get("exists"))
file_index = client.get("/api/file-vault/index").json()
assert file_index["mode"] == "allowlisted-incremental-file-index-cache"
assert file_index["incremental_summary"]["strategy"] == "mtime-size-id-diff"
assert "reused_count" in file_index["incremental_summary"]
response = client.get("/api/file-vault/organize-audit")
assert response.status_code == 200, response.text
file_organize_audit = response.json()
assert file_organize_audit["mode"] == "cached-file-organization-audit"
assert file_organize_audit["source"] == "file-vault-cache"
assert "scan live folders" in file_organize_audit["safe_note"] or "cached File Vault index" in file_organize_audit["safe_note"]
assert "group_counts" in file_organize_audit
assert "duplicate_names" in file_organize_audit
assert "safe_next_steps" in file_organize_audit or file_organize_audit["status"] == "index-missing"
response = client.post(
    "/api/file-vault/open",
    json={"root_id": root["id"], "path": "", "mode": "reveal", "dry_run": True},
)
assert response.status_code == 200, response.text
file_open = response.json()
assert file_open["status"] == "dry-run"
assert file_open["safety"] == "allowlisted-local-open-no-file-mutation"
assert file_open["root_id"] == root["id"]
assert file_open["dry_run"] is True

response = client.post(
    "/api/model-gateway/chat",
    json={"dry_run": True, "system_prompt": "route check", "user_prompt": "hello"},
)
assert response.status_code == 200, response.text
model_route = response.json()
assert model_route["status"] == "dry-run"
assert "endpoint" in model_route
assert "api_key" not in str(model_route).lower()

response = client.post(
    "/api/model-gateway/profile-tests",
    json={"profile_id": "deepseek-chat", "live_probe": False},
)
assert response.status_code == 200, response.text
profile_test = response.json()
assert profile_test["status"] == "recorded"
assert profile_test["test_status"] == "dry-run"
assert profile_test["live_probe"] is False
assert "api_key" not in str(profile_test).lower()
assert "report_path" in profile_test

vault_status = client.get("/api/model-gateway/key-vault").json()
assert vault_status["mode"] == "encrypted-local-key-vault"
assert vault_status["confirmation_required"] == "SAVE_API_KEY"
assert "entries" in vault_status
fake_secret = "ai-town-smoke-placeholder-key-not-written"
response = client.post(
    "/api/model-gateway/key-vault",
    json={"profile_id": "anthropic-compatible", "key_value": fake_secret, "dry_run": True, "source_building": "model-market"},
)
assert response.status_code == 200, response.text
vault_dry_run = response.json()
assert vault_dry_run["status"] == "dry-run"
assert vault_dry_run["confirmation_required"] == "SAVE_API_KEY"
assert vault_dry_run["safety"] == "confirm-required-encrypted-local-secret"
assert fake_secret not in str(vault_dry_run)

response = client.post(
    "/api/memory/proposals",
    json={
        "title": "AI Town smoke memory promotion proposal",
        "body": "Smoke-test proposal for the confirm-required Memory Library promotion gate.",
        "category": "sessions",
        "tags": "ai-town,smoke,memory-promotion",
        "source_building": "memory-library",
    },
)
assert response.status_code == 200, response.text
proposal = response.json()
assert proposal["status"] == "saved"
assert proposal["proposal_id"]

response = client.post(
    "/api/memory/promotions",
    json={"proposal_id": proposal["proposal_id"], "source_building": "memory-library"},
)
assert response.status_code == 200, response.text
promotion_preview = response.json()
assert promotion_preview["status"] == "confirmation-required"
assert promotion_preview["confirmation_required"] == "PROMOTE_MEMORY"
assert promotion_preview["safety"] == "confirm-required-shared-memory-write"
assert "target_path" in promotion_preview

response = client.post(
    "/api/memory/promotions",
    json={"proposal_id": proposal["proposal_id"], "dry_run": True, "source_building": "memory-library"},
)
assert response.status_code == 200, response.text
promotion_dry_run = response.json()
assert promotion_dry_run["status"] == "dry-run"
assert promotion_dry_run["title"] == "AI Town smoke memory promotion proposal"

projects = client.get("/api/projects").json()["projects"]
project_id = projects[0]["id"]
assert projects[0]["path"].replace("\\", "/").endswith("/ai-town")
github_snapshot = client.get(f"/api/github-harbor/repos/{project_id}/github").json()
assert github_snapshot["safety"] == "read-only-gh-cli-no-write"
assert github_snapshot["mode"] == "read-only-github-cli-snapshot"
assert github_snapshot["status"] in {"ok", "auth-unavailable", "repo-unavailable", "gh-unavailable"}
assert "issues" in github_snapshot and "releases" in github_snapshot
publish_readiness = client.get(f"/api/github-harbor/repos/{project_id}/publish-readiness").json()
assert publish_readiness["mode"] == "read-only-github-publish-readiness"
assert publish_readiness["safety"] == "read-only-git-github-readiness"
assert publish_readiness["checks_total"] >= 5
assert publish_readiness["confirmation_required"] == "PLAN_GITHUB_PUBLISH"
response = client.post(
    f"/api/github-harbor/repos/{project_id}/publish-plans",
    json={"publish_type": "pull-request"},
)
assert response.status_code == 200, response.text
publish_gate = response.json()
assert publish_gate["status"] == "confirmation-required"
assert publish_gate["confirmation_required"] == "PLAN_GITHUB_PUBLISH"
assert publish_gate["safety"] == "github-publish-plan-only"
runner_readiness = client.get("/api/agent-runners/readiness").json()
assert runner_readiness["mode"] == "read-only-agent-runner-readiness"
assert runner_readiness["runner_count"] >= 7
assert "runners" in runner_readiness
readiness_blob = json.dumps(runner_readiness)
assert "sk-" not in readiness_blob.lower()
assert "OPENAI_API_KEY=[redacted-secret]" in readiness_blob or "OPENAI_API_KEY" not in readiness_blob
response = client.post(
    "/api/agent-runners/dispatch-preview",
    json={
        "target_agent": "codex",
        "task_title": "AI Town smoke runner handoff",
        "task_body": "Build a confirm-required handoff preview without launching a runner.",
        "source_building": "agent-hub",
        "dry_run": True,
    },
)
assert response.status_code == 200, response.text
runner_preview = response.json()
assert runner_preview["mode"] == "confirm-required-agent-runner-preview"
assert runner_preview["target_agent"] == "codex"
assert runner_preview["dry_run"] is True
assert runner_preview["handoff_path"].endswith(".md")

build_readiness = client.get("/api/version-release-plaza/build-readiness").json()
assert build_readiness["mode"] == "read-only-godot-build-readiness"
assert build_readiness["status"] == "ok"
assert build_readiness["checks_passed"] == build_readiness["checks_total"]
assert build_readiness["godot"]["main_scene"] == "res://scenes/main.tscn"
assert build_readiness["export"]["platform"] == "Windows Desktop"
assert build_readiness["export"]["runnable"] is True
assert build_readiness["export"]["embed_pck"] is True
assert build_readiness["missing_required_count"] == 0
assert "does not run exports" in build_readiness["safe_note"]
export_tool = client.get("/api/version-release-plaza/export-tool").json()
assert export_tool["mode"] == "read-only-godot-export-tool-audit"
assert export_tool["script_exists"] is True
assert export_tool["template_installer_exists"] is True
assert export_tool["report_exists"] is True
assert export_tool["status"] == "exported"
assert export_tool["blocker_count"] == 0
assert export_tool["output_exists"] is True
assert export_tool["output_bytes"] > 100000000
assert export_tool["check_count"] >= 9
assert "does not run exports" in export_tool["safe_note"]
assert "kill processes" in export_tool["safe_note"]
packaged_launch = client.get("/api/version-release-plaza/packaged-launch").json()
assert packaged_launch["mode"] == "read-only-packaged-launch-readiness"
assert packaged_launch["status"] == "ok"
assert packaged_launch["checks_passed"] == packaged_launch["checks_total"]
assert packaged_launch["launcher_exists"] is True
assert packaged_launch["game_exists"] is True
assert packaged_launch["game_bytes"] > 100000000
assert "does not run the launcher" in packaged_launch["safe_note"]
assert "kill processes" in packaged_launch["safe_note"]
release_manifest = client.get("/api/version-release-plaza/release-manifest").json()
assert release_manifest["mode"] == "read-only-release-package-manifest-audit"
assert release_manifest["status"] == "ok"
assert release_manifest["file_count"] >= 5
assert release_manifest["exe_exists"] is True
assert release_manifest["exe_bytes"] > 100000000
assert len(release_manifest["exe_sha256"]) == 64
assert release_manifest["missing_required_count"] == 0
assert release_manifest["hash_mismatch_count"] == 0
assert "does not run exports" in release_manifest["safe_note"]
assert "publish anything" in release_manifest["safe_note"]
assert "No external agent runner" in runner_preview["safe_note"]
assert "sk-" not in json.dumps(runner_preview).lower()
response = client.post(
    "/api/agent-runners/launch-jobs",
    json={
        "target_agent": "codex",
        "handoff_path": runner_preview["handoff_path"],
        "source_building": "agent-hub",
        "dry_run": True,
    },
)
assert response.status_code == 200, response.text
runner_launch_gate = response.json()
assert runner_launch_gate["mode"] == "confirm-required-agent-runner-launch"
assert runner_launch_gate["status"] == "confirmation-required"
assert runner_launch_gate["confirmation_required"] == "RUN_AGENT_RUNNER"
response = client.post(
    f"/api/projects/{project_id}/verification-jobs",
    json={"command_label": "python-compile", "source_building": "code-workshop"},
)
assert response.status_code == 200, response.text
project_check_preview = response.json()
assert project_check_preview["status"] == "confirmation-required"
assert project_check_preview["confirmation_required"] == "RUN_PROJECT_CHECK"
assert project_check_preview["command"]["label"] == "python-compile"
response = client.post(
    f"/api/projects/{project_id}/verification-jobs",
    json={"command_label": "python-compile", "dry_run": True, "source_building": "code-workshop"},
)
assert response.status_code == 200, response.text
project_check_dry_run = response.json()
assert project_check_dry_run["status"] == "dry-run"
assert project_check_dry_run["safety"] == "confirm-required-project-verification"
response = client.post(
    "/api/agent-tasks/submit",
    json={
        "target_agent": "codex",
        "task_type": "code-explain-brief",
        "title": f"AI Town smoke code explanation for {project_id}",
        "body": "Build a bounded read-only code explanation brief.",
        "source_building": "code-workshop",
        "parameters": {"project_id": project_id},
    },
)
assert response.status_code == 200, response.text
code_explain = response.json()["task"]
agent_queue = response.json()["queue"]
assert agent_queue["policy"]["mode"] == "safe-local-agent-task-concurrency-policy"
assert agent_queue["policy"]["max_running"] >= 1
assert code_explain["task_type"] == "code-explain-brief"
for _ in range(20):
    code_explain = client.get(f"/api/agent-tasks/{code_explain['id']}").json()["task"]
    if code_explain["status"] in {"done", "failed"}:
        break
    time.sleep(0.1)
assert code_explain["status"] == "done"
assert code_explain["result"]["kind"] == "code-explain-brief"
assert code_explain["result"]["entry_points"]
assert code_explain["log_path"]
policy = client.get("/api/agent-tasks/policy").json()
assert policy["mode"] == "safe-local-agent-task-concurrency-policy"
assert policy["env_var"] == "AI_TOWN_AGENT_TASK_MAX_RUNNING"
task_events = client.get(f"/api/agent-tasks/{code_explain['id']}/events").json()
assert any("concurrency policy" in event["message"].lower() for event in task_events["events"])
task_logs = client.get("/api/agent-tasks/logs?limit=8").json()
assert task_logs["mode"] == "read-only-agent-task-log-archive"
assert task_logs["returned"] <= 8
assert task_logs["logs"], "Expected at least one durable agent task log"
task_log_detail = client.get(f"/api/agent-tasks/logs/{task_logs['logs'][0]['log_id']}").json()
assert task_log_detail["mode"] == "read-only-agent-task-log-detail"
assert task_log_detail["event_count"] >= 1
assert "does not replay tasks" in task_log_detail["safe_note"]

response = client.post(
    "/api/agent-tools/invoke",
    json={
        "tool_id": "memory-index",
        "target_agent": "codex",
        "parameters": {"limit_per_category": 1},
        "source_building": "agent-hub",
    },
)
assert response.status_code == 200, response.text
tool_invocation = response.json()["invocation"]
for _ in range(20):
    tool_detail = client.get(f"/api/agent-tools/invocations/{tool_invocation['id']}").json()["invocation"]
    if tool_detail["status"] in {"done", "failed"}:
        break
    time.sleep(0.1)
assert tool_detail["status"] == "done"
tool_events = client.get(f"/api/agent-tools/invocations/{tool_invocation['id']}/events").json()
assert tool_events["event_count"] >= 1
tool_logs = client.get("/api/agent-tools/logs?limit=8").json()
assert tool_logs["mode"] == "read-only-agent-tool-log-archive"
assert tool_logs["returned"] <= 8
assert tool_logs["logs"], "Expected at least one durable agent tool log"
tool_log_detail = client.get(f"/api/agent-tools/logs/{tool_logs['logs'][0]['log_id']}").json()
assert tool_log_detail["mode"] == "read-only-agent-tool-log-detail"
assert tool_log_detail["event_count"] >= 1
assert "does not replay tools" in tool_log_detail["safe_note"]

response = client.post(
    "/api/agent-tasks/submit",
    json={
        "target_agent": "codex",
        "task_type": "memory-brief",
        "title": "AI Town smoke cancellable agent task",
        "body": "Create a paused task so Agent Hub cancellation can be audited.",
        "source_building": "agent-hub",
        "start_paused": True,
    },
)
assert response.status_code == 200, response.text
cancellable_task = response.json()["task"]
assert cancellable_task["status"] == "paused"
response = client.post(
    f"/api/agent-tasks/{cancellable_task['id']}/cancel",
    json={"reason": "smoke-test cancellation", "source_building": "agent-hub"},
)
assert response.status_code == 200, response.text
cancelled_task = response.json()["task"]
assert cancelled_task["status"] == "cancelled"
assert cancelled_task["cancel_requested"] is True
assert "external runner" in cancelled_task["rollback_note"]
events = client.get(f"/api/agent-tasks/{cancellable_task['id']}/events").json()
assert any("cancel" in event["message"].lower() for event in events["events"])

terminal_catalog = client.get("/api/terminal/commands").json()
assert terminal_catalog["mode"] == "allowlisted-confirm-required"
assert terminal_catalog["commands"]
assert terminal_catalog["commands"][0]["preview_status"] in {"preview", "blocked"}
terminal_preview = client.get("/api/terminal/commands/git-status-ai-town/preview").json()
assert terminal_preview["mode"] == "terminal-command-preview"
assert terminal_preview["status"] == "preview"
assert terminal_preview["cwd_allowed"] is True
assert terminal_preview["confirmation_required"] == "RUN_LOCAL_COMMAND"
assert terminal_preview["args"] == ["git", "status", "--short"]
assert "does not queue jobs" in terminal_preview["safe_note"]

permissions = client.get("/api/permissions/overview").json()
assert permissions["mode"] == "read-only-policy-ledger"
assert permissions["permission_receipts"]["mode"] == "read-only-local-safety-audit"
assert permissions["secret_audit"]["mode"] == "read-only-secret-exposure-audit"
receipts = client.get("/api/permissions/receipts?limit=5").json()
assert receipts["returned"] <= 5
assert "workspace/terminal-logs" in receipts["sources"]
secret_audit = client.get("/api/permissions/secret-audit?limit=12").json()
assert secret_audit["mode"] == "read-only-secret-exposure-audit"
assert secret_audit["returned"] <= 12
assert secret_audit["scanned_files"] >= 1
assert "knowledge-index" in [source["id"] for source in secret_audit["sources"]]
assert "openai_key" in secret_audit["pattern_counts"]
secret_audit_payload = json.dumps(secret_audit)
assert "sk-testSecretValue" not in secret_audit_payload
assert "abc123456789" not in secret_audit_payload

response = client.post(
    "/api/testing-arena/vertical-slice-proofs",
    json={"title": "AI Town smoke vertical slice proof"},
)
assert response.status_code == 200, response.text
proof = response.json()
assert proof["status"] == "saved"
assert proof["checks_total"] >= 10
assert proof["checks_passed"] >= 8
assert "report_path" in proof
proof_id = proof["report_path"].replace("\\", "/").split("/")[-1].removesuffix(".md")
proof_detail = client.get(f"/api/testing-arena/vertical-slice-proofs/{proof_id}").json()
assert proof_detail["status"] == "ok"
assert proof_detail["preview_chars"] > 100
missing_proof = client.get("/api/testing-arena/vertical-slice-proofs/not-a-real-proof").json()
assert missing_proof["status"] == "not-found"

release_overview = client.get("/api/version-release-plaza/overview").json()
assert "report_count" in release_overview
assert "vertical_slice_proof_count" in release_overview
response = client.post(
    "/api/version-release-plaza/reports",
    json={"title": "AI Town smoke release readiness report", "release_target": "local-preview"},
)
assert response.status_code == 200, response.text
release_report = response.json()
assert release_report["status"] == "saved"
assert release_report["safety"] == "release-readiness-report-only"
assert release_report["gates_total"] >= 6
assert release_report["gates_passed"] >= 5
assert Path(release_report["report_path"]).exists()

paper_overview = client.get("/api/paper-reading-room/overview").json()
assert paper_overview["mode"] == "bounded-paper-map-plus-local-reading-notes"
assert "parser" in paper_overview
assert paper_overview["citation_audit"]["mode"] == "read-only-citation-audit"
citation_audit = client.get("/api/paper-reading-room/citation-audit").json()
assert citation_audit["mode"] == "read-only-citation-audit"
assert "does not edit bibliographies" in citation_audit["safe_note"]
response = client.post(
    "/api/paper-reading-room/citation-audits",
    json={"dry_run": True, "source_building": "paper-reading-room"},
)
assert response.status_code == 200, response.text
citation_note = response.json()
assert citation_note["status"] == "dry-run"
assert citation_note["safety"] == "citation-audit-note-only"
response = client.post(
    "/api/paper-reading-room/extract-jobs",
    json={"dry_run": True, "max_pages": 2, "source_building": "paper-reading-room"},
)
assert response.status_code == 200, response.text
paper_extract = response.json()
assert paper_extract["safety"] == "bounded-pdf-extraction-report-only"
assert paper_extract["status"] in {"dry-run", "not-available"}
if paper_extract["status"] == "dry-run":
    assert paper_extract["candidate"]["kind"] == "paper-pdf"
    assert paper_extract["message"].startswith("Dry run only")

response = client.post(
    "/api/workbench/action",
    json={"action_id": "prepare-work-note", "building_id": "file-vault"},
)
assert response.status_code == 200, response.text
prepared = response.json()
assert prepared["status"] == "preview"
assert prepared["safety"] == "write-requires-confirmation"
assert prepared["confirmation_required"] == "SAVE_LOCAL_DRAFT"
assert "preview" in prepared and "target_path" in prepared

print("FastAPI smoke passed")
'@ | python -
Pop-Location

Write-Host "[smoke] Godot headless"
if (!(Test-Path $Godot)) {
    throw "Godot executable missing: $Godot"
}
& $Godot --headless --path (Join-Path $Root "godot") --quit

Write-Host "[smoke] Exported game headless"
$ExportedGame = Join-Path $Root "dist\ai-town\AI Town.exe"
if (!(Test-Path -LiteralPath $ExportedGame)) {
    throw "Missing exported game executable: $ExportedGame"
}
& $ExportedGame --headless --quit

Write-Host "[smoke] OK"
