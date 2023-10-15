% Define Raspberry Pi SSH information
hostname = 'kudzii'; % Raspberry Pi hostname
ipAddress = '192.168.205.121'; % Raspberry Pi IP address
username = 'kudzii'; % Raspberry Pi username (default is usually 'pi')
password = '12345678'; % Raspberry Pi password

% Construct the SSH command
sshCommand = sprintf('sshpass -p "%s" ssh %s@%s', password, username, ipAddress);

% Execute the SSH command
[status, result] = system(sshCommand);

% Check the status of the SSH command
if status == 0
    fprintf('SSH connection successful.\n');
    % You can now execute commands on the Raspberry Pi using SSH.
    % For example, you can run a command on the Raspberry Pi like this:
    % system('sshpass -p "12345678" ssh pi@192.168.205.121 "ls -l"');
else
    fprintf('SSH connection failed.\n');
    fprintf('Error message: %s\n', result);
end
