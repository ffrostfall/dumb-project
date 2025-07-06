local process = require("@lune/process")

local function sourcemap_for_game()
	process.exec("rojo", { "sourcemap", "game.project.json", "--output", "sourcemap.json" }, { stdio = "forward" })
end

local function sourcemap_for_packages()
	process.exec(
		"rojo",
		{ "sourcemap", "packages.project.json", "--output", "packages-sourcemap.json" },
		{ stdio = "forward" }
	)
end

return {
	game = sourcemap_for_game,

	packages = sourcemap_for_packages,
}
