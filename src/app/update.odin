package pong

import "core:log"
import rl "vendor:raylib"

update :: proc(app: ^State) {
	if rl.IsKeyDown(rl.KeyboardKey.A) {
		app.pos -= 10 // X -= Y is X = X - Y
	}
	if rl.IsKeyDown(rl.KeyboardKey.D) {
		app.pos += 10
	}
}
