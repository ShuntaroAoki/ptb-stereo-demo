function [scrnNum, wndPtr] = createWindow(stereoMode, bgColor)
% CreateWindow    Create PTB window
%
% See source code of StereoDemo for the details of following processings
%

try
    scrnNum = max(Screen('Screens'));

    if IsWin & ( stereoMode == 4 | stereoMode == 5 )
        scrnNum = 0;
    end

    % Do we have at least two separate displays for both views?
    if stereoMode == 10
        if length(Screen('Screens')) < 2
            error('Sorry, for stereoMode 10 you''ll need at least 2 separate display screens in non-mirrored mode.');
        end
        
        if ~IsWin
            % Assign left-eye view (the master window) to main display
            scrnNum = 0;
        else
            % Assign left-eye view (the master window) to main display
            scrnNum = 1;
        end
    end

    bgColor = [ WhiteIndex(scrnNum) + BlackIndex(scrnNum) ] .* bgColor;

    wndPtr = Screen('OpenWindow', scrnNum, bgColor, [], [], [], stereoMode);

    if stereoMode == 10
        if IsWin
            slaveScreen = 2;
        else
            slaveScreen = 1;
        end
        Screen('OpenWindow', slaveScreen, BlackIndex(slaveScreen), [], [], [], stereoMode);
    end
    
    Screen('BlendFunction', wndPtr, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    Screen('Flip', wndPtr);

catch
    Screen('CloseAll');
    ShowCursor;
    psychrethrow(psychlasterror);
    
    scrnNum = NaN;
    wndPtr  = NaN;
end
