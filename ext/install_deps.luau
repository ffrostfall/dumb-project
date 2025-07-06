local fs = require("@lune/fs")
local process = require("@lune/process")
local sourcemap = require("@ext/sourcemap")

local STDIO_FORWARD: process.ExecOptions = { stdio = "forward" :: "forward" }

local function spawn_process(process_name: string, ...: string)
	process.exec(process_name, { ... }, STDIO_FORWARD)
end

local function does_server_packages_exist(): boolean
	return fs.isDir("ServerPackages")
end

local function pull_deps(install_dev_packages: boolean?)
	print("Cloning git repositories")
	spawn_process("git", "clone", "https://github.com/ffrostfall/lunePackages.git", "vendor/lunePackagesRepo")

	print("Copying repositories to vendor")
	if fs.isDir("vendor/lunePackages") then
		fs.removeDir("vendor/lunePackages")
	end
	fs.copy("vendor/lunePackagesRepo", "vendor/lunePackages")

	fs.removeDir("vendor/lunePackagesRepo")

	spawn_process("wally", "install")

	sourcemap.packages()

	spawn_process("wally-package-types", "--sourcemap", "packages-sourcemap.json", "Packages")

	if does_server_packages_exist() then
		spawn_process("wally-package-types", "--sourcemap", "packages-sourcemap.json", "ServerPackages")
	end

	if install_dev_packages then
		spawn_process("wally-package-types", "--sourcemap", "packages-sourcemap.json", "DevPackages")
	else
		local exists = fs.isFile("DevPackages")
		if exists then
			fs.removeDir("DevPackages")
		end
	end
end

return pull_deps
