function RotateMotorAngle(MySerial,newAngle)
%%% MySerial - the serial connection instance that you established in OpenMotor
%%%	newAngle - the angle you want the motor to be rotated; for example, newAngle = 60 means the motor will be rotated to 60 deg, 
% 				and if you wan to rotate another 1 deg, put newAgnle = 61

numSteps = round(newAngle/0.01125);
command=['\r\nmm 1 ',num2str(numSteps),'\r\n'] %\n\r is the serial terminator

while true
    try
        fprintf(MySerial, command);
        % fprintf(MySerial,'sm 1 \r\n')
        break;
    catch err
        disp('Error in rotate Cinemoco, repeating');
        disp(err);
    end
end

end
