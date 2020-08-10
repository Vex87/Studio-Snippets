local Handler = {
	Explorer = {},
}

local SettingsModule = require(script.Parent.Settings)
local Plugin = script.Parent.Parent.Parent

Handler.CreateButton = function(Type)
	local Widget = Handler[Type].Widget
	local Button = Handler[Type].Button
	
	Button = Handler.Toolbar:CreateButton(Type, SettingsModule.Explorer.Button.ToolTip, SettingsModule.Explorer.Button.IconName, SettingsModule.Explorer.Button.Text)
	Button.ClickableWhenViewportHidden = true
	
	if Widget.Enabled then
		Button:SetActive(true)
	end
	
	Button.Click:Connect(function()	
		if Widget.Enabled then
			Button:SetActive(false)
			Widget.Enabled = false
		else
			Button:SetActive(true)
			Widget.Enabled = true
		end
	end)
		
	Widget:BindToClose(function()
		Button:SetActive(false)
		Widget.Enabled = false
	end)
end

Handler.CreateWidget = function(Type)
	Handler[Type].Widget.Title = Type .. " (Studio Snippets)"
	Handler[Type].Widget.Name = "StudioSnippets_" .. Type
	
	Handler[Type].GUI = Plugin.UI[Type]:Clone()
	Handler[Type].GUI.Parent = Handler[Type].Widget		
end

return Handler