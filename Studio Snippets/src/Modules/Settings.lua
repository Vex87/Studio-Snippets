local SettingsModule = {}

SettingsModule.Explorer = {
	Widget = {
		WidgetInfo = DockWidgetPluginGuiInfo.new(
			Enum.InitialDockState.Float,
			false,
			false,
			250,
			200,
			250,
			200
		),
		IndentOffset = 20,
		VerticalSize = 20,
		VerticalOffset = 4,	
		LayoutMultiplier = 1000,
	},	
	Button = {
		ToolTip = "",
		IconName = "",
		Text = ""
	},	
}

return SettingsModule