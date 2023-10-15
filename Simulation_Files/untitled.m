
r1 = [0,0];                     %mic1
r2 = [0 6.31];                  %mic2
r3 = [3.68 0];                  %mic3              
r4 = [3.68,6.31];               %mic4

LUT = Generate_LUT(r1,r2,r3,r4,resolution);     % Generate Look up table for TODA WRT mic 1


[monoLeft1, monoRight1] = splitStereoToMono('pi_stereo1.wav');
[monoLeft2, monoRight2] = splitStereoToMono('pi_stereo2.wav');

% Assuming you have already loaded the mono signals
% If not, load them from your files as needed.

% Create a new figure
figure;

% Plot the first mono signal
subplot(2, 2, 1); % 2x2 grid, first plot
plot(monoLeft1);
title('Mono Left 1');

% Plot the second mono signal
subplot(2, 2, 2); % 2x2 grid, second plot
plot(monoRight1);
title('Mono Right 1');

% Plot the third mono signal
subplot(2, 2, 3); % 2x2 grid, third plot
plot(monoLeft2);
title('Mono Left 2');

% Plot the fourth mono signal
subplot(2, 2, 4); % 2x2 grid, fourth plot
plot(monoRight2);
title('Mono Right 2');

% Adjust the figure layout
sgtitle('Four Mono Signals'); % Add a title for the entire figure

% You can use the 'xlabel' and 'ylabel' functions to label the axes if needed.

% Optionally, you can use 'axis' to set custom axis limits for each plot if necessary.

% Display the figure
figure; % Create a new figure to avoid further plots appearing in the same figure

% Play the sound from monoRight1
sound(monoRight1, 48000); % Adjust the sampling rate as needed


[Estimated_positionN1, Estimated_positionN2, Estimated_positionN3, Estimated_positionN4, E1 , E2, E3 , E4 ]   = triangulate(TDOA_21,TDOA_31,TDOA_41,TDOA_32,TDOA_42,TDOA_43,LUT);

Estimate_arr = [Estimated_positionN1', Estimated_positionN2', Estimated_positionN3', Estimated_positionN4'];





%Ditirmine if there is a sampling error on a single mic
bad_mic = [0 0 0 0];
possible_solutions = zeros(2,4);
if (Estimated_positionN1(1)~=0 && Estimated_positionN1(2)~=0 && Estimated_positionN1(1)~=r4(1) && Estimated_positionN1(2)~=r4(2))
     display(Estimated_positionN1);
     possible_solutions(:,end+1)=Estimated_positionN1;
     bad_mic(1) = 1;
     
else 
    fprintf("Mic 1 is probably ok\n")
     
end
if (Estimated_positionN2(1)~=r1(1) && Estimated_positionN2(2)~=r1(1) && Estimated_positionN2(1)~=r4(1) && Estimated_positionN2(2)~=r4(2))
    display(Estimated_positionN2);
    possible_solutions(:,end+1)=Estimated_positionN2';
    bad_mic(2) = 1;
        
else 
    fprintf("Mic 2 is probably ok\n")
    okay_arr(2)=1;
end

if (Estimated_positionN3(1)~=0 && Estimated_positionN3(2)~=0 && Estimated_positionN3(1)~=r4(1) && Estimated_positionN3(2)~=r4(2))
    display(Estimated_positionN3);
    possible_solutions(:,end+1)=Estimated_positionN3';
    bad_mic(3) = 1;
  
else 
fprintf("Mic 3 is probably ok\n")
okay_arr(3)=1;
end

if (Estimated_positionN4(1)~=0 && Estimated_positionN4(2)~=0 && Estimated_positionN4(1)~=r4(1) && Estimated_positionN4(2)~=r4(2))
    display(Estimated_positionN4);
    possible_solutions(:,end+1)=Estimated_positionN4';
    bad_mic(4) = 1;
  
else 
fprintf("Mic 4 is probably ok\n")
okay_arr(4)=1;
end

%Output mean estimation if more than 1 possible solution
possible_solutions( :, all(~possible_solutions,1) ) = [];
if isempty(possible_solutions)
    disp("Bad Read, estimated position will be incorrect")
    Estimated_position = Estimated_positionN1;
else
    Estimated_position(1) = mean(possible_solutions(1,:));   
    Estimated_position(2) = mean(possible_solutions(2,:));

end
