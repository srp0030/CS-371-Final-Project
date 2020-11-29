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

local button1 = display.newRect( 300, 700, 100, 75)
button1:setFillColor(0,1,0)
local buttontext1 = display.newText( "Start Game", 300, 700, native.systemFont, 16 )
sceneGroup:insert(button1)
sceneGroup:insert(buttontext1)
button1:addEventListener( "tap", gameScene )

local button2 = display.newRect( 500, 700, 100, 75)
button2:setFillColor(0,1,0)
local buttontext2 = display.newText( "How to Play", 500, 700, native.systemFont, 16 )
sceneGroup:insert(button2)
sceneGroup:insert(buttontext2)
button2:addEventListener( "tap", helpScene )

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