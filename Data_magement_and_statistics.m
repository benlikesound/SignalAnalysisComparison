% Data Magement & Statistics

cd '/Users/itsu/Dropbox/Uni/4. Semester 4 - Research Report/Subject Results/Analysis Results'

load -mat 1_masters_PSD                 % dimensions are inconsistent with the rest.
load -mat 2_masters_narrowband_energy
load -mat 3_kickdrums_narrowband_energy 
load -mat 4_allkicks_xcorr              % dimensions are inconsistent with the rest.
% load -mat 5_allchans_wideband_power     % Wrong number of rows. Sub-index
% them into trial groups? Cut your losses. Don't include this in the study. The
% clock is running.

load Qualitative Data.csv

subjective_data = table2struct(QualitativeData);

allresults = catstruct(masters_PSD, masters_narrowband_energy, kickdrums_narrowband_energy, allkicks_xcorr, subjective_data);
save ('allresults.mat', 'allresults');

clearvars -except allresults
