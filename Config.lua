local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame.name = "Auto Shot (plugin)"
frame.parent = "Stay Focused!"
frame:Hide()

local title, subtitle = LibStub("tekKonfig-Heading").new(frame, "|cffa0a0f0Stay Focused!|r Auto Shot", "Options for auto shot bar.")

local ICONSIZE, ICONGAP, GAP, EDGEGAP, BIGGAP = 32, 3, 8, 16, 16
local tekcheck = LibStub("tekKonfig-Checkbox")
local tekslide = LibStub("tekKonfig-Slider")

local show_text = tekcheck.new(frame, nil, "Show text", "TOPLEFT", subtitle, "BOTTOMLEFT", 0, -GAP)
local checksound = show_text:GetScript("OnClick")
show_text:SetScript("OnClick", function(self)
	checksound(self);
	StayFocusedAutoShot.db.show_text = not StayFocusedAutoShot.db.show_text
	StayFocusedAutoShot:ApplyOptions()
end)

local frame_width, frame_width_l, frame_width_c = tekslide.new(frame, "Width", 50, 500, "TOPLEFT", show_text, "BOTTOMLEFT", 0, -BIGGAP)
frame_width:SetValueStep(5)
frame_width:SetScript("OnValueChanged", function(self, newvalue)
	frame_width_l:SetText(string.format("Width: %d", newvalue))
	StayFocusedAutoShot.db.width = newvalue
	StayFocusedAutoShot:ApplyOptions()
end)
local frame_height, frame_height_l, frame_height_c = tekslide.new(frame, "Height", 1, 100, "TOPLEFT", frame_width_c, "TOPRIGHT", 4*GAP, 0)
frame_height:SetValueStep(1)
frame_height:SetScript("OnValueChanged", function(self, newvalue)
	frame_height_l:SetText(string.format("Height: %d", newvalue))
	StayFocusedAutoShot.db.height = newvalue
	StayFocusedAutoShot:ApplyOptions()
end)	

local font_size, font_size_l, font_size_c = tekslide.new(frame, "Font size", 6, 32, "TOPLEFT", frame_width_c, "BOTTOMLEFT", 0, -BIGGAP)
font_size:SetValueStep(1)
font_size:SetScript("OnValueChanged", function(self, newvalue)
	font_size_l:SetText(string.format("Font size: %d", newvalue))
	StayFocusedAutoShot.db.font_size = newvalue
	StayFocusedAutoShot:ApplyOptions()
end)
local font_outline = tekcheck.new(frame, nil, "Font Outline", "TOPLEFT", font_size_c, "TOPRIGHT", 4*GAP, 0)
font_outline:SetScript("OnClick", function(self)
	checksound(self);
	StayFocusedAutoShot.db.font_outline = not StayFocusedAutoShot.db.font_outline
	StayFocusedAutoShot:ApplyOptions()
end)


frame:SetScript("OnShow", function(frame)
	show_text:SetChecked(StayFocusedAutoShot.db.show_text)
	
	font_size:SetValue(StayFocusedAutoShot.db.font_size)
	font_outline:SetChecked(StayFocusedAutoShot.db.font_outline)

	frame_width:SetValue(StayFocusedAutoShot.db.width)
	frame_height:SetValue(StayFocusedAutoShot.db.height)
end)


StayFocusedAutoShot.configframe = frame
InterfaceOptions_AddCategory(frame)