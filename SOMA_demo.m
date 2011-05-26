%% soma_demo.m
% This is the demonstration script that accompanies the markdown document
% that can be found in /docs/quickstart.md
%
% Please use this script while reading the aforementioned document.
% Execute each cell by placing the cursor within the cell and hitting
% ctrl+return (or cmd+return for mac users)


%% import the soma package
import soma.*

%% make the variable 'x' an inner hair cell process
x = ihcProc;

%% see the output of the model
x.see;

%% ramp up the channel density and redisplay the output
x.bmm_nChans = 256;
x.see;
