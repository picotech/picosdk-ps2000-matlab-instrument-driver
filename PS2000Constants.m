%% PS2000Constants 
%
% The PS2000Constants class defines a number of constant values that
% can be used to define the properties of an Oscilloscopes device or
% for passing as parameters to function calls.
%
% The properties in this file are divided into the following
% sub-sections:
% 
% * Timebases
% * ETS Mode Properties
% * Analogue offset values
% * Maximum/Minimum Waveform Frequencies
% * Function/Arbitrary Waveform Parameters
% * Maximum and minimum ADC count values
% * PicoScope 2000 Series Models using this driver
%
% Ensure that the location of this class file is on the MATLAB Path.		
%
% Copyright: � 2013 - 2017 Pico Technology Ltd. All rights reserved.

classdef PS2000Constants
    
    properties (Constant)
        
        PS2000_MAX_TIMEBASE = 19;

        PS2105_MAX_TIMEBASE = 20;
        PS2104_MAX_TIMEBASE = 19;

        PS2200_MAX_TIMEBASE = 23;
        PS2000_MAX_OVERSAMPLE = 256;

        PS2105_MAX_ETS_CYCLES =	250;
        PS2105_MAX_ETS_INTERLEAVE =	50;

        PS2104_MAX_ETS_CYCLES =	125;
        PS2104_MAX_ETS_INTERLEAVE =	25;

        PS2203_MAX_ETS_CYCLES =	250;
        PS2203_MAX_ETS_INTERLEAVE = 50;

        PS2204_MAX_ETS_CYCLES =	250;
        PS2204_MAX_ETS_INTERLEAVE = 40;

        PS2205_MAX_ETS_CYCLES =	250;
        PS2205_MAX_ETS_INTERLEAVE = 40;

        PS2000_MIN_ETS_CYCLES_INTERLEAVE_RATIO = 1;
        PS2000_MAX_ETS_CYCLES_INTERLEAVE_RATIO = 10;

        PS2000_MIN_SIGGEN_FREQ = single(0.0);
        PS2000_MAX_SIGGEN_FREQ = single(100000.0);
        
        PS2000_MIN_SIGGEN_OFFSET_MV = -2000;    % -2 Volts
        PS2000_MAX_SIGGEN_OFFSET_MV = 2000;     % +2 Volts
        
        PS2000_MIN_SIGGEN_PKTOPK_MV = 0;        % 0
        PS2000_MAX_SIGGEN_PKTOPK_MV = 4000;     % +/- 2 Volts
        
        PS2000_SIGGEN_ZERO_VOLTAGE_DC = 0;
        
        PS2000_AWG_DDS_FREQUENCY = 48e6; % DDS Frequency of 48MHz.

        % Although the PS2000 uses an 8-bit ADC, it is usually possible to
        % oversample (collect multiple readings at each time) by up to 256.
        % the results are therefore ALWAYS scaled up to 16-bits, even if
        % oversampling is not used.
        %
        % The maximum and minimum values returned are therefore as follows:

        PS2000_MAX_VALUE = 32767;
        PS2000_MIN_VALUE = -32767;
        PS2000_LOST_DATA = -32768;

        MAX_CHANNELS = 4;
        
        % PicoScope Models
        
        MODEL_NONE    = 'NONE';
        MODEL_PS2104  = '2104';
        MODEL_PS2105  = '2105';
        MODEL_PS2202  = '2202';
        MODEL_PS2203  = '2203';
        MODEL_PS2204  = '2204';
        MODEL_PS2205  = '2205';
        MODEL_PS2204A = '2204A';
        MODEL_PS2205A = '2205A';
        
    end

end

