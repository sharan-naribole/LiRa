function doExperiment( rotationAngle, measurementRange, filename)
%doExperiment - Conducting measurement automatically
%   INPUT ARGUMENTS

	% 	rotationAngle - the step angle of rotation for the Motor
	% 	measurementRange - the range of measurement; for example, -60 to 60 should input 120;

% OUTPUT ARGUMENTS
	% 	None,
	% 	One .mat file will be saved to the directory;

%=========================================================%
%% INITIALZATION

% Clear previous connections
delete(instrfindall);
clc;
disp('Beginning Measurement for Rotation');

% 
measurementNum = measurementRange/rotationAngle + 1;


% MAKE ARDUINO CONNECTION
disp('Setting Up Arduino Connections...');
myArduinoRx = arduino();

% Connect to motor
MotorPort = '/dev/cu.usbserial-cineMoco';
Motor = OpenMotor(MotorPort);

% VARIABLE INITIALIZATION
global arrayData
arrayData = struct();
global switchFlag
switchFlag = false;
RotateMotorAngle(Motor,0)
pause(10);
%=========================================================%
%% CONDUCTING EXPERIMENT
disp('Conducting Experiments...');
for i = 1: measurementNum
    arrayData.diode1(1,i) = 5 - readVoltage(myArduinoRx,'A0');
    arrayData.diode2(1,i) = 5 - readVoltage(myArduinoRx,'A1');
    arrayData.diode3(1,i) = 5 - readVoltage(myArduinoRx,'A2');
    arrayData.diode4(1,i) = 5 - readVoltage(myArduinoRx,'A3');
    pause(1);
    RotateMotorAngle(Motor,i*rotationAngle)
    arrayData
end

%=========================================================%
%% SAVE VARIABLE

CloseMotor(Motor)
disp('Saving Dataset...');

save(filename, 'arrayData');




end

