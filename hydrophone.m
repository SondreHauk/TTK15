%% ----- Extract hydrophone data ----- %%
% These are the files containing verified puls trains.
% They are registered at 13:00, but the real time was 15:00.
% As expected, the SNR decreases as the time/distance increases:
% 132700 has the best SNR, 134700 has the worst SNR.

% 132700, 132800, 132900, 133100, 133200, 133400, 133500, 133700,
% 133800, 134100, 134200, 134300, 134400, 134600, 134700

clear;
[audio, Fs] = audioread("data/Hydrophone/SBW1385_20261015_133500.wav");

%% ----- Plot spectrogram ----- %%
window = 2048;   % 2048 samples at 256 ksps = 8ms
overlap = 1024;  % 50% overlap
nfft = 4096;     % freq resolution 62.5 Hz

spectrogram(audio, window, overlap, nfft, Fs, 'yaxis');

colorbar;
title('Audio Spectrogram');
xlabel('Time (s)');
ylabel('Frequency (kHz)');


%% ----- save selected puls trains ----- %%

% PThighSNR, Time: 15:27:38 - 15:27:44 
% PTlowSNR, Time: 15:47:06 - 15:47:10
% PTmidSNR, Time: 15:35:28 - 15:35:34

PTmidSNR = audio(28*Fs:34*Fs); 
spectrogram(PTmidSNR, window, overlap, nfft, Fs, 'yaxis');


%% ----- filter signals ----- %%
Ftarget = 69000;
Fbuff = 500;

B = designfilt('bandpassiir',...
    DesignMethod='butter',...
    FilterOrder=4,...
    HalfPowerFrequency1=Ftarget-Fbuff,...
    HalfPowerFrequency2=Ftarget+Fbuff,...
    Samplerate=Fs);

filt = filter(B,PTmidSNR);
%% Do more here! Test different filters and study how the signal is affected.
spectrogram(filt, window, overlap, nfft, Fs, 'yaxis');