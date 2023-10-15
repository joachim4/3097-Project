import multiprocessing
from time import sleep
import os
import sys

#Define SSH record command for each Raspberry Pi 
def piCommand1():
    os.system("ssh kudzii@192.168.187.244 arecord -D plughw:0 -c2 -r 48000 -f S32_LE -t wav -V stereo -d 20 pi1stereo.wav")
def piCommand2():
    os.system("ssh kudzi@192.168.187.121 arecord -D plughw:0 -c2 -r 48000 -f S32_LE -t wav -V stereo -d 20 pi2stereo.wav")
   
    
if __name__ == '__main__':

    #Define file path to store recordings
    file_path = r'D:\MyPersonalGit\3097-Project\Simulation_Files'
    
    
    #Define parallel processes and target the ssh command
    process1 = multiprocessing.Process(target=piCommand1)
    process2 = multiprocessing.Process(target=piCommand2)

    #Execute parallel processes to begin recording
    process1.start()
    process2.start()
    
    #Wait until recordings fininsh
    sleep(17)                                          
   
   
    process1.terminate()
    process2.terminate()

    #Collect recordings from Raspberry Pis
    os.system("scp kudzii@192.168.187.244:pi1stereo.wav "+file_path)
    os.system("scp kudzi@192.168.187.121:pi2stereo.wav "+file_path)
    
    sys.exit()

#exit
#exit