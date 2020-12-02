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
physics.start() --start physics here
physics.setGravity( 0, 15 )

local numEnemies = 0

local soundTable = {
	shootSound = audio.loadSound('shoot.wav');
	hitSound = audio.loadSound('hit.wav');
	explodeSound = audio.loadSound('explode.wav')	
}

local ship_opt = {
    frames = {
        {x = 416, y = 245, width = 95, height = 100}, -- frame 1
    }
}

local enemy_opt = {
    frames = {
        {x = 579, y = 832, width = 73, height = 94}, -- frame 1
    }
}

local pillar_opt = {
    frames = {
        {x = -50, y = 0, width = 47, height = 125}, -- frame 1
    }
}

local health_opt = {
    frames = {
        {x = 114, y = 40, width = 632, height = 148},
        {x = 114, y = 226, width = 632, height = 148},
        {x = 114, y = 410, width = 632, height = 148},
        {x = 114, y = 595, width = 632, height = 148},
        {x = 114, y = 779, width = 632, height = 148},
        {x = 114, y = 964, width = 632, height = 148},
    },
}

local ship_sheet = graphics.newImageSheet("ships_transparent.png", ship_opt)
local enemy_sheet = graphics.newImageSheet("ships_transparent.png", enemy_opt)
local health_sheet = graphics.newImageSheet("healthbar.png", health_opt)

local ship_sequenceData = {
   {name = "walking", frames = {1}, time = 800, loopCount = 0}
}

local enemy_sequenceData = {
   {name = "walking", frames = {1}, time = 800, loopCount = 0}
}

local health_sequenceData = {
    {name = "health_decrease", frames = {1,2,3,4,5,6}, time = 800, loopCount = 0}
}

local player = display.newSprite(ship_sheet, ship_sequenceData) --initialize ship sprite
player.tag = "player"
player.HP = 10;

local function switchScene(event) -- Change scenes

      composer.gotoScene("scene1") --Title Screen
end 
local bar = display.newSprite(health_sheet, health_sequenceData)
bar:scale(0.5, 0.5)
bar.x,y = 250, 100
bar:setFrame(6)

local function showHealth(event)
    print(player.HP)
    --bar:setSequence("health_decrease")
    if(player.HP <= 8) then
        bar:setFrame(5)
    elseif(player.HP <= 6) then
        bar:setFrame(4)
    elseif(player.HP <= 4) then
        bar:setFrame(3)
    elseif(player.HP <= 3) then
        bar:setFrame(2)
    elseif(player.HP <= 2) then
        bar:setFrame(1)
    end
end

player:addEventListener("collision", showHealth)



local enemies = {}; -- place to store the enemies
local function createEnemy (yPos, id)
    id = 1
    numEnemies = numEnemies +1 
    yPos = math.random(display.contentCenterY - 200, display.contentCenterY + 200)
    local enemy = display.newSprite(enemy_sheet, enemy_sequenceData);  --enemy sprite data
    enemy.x= 1000
    enemy.y = yPos
	--enemy:setFillColor(0,1,0);
    physics.addBody(enemy,"dynamic", {isSensor = true});
    enemy.gravityScale = 0
	enemy.tag = "enemy";
    enemy.HP = 3;
    enemy:setLinearVelocity( -100, 0 )
    --hiddenGroup:insert(enemy)
    id = id+1  --increment enemy ID

    enemies[id] = enemy;
    
    local function enemyProjectile(event)  -- Timer calls function to fire bullets every second
    print("shoot")
    local ebullet = display.newCircle(enemies[id].x or 0, enemies[id].y or 0, 5);
    physics.addBody(ebullet, "kinematic", {radius=5, isSensor = true} );
    ebullet:setFillColor(1,0,0);
    ebullet:setLinearVelocity( -200, 0 )
    ebullet.tag = "enemyProj"
    end
        if(numEnemies >= 1) then
        timer.performWithDelay(2000, enemyProjectile, -1)
        end
end

timer.performWithDelay( 5000, createEnemy, -1)
--timer.performWithDelay(6000, enemyProjectile, -1)


local function fire (event) -- handles player firing
    local bullet = display.newCircle(player.x+40, player.y, 5);
    bullet:setFillColor(0,1,0);
    physics.addBody(bullet, "kinematic", {radius=5} );
    bullet.isBullet = true
    bullet:setLinearVelocity( 200, 0 )
    

    local function removeProjectile(event) --removes projectile on collision
        if (event.phase=="began") then
            print("collision")
        --event.target:removeSelf();
        --event.target=nil;

        if (event.other.tag == "enemy") then
			 	
				if (event.other.HP > 1) then
					event.other.HP = event.other.HP -1;
					event.other:setFillColor(event.other.HP/3, 0, 0)
					audio.play(soundTable['hitSound']);
				elseif (event.other.HP == 1) then
                    audio.play(soundTable['explodeSound']);
                    numEnemies = numEnemies -1
                    event.other:removeSelf(); 
                    event.other=nil;

				end
        end
        end
    end
    bullet:addEventListener("collision", removeProjectile)
end

local function playerHealth(event)
    if(event.other.tag == "enemyProj") then

            if (player.HP > 1) then
                    event.other:removeSelf(); 
                    event.other=nil;
                    player.HP = player.HP -1;
                    print("hit")
					audio.play(soundTable['hitSound']);
            elseif (player.HP <= 1) then
                    event.other:removeSelf(); 
                    event.other=nil;
					audio.play(soundTable['explodeSound']);
                    print("destroyed")
                    composer.gotoScene("deathScene")
            end
    end
    --[[if(event.other.tag == "topColumn" or event.other.tag == "bottomColumn") then

        if (player.HP > 1) then
                    player.HP = player.HP -1;
                    print("hit")
					audio.play(soundTable['hitSound']);
            elseif (player.HP <= 1) then
					audio.play(soundTable['explodeSound']);
                    print("destroyed")
                    composer.gotoScene("deathScene")
        end
    end--]]

end

player:addEventListener("collision", playerHealth)





local function moveColumns()
		for a = elements.numChildren,1,-1  do
			if(elements[a].x > -400) then
				elements[a].x = elements[a].x - 12
			else 
				elements:remove(elements[a])
			end	
		end
end

local function addColumns()
	
	height = math.random(display.contentCenterY - 200, display.contentCenterY + 200)

    local topColumn = display.newImageRect('column.png',300,714)
    topColumn.tag = "topColumn"
	topColumn.anchorX = 0.5
	topColumn.anchorY = 1
	topColumn.x = display.contentWidth + 100
	topColumn.y = height - 160
	physics.addBody(topColumn, "static", {density=1, bounce=0.1, friction=.2, isSensor= true})
	elements:insert(topColumn)
	
    local bottomColumn = display.newImageRect('column.png',300,714)
    bottomColumn.tag = "bottomColumn"
	bottomColumn.anchorX = 0.5
	bottomColumn.anchorY = 0
	bottomColumn.x = display.contentWidth + 100
	bottomColumn.y = height + 160
	physics.addBody(bottomColumn, "static", {density=1, bounce=0.1, friction=.2, isSensor= true})
	elements:insert(bottomColumn)

end	

local addColumnTimer = timer.performWithDelay(1000, addColumns, -1)
local moveColumnTimer = timer.performWithDelay(2, moveColumns, -1)

local function onObjectTouch(event)
    if event.phase == "began" then
    player:applyLinearImpulse(0, -60, player.x, player.y)
        --print("boost")
           
    end
end


-- "scene:create()"
function scene:create( event )

       local sceneGroup = self.view

       --sceneGroup:insert(enemy)

local background = display.newImageRect( "space_background.png", display.contentWidth, display.contentHeight) 
background.x = display.contentCenterX
background.y = display.contentCenterY
sceneGroup:insert(background)

                                                            --invisible button to allow user to shoot
local flyButton = display.newRect( 334, 375, 667, 750)
flyButton:setFillColor(0,1,0, 0.01) --opacity set nearly to 0 to make invisible
local buttontext2 = display.newText( "Shoot", 800, 700, native.systemFont, 16 )
sceneGroup:insert(flyButton)
sceneGroup:insert(buttontext2)
flyButton:addEventListener( "touch", onObjectTouch )

local shootButton = display.newRect( 1000, 375, 667, 750)
shootButton:setFillColor(0,0,1, 0.01) --opacity set nearly to 0 to make invisible
local shootButtontext = display.newText( "fly", 100, 700, native.systemFont, 16 )
sceneGroup:insert(shootButton)
sceneGroup:insert(shootButtontext)
shootButton:addEventListener( "tap", fire)


local ground = display.newRect(display.contentCenterX, display.contentCenterY + 380, 1500, 1) -- Adds a ground object to stop the ship from falling off screen
ground:setFillColor(0,0,0)
physics.addBody( ground, "static", { density=1.0, friction=0, bounce=0, isSensor = false } )
 
local button1 = display.newRect( 300, 700, 100, 75)
button1:setFillColor(0,1,0)
local buttontext1 = display.newText( "End Game", 300, 700, native.systemFont, 16 )
sceneGroup:insert(button1)
sceneGroup:insert(buttontext1)
button1:addEventListener( "tap", switchScene )

sceneGroup:insert(player)
physics.addBody( player, "dynamic", { density=1.0, friction=0, bounce=0, isSensor = false} ) 
player:setSequence("walking")
player.x = display.contentCenterX - 400
player.y = display.contentCenterY

elements = display.newGroup()
elements.anchorChildren = true
elements.anchorX = 0
elements.anchorY = 1
elements.x = 0
elements.y = 0
sceneGroup:insert(elements)

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