% Attentional blink experiment
PsychDebugWindowConfiguration
Screen('Preference', 'SkipSyncTests', 2);
try
	addpath('functions');
	KbName('UnifyKeyNames');
	ListenChar(2);
	[w, screens, const] = initGraphics;

	vpnr = 1;
    %output file
	resultFileName = ['results/Attentional_blink_Exp_' num2str(vpnr) '.dat'];
    %generating randomized design with random seed for reproducibility
    [design, designlbls] = genDesign(vpnr);

	NTRIALS = size(design,1);
	
    resultVars = table('Size', [NTRIALS 4], ...
        'VariableNames', {'R1', 'R2', 'correct1', 'correct2'}, ...
        'VariableTypes', {'string', 'string', 'double', 'double'});

	design = [design resultVars];

	[cx, cy] = RectCenter(const.srect);

	ESC = KbName('ESCAPE');
	keyCode = zeros(1,256);

	% timings
	% 	Raymond / Shapiro 
	times.ISI = 0.075;
	times.ISIafterFix = 0.000;
	times.Fix = 0.600;
	times.Stim = 0.015;

    showInstructions(w, const, 'material/instructions.txt');

	for trial = 1:NTRIALS
        % ====================
		% = specify Stimulus =
		% ====================
        t1 = design.color_T1(trial);
        t2 = design.color_T2(trial);
		t1Pos = design.PosT1(trial);
		t2Pos = design.PosT2(trial);
		t1congruent = design.congruence(trial);

        %generating rsvp with target1, target2, their positions and fillers
		[rsvp, T1] = generateRSVPstream(t1, t1Pos, t2, t2Pos, 'material/fillers.txt');

		% =================
		% = draw stimulus =
		% =================

		times = drawAndPresentStimulus(w, screens, const, times, rsvp, t1Pos, t2Pos, t1congruent);

% Here not worked----------------------------------------------

		% ==============================
		% = collect and score response =
		% ==============================
		tTargetDeadline = 1.500;
		% fprintf(1, '\n calling collectResponse\n')
		correct1 = 0;
		correct2 = 0;

		[rt, R1, R2] = collectResponse(w, cx, cy, times.t3);
        Screen('FillRect', w, const.bgcolor);
		Screen('Flip', w);       
        design.R1(trial) = (R1);
        design.R2(trial) = (R2);
		design.correct1(trial) = strcmp((R1), (T1));
		design.correct2(trial) = ...
            (t1congruent & strcmp((R2), 'Y')) | (~t1congruent & strcmp((R2), 'N'));
		writetable(design, resultFileName, 'Delimiter','\t');		
	end
	Priority(0);
	Screen('CloseAll')
	ListenChar(1);

catch 
	% psychrethrow(lasterror);
	ListenChar(1);
	Screen('CloseAll');
    rethrow(lasterror);
end

