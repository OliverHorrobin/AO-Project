classdef mirror < handle
    
    % I ommited reading the voltages because it makes it 4-5 times slower
    % than I need it to be.
    properties
        serial
        voltages = zeros(64,1);
        isconnected = 0;
    end
    methods
        function obj = mirror
            initialiseDriver(obj)
        end
        function setChannel(obj,volt,chan)
            check_connection(obj)
            if abs(volt) > 100
                error('Too much voltage')
            elseif chan > 64 || chan < 1
                error('Incorrect Channel')
            end
            volt = volt*1e+3;
            msg = sprintf('%d %d set_output',volt,chan);
            writeline(obj.serial,msg)
            obj.voltages(chan) = volt;  % Logging the voltage.
            % Ideally we wanna ask the driver what the voltages are because
            % if this object is deleted the voltages array resets while the
            % mirror keeps them applied.
        end
        function setChannels(obj,volts)
            check_connection(obj)
            if isscalar(volts)
                volts = volts*ones(64,1);
            end
            for i = 1:64
                setChannel(obj,volts(i),i)
            end
            obj.voltages = volts;
            pause(0.1) % Delay is used to give the actuators time to move.
            % I Don't actually know the response time of this mirror.
        end
        function degaus(obj)
            % Dunno if this is how you actually degaus nor if it's useful
            % in any way
            for i = 1:64
                for v = linspace(-30,30,5)
                    setChannel(obj,v,i)
                end
            end
            setChannels(obj,0)
        end
        function disconnect(obj)
            check_connection(obj)
            obj.serial = [];
            obj.isconnected = 0;
            fprintf('Connection closed\n');
        end
        function initialiseDriver(obj)
            % Rebecca's Code
            if obj.isconnected
                warning('Driver is already initialised. Skipping initialisation...')
                return
            end
            % Open serial port COM4 with baud rate 115200
            obj.serial = serialport("COM1",115200);
            % carriage return terminator
            configureTerminator(obj.serial,"CR");

            % initial command sent to drop out of the device's legacy mode
            writeline(obj.serial,"~~~");
            readString = readline(obj.serial);

            % send some carriage returns
            write(obj.serial,13,'char');
            readString = readline(obj.serial);
            write(obj.serial,13,'char');
            readString = readline(obj.serial);
            write(obj.serial,13,'char');
            readString = readline(obj.serial);

            % print to console the received response
            fprintf(readString);

            stringCheck = strfind(readString, 'ok');

            if stringCheck > 0
                fprintf("\r\nDevice now ready to receive commands\r\n");
                obj.isconnected = true;
            else
                fprintf("\r\nCommunication Error\r\n");
                disconnect(obj);
            end
        end
        function check_connection(obj)
            if ~obj.isconnected
                error('Driver not connected')
            end
        end
    end
end