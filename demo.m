% Demo program for displaying stereograms with Psychtoolbox
%
% Tested with Matlab 2020a and Psychtoolbox 3.0.16 (Rev. 10582) on macOS 10.15
%
% Author: Shuntaro C. Aoki <s_aoki@i.kyoto-u.ac.jp>
% Date: 2020-09-07
%

clear all;
close all;


%% Settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Paths to left and right eye images
% left_eye_image = 'stimuli/stereo_left.png';
% right_eye_image = 'stimuli/stereo_right.png';

% left_eye_image = 'stimuli/rds_03636649_d6c6665366854e6abec99d5b4657d5b1_dot_size_1_dot_density_1.0_left.png';
% right_eye_image = 'stimuli/rds_03636649_d6c6665366854e6abec99d5b4657d5b1_dot_size_1_dot_density_1.0_right.png';

images_dir = 'stimuli';

% Psychtoolbox stereo mode
stereo_mode = 8;

% To enable stereo display, you need to initialize PTB screen with
% stereo mode except 0.
%
% 0 == Mono display - No stereo at all.
% 6-9 == Different modes of anaglyph stereo for color filter glasses:
%
% 6 == Red-Green
% 7 == Green-Red
% 8 == Red-Blue
% 9 == Blue-Red
%
% So, when using left-red and right-blut glasses, set '8' here.
% See `help StereoDemo` for more details.

% Background colour
background = [.5, .5, .5];

% Termination key
key_term = 'q';

Screen('Preference', 'SkipSyncTests', 1)

%% Main %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Setup
addpath('./func');
AssertOpenGL;
KbName('UnifyKeyNames');

% Image setup
files = dir(fullfile(images_dir, '*_left.png'));
images = {};
for i = 1:length(files)
    image_name = strrep(files(i).name, '_left.png', '');
    images{end+1, 1} = image_name;
end

% PTB setup
[scrn_num, wnd_ptr] = createWindow(stereo_mode, background);
% `createWindow` is my custom function to initialize PTB screen with stereo
% mode.
% In brief, to enable PTB stereo display, you need to pass stereo mode arg
% when creating a PTB window (`Screen('OpenWindow'`).
%
%     wndPtr = Screen('OpenWindow', scrnNum, bgColor, [], [], [], stereoMode);
%
% When using 'Dual-Window stereo' mode (stereo_mode == 10; displaying left
% and right images on different screens), you need some additional lines.
%
% See source code of`StereoDemo` for mode details.


%% Initialize left and right eye images
image_index = 1;

left_eye_image = fullfile(images_dir, strcat(images{image_index}, '_left.png'));
right_eye_image = fullfile(images_dir, strcat(images{image_index}, '_right.png'));

img_left = imread(left_eye_image);
img_right = imread(right_eye_image);

%% Main loop
while 1

    %% Key check
    [key_isdown, key_secs, key_code, delta_secs] = KbCheck;
    if key_isdown
        if key_code(KbName(key_term))
            break;
        end
        if key_code(KbName('j'))
            image_index = image_index + 1;
            if image_index > length(images)
                image_index = 1;
            end
            left_eye_image = fullfile(images_dir, strcat(images{image_index}, '_left.png'));
            right_eye_image = fullfile(images_dir, strcat(images{image_index}, '_right.png'));

            img_left = imread(left_eye_image);
            img_right = imread(right_eye_image);
        end
        if key_code(KbName('k'))
            image_index = image_index - 1;
            if image_index < 1
                image_index = length(images);
            end
            left_eye_image = fullfile(images_dir, strcat(images{image_index}, '_left.png'));
            right_eye_image = fullfile(images_dir, strcat(images{image_index}, '_right.png'));

            img_left = imread(left_eye_image);
            img_right = imread(right_eye_image);
        end
        
        KbReleaseWait;
    end

    %% Display left and right images
    tex_left = Screen('MakeTexture', wnd_ptr, img_left);
    tex_right = Screen('MakeTexture', wnd_ptr, img_right);

    %-------------------------------------------------------------------------
    % This is the main body of stereo displaying.
    % You need to run two draw commands, one for the left and the other for
    % the right eye images, separately. Before running each command, you need
    % to specify the frame buffer (left or right) in which the following
    % commands draw something.
    %-------------------------------------------------------------------------

    Screen('SelectStereoDrawBuffer', wnd_ptr, 0); % Left buffer
    Screen('DrawTexture', wnd_ptr, tex_left);     % Draw left eye image

    Screen('SelectStereoDrawBuffer', wnd_ptr, 1); % Right buffer
    Screen('DrawTexture', wnd_ptr, tex_right);    % Draw right eye image

    %% Draw text
    Screen('SelectStereoDrawBuffer', wnd_ptr, 0);
    Screen('DrawText', wnd_ptr, 'Press "q" to quit.', 20, 20, [0, 0, 0]);
    Screen('DrawText', wnd_ptr, ['Image: ', images{image_index}], 20, 40, [0, 0, 0]);

    Screen('SelectStereoDrawBuffer', wnd_ptr, 1);
    Screen('DrawText', wnd_ptr, 'Press "q" to quit.', 20, 20, [0, 0, 0]);
    Screen('DrawText', wnd_ptr, ['Image: ', images{image_index}], 20, 40, [0, 0, 0]);

    %% Flip screen
    t_flip = Screen('Flip', wnd_ptr);
end

%% Terminate the program
Screen('CloseAll')
ShowCursor;
