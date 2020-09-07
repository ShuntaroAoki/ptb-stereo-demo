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
left_eye_image = 'stimuli/stereo_left.png';
right_eye_image = 'stimuli/stereo_right.png';

left_eye_image = 'stimuli/illcon_left.png';
right_eye_image = 'stimuli/illcon_right.png';


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
% See soure code of`StereoDemo` for mode details


%% Initialize left and right eye images
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

    %% Flip screen
    t_flip = Screen('Flip', wnd_ptr);
end

%% Terminate the program
Screen('CloseAll')
ShowCursor;
