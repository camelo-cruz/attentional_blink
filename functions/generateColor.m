function randomColor = generateColor()

    colors = [
    0   255 0;     % Green
    255 255 0;     % Yellow
    0   0   255;   % Blue
    255 0   0      % Red
    ];
    
    randomIndex = randi(size(colors, 1));
    randomColor = colors(randomIndex, :);
        