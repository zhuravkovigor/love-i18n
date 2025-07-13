# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2025-07-13

### Added

- Initial release of love-i18n library
- Automatic loading of translation files from configurable directory
- Support for nested keys using dot notation (e.g., "menu.items.play")
- String interpolation with placeholder support ({placeholder})
- Fallback language support for missing translations
- Love2D integration with filesystem support
- CamelCase API for better code consistency
- Full JSDoc-style type annotations for development experience
- Dynamic translation addition support
- Multiple locale management
- Complete test suite
- Examples for basic usage and Love2D integration
- LuaRocks compatibility

### Features

- `i18n.configure(options)` - Configure library settings
- `i18n.load()` - Load all translation files automatically
- `i18n.loadFile(locale, filepath)` - Load specific translation file
- `i18n.t(key, params, locale)` - Translate with interpolation support
- `i18n.setLocale(locale)` / `i18n.getLocale()` - Locale management
- `i18n.setFallbackLocale(locale)` / `i18n.getFallbackLocale()` - Fallback management
- `i18n.add(locale, key, value)` - Dynamic translation addition
- `i18n.getLocales()` - Get available locales
- `i18n.localeExists(locale)` - Check locale availability

### Technical Details

- Written in pure Lua 5.1+
- Compatible with Love2D and regular Lua projects
- Supports both love.filesystem and standard io operations
- No external dependencies
- Full type annotations for IDE support
