package pong

import rl "vendor:raylib"

render :: proc(app: ^State) {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	rl.DrawRectangle(app.pos, 100, 180, 30, rl.WHITE)

	rl.DrawFPS(10, 10)

	rl.ClearBackground(rl.BLACK)
}
