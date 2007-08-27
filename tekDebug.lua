

local frames = {}


tekDebug = DongleStub("Dongle-1.0"):New("tekDebug")


function tekDebug:Enable()
	local _, title = GetAddOnInfo("tekDebug")
	local author, version = GetAddOnMetadata("tekDebug", "Author"), GetAddOnMetadata("tekDebug", "Version")
	local oh = DongleStub("OptionHouse-1.0"):RegisterAddOn("tekDebug", title, author, version)
	for name,frame in pairs(frames) do oh:RegisterCategory(name, function() return frame end) end
end


local function OnMouseWheel(frame, delta)
	if delta > 0 then
		if IsShiftKeyDown() then frame:ScrollToTop()
		else frame:ScrollUp() end
	elseif delta < 0 then
		if IsShiftKeyDown() then frame:ScrollToBottom()
		else frame:ScrollDown() end
	end
end


function tekDebug:GetFrame(name)
	if frames[name] then return frames[name] end

	local f = CreateFrame("ScrollingMessageFrame", nil, UIParent)
	f:SetMaxLines(250)
	f:SetFontObject(ChatFontNormal)
	f:SetJustifyH("LEFT")
	f:SetFading(false)
	f:EnableMouseWheel(true)
	f:SetScript("OnMouseWheel", OnMouseWheel)
	f:SetScript("OnHide", f.ScrollToBottom)
	f:Hide()

	local orig = f.AddMessage
	f.AddMessage = function(self, txt, ...)
		local newtext = txt:gsub(name.."|r:", date("%X").."|r", 1)
		return orig(self, newtext, ...)
	end

	frames[name] = f

	return f
end


