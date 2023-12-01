function onBeatHit()
	if curBeat < 256 then

    	if curBeat %8 == 0 then
                makeLuaSprite('Warn', 'qt/warning', 400, 200)
		setLuaSpriteScrollFactor('Warn', 0, 0)
		addLuaSprite('Warn', true)
		scaleObject('Warn', 2, 2);
		

		playSound('alert', 1, 'QT')
		runTimer('second-beep', '0.25', 1)
		runTimer('alert-time', '0.5', 1)
end	
end
	if curBeat > 256 then

    	if curBeat %4 == 0 then
                makeLuaSprite('Warn', 'qt/warning', 400, 200)
		setLuaSpriteScrollFactor('Warn', 0, 0)
		addLuaSprite('Warn', true)
		scaleObject('Warn', 2, 2);
		

		playSound('alert', 1, 'QT')
		runTimer('second-beep', '0.25', 1)
		runTimer('alert-time', '0.5', 1)
end	
end
end

function onTimerCompleted(tag, Loops, LoopsLeft)
	if tag == 'alert-time' then
		if keyPressed('space') then
			removeLuaSprite('Warn', false)
			playSound('attack', 1, 'Attack')
                        setProperty('health', getProperty('health')+1)
		        characterPlayAnim('boyfriend', 'dodge', true);
		        characterPlayAnim('dad', 'slap', true);
                        setProperty('boyfriend.specialAnim', true);
                        setProperty('dad.specialAnim', true);
		else
			setProperty('health', 0)
			playSound('attack', 1, 'Attack')
		        characterPlayAnim('dad', 'slap', true);
                        setProperty('dad.specialAnim', true);
		end
	end
	if tag == 'second-beep' then
		playSound('alert', 1, 'QT')
	end
end