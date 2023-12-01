function onUpdate(elapsed)

	if getProperty('health') >= 0.01 then

		setProperty('health', getProperty('health') - 0.01)

    end
end    