StayFocusedAutoShot = CreateFrame("StatusBar", "StayFocusedAutoShotFrame", StayFocusedMainFrame)
local frame = StayFocusedAutoShot

function frame:CreateFrame()
	frame:SetStatusBarTexture(StayFocused.textures[StayFocusedDB.texture])
	frame:SetMinMaxValues(0, 100)
	frame:SetValue(0)
	frame:Hide()

	frame.backdrop = frame:CreateTexture(nil, "BACKGROUND", frame)
	frame.backdrop:SetPoint("TOPLEFT", -1, 1)
	frame.backdrop:SetPoint("BOTTOMRIGHT", 1, -1)
	frame.backdrop:SetTexture(0, 0, 0, StayFocusedDB.backdrop_alpha)
	
	frame.value = frame:CreateFontString(nil, "OVERLAY", frame)
	frame.value:SetPoint("CENTER")
	frame.value:SetJustifyH("CENTER")

	frame:ApplyOptions()
end

function frame:ApplyOptions()
	local o = frame.db;
	
	frame:SetPoint("TOP", StayFocusedMainFrame, "BOTTOM", 0, -2)
	frame:SetStatusBarColor(.5, .7, .5)
	frame:SetSize(o.width, o.height)

	frame.value:SetFont([=[Fonts\ARIALN.ttf]=], o.font_size, o.font_outline and "OUTLINE" or "")
	frame.value:SetTextColor(1, 1, 1)
	frame.value:SetText("")
end

local max_power = 0
local auto_shot = GetSpellInfo(75)

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

local currentTime, startTime, endTime
frame:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		local addon = ...
		if addon:lower() ~= "stayfocused_autoshot" then return end
		StayFocusedAutoShotDB = StayFocusedAutoShotDB or {
			show_text = true,
			
			font_size = 12,
			font_outline = true,
			
			width = 225,
			height = 10,
		}
		self.db = StayFocusedAutoShotDB
		
		self:CreateFrame()
		
		self:UnregisterEvent("ADDON_LOADED")
	else
		local unit, name = ...
		if unit ~= 'player' or name ~= auto_shot then return end

		startTime = GetTime()
		endTime = startTime + UnitRangedDamage("player")

		self:SetMinMaxValues(startTime, endTime)
		self.value:SetText("")
		self:Show()
	end
end)

frame:SetScript("OnUpdate", function(self, elapsed)
	currentTime = GetTime()
	if currentTime > endTime then
		self:Hide()
	else
		local elapsed = (currentTime - startTime)
		self:SetValue(startTime + elapsed)
		if self.db.show_text then self.value:SetFormattedText("%.1f", endTime - currentTime) end
	end
end)
