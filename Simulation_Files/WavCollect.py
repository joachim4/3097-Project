import wave
import paramiko
import time
import os

# SSH credentials for Pi 1
hostname1 = '192.168.205.243'  # replace with your Pi's IP address
username1 = 'kudzii'
password1 = '12345678'  # replace with your Pi's password

# SSH credentials for Pi 2
hostname2 = '192.168.205.121'  # replace with your Pi's IP address
username2 = 'kudzi'
password2 = '12345678'  # replace with your Pi's password

# Connect to Pi 1
ssh1 = paramiko.SSHClient()
ssh1.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh1.connect(hostname1, username=username1, password=password1)

# Record audio for 5 seconds on Pi 1
command1 = 'arecord -D plughw:0 -c2 -r 48000 -f S32_LE -t wav -V stereo -d 5 kudzi_stereo1.wav'
stdin1, stdout1, stderr1 = ssh1.exec_command(command1)

# Wait for the recording to finish on Pi 1
time.sleep(5)

# Transfer the file from Pi 1 to your laptop
local_path = 'C:/Users/Joach/Desktop/'
remote_path1 = 'kudzi_stereo1.wav'
scp1 = ssh1.open_sftp()
scp1.get(remote_path1, os.path.join(local_path, remote_path1))
scp1.close()

# Close the SSH connection to Pi 1
ssh1.close()

# Connect to Pi 2
ssh2 = paramiko.SSHClient()
ssh2.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh2.connect(hostname2, username=username2, password=password2)

# Record audio for 5 seconds on Pi 2
command2 = 'arecord -D plughw:0 -c2 -r 48000 -f S32_LE -t wav -V stereo -d 5 kudzi_stereo2.wav'
stdin2, stdout2, stderr2 = ssh2.exec_command(command2)

# Wait for the recording to finish on Pi 2
time.sleep(5)

# Transfer the file from Pi 2 to your laptop
remote_path2 = 'kudzi_stereo2.wav'
scp2 = ssh2.open_sftp()
scp2.get(remote_path2, os.path.join(local_path, remote_path2))
scp2.close()

# Close the SSH connection to Pi 2
ssh2.close()