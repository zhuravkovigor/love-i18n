-- Luacheck configuration for love-i18n

std = "lua51"

-- Ignore line length warnings for readability
max_line_length = false

-- Global variables that are okay to read/write
globals = {
	"love", -- Love2D framework
}

-- Read-only globals (standard Lua + Love2D)
read_globals = {
	"love",
	-- Standard Lua globals
	"table",
	"string",
	"math",
	"io",
	"os",
	"debug",
	"coroutine",
	-- Love2D specific
	"love.filesystem",
	"love.graphics",
	"love.window",
}

-- Files to exclude
exclude_files = {
	"docs/**",
	"dist/**",
	".luarocks/**",
}

-- Ignore specific warnings
ignore = {
	"213", -- Unused loop variable
	"631", -- Line is too long
}
