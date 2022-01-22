MistShortcuts = {}
local MS = MistShortcuts

function MS.info(str)
   d("[MistShortcuts] " .. tostring(str))
end

function MS.error(str)
   ml_error("[MistShortcuts] " .. tostring(str))
end

function MS.Init()
   local start_time = os.time()
   MS.info("Initialization begins")
   local shortcuts_dir = GetLuaModsPath() .. [[MistShortcuts\Shortcuts]]
   local shortcut_files = FolderList(shortcuts_dir, [[(.*).lua$]])
   for _, shortcut in pairs(shortcut_files) do
      local shortcutNameFriendly = shortcut:match("^(.*)%.lua$")
      local shortcutName = shortcutNameFriendly:gsub("%W", "") -- alphanumeric-only name for funcs
      local shortcutData = persistence.load(shortcuts_dir .. [[\]] .. shortcut)
      if type(shortcutData) == "function" then
         ml_input_mgr.unregisterFunction(shortcutNameFriendly)
         ml_input_mgr.registerFunction({
            name = shortcutNameFriendly,
            func = shortcutData,
         })
         MS[shortcutName] = shortcutData
         MS.info("Added shortcut " .. shortcutName)
      end
   end
   MS.info("Initialization complete in " .. os.time() - start_time .. " seconds")
end

RegisterEventHandler("Module.Initalize", MS.Init, "MistShortcuts.Init")
