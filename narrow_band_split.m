function [narrow_bands] = narrow_band_split(insig, fs)

insig = insig(:, 1) + insig(:, 2);											% Sum L+R to make Mono
order = 24;                                                                 % Filter order
phase = 0;                                                                  % Phase response

% Band 1: 20Hz-40Hz
% Band 2: 40Hz-80Hz
% Band 3: 80Hz-120Hz
% Band 4: 120Hz-160Hz 
% Band 5: 160Hz-200Hz
% Band 6: 200Hz-230Hz
% Band 7: 230Hz-260Hz
% Band 8: 260Hz-800Hz
% Band 9: 800Hz-3000Hz
% Band 10: 3kHz-20kHz  

f_lo = [20 40 80 120 160 200 230 260 800 3000];
f_hi = [40 80 120 160 200 230 260 800 3000 20000];

numbands = 10;
names = {'narrow20_40' 'narrow40_80' 'narrow80_120' 'narrow120_160' ...
	'narrow160_200' 'narrow200_230' 'narrow230_260' 'narrow260_800'...
	'narrow800_3k' 'narrow3k_20k'};

% Call bandsplit to bandpass filter audio into bands.
for i=1:numbands
	narrow_bands{i} = bandsplit(insig, f_lo(1,(i)), f_hi(1,(i)), order, fs, phase); 
end

% Convert cell array to structure to give cells names
% narrow_bands = cell2struct(narrow_bands, names, 2);

end


