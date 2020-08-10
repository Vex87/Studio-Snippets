local Modules = script.Modules
local Handler = require(Modules.Handler)
local ExplorerModule = require(Modules.Explorer)
local SettingsModule = require(Modules.Settings)

Handler.Explorer.Widget = plugin:CreateDockWidgetPluginGui("Explorer", SettingsModule.Explorer.Widget.WidgetInfo)
Handler.Toolbar = plugin:CreateToolbar("Snippets")
ExplorerModule.Create()