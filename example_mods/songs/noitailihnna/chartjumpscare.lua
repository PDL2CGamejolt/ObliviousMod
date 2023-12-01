function onCreatePost()
   setProperty('debugKeysChart', null); -- prevents key from doing anything

    makeAnimatedLuaSprite('sonicBoo','sonicJUMPSCARE',100,0)
    addAnimationByPrefix('sonicBoo','boo','sonicSPOOK',24,false)
    setProperty('sonicBoo.alpha',0.001)
    setObjectCamera('sonicBoo','other')
    addLuaSprite('sonicBoo',true)
end

function onUpdate()
 if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SEVEN') then

      setProperty('sonicBoo.alpha',1)
      playSound('datOneSound')
      objectPlayAnimation('sonicBoo','boo',true)

	runTimer('jumpscareWait', 1, 1)
end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'jumpscareWait' then
	os.exit();
end
end
