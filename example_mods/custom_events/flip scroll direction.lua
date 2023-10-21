-- Script by BCTIX

local isDownscroll = false

local speed = 0

local scrollangleup = 180

local scrollangledown = 0


function onCreatePost()

	if downscroll == true then
		isDownscroll = true
		debugPrint('isdown')
		scrollangleup = 0
		scrollangledown = 180
	end

	

	
end

function onUpdate()

noteCount = getProperty('notes.length');
for i = 0, noteCount - 1 do
		if getPropertyFromGroup('notes', i, 'isSustainNote') and isDownscroll then
			setPropertyFromGroup('notes', i, 'angle', scrollangleup)
		elseif getPropertyFromGroup('notes', i, 'isSustainNote') and not isDownscroll then
			setPropertyFromGroup('notes', i, 'angle', scrollangledown)
		end
end	
end

function onEvent(e,o,t)
	if e == "flip scroll direction" then
		speed = tonumber(o)
		triggerEvent('Change Scroll Speed', '0.1', tostring(speed/2))
		for i = 0,7 do
			if isDownscroll then
				--idk
				noteTweenY('gn'..i, i, 50, speed, 'quadInOut')
				doTweenY('hpBar', 'healthBar', screenHeight*0.89,  speed, 'quadInOut')
				doTweenY('scoreTxt', 'scoreTxt', screenHeight*0.89+36,  speed, 'quadInOut')
				doTweenY('timeTxt', 'timeTxt', 19,  speed, 'quadInOut')
				doTweenY('timeBg', 'timeBar', 19+10,  speed, 'quadInOut')
				doTweenY('icon1', 'iconP1', screenHeight*0.89-75,  speed, 'quadInOut')
				doTweenY('icon2', 'iconP2', screenHeight*0.89-75,  speed, 'quadInOut')
			elseif not isDownscroll then
				noteTweenY('gn1'..i, i, 550, speed, 'quadInOut')
				doTweenY('hpBar1', 'healthBar', screenHeight*0.11, speed, 'quadInOut')
				doTweenY('scoreTxt', 'scoreTxt', screenHeight*0.11+36,  speed, 'quadInOut')
				doTweenY('timeTxt1', 'timeTxt', screenHeight-44,  speed, 'quadInOut')
				doTweenY('timeBg1', 'timeBar', screenHeight-44+10,  speed, 'quadInOut')
				doTweenY('icon11', 'iconP1', screenHeight*0.11-75,  speed, 'quadInOut')
				doTweenY('icon21', 'iconP2', screenHeight*0.11-75,  speed, 'quadInOut')
			end
		end

		
		
		runTimer('yea', tonumber(speed/2))
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'yea' then
		triggerEvent('Change Scroll Speed', '1', tostring(speed/2))

		


			if isDownscroll then
				--it didnt work unless i did it like this idkwhy
				setPropertyFromGroup('opponentStrums',0,'downScroll',false)
				setPropertyFromGroup('opponentStrums',1,'downScroll',false)
				setPropertyFromGroup('opponentStrums',2,'downScroll',false)
				setPropertyFromGroup('opponentStrums',3,'downScroll',false)
				setPropertyFromGroup('playerStrums',0,'downScroll',false)
				setPropertyFromGroup('playerStrums',1,'downScroll',false)	
				setPropertyFromGroup('playerStrums',2,'downScroll',false)	
				setPropertyFromGroup('playerStrums',3,'downScroll',false)	
				isDownscroll = false

				
		
			elseif not isDownscroll then
				setPropertyFromGroup('opponentStrums',0,'downScroll',true)
				setPropertyFromGroup('opponentStrums',1,'downScroll',true)
				setPropertyFromGroup('opponentStrums',2,'downScroll',true)
				setPropertyFromGroup('opponentStrums',3,'downScroll',true)
				setPropertyFromGroup('playerStrums',0,'downScroll',true)
				setPropertyFromGroup('playerStrums',1,'downScroll',true)	
				setPropertyFromGroup('playerStrums',2,'downScroll',true)	
				setPropertyFromGroup('playerStrums',3,'downScroll',true)
				isDownscroll = true
				
				
			end

		
		--end
	end
end

