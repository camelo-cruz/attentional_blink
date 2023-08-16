function times = drawAndPresentStimulus(w, screens, const, times, rsvp, t1Pos, t2Pos, congruence);
%FUNCTION times = drawAndPresentStimulus(w, screens, const, times, rsvp, t1Pos);
%
% w: window pointer to main screen
% screens.fixation: pointer to fixation point texture
% const: some symbolic constants
% times.Fix: presentation time fixation cross
% times.Stim: presentation time letter in RSVP stream
% times.ISI:  presentation time blank between two letters
% rsvp: stream of targets to be presented (in black, except for T1)
% t1Pos: position of T1

% % gut zum Test, ob der Stimulus anschließend zentral präsentiert ist
% Screen('DrawLine', w, [0 0 0], cx, cy - 100, cx, cy + 100, 2);
% Screen('DrawLine', w, [0 0 0], cx - 100, cy, cx + 100, cy, 2);


% self-paced: trial starts after space bar

waitForSpaceKey();

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
    color1 = rsvp(t1Pos);
    switch color1
        case 'green'
            color1 = colors(1, :);
        case 'yellow'
            color1 = colors(2, :);
        case 'blue'
            color1 = colors(3, :);
        case 'red' 
            color1 = colors(4, :);
    end

    color2 = rsvp(t2Pos);
    switch color2
        case 'green'
            color2 = colors(1, :);
        case 'yellow'
            color2 = colors(2, :);
        case 'blue'
            color2 = colors(3, :);
        case 'red' 
            color2 = colors(4, :);
    end

    randomColor = generateColor();

    if ~isempty(colorlist) && isequal(randomColor, colorlist(end, :))
       while isequal(randomColor, colorlist(end, :))
           randomColor = generateColor();
       end
    end

    colorlist = [colorlist; randomColor];
        

	if i == t1Pos
        if congruence
            colorlist = [colorlist; color1];
		    Screen('DrawText', w, double(rsvp{i}), xchr, ychr, colorlist(end, :), const.bgcolor);
        elseif isequal(color1, colorlist(end, :))
            randomColor = generateColor();
            colorlist = [colorlist; randomColor];
            Screen('DrawText', w, double(rsvp{i}), xchr, ychr, colorlist(end, :), const.bgcolor);
        else
            Screen('DrawText', w, double(rsvp{i}), xchr, ychr, colorlist(end, :), const.bgcolor);
        end
    elseif i == t2Pos
        if isequal(color2, colorlist(end, :))
            randomColor = generateColor();
            colorlist = [colorlist; randomColor];
        end
        Screen('DrawText', w, double(rsvp{i}), xchr, ychr, colorlist(end, :), const.bgcolor);
    else
        if length(colorlist) >= 2 && isequal(colorlist(end - 1), colorlist(end))
            randomColor = generateColor();
            colorlist = [colorlist; randomColor];
        end
        Screen('DrawText', w, double(rsvp{i}), xchr, ychr, colorlist(end, :), const.bgcolor);
    end
	t2s(cnt+1) = Screen('Flip', w, t2s(cnt) + times.Stim - deltat);
    t2s(cnt+2) = Screen('Flip', w, t2s(cnt+1) + times.ISI- deltat);
    cnt = cnt + 2;
end
Screen('FillRect', w, const.bgcolor, stimRect);
t3 = Screen('Flip', w, t2s(end) + times.Stim - deltat);


times.t0 = t0;
times.t1 = t1;
times.t2 = t2s;
times.t3 = t3;
