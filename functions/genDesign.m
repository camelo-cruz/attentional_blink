function [design_table, designlbls] = genDesign(vpnr)
    v = version;
    if str2num(v(1:3)) >= 8
        % MATLAB
        RandStream('mt19937ar', 'seed', 1000 * vpnr);
    else
        rand('seed', 1000 * vpnr);
    end
    
    % Define factor values
    lag_factors = 1:8;
    colort1 = 1:4;
    colort2 = 1:4;
    congruentMeaning = [0, 1];
    color_names = {"red", "green", "yellow", "blue"};

    nRepetitions = 2;

  
    % Initialize matrix to store valid combinations
    design = [];
    
    % Generate all combinations
    for congruence = congruentMeaning
        for lag = lag_factors
            for color_T1 = colort1
                for color_T2 = colort2
                    if color_T1 ~= color_T2 % Check if colors are different
                        design = [design; lag, color_T1, color_T2, congruence];
                    end
                end
            end
        end
    end

    design = repmat(design, [nRepetitions 1]);
    design = sortrows(design, [1 2]);

    % control variable: t1 position randomly at positions between 4 and 9
    ntrials = size(design, 1);
    t1Pos = randsample(6, ntrials, true)+3;
    design(:,5) = t1Pos;
    t2Pos = design(:,1) + design(:,5);
    design(:,6) = t2Pos;

    design_table = array2table(design, 'VariableNames',{'t2lag','color_T1','color_T2', 'congruence', 'PosT1', 'PosT2'});
    design_table.color_T1 = color_names(design_table.color_T1)';
    design_table.color_T2 = color_names(design_table.color_T2)';

    % randomize presentation order
    random_ix = randperm(ntrials); % we could also use randsample here
    design_table = design_table(random_ix, :);
    design_table.trialNo = (1:ntrials)';
    
    
    designlbls = design_table.Properties.VariableNames;
