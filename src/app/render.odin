package pong

import rl "vendor:raylib"

render :: proc(app: ^State) {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	rl.DrawRectangleRec(app.paddle.pos, rl.WHITE)
	rl.DrawRectangleRec(app.ball.pos, rl.RED)

	rl.DrawFPS(10, 10)

	rl.ClearBackground(rl.BLACK)
}
