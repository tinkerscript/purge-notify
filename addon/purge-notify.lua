local function Print(caption, text)
	local value = text;

	if text == nil then
		value = 'nil';
	elseif text == '' then
		value = '<empty string>';
	end

	DEFAULT_CHAT_FRAME:AddMessage(caption..value);
end

local function Activate()
	Purgen_options.active = true;
	PurgenMain:RegisterEvent('CHAT_MSG_SPELL_BREAK_AURA');
end

local function Deactivate()
	Purgen_options.active = false;
	PurgenMain:UnregisterEvent('CHAT_MSG_SPELL_BREAK_AURA');
end

local function ShowStatus()
	if Purgen_options.active then
		Print('', 'Purgen is active');
	else
		Print('', 'Purgen is not active');
	end
end

local function LoadVariables()
	if not Purgen_options then
		Purgen_options = {
			active = true
		};
	else
		if Purgen_options.active then
			Activate();
		end
	end
end

local function ShowHelp()
	Print('', 'Purgen commands:');
	Print('', '  /purgen on - turn on');
	Print('', '  /purgen off - turn off');
end

SlashCmdList['PURGEN'] = function (msg)
	if not msg or msg == '' then
		ShowStatus();
	elseif msg == 'help' or msg == '?' then
		ShowHelp();
	else
		if msg == 'on' then
			Activate();
			Print('', 'Purgen activated');
		elseif msg == 'off' then
			Deactivate();
			Print('', 'Purgen deactivated');
		else
			Print('', 'Unknown command');
		end
	end
end

SLASH_PURGEN1 = '/purgen';

CreateFrame('Frame', 'PurgenMain');
PurgenMain:SetScript('OnEvent', function()
	if event == 'ADDON_LOADED' and arg1 ~= 'Purgen' then
		PurgenMain:UnregisterEvent('ADDON_LOADED');
		LoadVariables();
	end

	if Purgen_options ~= nil and Purgen_options.active then
		Activate();
	end

	if event == 'CHAT_MSG_SPELL_BREAK_AURA' then
		SendChatMessage(': '..arg1, 'EMOTE');
	end
end);

PurgenMain:RegisterEvent('ADDON_LOADED');
