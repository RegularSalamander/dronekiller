function tutorial_load()
    game_load()

    objects.buildings = {
        building:new(0, 100, 100),
        building:new(150, 100, 100),
        building:new(400, 100, 100),
        building:new(550, 0, 100)
    }
    objects.drones = {
        drone:new(450, 50),
        drone:new(500, 0)
    }

    tutorialProgress = 0
    tutorialPaused = false

    io.write("\n")
    io.write("use the arrow keys to move")
end

function tutorial_update(delta)
    if tutorialProgress == 0 then --stop for player to move right
        tutorialPaused = true
        if controls.right > 0 then
            tutorialProgress = 1
        end
    elseif tutorialProgress == 1 then -- wait for player to get to the edge
        tutorialPaused = false
        if objects.player[1].pos.x > 90 then
            tutorialProgress = 2
            io.write("\n")
            io.write("press z to jump")
        end
    elseif tutorialProgress == 2 then --stop for player to jump
        tutorialPaused = true
        if controls.z > 0 then
            tutorialProgress = 3
        end
    elseif tutorialProgress == 3 then -- wait for player to get to the edge
        tutorialPaused = false
        controls.right = 1 --keep them going
        if objects.player[1].pos.x > 240 then
            controls.right = 0
            tutorialProgress = 4
            io.write("\n")
            io.write("go on, jump")
            io.write("you can make it, I promise")
        end
    elseif tutorialProgress == 4 then --stop for player to jump again
        tutorialPaused = true
        if controls.z > 0 then
            tutorialProgress = 5
        end
    elseif tutorialProgress == 5 then --wait for the player to get to about half way across the gap
        tutorialPaused = false
        controls.right = 1 --keep them going
        if objects.player[1].pos.x > 300 then
            controls.right = 0
            tutorialProgress = 6
            io.write("\n")
            io.write("ooh maybe a little too far")
            io.write("hold right and press x to use your explosion sword")
    
        end
    elseif tutorialProgress == 6 then --stop for the player to dash right
        tutorialPaused = true
        if controls.x > 0 and controls.right > 0 and controls.up <= 0 and controls.down <= 0 and controls.left <= 0 then
            io.write(controls.right)
            tutorialProgress = 7
            objects.player[1].vel.x = playerDashSpeed * objects.player[1].dashMultiplier --manually fix the dash
            objects.player[1].vel.y = 0
        else
            objects.player[1].state = "air" --stop them from dashing prematurely
            objects.player[1].canDash = true
        end
    elseif tutorialProgress == 7 then --wait for the player to catch the wall
        tutorialPaused = false
        controls.right = 1 --keep them going
        if objects.player[1].state == "walled" then
            tutorialProgress = 8
            io.write("\n")
            io.write("you got it, just jump onto the roof")    
        end
    elseif tutorialProgress == 8 then --stop for the player to jump
        tutorialPaused = true
        controls.right = 1 --keep them going
        if controls.z > 0 then
            tutorialProgress = 9
        end
    elseif tutorialProgress == 9 then --wait for the player to get under the drone
        tutorialPaused = false
        controls.right = 1 --keep them going
        if objects.player[1].pos.x > 450 then
            controls.right = 0
            tutorialProgress = 10
            io.write("\n")
            io.write("hey, jump and boost up into this drone")    
        end
    elseif tutorialProgress == 10 then --wait for the player to  attack the drone
        tutorialPaused = false
        objects.player[1].pos.x = 450 --keep em steady
        if objects.player[1].state == "posthit" then
            tutorialProgress = 11
            io.write("\n")
            io.write("after you kill a drone, you can use the explosion to bounce yourself in any direction")
            io.write("hold up and right to get to that other drone")
            io.write("then dash up into it!")
        end
    elseif tutorialProgress == 11 then --stop for the player to move right and up
        tutorialPaused = true
        cameraShake = 0
        if controls.right > 0 and controls.up > 0 and controls.down <= 0 and controls.left <= 0 then
            tutorialProgress = 12
        end
    elseif tutorialProgress == 12 then --wait for the player to  attack the drone
        tutorialPaused = false
        if objects.player[1].state == "posthit" then
            tutorialProgress = 13
        end
    end
    if tutorialPaused then
        game_update(0)
    else
        game_update(delta)
    end
end

function tutorial_draw()
    game_draw()
end

function tutorial_keypressed(key, scancode, isrepeat)
    if isrepeat then return end
    if controls[scancode] ~= nil then controls[scancode] = 1 end
end

function tutorial_keyreleased(key, scancode, isrepeat)
    if isrepeat then return end
    if controls[scancode] ~= nil then controls[scancode] = 0 end
end