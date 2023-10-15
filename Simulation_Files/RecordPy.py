import multiprocessing
from time import sleep
import os
import sys
#import sounddevice as sd
#import soundfile as sf



#Define SSH record command for each Raspberry Pi 
def pi1():
    #os.system("ssh kudzii@192.168.187.244 sudo nice -n -20 arecord -f S32_LE -r 48000 -d 20 -c 2 -D plughw:0 pi1stereo.wav")
    os.system("ssh kudzii@192.168.187.244 arecord -D plughw:0 -c2 -r 48000 -f S32_LE -t wav -V stereo -d 25 pi1stereo.wav")
def pi2():
    #os.system("ssh kudzi@192.168.187.121 sudo nice -n -20 arecord -f S32_LE -r 48000 -d 20 -c 2 -D plughw:0 pi2stereo.wav")
    os.system("ssh kudzi@192.168.187.121 arecord -D plughw:0 -c2 -r 48000 -f S32_LE -t wav -V stereo -d 25 pi2stereo.wav")
   
    
if __name__ == '__main__':
   # argumentList = sys.argv[1:]                       #Read in File name
   # file_path = r'C:/Users/Joach/Desktop/'
    file_path = r'D:\MyPersonalGit\3097-Project\Simulation_Files'
    #os.system("mkdir "+str(file_path))                #Create directory
    
    #Define parallel processes and target the ssh command
    process1 = multiprocessing.Process(target=pi1)
    process2 = multiprocessing.Process(target=pi2)

    #Execute parallel processes to begin recording
    process1.start()
    process2.start()
    
    sleep(5)                                           #Wait 5 seconds
    
    #Read in calibration signal
    #filename = 'chirp.wav' 

   # data, fs = sf.read(filename, dtype='float32')      # Extract data and sampling rate from file
   # sd.play(data, fs)                                  #Play calibration signal
   #i status = sd.wait()                                 # Wait until file is done playing
    
    sleep(25)                                          #Wait until recordings fininsh
   

    #Collect recordings from Raspberry Pis
    os.system("scp kudzii@192.168.187.244:pi1stereo.wav "+file_path)
    os.system("scp kudzi@192.168.187.121:pi2stereo.wav "+file_path)
    
    exit
exit