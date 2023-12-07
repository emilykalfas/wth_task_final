if ~exist('eye_','var'), error('This demo requires eye signal input. Please set it up or try the simulation mode.'); end
hotkey('x', 'escape_screen(); assignin(''caller'',''continue_'',false);');

% remap trial error codes
trialerror(1,'Fixation 1 Failure',...
           2,'Random/CL1-2: Fixation 2 Failure',...
           3,'Random/CL1-2: Fixation 3 Failure',...
           4,'Random/CL1-2: Fixation 4 Failure',...
           5,'Random/CL1-2: Fixation 5 Failure',...
           6,'Random/CL1-2: Fixation 6 Failure',...
           7,'Random/CL1-2: Fixation 7 Failure',...
           8,'Random/CL1-2: Fixation 8 Failure',...
           9,'Random/CL1-2: Fixation 9 Failure');
       
% remap behavior codes (universal)
bhv_code(   100,'Start Trial',...
            200,'Reward',...
            300,'End Trial',...
            110,'Fixation 1 On',...
            111,'Fixation 1 Success',...
            120,'Fixation 2 On',...
            121,'Fixation 2 Success',...
            130,'Fixation 3 On',...
            131,'Fixation 3 Success',...
            140,'Fixation 4 On',...
            141,'Fixation 4 Success',...
            150,'Fixation 5 On',...
            151,'Fixation 5 Success',...
            160,'Fixation 6 On',...
            161,'Fixation 6 Success',...
            170,'Fixation 7 On',...
            171,'Fixation 7 Success',...
            180,'Fixation 8 On',...
            181,'Fixation 8 Success',...
            190,'Fixation 9 On',...
            191,'Fixation 9 Success',...
            220,'Fixation 10 On',...
            230,'Fixation 10 Success',...
            240,'Fixation 11 On',...
            250,'Fixation 11 Success',...
            000,'Failure');  % behavioral codes


% give names to the TaskObjects defined in the conditions file:
fixation_point_1 = 1; % point 'fix1.png' (20x20)
fixation_point_2 = 2; % point 'fix2.png' (20x20)
fixation_point_3 = 3; % point 'fix3.png' (20x20)
fixation_point_4 = 4; % point 'fix4.png' (20x20)
fixation_point_5 = 5; % point 'fix5.png' (20x20)
fixation_point_6 = 6; % point 'fix6.png' (20x20)
fixation_point_7 = 7; % point 'fix7.png' (20x20)
fixation_point_8 = 8; % point 'fix8.png' (20x20)
fixation_point_9 = 9; % point 'fix9.png' (20x20)
fixation_point_10 = 10; % point 'fix10.png' (20x20)
fixation_point_11 = 11; % point 'fix11.png' (20x20)

% define time intervals/fixation window
wait_for_fix_random = 5000;    % in ms
wait_for_fix_saccade = 250;
fix_hold_time_random = 500;    % in ms
fix_hold_time_saccade = 300;    % in ms
fix_radius = 3;
editable('wait_for_fix_random');
editable('wait_for_fix_saccade');
editable('fix_hold_time_saccade');
editable('fix_radius');

% define fixation variables for each condition
wait_for_fix = wait_for_fix_random;
fix_hold_time = fix_hold_time_random;

TrialRecord.User.timing.wait_for_fix(end+1) = wait_for_fix;
TrialRecord.User.timing.fix_hold_time(end+1) = fix_hold_time;

correct_fixation_count = sum(TrialRecord.TrialErrors==0);
block = TrialRecord.CurrentBlock;

if block == 1 || block == 3
    max_attempts = 1; % Set the maximum number of attempts for each scene
    
    failed_scenes = [];
    
    for scene_number = 1:9
        % Create the fixation point and wait-then-hold adapter for the current scene
        fix = SingleTarget(eye_);
        fix.Target = eval(['fixation_point_' num2str(scene_number)]);
        fix.Threshold = fix_radius;
        wth = WaitThenHold(fix);
        wth.WaitTime = wait_for_fix;
        wth.HoldTime = fix_hold_time;
    
        % Create the scene for the current fixation point
        current_scene = create_scene(wth, eval(['fixation_point_' num2str(scene_number)]));
    
        % Run the current scene
        run_scene(current_scene, scene_number * 10);
    
        % Check if the current scene was successful
        if wth.Success
            fixpoint_number_success = scene_number;
            send_reward();
            eventmarker(scene_number * 10 + 1);
            trialerror(0); % correct
        else
            % If the scene failed, store information for rerun
            fixpoint_number_failure = scene_number;
            eventmarker(0);
            trialerror(scene_number); % 1-8
            failed_scenes = [failed_scenes, scene_number];
        end
    end
    
    % Rerun failed scenes
    if numel(failed_scenes) == 1
        % If there is only one failed scene, run a random scene first
        random_scene = randi(9);
        while ismember(random_scene, failed_scenes)
            random_scene = randi(9);
        end
    
        % Run the random scene
        fix = SingleTarget(eye_);
        fix.Target = eval(['fixation_point_' num2str(random_scene)]);
        fix.Threshold = fix_radius;
        wth = WaitThenHold(fix);
        wth.WaitTime = wait_for_fix;
        wth.HoldTime = fix_hold_time;
        current_scene = create_scene(wth, eval(['fixation_point_' num2str(random_scene)]));
        run_scene(current_scene, random_scene * 10);
    end
    
    % Rerun remaining failed scenes
    for failed_scene = failed_scenes
        % Create the fixation point and wait-then-hold adapter for the failed scene
        fix = SingleTarget(eye_);
        fix.Target = eval(['fixation_point_' num2str(failed_scene)]);
        fix.Threshold = fix_radius;
        wth = WaitThenHold(fix);
        wth.WaitTime = wait_for_fix;
        wth.HoldTime = fix_hold_time;
    
        % Create the scene for the failed fixation point
        current_scene = create_scene(wth, eval(['fixation_point_' num2str(failed_scene)]));
    
        % Retry the failed scene up to max_attempts times
        for attempt = 1:max_attempts
            % Run the failed scene
            run_scene(current_scene, failed_scene * 10);
    
            % Check if the retry was successful
            if wth.Success
                fixpoint_number_success = failed_scene;
                send_reward();
                eventmarker(failed_scene * 10 + 1);
                trialerror(0); % correct
                break; % Exit the retry loop if successful
            end
    
            % If all attempts failed, return with the final error code
            if attempt == max_attempts
                failed_scenes = [failed_scenes, failed_scene];
            end
        end
    end
end


if block == 2 || block == 4
    fixpoint_number = 1;
    while fixpoint_number <= 11
        % Create the appropriate SingleTarget and WaitThenHold objects
        fix = SingleTarget(eye_);
        fix.Target = eval(['fixation_point_' num2str(fixpoint_number)]);
        fix.Threshold = fix_radius;
        wth = WaitThenHold(fix);
        wth.WaitTime = wait_for_fix;
        wth.HoldTime = fix_hold_time;

        % Create the scene
        scene = create_scene(wth, eval(['fixation_point_' num2str(fixpoint_number)]));

        % Run the scene
        run_scene(scene, fixpoint_number * 10);

        % Check for success
        if wth.Success
            fixpoint_number_success = fixpoint_number;
            send_reward();
            eventmarker(fixpoint_number * 10 + 1);
            trialerror(0); % correct
            fixpoint_number = fixpoint_number + 1;
        else
            if fixpoint_number == 1
                trialerror(fixpoint_number); % 1-8s
                fixpoint_number = fixpoint_number;
                eventmarker(0);
            else
                trialerror(fixpoint_number); % 1-8s
                fixpoint_number = fixpoint_number - 1;
                eventmarker(0);
            end
        end
    end
end

% End Session
if block > 4
    escape_screen()
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reward

function send_reward()
    goodmonkey(100, ...
            'numreward', 1, ...
            'pausetime', 300,...
            'eventmarker', 200,...
            'nonblocking', 0)
end
