% Signal Analysis Master Script

%%%%%%%%%%%%%%
% Load files for analysis and arrange them into structures for analysys.
% Four strucutres are created. One for the original mix stimuli provided to
% test subjects, one for master channel renders of the tasks submitted by
% subjects. The final two structs contain masters & individual channels 
% for every task. In the wide_bands struct, every piece of audio is split 
% into a high and low band. In the narrow_bands struct, every piece of
% audio is split into 10 bands.

% Set Input Folder
cd '/Users/itsu/Desktop/Test' % Test Directory
% cd '/Users/itsu/Documents/2. Masters of Architectural Science (Audio and Acoustics)/4. Semester 4 - Research Report/Subject Results'

% Create list of ALL wav files to be processed.
filelist = dir ('**/*.wav');

% Number of wav files in list.
num_files = length(filelist);

% Create Structure containing all wav files in the list.
for i=1:num_files
	[input_files{i}, fs] = audioread(filelist(i).name);	
end

clear i


% Change Directory to unmixed audio folder.
cd '/Users/itsu/Documents/2. Masters of Architectural Science (Audio and Acoustics)/3. Semester 3/1. Wednesday - Research in Architecture and Design Science/1. Research Proposal - Perception of Modal Resonances/Test Stimuli/Mix Stimuli'

% Create list of unmixed wav files to be analysed.
unmixed_audio = dir ('**/*.wav');

% Create Structure containing unmixed audio files.
for i=1:17 
	[unmixed_audio{i}, fs] = audioread(unmixed_audio(i).name);	
end

clear i

% Band Pass Filters
for i=1:num_files
	widenames{i} = strcat('wide', (matlab.lang.makeValidName...				% Makes filelist names valid as variable names
		(filelist(i).name)));												%
	
	wide_bands{i} = wide_band_split(input_files{1, i}, fs);					% Calls function to split input audio files in to hi and lo bands. Results stored in new cellarry.
	
	narrownames{i} = strcat('narrow', (matlab.lang.makeValidName...			% Makes filelist names valid as variable names
		(filelist(i).name)));												%
	
	narrow_bands{i} = narrow_band_split(input_files{1, i}, fs);				% Calls function to split input audio files in to 10 narrow bands. Results stored in new cellarry.	
end

% number of audiofiles in the structs for wide and narrow bands
wide_len = length(wide_bands);
narrow_len = length(narrow_bands);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Signal Analysis %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Observation #1 %%%%%%%%%%%%%
%%%% FFT of Master Channels %%%%%
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
	[master_bouncnes{i}, fs] = audioread(master_bounce_list(i).name);
end
clear i

% Compute the FFT
for i=1:num_files_master
	fft_masters{i} = fft(master_bounces{i});
	master_lengths{i} = length(master_bounces);
	
% Compute the two-sided spectrum P2. Then compute the single-sided spectrum P1 based on P2 and the even-valued signal length L.
	
	P2 = abs(fft_masters{i}/master_lengths{i});
	P1 = P2(1:master_lengths{i}/2+1);
	P1(2:end-1) = 2*P1(2:end-1);
	fft_masters = Fs*(0:(master_lengths{i})/2))/master_lengths{i};
end
% Convert Cell Arrays to Structure Arrays (use names from filelist)
wide_bands = cell2struct(wide_bands, widenames, 2);						
narrow_bands = cell2struct(narrow_bands, narrownames, 2);

% Call burgspecest object as a function to estimate the spectrum of the 
% signal by the Burg method
for i=1:narrow_len
	narrow_spectra(i) = step(burgspecest,narrow_bands(i))
end


% Concatenate all audio to be anylised in a new structure array.
all_bands = catstruct(wide_bands, narrow_bands, master_bounce_list);

 


%TEST%
	
