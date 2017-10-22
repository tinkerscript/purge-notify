local function Parse(source)
  local result = {}
  local apostrophe = string.find(source, "'s")
  local buffStart = 6

  if apostrophe ~= nil then
    result.name = string.sub(source, 1, apostrophe - 1)
    buffStart = apostrophe + 3
  end

  local buffEnd = string.find(source, ' is removed.')
  result.buff = string.sub(source, buffStart, buffEnd - 1)
  return result
end

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
    if arg1 ~= nil then
      local text = nil;
      local info = Parse(arg1);

      if info.name ~= nil then
        if info.buff == 'Blessing of Freedom' then
          text = 'Purged Blessing of Freedom from '..info.name..', stop him!'
        elseif info.buff == 'Blessing of Protection' then
          text = 'Purged Blessing of Protection from '..info.name..', finish him!'
        elseif info.buff == "Nature's Swiftness" then
          text = "Purged Nature's Swiftness from "..info.name..', loooser!'
        elseif info.buff == 'Sacrifice' then
          text = 'Purged Sacrifice from '..info.name..', finish him!'
        end

        if text ~= nil then
            SendChatMessage(text, 'SAY');
        end
      end
    end
  end
end);

PurgenMain:RegisterEvent('ADDON_LOADED');
