%function FindTimes()

%PsychDebugWindowConfiguration


initialGuess = 0.030;  % Initial guess for displaying time
thresholdRange = [0.001, 1];  % Possible range of displaying times
pThreshold = 0.82;  % Probability of correct response

q = QuestCreate(initialGuess, pThreshold, thresholdRange);

% Experiment loop
while ~QuestSd(q) < 0.01  % Convergence criterion
    % Get next stimulus time from QUEST
    stimulusTime = QuestQuantile(q);
    
    % Present stimulus with the calculated time
    [rsvp, T1, T2] = generateRSVPstream(t1, t1Pos, t2, t2Pos, 'material/fillers.txt');
    times = drawAndPresentStimulus(w, screens, const, times, rsvp, t1Pos, t2Pos, t1congruent);

    % Collect participant's response (1 for perceived, 0 for not perceived)
    responseSet = {'1', '0'};
    responseSetCodes = KbName(responseSet1);
    keyIsDown = true;
    while keyIsDown
        [keyIsDown, ~, keyCode] = KbCheck();
    end
    
    DrawFormattedText(w, 'visible?', 'center', cy-150, [0 0 0]);
    Screen('Flip', w, 0);
    done = false;

    while ~done
        [keyIsDown, secs, keyCode] = KbCheck();
        if keyIsDown && sum(keyCode)==1 	% only a single key pressed
            if any(keyCode(responseSetCodes1))
                rt = secs - t0;
                response = KbName(keyCode);
                DrawFormattedText(w, 'Visible', 'center', cy-150, [0 0 0]);
                Screen('DrawText', w, response, cx, cy-100);
                Screen('Flip', w);
                done = true;
            end
        end
    end

    %response = PresentStimulusAndCollectResponse(stimulusTime);
    
    % Update QUEST algorithm with the response
    q = QuestUpdate(q, stimulusTime, response);
end

% Get the final estimated threshold
finalThreshold = QuestMean(q);

disp(['Final Estimated Threshold: ', num2str(finalThreshold)]);

% Use the finalThreshold for your experiment