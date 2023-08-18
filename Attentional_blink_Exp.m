% Attentional blink experiment
%PsychDebugWindowConfiguration
Screen('Preference', 'SkipSyncTests', 2);

try
    %set functions folder and unify key names
	addpath('functions');
	KbName('UnifyKeyNames');
	ListenChar(2);

    %initializing screen
	[w, screens, const] = initGraphics;

    %random seed
	vpnr = 1;
    %output file
	resultFileName = ['results/Attentional_blink_Exp_' num2str(vpnr) '.dat'];
    %generating randomized design with random seed for reproducibility
    [design, designlbls] = genDesign(vpnr);

    %completing design table with resulting variables
	NTRIALS = size(design,1);
    resultVars = table('Size', [NTRIALS 4], ...
        'VariableNames', {'R1', 'R2', 'correct1', 'correct2'}, ...
        'VariableTypes', {'string', 'string', 'double', 'double'});
	design = [design resultVars];

    %finding screen center and display instructions
	[cx, cy] = RectCenter(const.srect);
    showInstructions(w, const, 'material/instructions.txt');


    %---------------------implement here quest------------------
    % timings
	% 	Raymond / Shapiro 
	times.ISI = 0.075;
	times.ISIafterFix = 0.000;
	times.Fix = 0.600;
	times.Stim = 0.015;
    %-----------------------------------------------------------

    %Loop for stimuli presentation
    exit = false;
    for trial = 1:NTRIALS
        instruction = WaitForInstruction();
        if isequal(instruction, 'kill')
            break                         
        else
            % ====================
		    % = specify Stimuli =
		    % ====================
            t1 = design.color_T1(trial);
            t2 = design.color_T2(trial);
		    t1Pos = design.PosT1(trial);
		    t2Pos = design.PosT2(trial);
		    t1congruent = design.congruence(trial);

            %create rsvp with specifications
		    [rsvp, T1, T2] = generateRSVPstream(t1, t1Pos, t2, t2Pos, 'material/fillers.txt');
    
		    % =================       
		    % = draw stimulus =
		    % =================
		    times = drawAndPresentStimulus(w, screens, const,...
                times, rsvp, t1Pos, t2Pos, t1congruent);

		    % ==============================
		    % = collect and score response =
		    % ==============================       
		    tTargetDeadline = 1.500;
		    correct1 = 0;       
		    correct2 = 0;

            %collecting response1 response2 and reaction times
		    [rt, R1, R2] = collectResponse(w, cx, cy, times.t3);
            Screen('FillRect', w, const.bgcolor);
		    Screen('Flip', w);
    
            design.R1(trial) = (R1);
            design.R2(trial) = (R2);
            if isequal(R1, T1)
		        design.correct1(trial) = 1;
            end
            if isequal(R2, T2)
                design.correct2(trial) = 1;
            end
		    writetable(design, resultFileName, 'Delimiter','\t');	
        end 
    end
	Priority(0);
	Screen('CloseAll')
	ListenChar(1);

catch           
	ListenChar(1);       
	Screen('CloseAll');
end
