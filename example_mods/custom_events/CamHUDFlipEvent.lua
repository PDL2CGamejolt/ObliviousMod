function onEvent(name, value1, value2)
if name == 'CamHUDFlipEvent' then
 --This Is For The Camera
 doTweenAngle('bruh', 'camhud', 180, 0.2, 'linear')
--When The Script Started, It Will Play A Sound
playSound('woop', true)

end
end