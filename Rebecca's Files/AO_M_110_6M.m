% takes in an actuator number and a voltage and sends to device
function AO_M_110_6M(s,channel, volt)
    % Convert actuator number to channel number
    % channel = actuator * 2;
    
    if channel > 64 || channel < 1
        error('Channel out of bounds')
    elseif volt > 100 || volt < -100
        error('Too much voltage')
    end
    
    % Change voltage of actuator
    msg = sprintf("%d %d set_output", volt, channel);
    writeline(s,msg);

    % Get and print voltage of all channels
    writeline(s,"list_outputs");
    voltageData = read(s,900,'string');
    fprintf(voltageData);
    fprintf("\r\nEnd of data\r\n")
end