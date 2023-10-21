
function onCreate()
    makeLuaText('f', 'Game Over! Press ENTER to restart.', 370, 460, 100)
	setTextSize('f', 50)
end

function onUpdate()
    if inGameOver == true then
	    addLuaText('f', 1500, 1500)
	end
end

function onGameOverConfirm()
    removeLuaText('f')
end