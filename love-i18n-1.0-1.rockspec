package = "love-i18n"
version = "1.0-1"
source = {
   url = "git+https://github.com/zhuravkovigor/love-i18n.git",
   tag = "v1.0"
}
description = {
   summary = "A small internationalization library for Love2D",
   detailed = [[
      love-i18n is a lightweight internationalization (i18n) library designed
      specifically for Love2D games but also works with regular Lua projects.

      Features:
      - Automatic loading of translation files from configurable directory
      - Support for nested keys using dot notation (e.g., "menu.items.play")
      - String interpolation with placeholder support
      - Fallback language support
      - Easy integration with Love2D
      - Simple camelCase API for adding translations dynamically
      - Strongly typed with comprehensive type annotations for better development experience

      Quick Start:

      1. Install: luarocks install love-i18n

      2. Create translation files in 'translations/' directory:
         -- translations/en.lua
         return {
           welcome = "Welcome!",
           menu = { title = "Main Menu" },
           score = "Score: {points}"
         }

         -- translations/es.lua
         return {
           welcome = "¡Bienvenido!",
           menu = { title = "Menú Principal" },
           score = "Puntuación: {points}"
         }

      3. Use in your code:
         local i18n = require("love-i18n")

         -- Load translations
         i18n.load()

         -- Basic usage
         print(i18n.t("welcome"))           -- "Welcome!"
         print(i18n.t("menu.title"))        -- "Main Menu"
         print(i18n.t("score", {points=100})) -- "Score: 100"

         -- Switch language
         i18n.setLocale("es")
         print(i18n.t("welcome"))           -- "¡Bienvenido!"

      Perfect for Love2D games with multilingual support!
   ]],
   homepage = "https://github.com/zhuravkovigor/love-i18n",
   license = "MIT"
}
dependencies = {
   "lua >= 5.1"
}
build = {
   type = "builtin",
   modules = {
      ["love-i18n"] = "init.lua"
   },
   copy_directories = {
      "translations"
   }
}
