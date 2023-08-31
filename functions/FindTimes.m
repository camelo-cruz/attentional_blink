function estimatedThreshold = FindTimes(w, screens, const, times, cx, cy)

    persistent secs
    % Initialize QUEST parameters
    initialGuess = 0.300;  % Initial guess for reading speed
    initialSD = 1;     % Initial standard deviation
    pThreshold = 0.82;   % Probability of correct response
    beta = 3.5;          % Slope of the psychometric function
    delta = 0.01;        % Lapse rate
    gamma=0.5;
    
    % Initialize QUEST structure
    q = QuestCreate(initialGuess, initialSD, pThreshold, beta, delta, gamma);
    
    
    % Constraints on presentation time
    minPresentationTime = 0.080;   % Minimum presentation time in ms
    maxPresentationTime = 0.300;  % Maximum presentation time in ms
    
    % Number of trials
    numTrials = 50;

    % Get the current stimulus intensity from QUEST
    
    % Calculate presentation time based on current intensity
    


    for trial = 1:numTrials
        tTest=QuestQuantile(q);
        presentationTime = max(minPresentationTime, min(maxPresentationTime, tTest));

        %---------create rsvp-------------------------
        streamLength = 18;
	    rsvp = {};
        fillers = fileread('material/fillers.txt');
        fillers = strsplit(fillers);

	    for i = 1:streamLength
		    rsvp(i) = fillers(randi(numel(fillers)));
        end


        t1pos = randi([4, 9]);
        t2pos = randi([4, 9]);
        t2 = rsvp{t2pos};
        T1 = rsvp{t1pos};

        %---------------------------------------------
        deltat = 1/120;
        stimRect = CenterRect([0 0 64 64], Screen('Rect', w));
        xchr = const.cx - const.letterWidth/2;
        ychr = const.cy - const.letterHeight/3;
        
        dx = .3 * const.ppd(1);
        dy = .3 * const.ppd(2);
        
        Screen('DrawTexture', w, screens.fixation);
        t0 = Screen('Flip', w);
        
        Screen('FillRect', w, const.bgcolor, stimRect);
        t1 = Screen('Flip', w, t0 + times.Fix);
        
        Screen('FillRect', w, const.bgcolor, stimRect);
        Screen('DrawText', w, double(rsvp{1}), xchr, ychr, [0 0 0], const.bgcolor);
        
        t2s = NaN*ones(length(rsvp)+1, 1);
        t2s(1) = Screen('Flip', w, t1 + times.ISIafterFix);
        cnt = 1;
        
        colorlist = [];
        for i = 2:length(rsvp)
            
        colors = [
            0   255 0;     % Green
            255 255 0;     % Yellow
            0   0   255;   % Blue
            255 0   0      % Red
        ];

        randomColor = generateColor();

        if ~isempty(colorlist) && isequal(randomColor, colorlist(end, :))
           while isequal(randomColor, colorlist(end, :))
               randomColor = generateColor();
           end
        end
    
        colorlist = [colorlist; randomColor];

        if length(colorlist) >= 2 && isequal(colorlist(end - 1), colorlist(end))
            randomColor = generateColor();
            colorlist = [colorlist; randomColor];
        end

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

        Screen('DrawText', w, double(rsvp{i}), xchr, ychr, colorlist(end, :), const.bgcolor);
        t2s(cnt+1) = Screen('Flip', w, t2s(cnt) +  presentationTime - deltat);
        t2s(cnt+2) = Screen('Flip', w, t2s(cnt+1) + times.ISI- deltat);
        cnt = cnt + 2;
        end

        Screen('FillRect', w, const.bgcolor, stimRect);
        t3 = Screen('Flip', w, t2s(end) + presentationTime - deltat);
        correct1 = 0;
        correct2 = 0;

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
                Screen('DrawText', w, text, center(1), center(2), [0 0 0]);
            end

            display_text = ['color of ', T1];
            Screen('DrawText', w, display_text, cx-100, cy-400, [255 255 255]);
            Screen('Flip', w, 0);
        
            % Get mouse coordinates
            [clicks, mousex,mousey,buttons,secs] = GetClicks(w);
            
            % Check if the mouse is inside any rectangle and button is pressed
            for i = 1:size(rectangles, 1)
                if IsInRect(mousex, mousey, rectangles(i, :)) && any(buttons)
                    rt = secs - t0;
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

    if isequal(t1color, response)
        response = 1;
    else
        response = 0;
    end

    q=QuestUpdate(q,tTest,1);
    Screen('TextSize', w , oldTextSize);
    WaitSecs(.5);

    end
    % Analyze QUEST results to get the estimated threshold
    estimatedThreshold = QuestMean(q);
    estimatedThreshold = max(minPresentationTime, min(maxPresentationTime, estimatedThreshold));
    
    
    % Close any open Psychtoolbox windows
    %Screen('CloseAll');


