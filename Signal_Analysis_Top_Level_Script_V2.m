% Signal Analysis Master Script


%% % Signal Analysis #1		 %%%%
%%%% FFT of Master Channels  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set Working Directory
cd '/Users/itsu/Desktop/Test' % Test Directory
% cd '/Users/itsu/Documents/2. Masters of Architectural Science (Audio and Acoustics)/4. Semester 4 - Research Report/Subject Results'

% Find all files in the dir with names that start with 'master'
master_bounce_list = dir ('**/master*');
% Number of 'master' files in list.
num_files_master = length(master_bounce_list);

% Create Structure containing all master bounce wav files.
for i=1:num_files_master 
	[master_bounces{i}, fs] = audioread(master_bounce_list(i).name);
end
clear i

% Compute the Power Spectral Density of the master files.
for i=1:num_files_master
	n = length(master_bounces{i});
	fft_master_bounces{i} = fft(master_bounces{i}); 
	fft_master_bounces{i} = fft_master_bounces{i}(1:n/2+1);
	masters_PSD{i} = (1/(fs*n))*abs(fft_master_bounces{i}).^2;
	fvec{i} = 0:fs/length(master_bounces{i}):fs/2;
end
clear i 

% % Plot Results of PSD (Valdation Purposes Only - Not Used In Final Results) 
% plot(fvec{1,1},10*log10(PSD_masters{1,1}))
% grid on
% title('Periodogram Using FFT')
% xlabel('Frequency (Hz)')
% ylabel('Power/Frequency (dB/Hz)')

clearvars fvec n fft_master_bounces % Clear Unnecessary data

%% % Signal Analysis #2			 %%%%
%%%% Energy in each band of each %%%%
%%%% master bounce (Narrow)		 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call narrow_band_splitter to filter each master bounce into 10 frequency bands.
for i=1:num_files_master
	narrownames{i} = strcat('narrow', (matlab.lang.makeValidName...		    
		(master_bounce_list(i).name)));								
	master_narrow_bands{i} = narrow_band_split(master_bounces{1, i}, fs);   
end

% Calculate the sum of the square of the signal in each band
for i=1:(num_files_master)
	masters_energy_narrow20_40{i} = sum((master_narrow_bands{1, i}{1,1})./fs);
	masters_energy_narrow40_80{i} = sum((master_narrow_bands{1, i}{1,2})./fs);
	masters_energy_narrow80_120{i} = sum((master_narrow_bands{1, i}{1,3})./fs);
	masters_energy_narrow120_160{i} = sum((master_narrow_bands{1, i}{1,4})./fs);
	masters_energy_narrow160_200{i} = sum((master_narrow_bands{1, i}{1,5})./fs);
	masters_energy_narrow200_230{i} = sum((master_narrow_bands{1, i}{1,6})./fs);
	masters_energy_narrow230_260{i} = sum((master_narrow_bands{1, i}{1,7})./fs);
	masters_energy_narrow260_800{i} = sum((master_narrow_bands{1, i}{1,8})./fs);
	masters_energy_narrow800_3k{i} = sum((master_narrow_bands{1, i}{1,9})./fs);	
	masters_energy_narrow3k_20k{i} = sum((master_narrow_bands{1, i}{1,10})./fs);	
end

names = {'narrow20_40' 'narrow40_80' 'narrow80_120' 'narrow120_160' ...
	'narrow160_200' 'narrow200_230' 'narrow230_260' 'narrow260_800'...
	'narrow800_3k' 'narrow3k_20k'};

masters_narrowband_energy = struct(names{1,1}, masters_energy_narrow20_40, names{1,2}, masters_energy_narrow40_80,...
	names{1,3}, masters_energy_narrow80_120, names{1,4}, masters_energy_narrow120_160, names{1,5}, masters_energy_narrow160_200,...
	names{1,6}, masters_energy_narrow200_230, names{1,7}, masters_energy_narrow230_260, names{1,8}, masters_energy_narrow260_800,...
	names{1,9}, masters_energy_narrow800_3k, names{1,10}, masters_energy_narrow3k_20k);

clearvars -except masters_narrowband_energy masters_PSD

%% % Signal Analysis #3		%%%%
%%%% Energy in each band of %%%%
%%%% each channel (Wide)	%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set Working Directory
cd '/Users/itsu/Desktop/Test' % Test Directory
% cd '/Users/itsu/Documents/2. Masters of Architectural Science (Audio and Acoustics)/4. Semester 4 - Research Report/Subject Results'

% Create list of ALL wav files to be processed.
allchans_list = dir ('**/*.wav');

% Number of wav files in list.
allchans_num_files = length(allchans_list);

% Create Structure containing all wav files in the list.
for i=1:allchans_num_files 
	[allchans{i}, fs] = audioread(allchans_list(i).name);	
end

clear i

% Call wide_band_splitter to filter each channel bounce into 2 frequency bands.

for i=1:allchans_num_files 
	widenames{i} = strcat('wide', (matlab.lang.makeValidName...
		(allchans_list(i).name)));
	allchans_wide_bands{i} = wide_band_split(allchans{1, i}, fs);   
end

% Calculate the sum of the square of the signal in each band
for i=1:allchans_num_files
	allchans_wide_low_energy{i} = sum((allchans_wide_bands{1, i}{1,1})./fs);
	allchans_wide_high_energy{i} = sum((allchans_wide_bands{1, i}{1,2})./fs);
end

names = {'allchans_wide_low_energy' 'allchans_wide_high_energy'};

allchans_wideband_energy = struct(names{1,1}, allchans_wide_low_energy, names{1,2}, allchans_wide_high_energy);

clearvars -except masters_narrowband_energy masters_PSD allchans_wideband_energy

%% % Signal Analysis #4		    %%%%
%%%% Cross correlation of       %%%%
%%%% unmixed kick drum channels %%%%
%%%% with each post-mix kick    %%%%
%%%% channel.				    %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Change Directory to unmixed audio folder.
cd '/Users/itsu/Desktop/Test' % Test Directory
% cd '/Users/itsu/Documents/2. Masters of Architectural Science (Audio and Acoustics)/4. Semester 4 - Research Report/Subject Results'

% Create list of unmixed kick drum channels files to be analysed.
mixed_kicks = dir ('**/kick*');

% Change Directory to unmixed audio folder.
cd '/Users/itsu/Documents/2. Masters of Architectural Science (Audio and Acoustics)/3. Semester 3/1. Wednesday - Research in Architecture and Design Science/1. Research Proposal - Perception of Modal Resonances/Test Stimuli/Mix Stimuli'

% Create list of unmixed kick drum channels files to be analysed.
unmixed_kicks = dir ('**/kick*');

% Create Structure containing unmixed audio files.
for i=1:17 
	[unmixed_audio{i}, fs] = audioread(unmixed_audio(i).name);	
end

clear i





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Collate Results		 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Convert Cell Arrays to Structure Arrays (use names from filelist)
wide_bands = cell2struct(wide_bands, widenames, 2);						
narrow_bands = cell2struct(narrow_bands, narrownames, 2);

% Concatenate all audio to be anylised in a new structure array.
all_bands = catstruct(wide_bands, narrow_bands, master_bounce_list);

 


%TEST%
	
