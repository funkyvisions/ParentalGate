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

local parentalgate = require("parentalgate")

display.setStatusBar(display.HiddenStatusBar)

-- Show the parental gate and display the menu scene when done
-- If the parental gate has already been bypassed once then the scene
-- will be shown immediately

parentalgate.show("menu")
