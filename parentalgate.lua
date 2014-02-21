-- 
-- Project: Parental Gate
--
-- Description: Shows how to use parentalgate module
-- to present an age verification before the user
-- is allowed to use the app. UI elements can then
-- be hidden or shown based on the users age
--
-- Version: 0.1
--
-- Copyright 2013 Doug Davies. All Rights Reserved.
-- MIT License. Feel free to use this however you want!
-- https://github.com/csddavies
-- http://www.funkyvisions.com
--

local storyboard = require("storyboard")
local widget = require("widget")
local json = require("json")

local _W = display.contentWidth
local _H = display.contentHeight 

local parentalgate = {}

-- Table persistence routines stolen from Rob Miracle
-- http://omnigeek.robmiracle.com/2012/02/23/need-to-save-your-game-data-in-corona-sdk-check-out-this-little-bit-of-code/

local function saveTable(t)
    local path = system.pathForFile("settings.json", system.DocumentsDirectory)
    local file = io.open(path, "w")
    if file then
        local contents = json.encode(t)
        file:write(contents)
        io.close(file)
        return true
    else
        return false
    end
end
 
local function loadTable()
    local path = system.pathForFile("settings.json", system.DocumentsDirectory)
    local contents = ""
    local myTable = {}
    local file = io.open(path, "r")
    if file then
         local contents = file:read("*a")
         myTable = json.decode(contents);
         io.close(file)
         return myTable 
    end
    return nil
end

-- function to return the current age selected from the parental gate (0 if none yet)

parentalgate.age = function()
	
	local settings = loadTable()

	if (settings ~= nil and settings.age ~= nil) then
		return settings.age
	end
	
	return 0
end

-- function to show the parental gate.  If the gate has already been bypassed (meaning
-- they selected an age already) then the specified scene is shown immediately
-- otherwise they must answer the question before proceeding

parentalgate.show = function(scene)
	
	-- load the settings
	
	local settings = loadTable()
	
	-- if already set just proceed
	
	if (settings ~= nil and settings.age ~= nil) then
		storyboard.gotoScene( scene, "fade", 500 )
		return
	end
	
	-- otherwise lets show the parental gate ui
	
	settings = {}
	local age = 13
	
	-- scale the dialog so that it looks the same on all devices (via group)
	
	local scale = display.actualContentWidth / 320
	local dialogGroup = display.newGroup()
	dialogGroup:scale(scale, scale)
	
 	-- create a dialog that almost fills the width (compenstate for scaling when positioning)
 	
	local dialog = display.newRoundedRect(dialogGroup, 0, 0, 300, 200, 12)
	dialog.anchorX = 0.5; dialog.anchorY = 0.5;
	dialog.x = (_W/2) / scale
	dialog.y = (_H/2) / scale
	dialog.strokeWidth = 3
	dialog:setFillColor(1,1,1)
	dialog:setStrokeColor(0,0,0)
	
	-- position all children relative to the top of the dialog
	
	local top = dialog.y - dialog.height/2
	
	local text1 = display.newText(dialogGroup, "How old are you?", 0, 0, native.systemFontBold, 24)
	text1.anchorX = 0.5; text1.anchorY = 0.5;
	text1.x = dialog.x
	text1.y = top + 20
	text1:setFillColor(0)
	
	local text2 = display.newText(dialogGroup, "13", 0, 0, native.systemFontBold, 24)
	text2.anchorX = 0.5; text2.anchorY = 0.5;
	text2.x = dialog.x
	text2.y = top + 60
	text2:setFillColor(0)
	
	local text3 = display.newText(dialogGroup, "Your age will affect what menu buttons you see", 0, 0, native.systemFont, 10)
	text3.anchorX = 0.5; text3.anchorY = 0.5;
	text3.x = dialog.x
	text3.y = top + 180
	text3:setFillColor(0)

	-- every time the stepper is pressed recalculate the age

	local function onPress(e)
		age = e.value
		text2.text = age
	end
	
	local stepper = widget.newStepper
	{
	    minimumValue = 1,
	    maximumValue = 100,
	    initialValue = age,
	    changeSpeedAtIncrement = 2,
	    timerIncrementSpeed = 500,
	    onPress = onPress
	}
	stepper.anchorX = 0.5; stepper.anchorY = 0.5;
	stepper.x = dialog.x
	stepper.y = top + 100
	dialogGroup:insert(stepper)
	
	-- when they finally hit OK then set the age in persistence and 
	-- proceed to the specified scene
	
	local function setAge(e)
		
		settings.age = age
		saveTable(settings)

		display.remove(dialogGroup)
		storyboard.gotoScene( scene, "fade", 500 )
		return true
		
	end
	
	local button = widget.newButton
	{
		label = "OK",
		width = 60,
		height = 20,
		onRelease = setAge
	}
	button.anchorX = 0.5; button.anchorY = 0.5;
	button.x = dialog.x
	button.y = top + 145
	dialogGroup:insert(button)

end

return parentalgate
