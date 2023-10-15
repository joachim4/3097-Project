import wave
import paramiko
import time
import os
import multiprocessing

# Define the SSH credentials for Pi 1
hostname1 = '192.168.137.178'  # replace with your Pi's IP address
username1 = 'kudzi'
password1 = '12345678'  # replace with your Pi's password

# Define the SSH credentials for Pi 2
hostname2 = '192.168.137.85'  # replace with your Pi's IP address
username2 = 'kudzii'
password2 = '12345678'  # replace with your Pi's password

# Function to record audio on Pi 1
def record_on_pi1():
    ssh1 = paramiko.SSHClient()
    ssh1.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh1.connect(hostname1, username=username1, password=password1)

    command1 = 'arecord -D plughw:0 -c2 -r 48000 -f S32_LE -t wav -V stereo -d 10 pi_stereo1.wav'
    stdin1, stdout1, stderr1 = ssh1.exec_command(command1)

    time.sleep(5)

    local_path = r'C:/Users/Joach/Desktop/'
    remote_path1 = r'pi_stereo1.wav'
    scp1 = ssh1.open_sftp()
    scp1.get(remote_path1, os.path.join(local_path, remote_path1))
    scp1.close()

    ssh1.close()

# Function to record audio on Pi 2
def record_on_pi2():
    ssh2 = paramiko.SSHClient()
    ssh2.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh2.connect(hostname2, username=username2, password=password2)

    command2 = 'arecord -D plughw:0 -c2 -r 48000 -f S32_LE -t wav -V stereo -d 10 pi_stereo2.wav'
    stdin2, stdout2, stderr2 = ssh2.exec_command(command2)

    time.sleep(5)

    local_path = r'C:/Users/Joach/Desktop/'
    remote_path2 = r'pi_stereo2.wav'
    scp2 = ssh2.open_sftp()
    scp2.get(remote_path2, os.path.join(local_path, remote_path2))
    scp2.close()

    ssh2.close()

if __name__ == '__main__':                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    # Create two separate processes for recording on each Pi
    process1 = multiprocessing.Process(target=record_on_pi1)
    process2 = multiprocessing.Process(target=record_on_pi2)

    # Start both processes in parallel
    process1.start()
    process2.start()

    # Wait until both recordings finish
    process1.join()
    process2.join()

    # Sleep for 15 seconds (optional)
    time.sleep(15)
