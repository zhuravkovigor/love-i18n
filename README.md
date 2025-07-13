# love-i18n

A small, lightweight internationalization (i18n) library written in Lua, designed for easy integration with Love2D games and compatible with LuaRocks.

## Features

- 🌍 **Automatic loading** of translation files from configurable directory
- 🔑 **Nested keys support** using dot notation (e.g., `"menu.items.play"`)
- 📝 **String interpolation** with placeholder support (`{placeholder}`)
- 🔄 **Fallback language** support for missing translations
- 💙 **Love2D integration** with filesystem support
- ⚡ **Simple API** for adding translations dynamically
- 📦 **LuaRocks compatible** for easy installation
- 🔒 **Strongly typed** with comprehensive type annotations

## Installation

### Option 1: LuaRocks

```bash
luarocks install love-i18n
```

### Option 2: Git Clone

```bash
git clone https://github.com/zhuravkovigor/love-i18n
```

Then copy `init.lua` to your project directory or add the cloned directory to your Lua path.

### Option 3: Manual Installation

Download the `init.lua` file and place it in your project directory.

## Quick Start

```lua
local i18n = require("love-i18n") -- or require("init") for manual installation

-- Configure (optional - these are defaults)
i18n.configure({
  translationsDir = "translations",
  fallbackLocale = "en",
  currentLocale = "en"
})

-- Load all translation files
i18n.load()

-- Use translations
print(i18n.t("welcome"))                    -- "Welcome to our game!"
print(i18n.t("menu.title"))                 -- "Main Menu"
print(i18n.t("game.score", { score = 100 })) -- "Score: 100"

-- Switch language
i18n.setLocale("es")
print(i18n.t("welcome"))                    -- "¡Bienvenido a nuestro juego!"
```

## Translation Files

Create translation files in your `translations` directory (or custom directory):

**translations/en.lua**

```lua
return {
  welcome = "Welcome to our game!",
  goodbye = "Goodbye!",

  menu = {
    title = "Main Menu",
    items = {
      play = "Play",
      settings = "Settings",
      exit = "Exit"
    }
  },

  game = {
    score = "Score: {score}",
    level = "Level {level}",
    lives = "Lives: {lives}"
  }
}
```

**translations/ru.lua**

```lua
return {
  welcome = "Добро пожаловать в нашу игру!",
  goodbye = "До свидания!",

  menu = {
    title = "Главное меню",
    items = {
      play = "Играть",
      settings = "Настройки",
      exit = "Выход"
    }
  },

  game = {
    score = "Счёт: {score}",
    level = "Уровень {level}",
    lives = "Жизни: {lives}"
  }
}
```

## API Reference

### Configuration

#### `i18n.configure(options)`

Configure the library settings.

```lua
i18n.configure({
  translationsDir = "translations",     -- Directory containing translation files
  fallbackLocale = "en",               -- Fallback language when translation not found
  currentLocale = "en",                -- Current active language
  interpolationPattern = "{([^}]+)}"   -- Pattern for placeholder interpolation
})
```

### Loading Translations

#### `i18n.load()`

Load all translation files from the translations directory.

#### `i18n.loadFile(locale, filepath)`

Load a specific translation file.

```lua
i18n.loadFile("fr", "custom/french.lua")
```

#### `i18n.set(locale, data)`

Set translation data directly.

```lua
i18n.set("es", {
  welcome = "¡Bienvenido!",
  goodbye = "¡Adiós!"
})
```

### Translation

#### `i18n.t(key, params, locale)` or `i18n.translate(key, params, locale)`

Translate a key with optional parameters and locale override.

```lua
i18n.t("welcome")                           -- Basic translation
i18n.t("menu.items.play")                   -- Nested key
i18n.t("game.score", { score = 1500 })      -- With interpolation
i18n.t("welcome", nil, "ru")                -- Force specific locale
```

### Locale Management

#### `i18n.getLocale()`

Get the current locale.

#### `i18n.setLocale(locale)`

Set the current locale.

#### `i18n.getFallbackLocale()`

Get the fallback locale.

#### `i18n.setFallbackLocale(locale)`

Set the fallback locale.

#### `i18n.getLocales()`

Get array of all available locales.

#### `i18n.localeExists(locale)`

Check if a locale is available.

### Dynamic Translations

#### `i18n.add(locale, key, value)`

Add a translation key-value pair dynamically.

```lua
i18n.add("en", "dynamic.message", "This is dynamic!")
i18n.add("en", "nested.deep.key", "Deep nested value")
```

## Love2D Integration

The library automatically detects Love2D and uses `love.filesystem` for file operations. Here's a simple integration example:

```lua
function love.load()
  local i18n = require("love-i18n")
  i18n.load()
  love.window.setTitle(i18n.t("game.title"))
end

function love.draw()
  love.graphics.print(i18n.t("game.score", { score = player.score }), 10, 10)
end

function love.keypressed(key)
  if key == "l" then
    -- Switch language with 'L' key
    local current = i18n.getLocale()
    i18n.setLocale(current == "en" and "ru" or "en")
  end
end
```

## Testing

Run the test suite:

```bash
lua test.lua
```

## Development Setup

This project includes a complete VS Code development environment with configured tasks, debugging, and code formatting.

### Prerequisites

```bash
# Install LuaRocks and development tools
sudo apt install luarocks  # On Ubuntu/Debian
# or
brew install luarocks      # On macOS

# Install development dependencies
luarocks install --local luacheck  # Code linting
luarocks install --local ldoc      # Documentation generation
```

### VS Code Setup

1. Install recommended extensions (VS Code will prompt automatically)
2. The project includes pre-configured:
   - **Tasks** for testing, linting, formatting, and publishing
   - **Settings** optimized for Lua development
   - **Launch configurations** for debugging
   - **Code formatting** with StyLua

### Available Make Commands

```bash
make test              # Run tests
make lint              # Lint code with luacheck
make format            # Format code with stylua
make docs              # Generate documentation
make ci                # Full CI check
make pack              # Create LuaRocks package
make upload-luarocks   # Upload to LuaRocks (requires login)
```

## License

MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

For development:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `make ci` to ensure all checks pass
5. Submit a pull request
