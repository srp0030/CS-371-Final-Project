local composer = require( "composer" )
local scene = composer.newScene()
local widget = require('widget')

local function gameScene(event) 

      composer.gotoScene("scene2") --Game scene
end

local function helpScene(event) 

      composer.gotoScene("scene3") --Help scene
end






-- "scene:create()"
function scene:create( event )

local sceneGroup = self.view

local background = display.newImageRect("logo3.png", 1334, 750)
background.x = display.contentCenterX
background.y = display.contentCenterY
sceneGroup:insert(background)

local start = display.newImageRect("start-up.png", 256, 256)
start.x = 300
start.y = 600
sceneGroup:insert(start)
start:addEventListener("tap", gameScene)

local help = display.newImageRect("instructions.png", 256, 256)
help.x = 1000
help.y = 600
sceneGroup:insert(help)
help:addEventListener("tap", helpScene)


--local button1 = display.newRect( 700, 800, 300, 175)
--button1:setFillColor(0,0, 1)
--local buttontext1 = display.newText( "Start Game", 700, 800, native.systemFont, 55 )
--buttontext1:setFillColor(0, 1, 0)
--sceneGroup:insert(button1)
--sceneGroup:insert(buttontext1)
--button1:addEventListener( "tap", gameScene )

--local button2 = display.newRect( 1200, 800, 300, 250)
--button2:setFillColor(0, 0, 1)
--local buttontext2 = display.newText( "How to Play", 1200, 800, native.systemFont, 55 )
--buttontext2:setFillColor(0, 1 , 0)
--sceneGroup:insert(button2)
--sceneGroup:insert(buttontext2)
--button2:addEventListener( "tap", helpScene )

end
 
-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
   end
end
 
-- "scene:hide()"
function scene:hide( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end
 
-- "scene:destroy()"
function scene:destroy( event )
 
   local sceneGroup = self.view
 
   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end
 
---------------------------------------------------------------------------------
 
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
---------------------------------------------------------------------------------
 
return scene