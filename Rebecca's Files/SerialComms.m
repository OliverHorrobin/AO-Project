% Open serial port COM3 with baud rate 115200
s = serialport("COM1",115200);
% carriage return terminator
configureTerminator(s,"CR");

% initial command sent to drop out of the device's legacy mode
writeline(s,"~~~");

% send some carriage returns
write(s,13,'char');
write(s,13,'char');
write(s,13,'char'); 
readString = readline(s);

% print to console the received response
fprintf(readString);

stringCheck = strfind(readString, 'ok');

if stringCheck > 0
    fprintf("\r\nDevice now ready to receive commands\r\n");
else
    fprintf("\r\nCommunication Error\r\n");
end

% AO_M_110_6M(actuator number, voltage)
AO_M_110_6M(s,1,0);

clear s;
