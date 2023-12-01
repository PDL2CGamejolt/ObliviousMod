--so then do this

function onCreate()

--Iterate over all notes

for i = 0, getProperty('unspawnNotes.length')-1 do

--Check if the note is an Instakill Note

if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Heal Note' then --change the notetype name here

setPropertyFromGroup('unspawnNotes', i, 'texture', 'HELLBEATNOTE_ASSETS'); --Change the name of the texture you want it to change to
setPropertyFromGroup('unspawnNotes', i, 'hitHealth', '0'); --Default value is: 0.023, health gained on hit
setPropertyFromGroup('unspawnNotes', i, 'missHealth', '0'); --Default value is: 0.0475, health lost on miss
setPropertyFromGroup('unspawnNotes', i, 'hitCausesMiss', false); --Whether hitting the note should count as a miss

if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true); --Miss has no penalties, botplay wont hit them but oh well
end
end
end
end

healamount = 0.015

poisonTimer = false;

-- Function called when you hit a note (after note hit calculations)

-- id: The note member id, you can get whatever variable you want from this note, example: "getPropertyFromGroup('notes', id, 'strumTime')"

-- noteData: 0 = Left, 1 = Down, 2 = Up, 3 = Right

-- noteType: The note type string/tag

-- isSustainNote: If it's a hold note, can be either true or false

function onStepHit()

if poisonTimer == true then

health = getProperty('health')

setProperty('health', getProperty('health')+healamount)

end

end

-- Called after the note miss calculations

-- Player missed a note by letting it go offscreen

function goodNoteHit(id, noteData, noteType, isSustainNote)

if noteType == 'Heal Note' then

runTimer('somethingrandom09', 10);

poisonTimer = true;

end

end

function onTimerCompleted(tag, loops, loopsLeft)

if tag == 'somethingrandom09' then

poisonTimer = false

end

end