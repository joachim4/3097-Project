%Question 1:

%Sampling Frequency
Fs = 1000; 
%Time for it to run
time = 1;           
t = (0:1/Fs:time);
%Frequency of the sinusoid
f = 30.76;                  
%Generating the sinusoid
x = sin(2*pi*f*t);
% Plot the signal versus time:
%subplot(1,1,1);
plot(t,x);
xlabel('time');

%Question 2:

%Sampling Frequency
Fs = 1000; 
%Time for it to run
time = 1;           
t = (0:1/Fs:time);
%Frequency of the sinusoid
f = 30.76; 
%Plotting the first signal
subplot(2,1,1);
x = sin(2*pi*f*t);
plot(t,x)
xlabel('time');
%updating the length for the second graph
subplot(2,1,2); 
time_2 = 0.325097529;
t_1 = (0:1/Fs:time_2);
x_1 = sin(2*pi*f*t_1);
plot(t_1,x_1)
xlabel('time');

%Question 3:

%Sampling Frequency
Fs = 200;         
time = 1;           
t = (0:1/Fs:time);
%Frequency of the sinusoid
f = 30.76; 
%Plotting the signal
x = sin(2*pi*f*t);
plot(t,x)
xlabel('time');

%Question 4:

%Sampling Frequency set at 50Hz
f = 30.76;
fs = 50; 
%Time for it to run
time = 1;   


t_3 = (0:1/fs:time);              
%Generating the sinusoid
x_3 = sin(2*pi*f*t_3);
%Plotting the first signal
subplot(3,1,1);
%y = linspace(0,time);
plot(t_3,x_3)
xlabel('time');
   
%updating the sampling frequency to 33.33 Hz for the second graph
subplot(3,1,2); 
FS = 33.33; 
t_4 = (0:1/FS:time);
x_4 = sin(2*pi*f*t_4);
plot(t_4,x_4)
xlabel('time');

%updating the sampling frequency to 28.57 Hz for the third graph 
subplot(3,1,3);
FS_1 = 28.57;
t_5 = (0:1/FS_1:time);
x_5 = sin(2*pi*f*t_5);
plot(t_5,x_5)
xlabel('time');
