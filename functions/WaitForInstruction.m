function  instruction = WaitForInstruction()

keyIsDown = true;
while keyIsDown
	[keyIsDown, t00, keyCode, deltaSecs] = KbCheck();
end
done = false;
while ~done
	[keyIsDown, secs, keyCode, deltaSecs] = KbCheck();
    if keyCode(KbName('ESCAPE'))
	    instruction = 'kill';
        done = true;
    elseif keyCode(KbName('space'))
        instruction = 'continue';
        done = true;
    end
end
