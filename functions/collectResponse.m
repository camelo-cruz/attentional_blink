function [rt, response1, response2] = collectResponse(w, cx, cy, t0)

persistent secs

response1 = '';
response2 = '';
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

    Screen('DrawText', w, 'first adjective', cx-100, cy-400, [255 255 255]);
    Screen('Flip', w, 0);

    % Get mouse coordinates
    [clicks,mousex,mousey,buttons,secs] = GetClicks(w);
    
    % Check if the mouse is inside any rectangle and button is pressed
    for i = 1:size(rectangles, 1)
        if IsInRect(mousex, mousey, rectangles(i, :)) && any(buttons)
            rt = secs - t0;
            switch i
                case 1
                    response1 = 'red';
                case 2
                    response1 = 'green';
                case 3
                    response1 = 'blue';
                case 4
                    response1 = 'yellow';
            end
            done = true;
        end
    end

end


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
        color = colors(i, :);
        center = centers(i, :);
        text = names{i};
        Screen('FillRect', w, color, rectPosition);
        Screen('TextSize', w, 20);
        Screen('DrawText', w, text, center(1), center(2), [0 0 0]);
    end

    Screen('DrawText', w, 'second adjective', cx-100, cy-400, [255 255 255]);
    Screen('Flip', w, 0);

    % Get mouse coordinates
    [clicks,mousex,mousey,buttons,secs] = GetClicks(w);
    
    % Check if the mouse is inside any rectangle and button is pressed
    for i = 1:size(rectangles, 1)
        if IsInRect(mousex, mousey, rectangles(i, :)) && any(buttons)
            rt = secs - t0;
            switch i
                case 1
                    response2 = 'red';
                case 2
                    response2 = 'green';
                case 3
                    response2 = 'blue';
                case 4
                    response2 = 'yellow';
            end
            done = true;
        end
    end
end