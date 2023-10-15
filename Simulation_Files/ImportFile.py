import wave
import paramiko
import time
import os

# SSH credentials
hostname = '192.168.205.243'  # replace with your Pi's IP address
username = 'kudzii'
password = '12345678'  # replace with your Pi's password

# Connect to the Pi
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(hostname, username=username, password=password)

# Record audio for 5 seconds
#command = 'arecord -D plughw:1 -d 5 -f cd -t wav -c 2 -r 48000 | tee recording.wav > /dev/null'
command = 'arecord -D plughw:0 -c2 -r 48000 -f S32_LE -t wav -V stereo -d 5 kudzi_stereo.wav'
stdin, stdout, stderr = ssh.exec_command(command)

# Wait for the recording to finish
time.sleep(5)

# Transfer the file to your laptop
local_path = 'C:/Users/Joach/Desktop/'
remote_path = 'kudzi_stereo.wav'
scp = ssh.open_sftp()
scp.get(remote_path, os.path.join(local_path, remote_path))
scp.close()

# Close the SSH connection
ssh.close()