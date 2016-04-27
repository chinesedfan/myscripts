#!/usr/bin/env osascript

tell application "Terminal"
    activate
    do script "cortex watch" in selected tab of the front window

    tell application "System Events" to tell process "Terminal" to keystroke "t" using command down
    do script "gulp watch" in selected tab of the front window

    delay 0.5
    tell application "System Events" to tell process "Terminal" to keystroke "t" using command down
    do script "http-server" in selected tab of the front window
end tell
