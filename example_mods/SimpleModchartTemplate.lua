local modchart = true --easy toggle

--"simple" psych lua modchart template by TheZoroForce240
--insprired by other templates (and notitg/itg of course)
--simple for actual modcharts, complex for generic fnf modcharts, can be really powerful if you know what youre doing
--made originally for final timeout new modchart (vs mart)


--features
--z axis on notes/strums (no layering sorry it causes a lot of lag, can be done in source if you know what youre doing)
--modifier system which can affect each note indivdually, and allows for cool looking wavy long notes
--basic modifiers built in (drunk/tipsy/reverse)
--modifiers can be stacked, tweened in/out and automatically work for both up and downscroll


local keyCount = 4
local arrowSize = 112 --160 * 0.7, usually wanna change if using more keys
local scrollSwitch = 520 --height to move to when reverse
--local noteDist = 0.45 --used for flipping between up/downscroll smoothly

local defaultSusScaleY = -1 --store scaley for all sustains
local defaultSusEndScaleY = -1


function runModifiers(data, curPos)
	--this is where mod math gets applied to strums/notes
	local xOffset = 0
	local yOffset = 0
	local zOffset = 0
	local angle = 0

	xOffset = xOffset + getProperty('strumOffset'..data..'.x') --add strum offsets
	yOffset = yOffset + getProperty('strumOffset'..data..'.y')
	zOffset = zOffset + getProperty('strumOffset'..data..'.angle') --using angle because

	--drunk
	if getProperty('drunk.x') ~= 0 then 
		xOffset = xOffset + getProperty('drunk.x') * (math.cos( ((getSongPosition()*0.001) + ((data%keyCount)*0.2) + (curPos*0.45)*(10/screenHeight)) * (getProperty('drunkSpeed.x')*0.2)) * arrowSize*0.5);
	end
	if getProperty('drunk.y') ~= 0 then 
		yOffset = yOffset + getProperty('drunk.y') * (math.cos( ((getSongPosition()*0.001) + ((data%keyCount)*0.2) + (curPos*0.45)*(10/screenHeight)) * (getProperty('drunkSpeed.y')*0.2)) * arrowSize*0.5);
	end
	if getProperty('drunk.angle') ~= 0 then 
		zOffset = zOffset + getProperty('drunk.angle') * (math.cos( ((getSongPosition()*0.001) + ((data%keyCount)*0.2) + (curPos*0.45)*(10/screenHeight)) * (getProperty('drunkSpeed.angle')*0.2)) * arrowSize*0.5);
	end

	--tipsy
	if getProperty('tipsy.x') ~= 0 then 
		xOffset = xOffset + getProperty('tipsy.x') * ( math.cos( getSongPosition()*0.001 *(1.2) + (data%keyCount)*(2.0) + getProperty('tipsySpeed.x')*(0.2) ) * arrowSize*0.4 );
	end
	if getProperty('tipsy.y') ~= 0 then 
		yOffset = yOffset + getProperty('tipsy.y') * ( math.cos( getSongPosition()*0.001 *(1.2) + (data%keyCount)*(2.0) + getProperty('tipsySpeed.y')*(0.2) ) * arrowSize*0.4 );
	end
	if getProperty('tipsy.angle') ~= 0 then 
		zOffset = zOffset + getProperty('tipsy.angle') * ( math.cos( getSongPosition()*0.001 *(1.2) + (data%keyCount)*(2.0) + getProperty('tipsySpeed.angle')*(0.2) ) * arrowSize*0.4 );
	end

	--reverse (scroll flip)
	if getProperty('reverse.y') ~= 0 or getProperty('reverse'..data..'.y') ~= 0 then 
		yOffset = yOffset + scrollSwitch * (getProperty('reverse.y') + getProperty('reverse'..data..'.y'))
	end

	--confusion (note angle)
	if getProperty('confusion.angle') ~= 0 or getProperty('confusion'..data..'.angle') ~= 0 then 
		angle = angle + getProperty('confusion.angle') + getProperty('confusion'..data..'.angle')
	end
	
	--add any custom modifiers here lol 


	return {xOffset, yOffset, zOffset/1000, angle}
	--do divide 1000 on z so it matches more closely to the other axis
end

function onCreatePost()
	for i = 0,(keyCount*2)-1 do 
		makeLuaSprite('strumOffset'..i, '', 0, 0)
		makeLuaSprite('scaleMulti'..i, '', 1, 1)
		makeLuaSprite('reverse'..i, '', 0, 0)
		makeLuaSprite('confusion'..i, '', 0, 0)
	end
	
	--basic modifiers
	--using lua sprites so you can tween lol
	--changing angle changes the z, not actual angle, to change note angle use confusion
	makeLuaSprite('tipsy', '', 0, 0)
	makeLuaSprite('drunk', '', 0, 0)
	makeLuaSprite('tipsySpeed', '', 1, 1)
	makeLuaSprite('drunkSpeed', '', 1, 1)

	makeLuaSprite('scale', '', 0.7, 0.7) --0.7 = default scale
	makeLuaSprite('confusion', '', 0, 0) --angle

	makeLuaSprite('reverse', '', 0, 0) --only y does stuff

	--setProperty('drunk.x', 0.5)
	--setProperty('tipsySpeed.angle', 1)

	if downscroll then 
		scrollSwitch = -520
	end


	modchart = true
	if not modchart then 
		return 
	end
end

function onEvent(tag, val1, val2)

	if tag == 'resetX' then 
		resetX(tonumber(val1), val2)
	elseif tag == 'resetY' then 
		resetY(tonumber(val1), val2)
	elseif tag == 'resetZ' then 
		resetZ(tonumber(val1), val2)
	elseif tag == 'invert' then 
		invert(tonumber(val1), val2)
	elseif tag == 'flip' then 
		flip(tonumber(val1), val2)
	elseif tag == 'easeModifierX' then 
		local nameAndVal = val1:split(",")
		local timeAndEase = val2:split(",")
		doTweenX(nameAndVal[1]..'.x', nameAndVal[1], tonumber(nameAndVal[2]), tonumber(timeAndEase[1]), timeAndEase[2])
	elseif tag == 'easeModifierY' then 
		local nameAndVal = val1:split(",")
		local timeAndEase = val2:split(",")
		doTweenY(nameAndVal[1]..'.y', nameAndVal[1], tonumber(nameAndVal[2]), tonumber(timeAndEase[1]), timeAndEase[2])
	elseif tag == 'easeModifierZ' then 
		local nameAndVal = val1:split(",")
		local timeAndEase = val2:split(",")
		doTweenAngle(nameAndVal[1]..'.z', nameAndVal[1], tonumber(nameAndVal[2]), tonumber(timeAndEase[1]), timeAndEase[2])
	elseif tag == 'setModifierX' then 
		setProperty(val1..'.x', tonumber(val2))
	elseif tag == 'setModifierY' then 
		setProperty(val1..'.y', tonumber(val2))
	elseif tag == 'setModifierZ' then 
		setProperty(val1..'.angle', tonumber(val2))
	end
end

function string:split( inSplitPattern, outResults ) -- from here, code isnt mine, https://stackoverflow.com/questions/19262761/lua-need-to-split-at-comma
    if not outResults then
      outResults = { }
    end
    local theStart = 1
    local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
    while theSplitStart do
      table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
      theStart = theSplitEnd + 1
      theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
    end
    table.insert( outResults, string.sub( self, theStart ) )
    return outResults
end

function resetX(time, ease)
	for i = 0,(keyCount*2)-1 do
		doTweenX(i..'x', 'strumOffset'..i, 0, time, ease)
	end
end
function resetY(time, ease)
	for i = 0,(keyCount*2)-1 do
		doTweenY(i..'y', 'strumOffset'..i, 0, time, ease)
	end
end
function resetZ(time, ease)
	for i = 0,(keyCount*2)-1 do
		doTweenAngle(i..'z', 'strumOffset'..i, 0, time, ease)
	end
end

function invert(time, ease)
	for i = 0,(keyCount*2)-1 do
		local invert = -1
		if i % 2 == 0 then 
			invert = 1
		end
		doTweenX(i..'x', 'strumOffset'..i, arrowSize*invert, time, ease)
	end
end
function flip(time, ease)
	--for i = 0,7 do
	--	doTweenX(i..'x', 'strumOffset'..i, arrowSize * 2 * (1.5 - (i%4)), time, ease)
	--end
	doTweenX('0x', 'strumOffset0', arrowSize * 3, time, ease)
	doTweenX('1x', 'strumOffset1', arrowSize * 1, time, ease)
	doTweenX('2x', 'strumOffset2', arrowSize * -1, time, ease)
	doTweenX('3x', 'strumOffset3', arrowSize * -3, time, ease)

	doTweenX('4x', 'strumOffset4', arrowSize * 3, time, ease)
	doTweenX('5x', 'strumOffset5', arrowSize * 1, time, ease)
	doTweenX('6x', 'strumOffset6', arrowSize * -1, time, ease)
	doTweenX('7x', 'strumOffset7', arrowSize * -3, time, ease)
	
end

local copyZ = true

function onUpdatePost(elapsed)

	if not modchart then 
		return 
	end

	local xPos = {}
	local yPos = {}
	local zPos = {}

	--runHaxeCode('game.variables["strumZOrder"] = [];')

	for i = 0,(keyCount*2)-1 do 
		table.insert(xPos, 0) --fill up for how many keys there are
		table.insert(yPos, 0)
		table.insert(zPos, 0)

		--xPos[i+1] = xPos[i+1] + xOffset[i+1]
		--yPos[i+1] = yPos[i+1] + yOffset[i+1]
		--zPos[i+1] = zPos[i+1] + zOffset[i+1]


		--runHaxeCode('game.variables["strumZOrder"].push('..zPos[i+1]..');')

	end


	local zNear = 0
	local zFar = 100
	local zRange = zNear - zFar 
	local tanHalfFOV = math.tan(math.pi/4)

	if copyZ then 

		for i = 0,(keyCount*2)-1 do 

			--Z Axis on strums
	
			local notePosZ = -1
	
			local strum = 'PlayerStrum'
			if i < keyCount then 
				strum = 'OpponentStrum'
			end
			local notePosX = _G['default'..strum..'X'..i%keyCount] - (screenWidth/2)
			local notePosY = _G['default'..strum..'Y'..i%keyCount] - (screenHeight/2)
			local noteAngle = 0

			local offsets = runModifiers(i, 0) --calc offsets
			notePosX = notePosX + offsets[1]
			notePosY = notePosY + offsets[2]
			notePosZ = notePosZ + offsets[3]
			noteAngle = noteAngle + offsets[4]
	
	
			local zPerspectiveOffset = (notePosZ+(2 * zFar * zNear / zRange));
			local xPerspective = notePosX*(1/tanHalfFOV);
			local yPerspective = notePosY/(1/tanHalfFOV);
			xPerspective = xPerspective/-zPerspectiveOffset;
			yPerspective = yPerspective/-zPerspectiveOffset;
	
			setPropertyFromGroup('strumLineNotes', i, 'x', xPerspective + (screenWidth/2))
			setPropertyFromGroup('strumLineNotes', i, 'y', yPerspective + (screenHeight/2))
			setPropertyFromGroup('strumLineNotes', i, 'angle', noteAngle)
	
			setPropertyFromGroup('strumLineNotes', i, 'scale.x', getProperty('scale.x') * (1/-zPerspectiveOffset) * getProperty('scaleMulti'..i..'.x'))
			setPropertyFromGroup('strumLineNotes', i, 'scale.y', getProperty('scale.y') * (1/-zPerspectiveOffset) * getProperty('scaleMulti'..i..'.y'))


			--explaination on perspective math

			--to start you need some basic variables for far, near, and range and the fov (tan halfed), ive skipped the actual fov since its not really needed (its just math.pi/2, which is 90 deg)
			--[[
				local zNear = 0
				local zFar = 100
				local zRange = zNear - zFar 
				local tanHalfFOV = math.tan(math.pi/4)
			]]
			--next, you need the position of your object without any perspective applied, so for this, it gets the default strum pos
			--you then take away that position by the screen width/height / 2 (it will be added back later so down worry about it), 
			--this is so fake "3D" camera focuses on the center of the screen 

			--you then do the main calculation for the perspective which is 
			--[[
				(z+(2 * zFar * zNear / zRange)); 
			]]--
			--there are more but its not nessessary for this

			--now you can transform the x and y using the halftanfov and the calculated perspective,
			--[[
				local xPerspective = notePosX*(1/tanHalfFOV);
				local yPerspective = notePosY/(1/tanHalfFOV);
				xPerspective = xPerspective/-zPerspectiveOffset;
				yPerspective = yPerspective/-zPerspectiveOffset;
			]]--
			--now you just add the screen width/height / 2 back onto the x/y and thats it for the main positioning

			--the only thing left is to do the scaling
			--which is just multiplying the scale by (1/-zPerspectiveOffset)
			--you need to remember the default scale though, for notes its just 0.7
			--[[
				getProperty('scale.x') * (1/-zPerspectiveOffset)
				getProperty('scale.y') * (1/-zPerspectiveOffset)
			]]
			--for most sprites, you also should updatehitbox right after scaling, its not done for strums since its done automatically and doing it here breaks the offsets

			--good place to go if you wanna learn more about this kinda stuff https://ogldev.org/www/tutorial12/tutorial12.html




			--updateHitboxFromGroup('strumLineNotes', i)

			

		end
	
		local noteCount = getProperty('notes.length');
		local fakeCrochet = (60 / bpm) * 1000

		--runHaxeCode('game.variables["noteZOrder"] = [];')
	
		for i = 0, noteCount-1 do 
			--setProperty('notes', i, 'copyX', false)
			--setProperty('notes', i, 'copyY', false)
			local mustPress = getPropertyFromGroup('notes', i, 'mustPress');
			local isSustainNote = getPropertyFromGroup('notes', i, 'isSustainNote');
			local noteData = getPropertyFromGroup('notes', i, 'noteData');
			local isSusEnd = string.find(string.lower(getPropertyFromGroup('notes', i, 'animation.curAnim.name')), 'end') or string.find(string.lower(getPropertyFromGroup('notes', i, 'animation.curAnim.name')), 'tail') --check tail in case playing on engine with extra keys
	
			--Z Axis on notes
	
			local notePosZ = -1

			local strumPos = noteData+keyCount
			local noteAngle = 0

	
			local strum = 'PlayerStrum'
			if not mustPress then 
				strum = 'OpponentStrum'
				strumPos = noteData
			end
			local notePosX = _G['default'..strum..'X'..noteData%keyCount] - (screenWidth/2)
			
			--local notePosY = getPropertyFromGroup('notes', i, 'y') - (screenHeight/2) 
			local notePosY = _G['default'..strum..'Y'..noteData%keyCount] - (screenHeight/2)

			local curPos = (getSongPosition()-getPropertyFromGroup('notes', i, 'strumTime')) * getProperty('songSpeed')

			local noteDist = 0.45
			if getProperty('reverse.y') ~= 0 then 
				noteDist = noteDist * (1-(getProperty('reverse.y')*2))		
			end
			if getProperty('reverse'..strumPos..'.y') ~= 0 then 
				noteDist = noteDist * (1-(getProperty('reverse'..strumPos..'.y')*2))		
			end
		

			local fixedDist = noteDist
			if downscroll then 
				fixedDist = noteDist * -1 --flip for downscroll
			end

			notePosY = notePosY - (curPos*fixedDist) --calc note y pos
			--setProperty('notes', i, 'flipY', fixedDist < 0)

			if isSustainNote and fixedDist < 0 then --fix downscroll sustains, just psych engine code put into lua
				setPropertyFromGroup('notes', i, 'flipY', true)

				if isSusEnd then
					notePosY = notePosY + 10.5 * (fakeCrochet / 400) * 1.5 * scrollSpeed + (46 * (scrollSpeed - 1));
					notePosY = notePosY - (46 * (1 - (fakeCrochet / 600)) * scrollSpeed);
					notePosY = notePosY - 19;
				end
				notePosY = notePosY + ((arrowSize) / 2) - (60.5 * (scrollSpeed - 1));
				notePosY = notePosY + 27.5 * ((bpm / 100) - 1) * (scrollSpeed - 1);

			else 
				setPropertyFromGroup('notes', i, 'flipY', false)
			end

			local offsets = runModifiers(strumPos, curPos) --calc offsets
			notePosX = notePosX + offsets[1]
			notePosY = notePosY + offsets[2]
			notePosZ = notePosZ + offsets[3]
			noteAngle = noteAngle + offsets[4]
	
			local zPerspectiveOffset = (notePosZ+(2 * zFar * zNear / zRange));

			notePosX = notePosX + getPropertyFromGroup('notes', i, 'offsetX') / (1/-zPerspectiveOffset)

			local xPerspective = notePosX*(1/tanHalfFOV);
			local yPerspective = notePosY/(1/tanHalfFOV);
			xPerspective = xPerspective/-zPerspectiveOffset;
			yPerspective = yPerspective/-zPerspectiveOffset;
	
			setPropertyFromGroup('notes', i, 'x', xPerspective + (screenWidth/2))
			setPropertyFromGroup('notes', i, 'y', yPerspective + (screenHeight/2))
	
			setPropertyFromGroup('notes', i, 'scale.x', getProperty('scale.x') * (1/-zPerspectiveOffset) * getProperty('scaleMulti'..strumPos..'.x'))
			if not isSustainNote then 
				setPropertyFromGroup('notes', i, 'scale.y', getProperty('scale.y') * (1/-zPerspectiveOffset) * getProperty('scaleMulti'..strumPos..'.y'))
				setPropertyFromGroup('notes', i, 'angle', noteAngle)
			else 
				if defaultSusEndScaleY == -1 and isSusEnd then 
					defaultSusEndScaleY = getPropertyFromGroup('notes', i, 'scale.y') --get sustain scaley
				
				elseif defaultSusScaleY == -1 and not isSusEnd then 
					defaultSusScaleY = getPropertyFromGroup('notes', i, 'scale.y') --get sustain scaley
				end

				if isSusEnd then --do sustains scale shit
					setPropertyFromGroup('notes', i, 'scale.y', defaultSusEndScaleY * (1/-zPerspectiveOffset) * (scrollSpeed/getProperty('songSpeed')))
				else 
					setPropertyFromGroup('notes', i, 'scale.y', defaultSusScaleY * (1/-zPerspectiveOffset) * (scrollSpeed/getProperty('songSpeed')))
				end
				
				--work out angle by calculating where the next sustain note would be
				local nextPos = curPos + (stepCrochet + (stepCrochet/getProperty('songSpeed')))
				local nextNoteY = _G['default'..strum..'Y'..noteData%keyCount] - (screenHeight/2)
				--nextNoteY = nextNoteY + ((stepCrochet + (stepCrochet/scrollSpeed))*fixedDist*scrollSpeed)
				nextNoteY = nextNoteY - (nextPos*fixedDist)
				local thisNoteY = notePosY
				local nextNoteX = _G['default'..strum..'X'..noteData%keyCount] - (screenWidth/2)
				nextNoteX = nextNoteX + getPropertyFromGroup('notes', i, 'offsetX') / (1/-zPerspectiveOffset)
				local thisNoteX = notePosX


				local susOffsets = runModifiers(noteData, nextPos) --do mods for fake sustain
				nextNoteX = nextNoteX + susOffsets[1]
				nextNoteY = nextNoteY + susOffsets[2]
				--notePosZ = notePosZ + offsets[3] --no doing z because cant angle towards z
				local ang = 0
				if fixedDist < 0 then 
					ang = math.deg(math.atan2( (nextNoteY-thisNoteY), (nextNoteX-thisNoteX) ) - math.pi/2) --calc angle by comparing difference in position
					--debugPrint(ang)
				else 
					ang = math.deg(math.atan2( (nextNoteY-thisNoteY), (nextNoteX-thisNoteX) ) + math.pi/2)
				end

				setPropertyFromGroup('notes', i, 'angle', ang)



			end

			

			updateHitboxFromGroup('notes', i) --update hitbox on notes lol

			--runHaxeCode('game.variables["noteZOrder"].push('..za..');')
	
	
	
		end

		--pain
		--dont even know if this works
		--runHaxeCode('game.notes.sort(function(a,b) { if (game.variables["noteZOrder"][game.notes.members.indexOf(a)] < game.variables["noteZOrder"][game.notes.members.indexOf(b)]) \nreturn -1; else if \n(game.variables["noteZOrder"][game.notes.members.indexOf(a)] > game.variables["noteZOrder"][game.notes.members.indexOf(b)]) return 1; else \n return 0;});')

	end


end






