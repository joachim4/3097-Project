import multiprocessing
from time import sleep
import os
import sys

#Define SSH record command for each Raspberry Pi 
def piCommand1():
    os.system("ssh kudzii@192.168.13.243 arecord -D plughw:0 -c2 -r 48000 -f S32_LE -t wav -V stereo -d 20 pi1stereo.wav")
def piCommand2():
    os.system("ssh kudzi@192.168.13.121 arecord -D plughw:0 -c2 -r 48000 -f S32_LE -t wav -V stereo -d 20 pi2stereo.wav")
   
    
if __name__ == '__main__':

    #Define file path to store recordings
    file_path = r'D:\MyPersonalGit\3097-Project\Simulation_Files'
    
    
    task1 = multiprocessing.Process(target=piCommand1)
    task2 = multiprocessing.Process(target=piCommand2)

    task1.start()
    task2.start()
    
    sleep(17)                                          
   
    task1.terminate()
    task2.terminate()

    #Collect recordings from Raspberry Pis
    os.system("scp kudzii@192.168.187.244:pi1stereo.wav "+file_path)
   # os.system("scp kudzi@192.168.187.121:pi2stereo.wav "+file_path)
    
    sys.exit()

#exit
#exit