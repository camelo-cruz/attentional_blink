function [rt, response, response2] = collectResponse(w, cx, cy, t0)
% waits for key in response set, returns response time and symbolic name
% w: Haupt-Fenster
% t0: Beginn der Präsentation letzter Reiz
persistent keyIsDown secs keyCode keyCode2 

oldTextSize = Screen('TextSize', w , 20);


responseSet1 = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};
responseSet2 = {'z', 'n'};
responseSetCodes1 = KbName(responseSet1);
responseSetCodes2 = KbName(responseSet2);

keyIsDown = true;
while keyIsDown
    [keyIsDown, ~, keyCode] = KbCheck();
end

DrawFormattedText(w, 'First letter', 'center', cy-150, [0 0 0]);
Screen('Flip', w, 0);


done = false;
while ~done
    [keyIsDown, secs, keyCode] = KbCheck();
    if keyIsDown && sum(keyCode)==1 	% only a single key pressed
        if any(keyCode(responseSetCodes1))
            rt = secs - t0;
            response = KbName(keyCode);
            % adjust for German keyboard
            if upper(response) == 'Z'
                response = 'Y';
            elseif upper(response) == 'Y'
                response = 'Z';
            end
            DrawFormattedText(w, 'First letter', 'center', cy-150, [0 0 0]);
            Screen('DrawText', w, upper(response), cx, cy-100);
            DrawFormattedText(w, 'X present (y/n)', 'center', cy+50, [0 0 0])
            Screen('Flip', w);
            done = true;
        end
    end
end

keyIsDown = true;
while keyIsDown
    [keyIsDown, ~, keyCode2] = KbCheck();
end

done = false;
while ~done
    [keyIsDown, ~, keyCode2] = KbCheck();
    if keyIsDown && sum(keyCode2)==1 % only a single key pressed
        if any(keyCode2(responseSetCodes2))
            % rt = secs - t0;
            response2 = KbName(keyCode2);
            % adjust for German keyboard
            if upper(response2) == 'Z'
                response2 = 'Y';
            elseif upper(response2) == 'Y'
                response2 = 'Z';
            end
            done = true;
        end
    end

end

DrawFormattedText(w, 'First letter', 'center', cy-150, [0 0 0]);
Screen('DrawText', w, upper(response), cx, cy-100);
DrawFormattedText(w, 'X present (y/n)', 'center', cy+50, [0 0 0])
Screen('DrawText', w, upper(response2), cx, cy+100);
Screen('Flip', w);

Screen('TextSize', w , oldTextSize);
WaitSecs(.5);

