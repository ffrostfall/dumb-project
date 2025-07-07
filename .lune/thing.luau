local process = require("@lune/process")

local function spawn_process(process_name: string, ...: string)
	process.exec(process_name, { ... }, { stdio = "forward" })
end

spawn_process("wally", "install")
spawn_process("wally-package-types", "--sourcemap", "sourcemap.json", "Packages")

spawn_process("rojo", "sourcemap", "default.project.json", "--output=sourcemap.json", "--include-non-scripts")
