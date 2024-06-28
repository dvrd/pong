package builder

import "cmd"
import "core:fmt"
import "core:log"
import "core:os"
import "core:path/filepath"
import "core:strings"

PONG_SRC :: "src/app"
PONG_TARGET :: "target/debug/pong"
BASE_SRC :: "src"
BASE_TARGET :: "target/debug/base"

extra_linker_flags :: proc(with_raylib_dll := true) -> string {
	flags := make([dynamic]string)
	append(&flags, "-rpath", filepath.join({ODIN_ROOT, "vendor", "raylib", "macos-arm64"}))

	return fmt.tprintf("-extra-linker-flags:\"%s\"", strings.join(flags[:], " "))
}

build_pong :: proc() {
	if !os.exists("target") do os.make_directory("target")
	if !os.exists("target/debug") do os.make_directory("target/debug")

	args := make([dynamic]string)

	append(&args, "odin", "build")
	append(&args, PONG_SRC)
	append(&args, "-build-mode:dll")
	append(&args, "-debug")
	append(&args, "-define:RAYLIB_SHARED=true")
	append(&args, extra_linker_flags())
	append(&args, "-out:" + PONG_TARGET)
	log.debug("Building pong")
	log.debug(strings.join(args[:], " "))
	err := cmd.launch(args[:])
	if err != .ERROR_NONE {
		log.error("Failed compilation of " + PONG_SRC + " due to:", os.get_last_error_string())
		os.exit(1)
	}
	log.debug("Successfully compiled", PONG_TARGET)
}

build_base :: proc() {
	if !os.exists(PONG_TARGET) do build_pong()
	if !os.exists("target") do os.make_directory("target")
	if !os.exists("target/debug") do os.make_directory("target/debug")

	args := make([dynamic]string)

	append(&args, "odin", "build")
	append(&args, BASE_SRC)
	append(&args, "-debug")
	append(&args, "-out:" + BASE_TARGET)
	log.debug("Building app")
	log.debug(strings.join(args[:], " "))
	err := cmd.launch(args[:])
	if err != .ERROR_NONE {
		log.error("Failed compilation of src due to:", os.get_last_error_string())
		os.exit(1)
	}
	log.debug("Successfully compiled", BASE_TARGET)
}

run_app :: proc() {
	if !os.exists(BASE_TARGET) do build_base()

	log.debug("Executing pong at", BASE_TARGET)
	err := cmd.launch({BASE_TARGET})
	if err != .ERROR_NONE {
		log.error("Failed compilation of src due to:", os.get_last_error_string())
		os.exit(1)
	}
}

main :: proc() {
	context.logger = log.create_console_logger(opt = log.Options{.Level, .Terminal_Color})

	switch os.args[1] {
	case "app":
		build_pong()
	case "hmr":
		build_base()
	case "run":
		run_app()
	case:
		log.error("Invalid command")
		os.exit(1)
	}
}
