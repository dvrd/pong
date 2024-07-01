package pong

import "core:log"
import "core:math/linalg"
import rl "vendor:raylib"

update :: proc(using app: ^State) {
	if rl.IsKeyDown(.UP) {
		paddle.pos.y -= paddle.speed
	}
	if rl.IsKeyDown(.DOWN) {
		paddle.pos.y += paddle.speed
	}

	paddle.pos.y = linalg.clamp(paddle.pos.y, 0, window.y - paddle.pos.height)

	next_ball := ball.pos
	next_ball.y += ball.speed * ball.dir.y
	next_ball.x += ball.speed * ball.dir.x

	if next_ball.y >= window.y - ball.pos.height || next_ball.y <= 0 {
		ball.dir.y *= -1 // flips -1 to 1 or 1 to -1
	}

	if next_ball.x >= window.x - ball.pos.width || next_ball.x <= 0 {
		ball.dir.x *= -1 // flips -1 to 1 or 1 to -1
	}

	if rl.CheckCollisionRecs(next_ball, paddle.pos) {
		ball_center := rl.Vector2 {
			next_ball.x + ball.pos.width / 2,
			next_ball.y + ball.pos.height / 2,
		}
		paddle_center := rl.Vector2 {
			paddle.pos.x + paddle.pos.width / 2,
			paddle.pos.y + paddle.pos.height / 2,
		}
		ball.dir = linalg.normalize0(ball_center - paddle_center)
	}

	ball.pos.y += ball.speed * ball.dir.y
	ball.pos.x += ball.speed * ball.dir.x
}
