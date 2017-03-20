function MySerial = OpenMotor(motorCom)
% this function initialize the CineMoco motor connection
% INPUT ARGUMENT
% 	motorCom - this is the USB connection communication port, e.g 'COM11' for Windows,
%		or '/dev/cu.usbmodem1421'	
% OUTPUT ARGUMENT
%	MySerial - the CineMoco instance for controlling

try
	MySerial = serial(motorCom,'BaudRate',57600,'terminator','CR/LF')
	fopen(MySerial);
catch err
	disp('ERROR. Please Reconnect Motor...')

end