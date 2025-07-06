local process = require("@lune/process")
local task = require("@lune/task")

-- local fflags_str = serde.encode("json", serde.decode("toml", fs.readFile("fflags.toml")))
local build_target = process.args[1]

local function spawn_process_threaded(process_name: string, ...: string): thread
	return task.spawn(
		process.exec,
		process_name,
		{ ... },
		{ stdio = "forward" :: "forward", env = { BUILD_MODE = "dev", GAME_PLACE_ID = "0" } }
	)
end

local function usage()
	print("usage:")
	print("\tdev <target>")
	print("\ttarget can be 'game' or 'menu'")
end

if build_target ~= "game" and build_target ~= "menu" then
	usage()
	return
end

if build_target == "game" then
	-- fs.copy("game", "build/game", true)

	spawn_process_threaded(
		"rojo",
		"sourcemap",
		"game.project.json",
		"--output=sourcemap.json",
		"--include-non-scripts",
		"--watch"
	)
	-- task.wait(0.1)
	-- spawn_process_threaded("blink", "game/net/main.blink --watch")
	-- task.wait(0.1)
	-- spawn_process_threaded("darklua", "process", "global/", "build/global/", "--watch")
	-- spawn_process_threaded("darklua", "process", "game/", "build/game/", "--watch")

	-- spawn_process_threaded("rojo", "serve", "game_build.project.json")
elseif build_target == "menu" then
	spawn_process_threaded("rojo", "sourcemap", "menu.project.json", "--output=sourcemap.json", "--watch")
	task.wait(0.1)
	spawn_process_threaded("blink", "menu/net/main.blink --watch")

	spawn_process_threaded("darklua", "process", "menu/", "build/menu/")
	spawn_process_threaded("rojo", "serve", "menu_build.project.json")
end
