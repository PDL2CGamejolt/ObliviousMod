local spacepress = 0
function onEvent(name, value1, value2)
	if name == 'QT' then
		makeLuaSprite('Warn', 'qt/warning', 400, 200)
		setLuaSpriteScrollFactor('Warn', 0, 0)
		addLuaSprite('Warn', true)
		scaleObject('Warn', 2, 2);
		

		playSound('alert', 1, 'QT')
		runTimer('second-beep', value1, 1)
		runTimer('alert-time', value2, 1)
	end
end

function onTimerCompleted(tag, Loops, LoopsLeft)
	if tag == 'alert-time' then
		if keyPressed('space') or botPlay then
			removeLuaSprite('Warn', false)
			playSound('attack', 1, 'Attack')
		else
			setProperty('health', -500)
			playSound('attack', 1, 'Attack')
		end
	end
	if tag == 'second-beep' then
		playSound('alert', 1, 'QT')
	end
end