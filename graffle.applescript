#!/usr/bin/osascript

-- returns index of itemName in thisList
on listPosition(thisList, itemName)
    repeat with i from 1 to the count of thisList
        set listItem to item i of thisList
        if name of listItem is itemName then
          return i
        end if
    end repeat
    return -1
end listPosition

-- converts a comma-separated string into a list
to splitString(theString)
  set prevDelimiter to AppleScript's text item delimiters
  set AppleScript's text item delimiters to {","}
  set resultList to every text item of theString
  set AppleScript's text item delimiters to prevDelimiter
  return resultList
end splitString

-- main function
on run argv
    -- parse input parameters of script graffle.sh
    set canvasName to (get item 1 of argv as string)
    set borderSize to (get item 2 of argv as real)
    set outputSizeList to splitString(get item 3 of argv as string)
    set outputScale to (get item 4 of argv as real)
    set outputResolution to (get item 5 of argv as real)
    set transparentBackground to (get item 6 of argv as boolean)
    set includeBorder to (get item 7 of argv as boolean)
    set input to (get POSIX file (item 8 of argv) as string)
    set output to (get POSIX file (item 9 of argv) as string)
    set doQuit to (get item 10 of argv as boolean)
    if not outputSizeList = {} then
        set outputSize to {item 1 of outputSizeList as real, item 2 of outputSizeList as real} as point
    end if
    -- call OmniGraffle, open document, and export requested image
    tell application "OmniGraffle"
        open input
        set theDocument to front document
        if contents of canvasName is not "" then
            set canvasId to my listPosition(canvases of theDocument, canvasName)
            if canvasId is not -1 then set canvas of front window to canvas canvasId of theDocument
        end if
        --set mySettings to current export settings
        set area type of current export settings to current canvas
        set border amount of current export settings to borderSize
        set draws background of current export settings to not transparentBackground
        set export scale of current export settings to outputScale
        set include border of current export settings to includeBorder
        set resolution of current export settings to outputResolution
        if not outputSizeList = {} then
            set size of current export settings to outputSize
        end if
        save theDocument in file output
        if doQuit then quit
    end tell
end run

