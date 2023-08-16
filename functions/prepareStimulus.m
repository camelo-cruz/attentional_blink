function [screens, xys] = prepareStimulus(screens, mask1, mask2, ppd, dpp, cx, cy, rectUp, rectDown, boxLineWidth)
% screens: struct array of texture pointers
% mask1, mask2: abstract representations of x and y coordinates of mask lines
% ppd, dpp: conversion factors from degrees to pixels and back 
% cx, cy: x and y coordinates of Screen center
% rectUp: Bildschirmkoordinaten der oberen Box
% rectDown: Bildschirmkoordinaten der unterenBox
% boxLineWidth: line width of stimulus frame boxes

% TODO: 
% - frame-genaue Präsentation
% - Cue zeitgerecht löschen bei kurzen SOAs

% todo: compute dpp, ppd


% leere Boxen und Fixationskreuz herüberkopieren
Screen('DrawTexture', screens.mask, screens.boxes);
% einige für die Cue-Präsentation benötigte Maße berechnen

% =======================
% = % Stimulus zeichnen =
% =======================
dx = RectWidth(rectUp) / (size(mask1,2) + 1);
dy = RectHeight(rectUp) / (size(mask1,1) + 1);
y00 = rectUp(RectTop);
x00 = rectUp(RectLeft);
y01 = rectDown(RectTop);
x01 = rectDown(RectLeft);

xys0 = NaN*ones(2, numel(mask1));
xys1 = NaN*ones(2, numel(mask2));
ygrid0 = y00;
ygrid1 = y01;
cnt = 1;
for j = 1:size(mask1,1)
	xgrid0 = x00;
	xgrid1 = x01;
	ygrid0 = ygrid0 + dy;
	ygrid1 = ygrid1 + dy;
	for i = 1:size(mask1,2)
		xgrid0 = xgrid0 + dx;
		xgrid1 = xgrid1 + dx;
		xys0(:,cnt) = [xgrid0 + mask1(j,i).x * ppd(1); ygrid0 + mask1(j,i).y * ppd(2)];
		xys1(:,cnt) = [xgrid1 + mask1(j,i).x * ppd(1); ygrid1 + mask1(j,i).y * ppd(2)];
		cnt = cnt + 1;
		xys0(:,cnt) = [xgrid0 - mask2(j,i).x * ppd(1); ygrid0 - mask2(j,i).y * ppd(2)];
		xys1(:,cnt) = [xgrid1 - mask2(j,i).x * ppd(1); ygrid1 - mask2(j,i).y * ppd(2)];
		cnt = cnt + 1;
	end
end

% clip to frame
maskLineWidth = 2;
xys0 = round(xys0);
xys1 = round(xys1);

xys0(1, xys0(1,:) <= rectUp(RectLeft)) = rectUp(RectLeft) + boxLineWidth + maskLineWidth;
xys0(1, xys0(1,:) >= rectUp(RectRight)) = rectUp(RectRight) - boxLineWidth - maskLineWidth;
xys0(2, xys0(2,:) <= rectUp(RectTop)) = rectUp(RectTop) + boxLineWidth + maskLineWidth;
xys0(2, xys0(2,:) >= rectUp(RectBottom)) = rectUp(RectBottom) - boxLineWidth - maskLineWidth;

xys1(1, xys1(1,:) <= rectDown(RectLeft)) = rectDown(RectLeft) + boxLineWidth + maskLineWidth;
xys1(1, xys1(1,:) >= rectDown(RectRight)) = rectDown(RectRight) - boxLineWidth - maskLineWidth;
xys1(2, xys1(2,:) <= rectDown(RectTop)) = rectDown(RectTop) + boxLineWidth + maskLineWidth;
xys1(2, xys1(2,:) >= rectDown(RectBottom)) = rectDown(RectBottom) - boxLineWidth - maskLineWidth;

xys = [xys0 xys1];

Screen('DrawLines', screens.mask, xys, maskLineWidth, [255 255 255]);
Screen('FrameRect', screens.mask, [128 128 128], [rectUp; rectDown]', boxLineWidth);
