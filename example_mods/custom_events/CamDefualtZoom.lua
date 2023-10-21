function onEvent(name, value1, value2)
	if name == "CamDefualtZoom" then
	    zoom = tonumber(value1);
		setProperty('defaultCamZoom',zoom)
	end
end