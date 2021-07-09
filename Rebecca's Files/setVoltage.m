function setVoltage(volt,channel)
    % Open serial port COM4 with baud rate 115200
    s = serialport("COM4",115200);
    % carriage return terminator
    configureTerminator(s,"CR");

    % initial command sent to drop out of the device's legacy mode
    writeline(s,"~~~");
    readString = readline(s);

    % send some carriage returns
    write(s,13,'char'); % WAS 'char'
    readString = readline(s);
    write(s,13,'char');
    readString = readline(s);
    write(s,13,'char');
    readString = readline(s);

    % print to console the received response
    fprintf(readString);

    stringCheck = strfind(readString, 'ok');
    disp(stringCheck);

    if stringCheck > 0
        fprintf("\r\nDevice now ready to receive commands\r\n");
    else
        fprintf("\r\nCommunication Error\r\n");
    end

%     fprintf("\r\nTest Message\r\n");

    % Get and print voltage of all channels
    writeline(s,"list_outputs");
    voltageData = read(s,860,'string');
%     fprintf(voltageData);
%     fprintf("\r\nEnd of data\r\n");

    % Change voltage of channel
    msg = sprintf("%d %d set_output",volt,channel);
    writeline(s,msg);

    % Get and print voltage of all channels
    writeline(s,"list_outputs");
    voltageData = read(s,860,'string');
%     fprintf(voltageData);
%     fprintf("\r\nEnd of data\r\n");

    clear s;

end