function opIDs = GiveMeFeatureSet(whatFeatureSet,Operations)
% GiveMeFeatureSet Outputs a set of Operation IDs corresponding to a given set
%
% INPUTS:
% ---whatFeatureSet, the type of feature set to retrieve/filter.
% ---Operations, the Operations table to match to.

% ------------------------------------------------------------------------------
% Copyright (C) 2020, Ben D. Fulcher <ben.d.fulcher@gmail.com>,
% <http://www.benfulcher.com>
%
% If you use this code for your research, please cite the following two papers:
%
% (1) B.D. Fulcher and N.S. Jones, "hctsa: A Computational Framework for Automated
% Time-Series Phenotyping Using Massive Feature Extraction", Cell Systems 5: 527 (2017).
% DOI: 10.1016/j.cels.2017.10.001
%
% (2) B.D. Fulcher, M.A. Little, N.S. Jones, "Highly comparative time-series
% analysis: the empirical structure of time series and their methods",
% J. Roy. Soc. Interface 10(83) 20130048 (2013).
% DOI: 10.1098/rsif.2013.0048
%
% This work is licensed under the Creative Commons
% Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of
% this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send
% a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View,
% California, 94041, USA.
% ------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
if nargin < 1 || isempty(whatFeatureSet)
    whatFeatureSet = 'catch22';
end
if nargin < 2
    error('You must provide an Operations table to match features to by name');
end
%-------------------------------------------------------------------------------

switch whatFeatureSet
case 'noLengthLocationSpread'
    matchByName = false;
    % Remove length, location, spread-dependent features
    doOld = false;
    if doOld
        lengthIDs = TS_GetIDs('lengthdep',Operations,'ops','Keywords');
        locIDs = TS_GetIDs('locdep',Operations,'ops','Keywords');
        spreadIDs = TS_GetIDs('spreaddep',Operations,'ops','Keywords');
    else
        lengthIDs = TS_GetIDs('lengthDependent',Operations,'ops','Keywords');
        locIDs = TS_GetIDs('locationDependent',Operations,'ops','Keywords');
        spreadIDs = TS_GetIDs('spreadDependent',Operations,'ops','Keywords');
    end
    opIDs = unique([lengthIDs,locIDs,spreadIDs]);
case 'sarab16'
    matchByName = true;
    % Sarab's top 16 features
    featureNames = {'DN_HistogramMode_10', ...
                    'AC_9', ...
                    'first_min_acf', ...
                    'SY_StdNthDer_1', ...
                    'CO_trev_1_num', ...
                    'CO_Embed2_Basic_tau_incircle_1', ...
                    'CO_Embed2_Basic_tau_incircle_2', ...
                    'SY_SpreadRandomLocal_ac2_100_meantaul', ...
                    'SY_SpreadRandomLocal_50_100_meantaul', ...
                    'PH_Walker_prop_01_sw_propcross', ...
                    'EN_SampEn_5_03_sampen1', ...
                    'FC_LocalSimple_mean1_taures', ...
                    'FC_LocalSimple_lfittau_taures', ...
                    'DN_OutlierInclude_abs_001_mdrmd', ...
                    'SB_MotifTwo_mean_hhh', ...
                    'SC_FluctAnal_2_rsrangefit_50_1_logi_prop_r1'};
case 'catch22'
    matchByName = true;
    % The catch22 feature set (EXCLUDES MEAN/SPREAD-DEPENDENT FEATURES)
    % cf. https://github.com/chlubba/catch22
    featureNames = {'DN_HistogramMode_5', ...
                    'DN_HistogramMode_10', ...
                    {'first1e_acf_tau', 'first_1e_ac'}, ... % (new name)
                    {'firstMin_acf', 'first_min_acf'}, ... % (new name)
                    {'CO_HistogramAMI_even_5_2','CO_HistogramAMI_even_5bin_ami2'}, ... % (new name; CO_HistogramAMI_even_2_5)
                    'CO_trev_1_num', ...
                    'MD_hrv_classic_pnn40', ...
                    'SB_BinaryStats_mean_longstretch1', ...
                    'SB_TransitionMatrix_3ac_sumdiagcov', ...
                    'PD_PeriodicityWang_th0.01', ...
                    'CO_Embed2_Dist_tau_d_expfit_meandiff', ...
                    'IN_AutoMutualInfoStats_40_gaussian_fmmi', ...
                    'FC_LocalSimple_mean1_tauresrat', ...
                    'DN_OutlierInclude_p_001_mdrmd', ...
                    'DN_OutlierInclude_n_001_mdrmd', ...
                    'SP_Summaries_welch_rect_area_5_1', ...
                    'SB_BinaryStats_diff_longstretch0', ...
                    'SB_MotifThree_quantile_hh', ...
                    'SC_FluctAnal_2_rsrangefit_50_1_logi_prop_r1', ...
                    'SC_FluctAnal_2_dfa_50_1_2_logi_prop_r1', ...
                    'SP_Summaries_welch_rect_centroid', ...
                    'FC_LocalSimple_mean3_stderr'};
case 'catchaMouse16'
    matchByName = true;
    featureNames = {'SY_DriftingMean50_min',...
                    'MF_CompareAR_1_10_05_stddiff',...
                    'SC_FluctAnal_2_dfa_50_2_logi_r2_se2',...
                    'IN_AutoMutualInfoStats_diff_20_gaussian_ami8',...
                    'PH_Walker_momentum_5_w_momentumzcross',...
                    'MF_steps_ahead_arma_3_1_6_ac1_6',...
                    {'DN_RemovePoints_absclose_05_ac2rat','DN_RemovePoints_absclose_05_remove_ac2rat'},...
                    'MF_steps_ahead_ar_2_6_maxdiffrms',...
                    'SP_Summaries_fft_fpolysat_rmse',...
                    {'CO_HistogramAMI_even_2_3','CO_HistogramAMI_even_2bin_ami3'},...
                    'AC_nl_036',...
                    'AC_nl_112',...
                    'MF_StateSpace_n4sid_1_05_1_ac2',...
                    'ST_LocalExtrema_n100_diffmaxabsmin',...
                    'CO_TranslateShape_circle_35_pts_statav4_m',...
                    'CO_AddNoise_1_even_10_ami_at_10'};
otherwise
    error('Unknown feature set ''%s''',whatFeatureSet);
end

if matchByName
    isMatch = cellfun(@(x)any(ismember(Operations.Name,x)),featureNames);
    opIDs = Operations.ID(isMatch);
    fprintf(1,'Matched %u/%u features!\n',length(opIDs),length(featureNames));
end

if length(opIDs) < length(featureNames)
    didNotMatch = find(~isMatch);
    for i = 1:length(didNotMatch)
        if iscell(featureNames{didNotMatch(i)})
            theFeatureName = featureNames{didNotMatch(i)}{1};
        else
            theFeatureName = featureNames{didNotMatch(i)};
        end
        fprintf(1,'''%s'' does not exist in this HCTSA dataset\n',theFeatureName);
    end
end

end
