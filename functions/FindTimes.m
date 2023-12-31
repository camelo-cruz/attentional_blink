function estimatedThreshold = FindTimes(w, screens, const, times, cx, cy)

    % Initialize QUEST parameters
    initialGuess = 0.150;  % Initial guess for reading speed
    initialSD = 5;         % Initial standard deviation
    pThreshold = 0.82;     % Probability of correct response
    beta = 3.5;            % Slope of the psychometric function
    delta = 0.01;          % Lapse rate
    gamma=0.5;
    
    % Initialize QUEST
    q = QuestCreate(initialGuess, initialSD, pThreshold, beta, delta, gamma);
    
    
    % Constraints on presentation time
    minPresentationTime = 0.080;   % Minimum presentation time in ms
    maxPresentationTime = 0.300;  % Maximum presentation time in ms
    
    % Number of trials
    numTrials = 50;

    for trial = 1:numTrials
        try
        % get current presentation times (for current trial)
        tTest=QuestQuantile(q);
        presentationTime = max(minPresentationTime, min(maxPresentationTime, tTest));

        %---------create rsvp-------------------------
        streamLength = 18;
	    rsvp = {};
        fillers = fileread('material/fillers.txt');
        fillers = strsplit(fillers);

        for j = 1:streamLength
		    rsvp(j) = fillers(randi(numel(fillers)));
        end

        t1pos = randi([4, 9]);
        T1 = rsvp{t1pos};

        %---------------------------------------------

        deltat = 1/120;
        stimRect = CenterRect([0 0 64 64], Screen('Rect', w));
        xchr = const.cx - const.letterWidth/2;
        ychr = const.cy - const.letterHeight/3;
        
        %present fixation cross
        Screen('DrawTexture', w, screens.fixation);
        t0 = Screen('Flip', w);
        
        Screen('FillRect', w, const.bgcolor, stimRect);
        t1 = Screen('Flip', w, t0 + times.Fix);

        %present first word in black
        Screen('FillRect', w, const.bgcolor, stimRect);
        DrawFormattedText(w, double(rsvp{1}), 'center', 'center', [0 0 0], [], [], [], [], [], [xchr, ychr, xchr, ychr]);

        t2s = NaN*ones(length(rsvp)+1, 1);
        t2s(1) = Screen('Flip', w, t1 + times.ISIafterFix);
        cnt = 1;

        %create color list for assigning colors to each word
        colorlist = [];
        for index = 2:length(rsvp)
        randomColor = generateColor();

        %check that no color is repeated
        if ~isempty(colorlist) && isequal(randomColor, colorlist(end, :))
           while isequal(randomColor, colorlist(end, :))
               randomColor = generateColor();
           end
        end
        colorlist = [colorlist; randomColor];

        % if index is target index:
        % store color of target to check with answer
        if isequal(index, t1pos)
            t1color = colorlist(end, :);
            if isequal(t1color, [255, 0, 0])
                t1color = 'red';
            elseif isequal(t1color, [0, 255, 0])
                t1color = 'green';
            elseif isequal(t1color, [0, 0, 255])
                t1color = 'blue';
            elseif isequal(t1color, [255, 255, 0])
                t1color = 'yellow';
            end
        end

        %present stimuli
        DrawFormattedText(w, double(rsvp{index}), 'center', 'center', colorlist(end, :), [], [], [], [], [], [xchr, ychr, xchr, ychr]);
        t2s(cnt+1) = Screen('Flip', w, t2s(cnt) +  presentationTime - deltat);
        t2s(cnt+2) = Screen('Flip', w, t2s(cnt+1) + times.ISI- deltat);
        cnt = cnt + 2;
        end

        Screen('FillRect', w, const.bgcolor, stimRect);
        Screen('Flip', w, t2s(end) + presentationTime - deltat);
        
        %collecting response
        oldTextSize = Screen('TextSize', w , 20);
        response = '';
        
        done = false;
        while ~done
        
            rectWidth = 420;
            rectHeight = 300;
            
            rectangles = [
                cx - rectWidth, cy+50, cx-100, cy + rectHeight;  % Rectangle 1
                cx - rectWidth, cy - rectHeight, cx-100, cy-50;  % Rectangle 2
                cx+100, cy+50, cx + rectWidth, cy + rectHeight;  % Rectangle 3 
                cx+100, cy - rectHeight, cx + rectWidth, cy-50    % Rectangle 4
            ];
            
            colors = [
                255, 0, 0; % Red
                0, 255, 0; % Green
                0, 0, 255; % Blue
                255, 255, 0; % Yellow
            ]; 
            
            names = {
                'red';
                'green';
                'blue';
                'yellow'
            };
            
            centers = [
                ((rectangles(1, 1) + rectangles(1, 3)) / 2) - 20, ((rectangles(1, 2) + rectangles(1, 4)) / 2) - 10;
                ((rectangles(2, 1) + rectangles(2, 3)) / 2) - 30, ((rectangles(2, 2) + rectangles(2, 4)) / 2) - 20; % Center of Rectangle 2
                ((rectangles(3, 1) + rectangles(3, 3)) / 2) - 20 , ((rectangles(3, 2) + rectangles(3, 4)) / 2) - 10; % Center of Rectangle 3
                ((rectangles(4, 1) + rectangles(4, 3)) / 2) - 30, ((rectangles(4, 2) + rectangles(4, 4)) / 2) - 20; % Center of Rectangle 4
            ];
            
            for i = 1:size(rectangles, 1)
                rectPosition = rectangles(i, :);
                center = centers(i, :);
                color = colors(i, :);
                text = names{i};
                Screen('FillRect', w, color, rectPosition);
                Screen('TextSize', w, 20);
                Screen('DrawText', w, double(text), center(1), center(2), [0 0 0]);
            end

            display_text = ['color of ', T1];
            Screen('DrawText', w, double(display_text), cx-100, cy-400, [255 255 255]);
            Screen('Flip', w, 0);
        
            % Get mouse coordinates
            [~, mousex,mousey,buttons,~] = GetClicks(w);
            
            % Check if the mouse is inside any rectangle and button is pressed
            for i = 1:size(rectangles, 1)
                if IsInRect(mousex, mousey, rectangles(i, :)) && any(buttons)
                    switch i
                        case 1
                            response = 'red';
                        case 2
                            response = 'green';
                        case 3
                            response = 'blue';
                        case 4
                            response = 'yellow';
                    end
                    done = true;
                end
            end
        end

        % check if response is correct
        if isequal(t1color, response)
            response = 1;
        else
            response = 0;
        end
    
        %update quest structure for use in next trial
        q=QuestUpdate(q,tTest,response);
        Screen('TextSize', w , oldTextSize);
        WaitSecs(.5);


        % Some error occurred if you get here.
        catch ME
        errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
        ME.stack(1).name, ME.stack(1).line, ME.message);
        fprintf(1, '%s\n', errorMessage);
        uiwait(warndlg(errorMessage));
        end

    end
    
    % Analyze QUEST results to get the estimated threshold
    % This is going to be, after 50 trials, presentation time of stimuli
    estimatedThreshold = QuestMean(q);
    estimatedThreshold = max(minPresentationTime, min(maxPresentationTime, estimatedThreshold));

    Screen('FillRect', w, const.bgcolor);
    
    


