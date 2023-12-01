function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'slap' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'ring'); -- texture path
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashDisabled', true); --no note splashes
			setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false);
			setPropertyFromGroup('unspawnNotes', i, 'mustPress', true); 
			setPropertyFromGroup('unspawnNotes', i, 'copyAlpha', false); 
			setPropertyFromGroup('unspawnNotes', i, 'copyX', false);  
			setPropertyFromGroup('unspawnNotes', i, 'colorSwap.hue', 0)
            setPropertyFromGroup('unspawnNotes', i, 'colorSwap.saturation', 0)
            setPropertyFromGroup('unspawnNotes', i, 'colorSwap.brightness', 0)
            setPropertyFromGroup('unspawnNotes', i, 'noteSplashHue', 0)
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashSat', 0)
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashBrt', 0)
			--setPropertyFromGroup('unspawnNotes', i, 'copyY', false);  
			setPropertyFromGroup('unspawnNotes', i, 'noteData', 0); -- ITS ALWAYS A DAD RIGHT NOTE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		end
	end
end


function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'slap' then
		playSound('Shoot', 0.5);
		characterPlayAnim('boyfriend', 'dodge', true);
		characterPlayAnim('dad', 'slap', true);
		setProperty('boyfriend.specialAnim', true);
		setProperty('dad.specialAnim', true);
		cameraShake('camGame', 0.01, 0.2)
           playSound('Shoot', 0.5);
    end
end

local healthDrain = 0;
function noteMiss(id, noteData, noteType, isSustainNote)
	if noteType == 'slap' then
	     characterPlayAnim('dad', 'slap', true);
             runTimer('kill', 0.1, 1)
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
      if tag == 'kill' then
          setProperty('health', 0);
      end
end