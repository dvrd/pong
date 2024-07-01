package pong

import "core:c"
import "core:fmt"
import "core:math"
import "core:math/rand"
import rl "vendor:raylib"

EditMode :: enum {
	Normal,
	Insert,
}

Paddle :: struct {
	pos:   rl.Rectangle,
	speed: c.float,
}

Ball :: struct {
	pos:   rl.Rectangle,
	dir:   rl.Vector2,
	speed: c.float,
}

State :: struct {
	window: rl.Vector2,
	exit:   bool,
	paddle: Paddle,
	ball:   Ball,
}

application_state: ^State

reset :: proc(using app: ^State) {
	angle := rand.float32_range(-45, 46)
	r := math.to_radians(angle)

	ball.dir.x = math.cos(r)
	ball.dir.y = math.sin(r)

	ball.pos.x = window.x / 2 - ball.pos.width / 2
	ball.pos.y = window.y / 2 - ball.pos.height / 2

	paddle.pos.x = window.x - 80
	paddle.pos.y = window.y / 2 - paddle.pos.height / 2
}

@(export)
app_update :: proc() -> bool {
	update(application_state)
	render(application_state)
	return rl.WindowShouldClose() || application_state.exit
}

@(export)
app_init_window :: proc() {
	rl.InitWindow(
		cast(c.int)application_state.window.x,
		cast(c.int)application_state.window.y,
		"PONG",
	)
	rl.SetExitKey(.KEY_NULL)
	rl.SetTargetFPS(120)
}

@(export)
app_init :: proc() {
	application_state = new(State)
	application_state.window = {1280, 720}
	application_state.paddle.pos = rl.Rectangle {
		width  = 30,
		height = 80,
	}
	application_state.paddle.speed = 10
	application_state.ball.pos = rl.Rectangle {
		width  = 30,
		height = 30,
	}
	application_state.ball.dir = rl.Vector2{0, -1}
	application_state.ball.speed = 10
	reset(application_state)

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
