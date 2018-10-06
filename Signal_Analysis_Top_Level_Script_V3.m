% Signal Analysis Master Script

%% % Signal Analysis #1		 %%%%
%%%% FFT of Master Channels  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set Working Directory
cd '/Users/itsu/Dropbox/Uni/4. Semester 4 - Research Report/Subject Results/Master Bounces'

% Find all files in the dir with names that start with 'master'
master_bounce_list = dir ('**/*.wav');

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
	fft_master_bounces{i} = fft_master_bounces{i}(1:(round((n/2+1), 0)));
	masters_PSD{i} = (1/(fs*n))*abs(fft_master_bounces{i}).^2;
	fvec{i} = 0:fs/length(master_bounces{i}):fs/2;
end
clear i 

masters_PSD = masters_PSD'; % Transpose so that cases/subjects/programs/ run down on the Y Axis.

% % Plot Results of PSD (Valdation Purposes Only - Not Used In Final Results) 
% plot(fvec{1,1},10*log10(masters_PSD{1,1}))
% grid on
% title('Periodogram Using FFT')
% xlabel('Frequency (Hz)')
% ylabel('Power/Frequency (dB/Hz)')

masters_PSD = struct('masters_PSD', masters_PSD);

clearvars fvec n fft_master_bounces % Clear Unnecessary data

%% % Signal Analysis #2			 %%%%
%%%% Energy in each band of each %%%%
%%%% master bounce (Narrow)		 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call narrow_band_splitter to filter each master bounce into 10 frequency bands.
for i=1:num_files_master
% 	narrownames{i} = strcat('narrow', (matlab.lang.makeValidName...		    
% 		(master_bounce_list(i).name)));								
	master_narrow_bands{i} = narrow_band_split(master_bounces{1, i}, fs);   
end
clear i

% Calculate the sum of the square of the signal in each band
for i=1:(num_files_master)
	masters_energy_narrow20_40{i} = sum(((master_narrow_bands{1, i}{1,1}.^2))./fs);
	masters_energy_narrow40_80{i} = sum(((master_narrow_bands{1, i}{1,2}.^2))./fs);
	masters_energy_narrow80_120{i} = sum(((master_narrow_bands{1, i}{1,3}.^2))./fs);
	masters_energy_narrow120_160{i} = sum(((master_narrow_bands{1, i}{1,4}.^2))./fs);
	masters_energy_narrow160_200{i} = sum(((master_narrow_bands{1, i}{1,5}.^2))./fs);
	masters_energy_narrow200_230{i} = sum(((master_narrow_bands{1, i}{1,6}.^2))./fs);
	masters_energy_narrow230_260{i} = sum(((master_narrow_bands{1, i}{1,7}.^2))./fs);
	masters_energy_narrow260_800{i} = sum(((master_narrow_bands{1, i}{1,8}.^2))./fs);
	masters_energy_narrow800_3k{i} = sum(((master_narrow_bands{1, i}{1,9}.^2))./fs);	
	masters_energy_narrow3k_20k{i} = sum(((master_narrow_bands{1, i}{1,10}.^2))./fs);	
end
clear i

names = {'masters_energy_narrow20_40' 'masters_energy_narrow40_80' 'masters_energy_narrow80_120' 'masters_energy_narrow120_160' ...
	'masters_energy_narrow160_200' 'masters_energy_narrow200_230' 'masters_energy_narrow230_260' 'masters_energy_narrow260_800'...
	'masters_energy_narrow800_3k' 'masters_energy_narrow3k_20k'};

masters_narrowband_energy = struct(names{1,1}, masters_energy_narrow20_40, names{1,2}, masters_energy_narrow40_80,...
	names{1,3}, masters_energy_narrow80_120, names{1,4}, masters_energy_narrow120_160, names{1,5}, masters_energy_narrow160_200,...
	names{1,6}, masters_energy_narrow200_230, names{1,7}, masters_energy_narrow230_260, names{1,8}, masters_energy_narrow260_800,...
	names{1,9}, masters_energy_narrow800_3k, names{1,10}, masters_energy_narrow3k_20k)';

clearvars -except masters_PSD masters_narrowband_energy 

%% % Signal Analysis #3					%%%%
%%%% Energy in each band of				%%%%
%%%% each kick drum channel (Narrow)	%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set Working Directory (kick drum folder)
cd '/Users/itsu/Dropbox/Uni/4. Semester 4 - Research Report/Subject Results/Kick Drums'

% Create list of ALL wav files to be processed.
kickdrums_list = dir ('**/*.wav');

% Number of wav files in list.
kickdrums_num_files = length(kickdrums_list);

% Create Structure containing all kick drum channels in the list.
for i=1:kickdrums_num_files 
	[kickdrums{i}, fs] = audioread(kickdrums_list(i).name);	
end
clear i

% Call narrow_band_splitter to filter each master bounce into 10 frequency bands.
for i=1:kickdrums_num_files
% 	narrownames{i} = strcat('narrow', (matlab.lang.makeValidName...		    
% 		(master_bounce_list(i).name)));								
	kickdrums_narrow_bands{i} = narrow_band_split(kickdrums{1, i}, fs);   
end
clear i

% Calculate the sum of the square of the signal in each band
for i=1:(kickdrums_num_files)
	kickdrums_energy_narrow20_40{i} = sum(((kickdrums_narrow_bands{1, i}{1,1}.^2))./fs);
	kickdrums_energy_narrow40_80{i} = sum(((kickdrums_narrow_bands{1, i}{1,2}.^2))./fs);
	kickdrums_energy_narrow80_120{i} = sum(((kickdrums_narrow_bands{1, i}{1,3}.^2))./fs);
	kickdrums_energy_narrow120_160{i} = sum(((kickdrums_narrow_bands{1, i}{1,4}.^2))./fs);
	kickdrums_energy_narrow160_200{i} = sum(((kickdrums_narrow_bands{1, i}{1,5}.^2))./fs);
	kickdrums_energy_narrow200_230{i} = sum(((kickdrums_narrow_bands{1, i}{1,6}.^2))./fs);
	kickdrums_energy_narrow230_260{i} = sum(((kickdrums_narrow_bands{1, i}{1,7}.^2))./fs);
	kickdrums_energy_narrow260_800{i} = sum(((kickdrums_narrow_bands{1, i}{1,8}.^2))./fs);
	kickdrums_energy_narrow800_3k{i} = sum(((kickdrums_narrow_bands{1, i}{1,9}.^2))./fs);	
	kickdrums_energy_narrow3k_20k{i} = sum(((kickdrums_narrow_bands{1, i}{1,10}.^2))./fs);	
end
clear i

names = {'kicks_energy_narrow20_40' 'kicks_energy_narrow40_80' 'kicks_energy_narrow80_120' 'kicks_energy_narrow120_160' ...
	'kicks_energy_narrow160_200' 'kicks_energy_narrow200_230' 'kicks_energy_narrow230_260' 'kicks_energy_narrow260_800'...
	'kicks_energy_narrow800_3k' 'kicks_energy_narrow3k_20k'};

kickdrums_narrowband_energy = struct(names{1,1}, kickdrums_energy_narrow20_40, names{1,2}, kickdrums_energy_narrow40_80,...
	names{1,3}, kickdrums_energy_narrow80_120, names{1,4}, kickdrums_energy_narrow120_160, names{1,5}, kickdrums_energy_narrow160_200,...
	names{1,6}, kickdrums_energy_narrow200_230, names{1,7}, kickdrums_energy_narrow230_260, names{1,8}, kickdrums_energy_narrow260_800,...
	names{1,9}, kickdrums_energy_narrow800_3k, names{1,10}, kickdrums_energy_narrow3k_20k)';

clearvars -except masters_PSD masters_narrowband_energy kickdrums_narrowband_energy

%% % Signal Analysis #4		    %%%%
%%%% Cross correlation of       %%%%
%%%% unmixed kick drum channels %%%%
%%%% with each post-mix kick    %%%%
%%%% channel.				    %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Change Directory and load program A kick drums.
cd '/Users/itsu/Dropbox/Uni/4. Semester 4 - Research Report/Subject Results/Processed Kicks Program Sorted/Program A'
program_A_kicks_list = dir ('**/*.wav');
num_program_A_kicks = length(program_A_kicks_list);
for i=1:num_program_A_kicks
	[program_A_kicks{i}, fs] = audioread(program_A_kicks_list(i).name);	
end
clear i

% Change Directory and load program D kick drums.
cd '/Users/itsu/Dropbox/Uni/4. Semester 4 - Research Report/Subject Results/Processed Kicks Program Sorted/Program D'
program_D_kicks_list = dir ('**/*.wav');
num_program_D_kicks = length(program_D_kicks_list);
for i=1:num_program_D_kicks
	[program_D_kicks{i}, fs] = audioread(program_D_kicks_list(i).name);	
end
clear i

% Change Directory and load program J kick drums.
cd '/Users/itsu/Dropbox/Uni/4. Semester 4 - Research Report/Subject Results/Processed Kicks Program Sorted/Program J'
program_J_kicks_list = dir ('**/*.wav');
num_program_J_kicks = length(program_J_kicks_list);
for i=1:num_program_J_kicks
	[program_J_kicks{i}, fs] = audioread(program_J_kicks_list(i).name);	
end
clear i

% Change Directory and load program R kick drums.
cd '/Users/itsu/Dropbox/Uni/4. Semester 4 - Research Report/Subject Results/Processed Kicks Program Sorted/Program R'
program_R_kicks_list = dir ('**/*.wav');
num_program_R_kicks = length(program_R_kicks_list);
for i=1:num_program_R_kicks
	[program_R_kicks{i}, fs] = audioread(program_R_kicks_list(i).name);	
end
clear i

% Change Directory and load original kick drums.
cd '/Users/itsu/Dropbox/Uni/4. Semester 4 - Research Report/Subject Results/Original Kicks'
original_kicks_list = dir ('**/*.wav');
num_original_kicks = length(original_kicks_list);
for i=1:num_original_kicks 
	[original_kicks{i}, fs] = audioread(original_kicks_list(i).name);
end
clear i

% Make mono
for i=1:num_original_kicks
	original_kicks{i} = original_kicks{1,i}(:, 1) + original_kicks{1,i}(:, 2);
end
clear i
for i=1:num_program_A_kicks
	program_A_kicks{i} = program_A_kicks{1,i}(:, 1) + program_A_kicks{1,i}(:, 2);
	program_D_kicks{i} = program_D_kicks{1,i}(:, 1) + program_D_kicks{1,i}(:, 2);
	program_J_kicks{i} = program_J_kicks{1,i}(:, 1) + program_J_kicks{1,i}(:, 2);
	program_R_kicks{i} = program_R_kicks{1,i}(:, 1) + program_R_kicks{1,i}(:, 2);
end
clear i

% Compute Cross Corelations of Program A Kicks with original A Kick.
for i=1:num_program_A_kicks
	program_A_xcorr{i} = xcorr(original_kicks{1,1}, program_A_kicks{1,i});
	program_D_xcorr{i} = xcorr(original_kicks{1,2}, program_D_kicks{1,i});
	program_J_xcorr{i} = xcorr(original_kicks{1,3}, program_J_kicks{1,i});
	program_R_xcorr{i} = xcorr(original_kicks{1,4}, program_R_kicks{1,i});
end
clear i

% Transpose
	program_A_xcorr = program_A_xcorr';
	program_D_xcorr = program_D_xcorr';
	program_J_xcorr = program_J_xcorr';
	program_R_xcorr = program_R_xcorr';
	
% Add Decay Condition A to master xcorr array
for i=1:5	
	allkicks_xcorr(i,1) = [program_A_xcorr(i,1)];
end
clear i
for i=1:5	
	allkicks_xcorr(5+i,1) = [program_D_xcorr(i,1)];
end
clear i
for i=1:5
	allkicks_xcorr(10+i,1) = [program_J_xcorr(i,1)];
end
clear i
for i=1:5
	allkicks_xcorr(15+i,1) = [program_R_xcorr(i,1)];
end
clear i
% Add Decay Condition B to master xcorr array
for i=1:5
	allkicks_xcorr(20+i,1) = [program_A_xcorr(i+5,1)];
end
clear i
for i=1:5
	allkicks_xcorr(25+i,1) = [program_D_xcorr(i+5,1)];
end
clear i
for i=1:5
	allkicks_xcorr(30+i,1) = [program_J_xcorr(i+5,1)];
end
clear i
for i=1:5
	allkicks_xcorr(35+i,1) = [program_R_xcorr(i+5,1)];
end
clear i
% Add Decay Condition C to master xcorr array
for i=1:5
	allkicks_xcorr(40+i,1) = [program_A_xcorr(i+10,1)];
end
clear i
for i=1:5
	allkicks_xcorr(45+i,1) = [program_D_xcorr(i+10,1)];
end
clear i
for i=1:5
	allkicks_xcorr(50+i,1) = [program_J_xcorr(i+10,1)];
end
clear i
for i=1:5
	allkicks_xcorr(55+i,1) = [program_R_xcorr(i+10,1)];
end
clear i
% Add Decay Condition D to master xcorr array
for i=1:5
	allkicks_xcorr(60+i,1) = [program_A_xcorr(i+15,1)];
end
clear i
for i=1:5
	allkicks_xcorr(65+i,1) = [program_D_xcorr(i+15,1)];
end
clear i
for i=1:5
	allkicks_xcorr(70+i,1) = [program_J_xcorr(i+15,1)];
end
clear i
for i=1:5
	allkicks_xcorr(75+i,1) = [program_R_xcorr(i+15,1)];
end
clear i

allkicks_xcorr = struct('allkicks_xcorr', allkicks_xcorr);
	
clearvars -except masters_PSD masters_narrowband_energy kickdrums_narrowband_energy allkicks_xcorr

%% % Signal Analysis #5				%%%%
%%%% Power in each band of          %%%%
%%%% each individual channel (Wide) %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set Working Directory (All chans folder)
cd '/Users/itsu/Dropbox/Uni/4. Semester 4 - Research Report/Subject Results/Individual Channels'

% Create list of ALL wav files to be processed.
allchans_list = dir ('**/*.wav');

% Number of wav files in list.
allchans_num_files = length(allchans_list);

% Create Structure containing all kick drum channels in the list.
for i=1:allchans_num_files 
	[allchans{i}, fs] = audioread(allchans_list(i).name);	
end
clear i

% Split all audio channels into wide bands (20-300 & 300-20,000)
for i=1:allchans_num_files
    allchans_wide_bands{i} = wide_band_split(allchans{1, i}, fs);
end
clear i 

% Calculate the power in the signal in each band
for i=1:(kickdrums_num_files)
	kickdrums_energy_narrow20_40{i} = mean(kickdrums_narrow_bands{1, i}{1,1}.^2);
	kickdrums_energy_narrow40_80{i} = mean(kickdrums_narrow_bands{1, i}{1,2}.^2);
end
clear i

kickdrums_narrowband_energy = struct('allchans_power_low', allchans_power_high, 'allchans_power_low', allchans_power_low);    

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Collate Results		 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Concatenate all audio to be anylised in a new structure array.
all_results = catstruct(wide_bands, narrow_bands, master_bounce_list);

 


%TEST%
	
