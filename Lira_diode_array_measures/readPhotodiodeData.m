function readPhotodiodeData( myArduino, numTrial, switchFlag )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

configurePin(myArduinoRx,'A0','AnalogInput')
configurePin(myArduinoRx,'A1','AnalogInput')
configurePin(myArduinoRx,'A2','AnalogInput')
configurePin(myArduinoRx,'A3','AnalogInput')

X = sprintf('Currently Writing Data to %d th Column in arrayData structure.', numTrial);
disp(X)

switch switchFlag
	case true % transmitter side LED ON;
        	arrayData.diode1(2,numTrial) = 5 - readVoltage(myArduinoRx,'A0');
                arrayData.diode2(2,numTrial) = 5 - readVoltage(myArduinoRx,'A1');
                arrayData.diode3(2,numTrial) = 5 - readVoltage(myArduinoRx,'A2');
                arrayData.diode4(2,numTrial) = 5 - readVoltage(myArduinoRx,'A3');
	otherwise
        	arrayData.diode1(1,numTrial) = 5 - readVoltage(myArduinoRx,'A0');
                arrayData.diode2(1,numTrial) = 5 - readVoltage(myArduinoRx,'A1');
                arrayData.diode3(1,numTrial) = 5 - readVoltage(myArduinoRx,'A2');
                arrayData.diode4(1,numTrial) = 5 - readVoltage(myArduinoRx,'A3');
end


end

