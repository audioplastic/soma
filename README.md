SOMA
=====

**[S]**IMPLE

**[O]**BJECT-ORIENTED

**[M]**ODEL OF

**[A]**UDITION


- - - - - - - - - - - - - - - - - 

This document is written in [markdown] syntax.

![screenshot](https://github.com/audioplastic/soma/raw/master/docs/images/main_shot.png)


Simple
------

This Matlab model is designed to be incredibly simple in terms of both its functionality and code base. It allows the user to coarsely simulate the information transmitted along the auditory nerve to the brain in response to a given stimulus. However, this simplicity is not necessarily a handicap as it allows the model to be exceptionally fast.

 - Fast in terms of a shallow learning curve. You will be able to get the model up and running in no time. 

 - Fast in that model parameters can be changed and the model will recalculate its other parameters automagically to re formulate a new auditory nerve firing rate probability.

 - Fast in terms of execution speed. Simple processing means that huge batch jobs can be completed in very little time.

The simplicity of this model makes it suitable to be used as an educational tool, or as a stepping stone to the more advanced and more functionally and physiologically accurate auditory models published on the [soundsoftware] website.




Object-oriented
---------------

The user needs absolutely no experience in object oriented programming to use this model. This model will happily sit and work inside functional matlab script. This model started life as an experiment to try out some of the revamped object-oriented functionality built into Matlab since version 2008a. Because of this, it is not compatible with previous versions. 

The model is basically a very smart data structure. The user puts the input stimulus into one of the fields of the structure and data automatically becomes available in other fields of the structure that represent the stimulus information at various stages on its journey along the auditory periphery. If, for example, an outer-middle ear parameter is changed by the user, the effects of this change ripple along the processing chain so that all subsequent representations are updated to account for this change. The data structure understands what it needs to do in order to update itself appropriately and the user does not need to "re run" the model as they would if the model were implemented based on a functional programming paradigm. To jump straight in, please see the quick start guide.

This self updating behaviour is achieved by cunning use of "Dependent" variables. The source code is available in the "+SOMA" package directory.




Model of audition
-----------------

The SOMA model simulates the auditory periphery as a hierarchy of four discrete modules. 

 - At the base level there is the stimulus module. Given an input stimulus input as a column vector time series along with a sample rate, this module is aware of the length of the stimulus, a time axis, and other statistics about the time series.

 - Next, there is an outer-middle ear module that simulates this part of the periphery as a broad band-pass filter.

 - Cochlear frequency decomposition occurs next. This is simulated by a bank of gammatone filters.

 - The final stage is a crude inner hair cell model simulating mechanical to neural transduction. This is achieved by half-wave rectification and low pass filtering of the signal within each cochlear frequency band. The signal is also passed through a compressive non-linearity at this stage to simulate the lumped compressive action of the cochlear filtering and neural transduction in one hit.

For a more detailed description of the function of each of the stages in the auditory periphery, please refer to the documentation available in the more established auditory models over at [soundsoftware]. Otherwise, please take a moment to view the quick start guide.


[soundsoftware]:http://code.soundsoftware.ac.uk/projects/auditory-models

[markdown]: http://softwaremaniacs.org/playground/showdown-highlight/






Quick start guide to SOMA
=========================

This is a quick start guide to using the SOMA package. It really is very, very quick indeed! The best way to appreciate some of the novelty of SOMA is to jump straight in at the deep end, start poking and prodding parameters and then see what comes out. Later on we can disect the model to better understand what each stage is doing.





Make the SOMA package available to Matlab
-----------------------------------------

The first essential step is to make sure the soma package (the folder named +SOMA) is on the Matlab path. If you have just downloaded SOMA and would like to work through the demo script, then just set your present working directory to the directory containing SOMA_demo.m. This folder contains the "+SOMA" package directory. To get more serious work done with SOMA after you have got the hang of it, you can either...
 
 - Copy the +SOMA package directory into the working directories of your future projects every time you start a new project.
 - Add the +SOMA package directory to your malab path.




How this guide works
--------------------

Open up the SOMA_demo.m script in the Matlab editor. This script is arranged as a series of cells bounded by '%%' syntax. Each of these cells can be executed individually as you work through this quick start guide. To execute the code within a cell, place the cursor in that cell and hit ctrl+return. 

Alternatively, you can completely ignore SOMA_demo.m and just paste the commands listed in this document directly into the command window



Import the SOMA package
-----------------------

Before a SOMA object can be created, the package must be imported first. Python and Java programmers will spot the similarity here. To do this issue the command... 

    import soma.*

If all goes well then nothing will happen. To see the list of currently imported packages issue the command...

    import

This should display the following result

    >> import

    ans = 

        'soma.*'

Create an inner haircell process object
---------------------------------------

This is where we jump in at the deep end. The inner haircell process (ihcProc) inherits all of the functionality of the gammatone filtering process (gtfProc) which in turn inherits all of the functionality of the outer/middle ear process (omeProc) which in turn inherrits all of the functionality of the stimulus definition process (sigProc). Assign the varable x to an instance of the ihcProc class using the following command.

    x = ihcProc;

Doing this will create an object named x of type soma.ihcProc in the workspace.

![Workspace](https://github.com/audioplastic/soma/raw/master/docs/images/Workspace.png)

Typing x into the command window without a semicolon will show all of the properties of the object...

    x = 
    
      soma.ihcProc
      Package: soma
    
      Properties:
        ihc_cmpType: 'log'
        ihc_fCut: 1200
        ihc_fOrd: 2
        darkTheme: 1
        ihc: [2500x30 double]
        ihc_RMSc: [1x30 double]
        ihc_RMSt: [2500x1 double]
        bmm_fMin: 200
        bmm_fMax: 6000
        bmm_nChans: 30
        cf: [1x30 double]
        bmm: [2500x30 double]
        bmm_RMSc: [1x30 double]
        bmm_RMSt: [2500x1 double]
        ome_fLoCut: 450
        ome_fHiCut: 8000
        ome_fOrd: 2
        ome: [2500x1 double]
        sr: 25000
        sig: [2500x1 double]
        tAxis: [1x2500 double]
        nSamp: 2500
        dur: 0.1000

The stimulus related properties include...
 
 - sr = Sample rate of the stimulus
 - nSamp = The number of samples in the stimulus time series
 - dur = The stimulus duration
 - sig = the actual time series data

When the object is first created,the default signal is a brief click train. This can be visualised easily by doing a stem plot...

    stem(x.tAxis*1000, x.sig); xlabel('Time in ms'); ylim([0 1.2])

![clicks](https://github.com/audioplastic/soma/raw/master/docs/images/clicks.PNG)

If the stimulus is extended, by adding trailing zeros for example ...

    x.sig = [x.sig; zeros(100,1)]

..then some of the novelty of this model begins to shine through. On re-inspection of the stimulus related properties,it is now evident that the object is automatically updating its properties to accommodate the user specified change. Just looking at the stimulus related properties, the time axis has increased in length, the 'nSamp' parameter is now 2600, and the 'dur' parameter now reflects the new duration of 0.104 seconds (all properties are specified in SI units).

            sig: [2600x1 double]
          tAxis: [1x2600 double]
          nSamp: 2600
            dur: 0.1040

Return the signal back to its original size and the other parameters will follow.

   x.sig = x.sig(1:2500);

To view a summary of the auditory nerve information in response to a stimulus, the object has a built in 'see' method that can be invoked by typing either 

    x.see

or 

    see(x)


![clicksD](https://github.com/audioplastic/soma/raw/master/docs/images/clicks30d.PNG)

Those preferring the more sedate standard Matlab colour scheme can revert to it simply by switching the 'darkTheme' property to zero or false.

    close all
    x.darkTheme = false;
    x.see

![clicksL](https://github.com/audioplastic/soma/raw/master/docs/images/clicks30l.PNG)




