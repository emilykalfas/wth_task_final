function [C,timingfile,userdefined_trialholder] = wth_userloop_final(MLConfig,TrialRecord)

C = [];
timingfile = 'wth_runscene_final.m';
userdefined_trialholder = '';

persistent timing_filename_returned
if isempty(timing_filename_returned)
    timing_filename_returned = true;
    TrialRecord.User.timing = struct('wait_for_fix', [],...
                                     'fix_hold_time', []);
    TrialRecord.User.trial_type = struct('random_trial', [],...
                                         'saccade_trial', []);
    return
end

condition = TrialRecord.CurrentCondition;
num_blocks = 4;
block = TrialRecord.CurrentBlock;
% list_correct = TrialRecord.TrialErrors==0;

% Setting block numbers to change each time the monkey successfully
% completes a trial -- will use block number changes to set trial type
persistent trial_type random_flag saccade_flag correct_trial_count
if isempty(TrialRecord.TrialErrors) || TrialRecord.TrialErrors(end)==0 % first or last trial correct
    correct_trial_count = sum(TrialRecord.TrialErrors==0);
    if correct_trial_count == 0
        block = 1;
    elseif correct_trial_count == 1
        block = 2;
    elseif correct_trial_count == 2
        block = 3;
    elseif correct_trial_count == 3
        block = 4;
    else
        block = 5;
    end
end


% Random Condition
distance = 5;

[x1, y1] = deal (0-distance, distance);
[x2, y2] = deal (0, distance);
[x3, y3] = deal (distance,distance);
[x4, y4] = deal (0-distance,0);
[x5, y5] = deal (0,0);
[x6, y6] = deal (distance,0);
[x7, y7] = deal (0-distance,0-distance);
[x8, y8] = deal (0,0-distance);
[x9, y9] = deal (distance,0-distance);

% Generate Shuffled List of Locations
locations_list = {[x1, y1], [x2, y2], [x3, y3], [x4, y4], [x5, y5], [x6, y6], [x7, y7], [x8, y8], [x9, y9]};
numLocations = numel(locations_list);
permIndices = randperm(numLocations);
shuffled_locations = cell(1, numLocations);
for i = 1:numLocations
    shuffled_locations{i} = locations_list{permIndices(i)};
end

location_1 = shuffled_locations{1};
location_2 = shuffled_locations{2};
location_3 = shuffled_locations{3};
location_4 = shuffled_locations{4};
location_5 = shuffled_locations{5};
location_6 = shuffled_locations{6};
location_7 = shuffled_locations{7};
location_8 = shuffled_locations{8};
location_9 = shuffled_locations{9};

x1shuff = location_1(1,1);
x2shuff = location_2(1,1);
x3shuff = location_3(1,1);
x4shuff = location_4(1,1);
x5shuff = location_5(1,1);
x6shuff = location_6(1,1);
x7shuff = location_7(1,1);
x8shuff = location_8(1,1);
x9shuff = location_9(1,1);

y1shuff = location_1(1,2);
y2shuff = location_2(1,2);
y3shuff = location_3(1,2);
y4shuff = location_4(1,2);
y5shuff = location_5(1,2);
y6shuff = location_6(1,2);
y7shuff = location_7(1,2);
y8shuff = location_8(1,2);
y9shuff = location_9(1,2);

% Saccade Condition
saccade_distance = 5;
saccade_height = 0;

[x1sacc, ysacc] = deal (-saccade_distance, saccade_height);
[x2sacc, ysacc] = deal (saccade_distance, saccade_height);

% Run Scenes
if block == 1 
    C = {sprintf('pic(%s, %d, %d)', 'fix_1.png', x1shuff, y1shuff), ...
        sprintf('pic(%s, %d, %d)', 'fix_2.png', x2shuff, y2shuff), ...
        sprintf('pic(%s, %d, %d)', 'fix_3.png', x3shuff, y3shuff), ...
        sprintf('pic(%s, %d, %d)', 'fix_4.png', x4shuff, y4shuff), ...
        sprintf('pic(%s, %d, %d)', 'fix_5.png', x5shuff, y5shuff), ...
        sprintf('pic(%s, %d, %d)', 'fix_6.png', x6shuff, y6shuff), ...
        sprintf('pic(%s, %d, %d)', 'fix_7.png', x7shuff, y7shuff), ...
        sprintf('pic(%s, %d, %d)', 'fix_8.png', x8shuff, y8shuff), ...
        sprintf('pic(%s, %d, %d)', 'fix_9.png', x9shuff, y9shuff), ...
        sprintf('crc(0.001,[0 0 0],0,0,0)'), ...
        sprintf('crc(0.001,[0 0 0],0,0,0)'), ...
        };
    return
end

fprintf('Correct Trial Count: %d\n', correct_trial_count)
fprintf('Current Block: %d\n', block)
TrialRecord.NextBlock = block;

if block == 2
    C = {sprintf('pic(%s, %d, %d)', 'fix_1.png', x1sacc, ysacc), ...
        sprintf('pic(%s, %d, %d)', 'fix_2.png', x2sacc, ysacc), ...
        sprintf('pic(%s, %d, %d)', 'fix_3.png', x1sacc, ysacc), ...
        sprintf('pic(%s, %d, %d)', 'fix_4.png', x2sacc, ysacc), ...
        sprintf('pic(%s, %d, %d)', 'fix_5.png', x1sacc, ysacc), ...
        sprintf('pic(%s, %d, %d)', 'fix_6.png', x2sacc, ysacc), ...
        sprintf('pic(%s, %d, %d)', 'fix_7.png', x1sacc, ysacc), ...
        sprintf('pic(%s, %d, %d)', 'fix_8.png', x2sacc, ysacc), ...
        sprintf('pic(%s, %d, %d)', 'fix_9.png', x1sacc, ysacc), ...
        sprintf('pic(%s, %d, %d)', 'fix_10.png', x2sacc, ysacc), ...
        sprintf('pic(%s, %d, %d)', 'fix_11.png', x1sacc, ysacc), ...
        };
    return
end

TrialRecord.NextBlock = block;

if block == 3
    C = {sprintf('pic(%s, %d, %d)', 'fix_1.png', x1shuff, y1shuff), ...
        sprintf('pic(%s, %d, %d)', 'fix_2.png', x2shuff, y2shuff), ...
        sprintf('pic(%s, %d, %d)', 'fix_3.png', x3shuff, y3shuff), ...
        sprintf('pic(%s, %d, %d)', 'fix_4.png', x4shuff, y4shuff), ...
        sprintf('pic(%s, %d, %d)', 'fix_5.png', x5shuff, y5shuff), ...
        sprintf('pic(%s, %d, %d)', 'fix_6.png', x6shuff, y6shuff), ...
        sprintf('pic(%s, %d, %d)', 'fix_7.png', x7shuff, y7shuff), ...
        sprintf('pic(%s, %d, %d)', 'fix_8.png', x8shuff, y8shuff), ...
        sprintf('pic(%s, %d, %d)', 'fix_9.png', x9shuff, y9shuff), ...
        sprintf('crc(0.001,[0 0 0],0,0,0)'), ...
        sprintf('crc(0.001,[0 0 0],0,0,0)'), ...
        };
    return
end

TrialRecord.NextBlock = block;

if block == 4
    C = {sprintf('pic(%s, %d, %d)', 'fix_1.png', x1sacc, ysacc), ...
        sprintf('pic(%s, %d, %d)', 'fix_2.png', x2sacc, ysacc), ...
        sprintf('pic(%s, %d, %d)', 'fix_3.png', x1sacc, ysacc), ...
        sprintf('pic(%s, %d, %d)', 'fix_4.png', x2sacc, ysacc), ...
        sprintf('pic(%s, %d, %d)', 'fix_5.png', x1sacc, ysacc), ...
        sprintf('pic(%s, %d, %d)', 'fix_6.png', x2sacc, ysacc), ...
        sprintf('pic(%s, %d, %d)', 'fix_7.png', x1sacc, ysacc), ...
        sprintf('pic(%s, %d, %d)', 'fix_8.png', x2sacc, ysacc), ...
        sprintf('pic(%s, %d, %d)', 'fix_9.png', x1sacc, ysacc), ...
        sprintf('pic(%s, %d, %d)', 'fix_10.png', x2sacc, ysacc), ...
        sprintf('pic(%s, %d, %d)', 'fix_11.png', x1sacc, ysacc), ...
        };
    return
end

TrialRecord.NextBlock = block;