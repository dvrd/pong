package pong

import "core:c"
import "core:fmt"
import "core:math/linalg"
import rl "vendor:raylib"

SCREEN :: [2]c.int{1280, 180}

EditMode :: enum {
	Normal,
	Insert,
}

State :: struct {
	exit: bool,
	pos:  i32,
}

application_state: ^State

@(export)
app_update :: proc() -> bool {
	update(application_state)
	render(application_state)
	return rl.WindowShouldClose() || application_state.exit
}

@(export)
app_init_window :: proc() {
	rl.InitWindow(SCREEN.x, SCREEN.y, "PONG")
	rl.SetExitKey(.KEY_NULL)
	rl.SetTargetFPS(120)
}

@(export)
app_init :: proc() {
	application_state = new(State)

	application_state^ = State {
		pos = 100,
	}

	app_hot_reloaded(application_state)
}

@(export)
app_shutdown :: proc() {
	free(application_state)
}

@(export)
app_shutdown_window :: proc() {
	rl.CloseWindow()
}

@(export)
app_state :: proc() -> rawptr {
	return application_state
}

@(export)
app_state_size :: proc() -> int {
	return size_of(State)
}

@(export)
app_hot_reloaded :: proc(app: rawptr) {
	application_state = (^State)(app)
}

@(export)
app_force_reload :: proc() -> bool {
	return rl.IsKeyPressed(.F5)
}

@(export)
app_force_restart :: proc() -> bool {
	return rl.IsKeyPressed(.F6)
}
