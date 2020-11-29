local composer = require( "composer" )
local scene = composer.newScene()
local widget = require('widget')
local physics = require( "physics" )
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
 
---------------------------------------------------------------------------------
local ship_opt = {
    frames = {
        {x = 364, y = 221, width = 86, height = 88}, -- frame 1
    }
}

local ship_sheet = graphics.newImageSheet("shipsheet.png", ship_opt)

local ship_sequenceData = {
   {name = "walking", frames = {1}, time = 800, loopCount = 0}
}

local sheet = ship_sheet;
local sequenceData = ship_sequenceData;
local anim = display.newSprite(sheet, sequenceData) --initialize ship sprite

local function switchScene(event) -- Change scenes

      composer.gotoScene("scene1") --Title Screen
end  

local function onObjectTouch(event)
    if event.phase == "began" then
        touching = true           
    elseif event.phase == "ended" then
        touching = false
    anim:applyLinearImpulse(0, -20, anim.x, anim.y)
    print("linear impulse applied")
    end
end

--TESTING MOVEMENT

--[[local funtion EnterFrame(event)
    if touching == true then
            timer.performWithDelay( 1000, move)
    end
end--]]

--local function applyForce(event) -- Function to apply force to the object
  
while (touching == true) do
    vx, vy = anim:getLinearVelocity()
    anim:applyForce( 0, vy-20, anim.x, anim.y )
    print("force applied") --testing
end
--[[if(event.phase == "ended") then
    vx, vy = anim:getLinearVelocity()
    print(vx, vy)
    anim:applyLinearImpulse(0, -20, anim.x, anim.y)
    print("linear impulse applied")
end--]]
    

--end

--Runtime:addEventListener("tap", applyForce)
Runtime:addEventListener("touch", onObjectTouch)

-- "scene:create()"
function scene:create( event )

       local sceneGroup = self.view

local background = display.newImageRect( "space_background.png", display.contentWidth, display.contentHeight) 
background.x = display.contentCenterX
background.y = display.contentCenterY
sceneGroup:insert(background)

 physics.start() --start physics here
 physics.setGravity( 0, 5 )

local ground = display.newRect(display.contentCenterX, display.contentCenterY + 380, 1500, 1) -- Adds a ground object to stop the ship from falling off screen
ground:setFillColor(0,0,0)
physics.addBody( ground, "static", { density=1.0, friction=0, bounce=0, isSensor = false } )
 
local button1 = display.newRect( 300, 700, 100, 75)
button1:setFillColor(0,1,0)
local buttontext1 = display.newText( "End Game", 300, 700, native.systemFont, 16 )
sceneGroup:insert(button1)
sceneGroup:insert(buttontext1)
button1:addEventListener( "tap", switchScene )

sceneGroup:insert(anim)
physics.addBody( anim, "dynamic", { density=1.0, friction=0, bounce=0, isSensor = false} )
anim:setSequence("walking")
anim.x = display.contentCenterX - 400
anim.y = display.contentCenterY

end
 
-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
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
    physics.stop()
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