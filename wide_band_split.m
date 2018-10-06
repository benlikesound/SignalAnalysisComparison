function wide_bands = wide_band_split(insig, fs)

insig = insig(:, 1) + insig(:, 2);											% Sum L+R to make Mono
order = 24;                                                                 % Filter order
phase = 0;                                                                  % Phase response

% Band 1: 20Hz-300Hz
% Band 2: 300Hz-20kHz

% Init Cutoff Vars
numbands = 2;
f_lo = [20 300];
f_hi = [300 20000];
names = {'low' 'high'};

% Call bandsplit to bandpass filter audio into bands.
for i=1:numbands
	wide_bands{i} = bandsplit(insig, f_lo(1,(i)), f_hi(1,(i)), order, fs, phase); 
end

% Convert cell array to structure to give cells names
% wide_bands = cell2struct(wide_bands, names, 2);

end


