-- Test script for love-i18n library

local i18n = require("init")

-- Test configuration
local function test_configuration()
	print("Testing configuration...")

	i18n.configure({
		localesDir = "locales",
		fallbackLocale = "en",
		currentLocale = "es",
	})

	assert(i18n.getLocale() == "es", "Locale setting failed")
	assert(i18n.getFallbackLocale() == "en", "Fallback locale setting failed")

	print("✓ Configuration tests passed")
end

-- Test loading translations
local function test_loading()
	print("Testing translation loading...")

	i18n.load()

	local locales = i18n.getLocales()
	assert(#locales > 0, "No locales loaded")

	local hasEn = false
	local hasEs = false
	for _, locale in ipairs(locales) do
		if locale == "en" then
			hasEn = true
		end
		if locale == "es" then
			hasEs = true
		end
	end

	assert(hasEn, "English locale not loaded")
	assert(hasEs, "Spanish locale not loaded")

	print("✓ Loading tests passed")
end

-- Test basic translation
local function test_translation()
	print("Testing basic translation...")

	i18n.setLocale("en")

	local welcome = i18n.t("welcome")
	assert(welcome == "Welcome to our game!", "Basic translation failed: " .. welcome)

	local menuTitle = i18n.t("menu.title")
	assert(menuTitle == "Main Menu", "Nested translation failed: " .. menuTitle)

	local playButton = i18n.t("menu.items.play")
	assert(playButton == "Play", "Deep nested translation failed: " .. playButton)

	print("✓ Basic translation tests passed")
end

-- Test interpolation
local function test_interpolation()
	print("Testing interpolation...")

	i18n.setLocale("en")

	local score = i18n.t("game.score", { score = 1500 })
	assert(score == "Score: 1500", "Interpolation failed: " .. score)

	local levelMessage = i18n.t("game.messages.level_complete", { level = 5 })
	assert(levelMessage == "Level 5 complete!", "Multi-word interpolation failed: " .. levelMessage)

	print("✓ Interpolation tests passed")
end

-- Test language switching
local function test_language_switching()
	print("Testing language switching...")

	i18n.setLocale("en")
	local welcomeEn = i18n.t("welcome")

	i18n.setLocale("es")
	local welcomeEs = i18n.t("welcome")

	assert(welcomeEn ~= welcomeEs, "Language switching failed - same text returned")
	assert(
	welcomeEs == "¡Bienvenido a nuestro juego!",
		"Spanish translation incorrect: " .. welcomeEs
	)

	print("✓ Language switching tests passed")
end

-- Test fallback behavior
local function test_fallback()
	print("Testing fallback behavior...")

	i18n.setLocale("nonexistent")

	-- Should fallback to English
	local welcome = i18n.t("welcome")
	assert(welcome == "Welcome to our game!", "Fallback failed: " .. welcome)

	-- Non-existent key should return the key itself
	local nonExistent = i18n.t("non.existent.key")
	assert(nonExistent == "non.existent.key", "Non-existent key handling failed: " .. nonExistent)

	print("✓ Fallback tests passed")
end

-- Test dynamic translation addition
local function test_dynamic_addition()
	print("Testing dynamic translation addition...")

	i18n.add("en", "test.dynamic", "Dynamic message")
	i18n.add("es", "test.dynamic", "Mensaje dinámico")

	i18n.setLocale("en")
	local dynamicEn = i18n.t("test.dynamic")
	assert(dynamicEn == "Dynamic message", "Dynamic English addition failed: " .. dynamicEn)

	i18n.setLocale("es")
	local dynamicEs = i18n.t("test.dynamic")
	assert(dynamicEs == "Mensaje dinámico", "Dynamic Spanish addition failed: " .. dynamicEs)

	print("✓ Dynamic addition tests passed")
end

-- Run all tests
local function run_tests()
	print("Running love-i18n tests...\n")

	test_configuration()
	test_loading()
	test_translation()
	test_interpolation()
	test_language_switching()
	test_fallback()
	test_dynamic_addition()

	print("\n🎉 All tests passed!")
end

-- Execute tests
run_tests()
