%% PS2000CONFIG Configure path and parameter information for PicoScope 2000 Series Oscilloscope
% Configures paths according to platforms and loads information from
% prototype files for PicoScope 2000 Series Oscilloscopes. The folder that
% this file is located in must be added to the MATLAB path.
%
% Platform Specific Information:-
%
% Microsoft Windows: Download the Software Development Kit installer from
% the <a href="matlab: web('https://www.picotech.com/downloads')">Pico Technology Download software and manuals for oscilloscopes and data loggers</a> page.
% 
% Linux: Follow the instructions to install the libps2000 and libpswrappers
% packages from the <a href="matlab:
% web('https://www.picotech.com/downloads/linux')">Pico Technology Linux Software & Drivers for Oscilloscopes and Data Loggers</a> page.
%
% Apple Mac OS X: Follow the instructions to install the PicoScope 6
% application from the <a href="matlab: web('https://www.picotech.com/downloads')">Pico Technology Download software and manuals for oscilloscopes and data loggers</a> page.
% Optionally, create a 'maci64' folder in the same directory as this file
% and copy the following files into it:
%
% * libps2000.dylib and any other libps2000 library files
% * libps2000Wrap.dylib and any other libps2000Wrap library files
%
% Contact our Technical Support team via the <a href="matlab: web('https://www.picotech.com/tech-support/')">Technical Enquiries form</a> for further assistance.
%
% Run this script in the MATLAB environment prior to connecting to the 
% device.
%
% This file can be edited to suit application requirements.

%% Set Path to Shared Libraries
% Set paths to shared library files according to the operating system and
% architecture.

% Identify working directory
ps2000ConfigInfo.workingDir = pwd;

% Find file name
ps2000ConfigInfo.configFileName = mfilename('fullpath');

% Only require the path to the config file
[ps2000ConfigInfo.pathStr] = fileparts(ps2000ConfigInfo.configFileName);

% Identify architecture e.g. 'win64'
ps2000ConfigInfo.archStr = computer('arch');
ps2000ConfigInfo.archPath = fullfile(ps2000ConfigInfo.pathStr, ps2000ConfigInfo.archStr);

% Add path to Prototype and Thunk files if not already present
if (isempty(strfind(path, ps2000ConfigInfo.archPath)))
    
    try

        addpath(ps2000ConfigInfo.archPath);
    
	catch err
    
		error('PS2000Config:OperatingSystemNotSupported', 'Operating system not supported - please contact support@picotech.com');
    
    end
	
end

% Set the path to drivers according to operating system.

% Define possible paths for drivers - edit to specify location of drivers

ps2000ConfigInfo.macDriverPath = '/Applications/PicoScope6.app/Contents/Resources/lib';
ps2000ConfigInfo.linuxDriverPath = '/opt/picoscope/lib/';

ps2000ConfigInfo.winSDKInstallPath = 'C:\Program Files\Pico Technology\SDK';
ps2000ConfigInfo.winDriverPath = fullfile(ps2000ConfigInfo.winSDKInstallPath, 'lib');

ps2000ConfigInfo.woW64SDKInstallPath = 'C:\Program Files (x86)\Pico Technology\SDK'; % Windows 32-bit version of MATLAB on Windows 64-bit
ps2000ConfigInfo.woW64DriverPath = fullfile(ps2000ConfigInfo.woW64SDKInstallPath, 'lib');

if (ismac())
    
    % Libraries (including wrapper libraries) are stored in the PicoScope
    % 6 App folder. Add locations of library files to environment variable.
    
    setenv('DYLD_LIBRARY_PATH', '/Applications/PicoScope6.app/Contents/Resources/lib');
    
    if (strfind(getenv('DYLD_LIBRARY_PATH'), '/Applications/PicoScope6.app/Contents/Resources/lib'))
       
        addpath('/Applications/PicoScope6.app/Contents/Resources/lib');
        
    else
        
        warning('PS2000Config:LibraryPathNotFound','Locations of libraries not found in DYLD_LIBRARY_PATH');
        
    end
    
elseif (isunix())
	    
    % Add path to drivers if not already on the MATLAB path
    if (isempty(strfind(path, ps2000ConfigInfo.linuxDriverPath)))
        
        addpath(ps2000ConfigInfo.linuxDriverPath);
            
    end
		
elseif (ispc())
    
    % Microsoft Windows operating system
    
    % Set path to dll files if the Pico Technology SDK Installer has been
    % used or place dll files in the folder corresponding to the
    % architecture. Detect if 32-bit version of MATLAB on 64-bit Microsoft
    % Windows.
    
    ps2000ConfigInfo.winSDKInstallPath = '';
    
    if (strcmp(ps2000ConfigInfo.archStr, 'win32') && exist('C:\Program Files (x86)\', 'dir') == 7)
		
		% Add path to drivers if not already on the MATLAB path
        if (isempty(strfind(path, ps2000ConfigInfo.woW64DriverPath)))
		
            try 
				
				addpath(ps2000ConfigInfo.woW64DriverPath);
				
			catch err
			   
				warning('PS2000Config:DirectoryNotFound', ['Folder C:\Program Files (x86)\Pico Technology\SDK\lib\ not found. '...
					'Please ensure that the location of the library files are on the MATLAB path.']);
				
            end
			
        end
        
    else
        
        % 32-bit MATLAB on 32-bit Windows or 64-bit MATLAB on 64-bit
        % Windows operating systems
		
		% Add path to drivers if not already on the MATLAB path
        if (isempty(strfind(path, ps2000ConfigInfo.winDriverPath)))
        
            try 
			
				addpath('C:\Program Files\Pico Technology\SDK\lib\');
				ps2000ConfigInfo.winSDKInstallPath = 'C:\Program Files\Pico Technology\SDK';
				
			catch err
			   
				warning('PS2000Config:DirectoryNotFound', ['Folder C:\Program Files\Pico Technology\SDK\lib\ not found. '...
					'Please ensure that the location of the library files are on the MATLAB path.']);
				
            end
			
        end
        
    end
    
else
    
    error('PS2000Config:OperatingSystemNotSupported', 'Operating system not supported - please contact support@picotech.com');
    
end

%% Set Path for PicoScope Support Toolbox Files if Not Installed
% Set MATLAB Path to include location of PicoScope Support Toolbox
% Functions and Classes if the Toolbox has not been installed. Installation
% of the toolbox is only supported in MATLAB 2014b and later versions.

% Check if PicoScope Support Toolbox is installed - using code based on
% <http://stackoverflow.com/questions/6926021/how-to-check-if-matlab-toolbox-installed-in-matlab How to check if matlab toolbox installed in matlab>

ps2000ConfigInfo.psTbxName = 'PicoScope Support Toolbox';
ps2000ConfigInfo.v = ver; % Find installed toolbox information

if (~any(strcmp(ps2000ConfigInfo.psTbxName, {ps2000ConfigInfo.v.Name})))
   
    warning('PS2000Config:PSTbxNotFound', 'PicoScope Support Toolbox not found, searching for folder.');
    
    % If the PicoScope Support Toolbox has not been installed, check to see
    % if the folder is on the MATLAB path, having been downloaded via zip
    % file.
    
    ps2000ConfigInfo.psTbxFound = strfind(path, ps2000ConfigInfo.psTbxName);
    
    if (isempty(ps2000ConfigInfo.psTbxFound))
        
        ps2000ConfigInfo.psTbxNotFoundWarningMsg = sprintf(['Please either:\n'...
            '(1) install the PicoScope Support Toolbox via the Add-Ons Explorer or\n'...
            '(2) download the zip file from MATLAB Central File Exchange and add the location of the extracted contents to the MATLAB path.']);
        
        warning('PS2000Config:PSTbxDirNotFound', ['PicoScope Support Toolbox not found. ', ps2000ConfigInfo.psTbxNotFoundWarningMsg]);
        
        ps2000ConfigInfo.f = warndlg(ps2000ConfigInfo.psTbxNotFoundWarningMsg, 'PicoScope Support Toolbox Not Found', 'modal');
        uiwait(ps2000ConfigInfo.f);
        
        web('https://uk.mathworks.com/matlabcentral/fileexchange/53681-picoscope-support-toolbox');
            
    end
    
end

% Change back to the folder where the script was called from.
cd(ps2000ConfigInfo.workingDir);

%% Load Enumerations and Structure Information
% Enumerations and structures are used by certain Intrument Driver functions.

% Find prototype file names based on architecture
ps2000ConfigInfo.ps2000MFile = str2func(strcat('ps2000MFile_', ps2000ConfigInfo.archStr));

[ps2000Methodinfo, ps2000Structs, ps2000Enuminfo, ps2000ThunkLibName] = ps2000ConfigInfo.ps2000MFile();

%% PicoScope Settings
% Define Settings for PicoScope 2000 series.

% Channel Settings
% ----------------

% Channel A
ps2000ConfigInfo.channelSettings.channelA.enabled = PicoConstants.TRUE;
ps2000ConfigInfo.channelSettings.channelA.dc = PicoConstants.TRUE;
ps2000ConfigInfo.channelSettings.channelA.range = ps2000Enuminfo.enPS2000Range.PS2000_1V;

% Channel B
ps2000ConfigInfo.channelSettings.channelB.enabled = PicoConstants.TRUE;
ps2000ConfigInfo.channelSettings.channelB.dc = PicoConstants.TRUE;
ps2000ConfigInfo.channelSettings.channelB.range = ps2000Enuminfo.enPS2000Range.PS2000_2V;

% Simple Trigger settings
% -----------------------

% Delay and Auto Trigger are defined as Instrument Driver Trigger Group
% Properties.
ps2000ConfigInfo.simpleTrigger.source = ps2000Enuminfo.enPS2000Channel.PS2000_CHANNEL_A; % Set to PS2000_NONE to disable.
ps2000ConfigInfo.simpleTrigger.threshold = 500;
ps2000ConfigInfo.simpleTrigger.direction = ps2000Enuminfo.enPS2000TriggerDirection.PS2000_RISING;

% TODO: Advanced Trigger settings
% -------------------------------

% Signal Generator settings
% -------------------------

% General Signal Generator.
ps2000ConfigInfo.sigGen.offsetVoltage    = 500;  % millivolts
ps2000ConfigInfo.sigGen.pkToPk           = 2000; % millivolts
ps2000ConfigInfo.sigGen.sweepType        = ps2000Enuminfo.enPS2000SweepType.PS2000_UP;
ps2000ConfigInfo.sigGen.sweeps           = 0;

% Built In.
ps2000ConfigInfo.sigGen.builtIn.waveType = ps2000Enuminfo.enPS2000WaveType.PS2000_SINE;
ps2000ConfigInfo.sigGen.builtIn.increment = 500; % Hz
ps2000ConfigInfo.sigGen.builtIn.dwellTime = 1;   % seconds

% AWG Specific
% ------------

% Create a sin(x) + sin(2x) wave.

x = 0:(2 * pi)/ (PicoConstants.AWG_BUFFER_4KS - 1):2 * pi;
y = sin(x) + sin(2*x);

% Normalise the wave.
ps2000ConfigInfo.sigGen.awg.waveform = normalise(y);
clear x;
clear y;
