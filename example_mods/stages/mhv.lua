function onCreate()
	makeLuaSprite('code-bg-virused', 'mhv', -600, -600);
	setLuaSpriteScrollFactor('code-bg-virused', 0, 0);
	scaleObject('code-bg-virused', 1.5, 1.5)
         addGlitchEffect('code-bg-virused', 1.8, 90, 0.001);
	addLuaSprite('code-bg-virused', false);
end