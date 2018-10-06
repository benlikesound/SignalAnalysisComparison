function [magmat, phasemat, fmat, averagedbspectrum] = myspectrogram (wave, fs, windowsize, overlap)
% Produces a spectrogram plot for a given audio signal and an average magnitude 
% spectrum plot
%
% Input arguments:
% wave - a wave file for analysis
% fs -  sampling frequency of the signal in Hz
% windowsize - window size for the analysis in samples
% overlap - the overlap of the windows in percentage
% Note that fft algorithms are optimized for multiples of 2, therefore the 
% windowsize parameter should be calculated by 2^N.
%
% Output arguments:
% magmat - matrix containing the magnitude response of the spectrum for
% each of the windows
% phasemat - matrix containing the phase response of the spectrum for
% each of the windows in radians
% fmat - frequency vector
% averagedbspectrum - average magnotude response in decibels for each of
% the windows

%% Analysis script
% The function uses a for loop to analyse different portions of the wave.
% Note that I'm using the same function described on chunkymovie.
% It is a good idea to initialize variables when a code iterates as is the
% case of our for loop. This preallocates memory and makes calculations
% faster. This is done for the variables spectrogrammat and samplemat.
numChunks = ceil(length(wave) / (windowsize*(1-(overlap/100))));
wavelength = length(wave);
spectrogrammat = zeros(windowsize,numChunks);
samplemat = zeros(numChunks,1);

% This is the main process loop.
for i = 0:numChunks-1
  chunkstart = ceil((i * windowsize + 1)-(windowsize*i*(overlap/100))); 
  
  chunkend = chunkstart + windowsize;
  if chunkend > wavelength;
      chunkend = wavelength;
      zeropadding = zeros(windowsize-(chunkend-chunkstart),1);
      spectrogrammat(:,i+1) = fft((cat(1,wave(chunkstart:(chunkend-1)),...
          zeropadding)).*hann(windowsize),windowsize); % The fft algorithm is
      % applied to the signal here. Note that a Hanning window is used to
      % overcome window edge problems.
  else
      spectrogrammat(:,i+1) = fft((wave(chunkstart:(chunkend-1))).*hann(windowsize),windowsize);
  end

samplemat(i+1)  =   chunkstart; % A matrix with the sample number at each
% analysis frame is created. This allows us to convert this samples to time
% instances for the plotting function below.
end

timemat = samplemat./fs; % Time instances of analysis frames is converted to
% time.

fmatstep = fs/windowsize;
fmat = 0:fmatstep:fs; % The frequency matrix is built by equally dividing the
% frequency range up to the sampling frequency in equal length steps.

magmat = abs(spectrogrammat); % The magnitude spectrum is obtained by finding the 
% magnitude of each complex frequency component.
phasemat = angle(spectrogrammat); % The phase spectrum is obtained by finding the 
% angle of each complex frequency component.
magmattonyquist = magmat(1:windowsize/2, :); % For analysis purposes, 
% we are only interested in frequencies up to the Nyquist frequency.
fmattonyquist = fmat(1, 1:windowsize/2);

averagedbspectrum = mag2db(mean(magmattonyquist,2)./(windowsize/2)); % The 
% average spectrum in decibels is obtained by getting the average of all
% sampled times. The last term in the equation is used to find the average
% spectrum per sample instead of the average spectrum per DFT period.

%% Spectrogram Plot
figure1 = figure;
axes1 = axes('Parent',figure1,'YScale','log',...
    'YMinorTick','on',...
    'YMinorGrid','on');
hold(axes1,'all'); % This lines initialize the figure that is used for
% the spectrogram plot.

surf(timemat, fmattonyquist, 20*log10(magmattonyquist), 'edgecolor', 'none'); axis tight;
% We use the surf function to plot the magnitude spectrum against the time
% instances and frequencies we calculated above.
ylim(axes1,[0 (fs/2)]);

view (0,90);

xlabel('Time (Seconds)'); ylabel('Hz');

%% Average Magnitude Spectrum Plot
figure2 = figure;

axes2 = axes('Parent',figure2,'YGrid','on','XScale','log','XMinorTick','on',...
    'XMinorGrid','on',...
    'XGrid','on');
 xlim(axes2,[0 (fs/2)]);
 ylim(axes2,[-90 0]);
box(axes2,'on');
hold(axes2,'all');

xlabel('Frequency (Hz)');

ylabel('Amplitude (dB)');

title('Average Magnitude Spectrum');

semilogx(fmattonyquist,averagedbspectrum,...
    'DisplayName','averagedbspectrum vs fmattonyquist'); % We use the semilogx
% function to plot logarithmically the average spectrum against frequency.




