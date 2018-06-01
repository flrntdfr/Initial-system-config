-- Manage hot corners
-- Adapted from https://discussions.apple.com/message/23989931

property theSavedValues : {"Mission Control", "-", "Bureau", "Mettre le moniteur en veille"} -- (For french system)

tell application "System Preferences"
	activate
	set current pane to pane id "com.apple.preference.expose"
	tell application "System Events"
		delay 3 -- Let time for Mission control to open
		tell window "Mission Control" of process "System Preferences"
			click button "Coins actifs…" --(For french system)
			tell sheet 1
				tell group 1
					set theCurrentValues to value of pop up buttons
					repeat with i from 1 to 4
						set thisValue to item i of theSavedValues
						tell pop up button i
							click
							click menu item thisValue of menu 1
						end tell
					end repeat
				end tell
				click button "OK"
			end tell
		end tell
	end tell
	quit
end tell
