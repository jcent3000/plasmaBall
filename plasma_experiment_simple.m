% simple script to run plasma ball experiment
% Dean Radin, Institute of Noetic Sciences, Petaluma, CA
% October 10 2018

clear;

% Webcam experiment  
% ----------
clear;
TrialLength = 30;       % X second trial epochs
nTrials = 7;            % X pairs of C and R
e1A = [];  e2A = [];
soA = []; moA = []; c1A = []; c2A = []; c3A = []; cA = []; 
exptA = []; baseA = [];
soA2 = []; moA2 = []; tA = [];

% setup voice instructions
fprintf('setting up sounds\n');
[voiceBegin       voiceRate]  = audioread('LeenaVoice-Begin.wav');
[voiceConcentrate voiceRate]  = audioread('LeenaVoice-Concentrate.wav');
[voiceEnd         voiceRate]  = audioread('LeenaVoice-Experiment Over.wav');
[voiceRelax       voiceRate]  = audioread('LeenaVoice-Relax.wav');

vConcentrate = audioplayer(voiceConcentrate, voiceRate);
vBegin = audioplayer(voiceBegin, voiceRate);
vEnd = audioplayer(voiceEnd, voiceRate);
vRelax = audioplayer(voiceRelax, voiceRate);

fprintf('finished setting up sounds\n');
system('nircmd.exe setsysvolume 65000'); % for max volume
playblocking(vBegin);

%% setup camera  
% name and create output file
camList = webcamlist;
cam = webcam(2);
cam.Resolution = '640x480';

% Get subject's name and create output file
% ----------------------------------------------
subjectName = inputdlg({'Enter subject name (no spaces)'},'Subject Name',1,{''});
drawnow;
fout = [subjectName{1}];

condition = 1;
system('nircmd setbrightness 5');
for epoch = 1 : 20
    if(condition == 0)
        condition = 1;
        system('nircmd setbrightness 60');
        playblocking(vConcentrate);
    else
        clf;
        condition = 0;
        system('nircmd setbrightness 3');
        playblocking(vRelax);
    end
%     tic;
    t1 = now;
    for j = 1 : 100
        o = snapshot(cam);
        pause(.1);
        r = snapshot(cam);


        mo = mean2(o);      % mean illumination of entire ball
        moA = [moA mo];     % mean illumination array
        cA = [cA condition]; % condition array
        if(condition == 1)
            exptA = [exptA mo];
            plot(exptA);
            hold on;
            plot(xlim, [B B], ':r');
            hold off;
            drawnow;
            fprintf('%4d %6.3f\n', j, B);
        elseif(condition == 0)
            baseA = [baseA mo];
            fprintf('%4d\n', j);
        end
    end
    t2 = now;
    elapsed = (t2-t1)*24*3600;
    tA = [tA elapsed];

	if(condition == 0)
        B = nanmean(baseA);
        baseA = [];
    else
        exptA = [];
    end
end

save(fout, 'cA', 'tA', 'moA');
playblocking(vEnd);
clear cam;

