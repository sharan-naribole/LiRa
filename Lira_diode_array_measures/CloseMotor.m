function CloseMotor(MySerial)

% command=['xymm 1 0xy'];
% fprintf(MySerial, command);
% pause(10);
fclose(MySerial);
delete(MySerial);

end