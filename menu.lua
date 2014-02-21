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

local storyboard = require( "storyboard" )
local parentalgate = require("parentalgate")
local widget = require("widget")

local _W = display.contentWidth
local _H = display.contentHeight 

local scene = storyboard.newScene()

function scene:createScene( event )
	
	-- Create 2 buttons. One that kids should be able to see and one that
	-- adults only should be able to see
	
	local kidbutton = widget.newButton
	{
		label = "Kids",
		width = 120,
		height = 20
	}
	kidbutton.anchorX = 0.5; kidbutton.anchorY = 0.5;
	kidbutton.x = _W/2
	kidbutton.y = _H/2 - 25

	local adultbutton = widget.newButton
	{
		label = "Adults",
		width = 120,
		height = 20
	}
	adultbutton.anchorX = 0.5; adultbutton.anchorY = 0.5;
	adultbutton.x = _W/2
	adultbutton.y = _H/2 + 25
	
	-- if they are under age 13 then hide the adult button
	
	local age = parentalgate.age()
	
	if (age < 13) then
		adultbutton.isVisible = false
	end

end

scene:addEventListener( "createScene", scene )

return scene
