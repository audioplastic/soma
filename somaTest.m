close all; clear all; clc; clear; clear classes

import soma.*
% 
% fprintf(1,['asdasd \n' 'ewfrwerf'])

% fprintf(1,...
% ['/ _\\ ___  _ __ ___   __ _\n' ... 
% '\\ \\ / _ \\| ''_ ` _ \\ / _` |\n' ...
% '_\\ \\ (_) | | | | | | (_| |\n' ...
% '\\__/\\___/|_| |_| |_|\\__,_|'] );

x = ihcProc;
% x.ihc_cmpType = 'none';
% x.ihc_fOrd = 0;
figure; x.see

x.bmm_filterMethod = 'Brown';
figure; x.see

