--- love-i18n - A small internationalization library for Love2D
---
--- Features:
--- - Automatic loading of translation files
--- - Support for nested keys (e.g., "menu.items.play")
--- - Configurable translation directory
--- - Fallback language support
--- - Interpolation support with placeholders
--- - Love2D integration

local i18n = {}

--- Default configuration table
-- @table config
-- @field localesDir Directory containing translation files (default: "locales")
-- @field fallbackLocale Fallback language when translation not found (default: "en")
-- @field currentLocale Current active language (default: "en")
-- @field interpolationPattern Pattern for placeholder interpolation (default: "{([^}]+)}")
local config = {
	localesDir = "locales",
	fallbackLocale = "en",
	currentLocale = "en",
	interpolationPattern = "{([^}]+)}",
}

--- Storage for all translations
-- @table translations
local translations = {}

--- Helper function to check if a file exists
--- @param path string File path to check
--- @return boolean exists True if file exists
local function fileExists(path)
	if love and love.filesystem then
		return love.filesystem.getInfo(path) ~= nil
	else
		local file = io.open(path, "r")
		if file then
			file:close()
			return true
		end
		return false
	end
end

--- Helper function to read file content
--- @param path string File path to read
--- @return string|nil content File content or nil if failed
local function readFile(path)
	if love and love.filesystem then
		if love.filesystem.getInfo(path) then
			local content = love.filesystem.read(path)
			return content
		end
	else
		local file = io.open(path, "r")
		if file then
			local content = file:read("*all")
			file:close()
			return content
		end
	end
	return nil
end

--- Helper function to get files in directory
--- @param dir string Directory path
--- @return string[] files Array of filenames
local function getFilesInDirectory(dir)
	local files = {}

	if love and love.filesystem then
		local items = love.filesystem.getDirectoryItems(dir)
		for _, item in ipairs(items) do
			local path = dir .. "/" .. item
			if love.filesystem.getInfo(path, "file") then
				table.insert(files, item)
			end
		end
	else
		-- For regular Lua, use basic directory listing
		local handle = io.popen('ls "' .. dir .. '"')
		if handle then
			for filename in handle:lines() do
				if filename:match("%.lua$") then
					table.insert(files, filename)
				end
			end
			handle:close()
		end
	end

	return files
end

--- Load translation file
--- @param _locale string Locale identifier (unused but kept for API consistency)
--- @param filepath string Path to translation file
--- @return table|nil translations Loaded translation data or nil if failed
local function loadTranslationFile(_locale, filepath)
	local content = readFile(filepath)
	if not content then
		return nil
	end

	-- Load Lua table from file
	local chunk, err
	if _VERSION == "Lua 5.1" then
		chunk, err = loadstring(content)
	else
		chunk, err = load(content, filepath)
	end
	if not chunk then
		error("Failed to load translation file " .. filepath .. ": " .. err)
	end

	local success, result = pcall(chunk)
	if not success then
		error("Failed to execute translation file " .. filepath .. ": " .. result)
	end

	return result
end

--- Get nested value from table using dot notation
--- @param t table Table to search in
--- @param key string Dot-separated key (e.g., "menu.items.play")
--- @return any|nil value Found value or nil
local function getNestedValue(t, key)
	local keys = {}
	for k in string.gmatch(key, "[^%.]+") do
		table.insert(keys, k)
	end

	local current = t
	for _, k in ipairs(keys) do
		if type(current) == "table" and current[k] ~= nil then
			current = current[k]
		else
			return nil
		end
	end

	return current
end

--- Set nested value in table using dot notation
--- @param t table Table to modify
--- @param key string Dot-separated key (e.g., "menu.items.play")
--- @param value any Value to set
local function setNestedValue(t, key, value)
	local keys = {}
	for k in string.gmatch(key, "[^%.]+") do
		table.insert(keys, k)
	end

	local current = t
	for i = 1, #keys - 1 do
		local k = keys[i]
		if type(current[k]) ~= "table" then
			current[k] = {}
		end
		current = current[k]
	end

	current[keys[#keys]] = value
end

--- Interpolate placeholders in string
--- @param str string String with placeholders
--- @param params table<string, any>|nil Parameters for interpolation
--- @return string result Interpolated string
local function interpolate(str, params)
	if not params then
		return str
	end

	local result = string.gsub(str, config.interpolationPattern, function(key)
		return tostring(params[key] or ("{" .. key .. "}"))
	end)
	return result
end

-- Public API

--- Configure the i18n library
--- @param options table Configuration options with fields: localesDir, fallbackLocale, currentLocale, interpolationPattern
function i18n.configure(options)
	if options.localesDir then
		config.localesDir = options.localesDir
	end
	if options.fallbackLocale then
		config.fallbackLocale = options.fallbackLocale
	end
	if options.currentLocale then
		config.currentLocale = options.currentLocale
	end
	if options.interpolationPattern then
		config.interpolationPattern = options.interpolationPattern
	end
end

---Load all translation files from the translations directory
function i18n.load()
	translations = {}

	if not fileExists(config.localesDir) then
		print("Warning: Translations directory '" .. config.localesDir .. "' not found")
		return
	end

	local files = getFilesInDirectory(config.localesDir)

	for _, filename in ipairs(files) do
		if filename:match("%.lua$") then
			local locale = filename:match("^(.+)%.lua$")
			local filepath = config.localesDir .. "/" .. filename

			local translationData = loadTranslationFile(locale, filepath)
			if translationData then
				translations[locale] = translationData
				print("Loaded translations for locale: " .. locale)
			end
		end
	end
end

--- Load specific translation file
--- @param locale string Locale identifier
--- @param filepath string Path to translation file
--- @return boolean success True if file was loaded successfully
function i18n.loadFile(locale, filepath)
	local translationData = loadTranslationFile(locale, filepath)
	if translationData then
		translations[locale] = translationData
		return true
	end
	return false
end

--- Set translation data directly
--- @param locale string Locale identifier
--- @param data table Translation data
function i18n.set(locale, data)
	translations[locale] = data
end

--- Add translation key-value pair
--- @param locale string Locale identifier
--- @param key string Translation key (supports dot notation)
--- @param value string|table Translation value
function i18n.add(locale, key, value)
	if not translations[locale] then
		translations[locale] = {}
	end
	setNestedValue(translations[locale], key, value)
end

--- Get current locale
--- @return string locale Current locale identifier
function i18n.getLocale()
	return config.currentLocale
end

--- Set current locale
--- @param locale string Locale identifier
function i18n.setLocale(locale)
	config.currentLocale = locale
end

--- Get fallback locale
--- @return string locale Fallback locale identifier
function i18n.getFallbackLocale()
	return config.fallbackLocale
end

--- Set fallback locale
--- @param locale string Locale identifier
function i18n.setFallbackLocale(locale)
	config.fallbackLocale = locale
end

--- Translate a key
--- @param key string Translation key (supports dot notation)
--- @param params table<string, any>|nil Parameters for interpolation
--- @param locale string|nil Locale override (uses current locale if not specified)
---@return string translation Translated string or key if translation not found
function i18n.t(key, params, locale)
	local targetLocale = locale or config.currentLocale

	-- Try to get translation from target locale
	local translation = nil
	if translations[targetLocale] then
		translation = getNestedValue(translations[targetLocale], key)
	end

	-- Fallback to fallback locale if not found
	if translation == nil and targetLocale ~= config.fallbackLocale then
		if translations[config.fallbackLocale] then
			translation = getNestedValue(translations[config.fallbackLocale], key)
		end
	end

	-- Return key if translation not found
	if translation == nil then
		return key
	end

	-- Handle interpolation
	if type(translation) == "string" and params then
		return interpolate(translation, params)
	end

	return translation
end

--- Alias for t function
i18n.translate = i18n.t

--- Check if locale exists
--- @param locale string Locale identifier
--- @return boolean exists True if locale has loaded translations
function i18n.localeExists(locale)
	return translations[locale] ~= nil
end

--- Get list of available locales
--- @return string[] locales Array of available locale identifiers
function i18n.getLocales()
	local locales = {}
	for locale, _ in pairs(translations) do
		table.insert(locales, locale)
	end
	table.sort(locales)
	return locales
end

--- Get all translations for a locale
--- @param locale string|nil Locale identifier (uses current locale if not specified)
--- @return table|nil translations Translation data for the locale
function i18n.getTranslations(locale)
	return translations[locale or config.currentLocale]
end

-- Initialize with default configuration
i18n.load()

return i18n
