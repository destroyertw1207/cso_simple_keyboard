
-- #ui_simple_keyboard
-- Made by. DestroyerI滅世I ( Destroyertw1207 )

local screen = UI.ScreenSize()

function UI_Load_keyboard()
	keyboard = {
		  box = {}
		, txt = {}
	}
	
	-- 固定值 ( *不可調整 )
	local addx = 0
	local addy = 0
	local maxn = 0
	local totalw = 0
	local totalh = 0
	
	-- 設定鍵上的文字 ( *可調整 )
	local keyboard_t = {
		  {"`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "←-", " "}
		, {"TAB", "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "[", "]", "\\", "  "}
		, {"CAPS", "A", "S", "D", "F", "G", "H", "J", "K", "L", ";", "'", "ENTER", "   "}
		, {"LSHIFT", "Z", "X", "C", "V", "B", "N", "M", ",", ".", "/", "RSHIFT", "↑"}
		, {"LCTRL", "L田", "LALT", "SPACE", "RALT", "R田", "MENU", "RCTRL", "←", "↓", "→"}
	}
	
	-- 設定鍵的寬度 ( *可調整 )
	local keyboard_w = {
		  {                                                        [14] =  20, [15] = 100}
		, {[1] = 20                                                          , [15] = 100}
		, {[1] = 40                                  , [13] =  30, [14] = 100            }
		, {[1] = 60                      , [12] =  60, [13] = 100                        }
		, {[1] = 10, [4] = 300, [8] =  10,                                               }
	}
	
	-- 每個鍵的長寬及間隔 ( *可調整 )
	local width = 45
	local height = 45
	local interval = 5
	
	-- 計算整體鍵盤長寬
	for k, v in pairs(keyboard_t) do
		if #v > maxn then
			maxn = #v
		end
		totalh = totalh + height + interval
	end
	totalh = totalh - interval - interval / 2 - 2
	
	for i = 1, maxn do
		if keyboard_w[1][i] then
			totalw = totalw + width + interval + keyboard_w[1][i]
		else
			totalw = totalw + width + interval
		end
	end
	totalw = totalw - 2
	
	-- 整體鍵盤的位置 ( 置中 ) ( *可調整 )
	local x = screen.width / 2 - totalw / 2
	local y = screen.height - totalh - 60
	
	-- y軸置中 local y = screen.height / 2 - totalh / 2

	for i, row in pairs(keyboard_t) do
		addx = 0
		for j, key in pairs(row) do
			local csokey = key
			
			-- 特殊調整: 讓按鍵能配合 UI.KEY 的名稱
			local set = {
				  {tonumber(key)  , "NUM" .. key}
				, {key == "↑"     , "UP"        }
				, {key == "↓"     , "DOWN"      }
				, {key == "←"     , "LEFT"      }
				, {key == "→"     , "RIGHT"     }
				, {key == "LSHIFT", "SHIFT"     }
				, {key == "RSHIFT", "SHIFT"     }
			}
			for k, v in pairs(set) do
				if v[1] then
					csokey = v[2]
				end
			end
			
			-- 建立 UI，如果非 UI.KEY 內容則會以按鍵名稱為 UI 變數
			local keyid = UI.KEY[csokey] or csokey
			
			if not keyboard.box[keyid] then
				keyboard.box[keyid] = {}
				keyboard.txt[keyid] = {}
			end
			local samekey = #keyboard.box[keyid] + 1
			keyboard.box[keyid][samekey] = UI.Box.Create()
			keyboard.box[keyid][samekey]:Set({x = x + addx, y = y + addy, width = width + (keyboard_w[i][j] or 0), height = height, r = 0, g = 0, b = 0, a = 150})
			
			keyboard.txt[keyid][samekey] = UI.Text.Create()
			keyboard.txt[keyid][samekey]:Set({text = key, align = "center", font = "small", x = x + addx, y = y + addy + height / 4, width = width + (keyboard_w[i][j] or 0), height = height, r = 255, g = 255, b = 255, a = 255})
			
			-- 按鍵顏色，UI.KEY 內容會以白色 {250, 250, 250} 顯示，否則以灰色 {100, 100, 100} 顯示
			local clr = tonumber(keyid) and {r = 250, g = 250, b = 250} or {r = 100, g = 100, b = 100}
			for k, v in pairs(keyboard.txt[keyid]) do
				v:Set(clr)
			end
			
			addx = addx + width + interval + (keyboard_w[i][j] or 0)
		end
		addy = addy + height + interval
	end
end
UI_Load_keyboard()

function UI.Event:OnKeyUp(inputs)
	for k, v in pairs(inputs) do
		if v then
			if keyboard.txt[k] then
				for i, j in pairs(keyboard.txt[k]) do
					j:Set({r = 250, g = 250, b = 250})
				end
			end
		end
	end
end

function UI.Event:OnKeyDown(inputs)
	for k, v in pairs(inputs) do
		if v then
			if keyboard.txt[k] then
				for i, j in pairs(keyboard.txt[k]) do
					j:Set({r = 100, g = 250, b = 100})
				end
			end
		end
	end
end
