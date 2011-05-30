SOMA for Matlab
===============

**[S]**IMPLE

**[O]**BJECT-ORIENTED

**[M]**ODEL OF

**[A]**UDITION


- - - - - - - - - - - - - - - - - 

This document is written in [markdown] syntax. If you have downloaded SOMA, and are reading this document in a plain text format, then you will not be able to see screenshots and code highlighting. For the best user experience, follow the link to the project homepage at [github] and scroll down.

![screenshot](https://github.com/audioplastic/soma/raw/master/docs/images/main_shot.png)


Simple
------

This Matlab model is designed to be incredibly simple in terms of both its functionality and code base. It allows the user to coarsely simulate the information transmitted along the auditory nerve to the brain in response to a given stimulus. However, this simplicity is not necessarily a handicap as it allows the model to be exceptionally fast.

 - Fast in terms of a shallow learning curve. You will be able to get the model up and running in no time. 

 - Fast in that model parameters can be changed and the model will recalculate its other parameters automagically to re formulate a new auditory nerve firing rate probability.

 - Fast in terms of execution speed. Simple processing means that huge batch jobs can be completed in very little time.

The simplicity of this model makes it suitable to be used as an educational tool, or as a stepping stone to the more advanced and more functionally and physiologically accurate auditory models published on the [soundsoftware] website.

In signal processing terms, there is nothing novel about this model. In many places, code has been canabalised from the more established auditory models. The novelty of this model lies in its implementation. Advanced Matlab functionality is used behind the scenes to give a slick end-user experience.



Object-oriented
---------------

The user needs absolutely no experience in object oriented programming to use this model. This model will happily sit and work inside functional Matlab script. This model started life as an experiment to try out some of the revamped object-oriented functionality built into Matlab since version 2008a. Because of this, it is not compatible with previous versions released before 2008. 

The model is basically a very smart data structure. The user puts the input stimulus into one of the fields of the structure and data automatically becomes available in other fields of the structure that represent the stimulus information at various stages on its journey along the auditory periphery. If, for example, an outer-middle ear parameter is changed by the user, the effects of this change ripple along the processing chain so that all subsequent representations are updated to account for this change. The data structure understands what it needs to do in order to update itself appropriately and the user does not need to "re run" the model as they would if the model were implemented based on a functional programming paradigm.

This self updating behavior is achieved by using "Dependent" variables and event driven programming. Calculations are only performed when and where necessary to keep the model responsive. 

The source code is available in the "+SOMA" package directory. I do not update the source of this project very often, but now and then I want to test out some of Matlab's object-oriented features and use SOMA to showcase/dry-run them. If you wish to contribute to the SOMA project, then fork the repository at [github] and send me a "pull" request.




Model of audition
-----------------

The SOMA model simulates the auditory periphery as a hierarchy of four discrete modules. 

 - At the base level there is the stimulus module. Given an input stimulus input as a column vector time series along with a sample rate, this module is aware of the length of the stimulus, a time axis, and other statistics about the time series.

 - Next, there is an outer-middle ear module that simulates this part of the periphery as a broad band-pass filter.

 - Cochlear frequency decomposition occurs next. This is simulated by a bank of gammatone filters.

 - The final stage is a crude inner hair cell model simulating mechanical to neural transduction. This is achieved by half-wave rectification and low pass filtering of the signal within each cochlear frequency band. The signal is also passed through a compressive non-linearity at this stage to simulate the lumped compressive action of the cochlear filtering and neural transduction in one hit.

I may update the project to use more advanced modules if any interest is shown in the project. This could include the option of having non-linear filterbanks or more advanced haircell models etc.

For a more detailed description of the function of each of the stages in the auditory periphery, please refer to the documentation available in the more established auditory models over at [soundsoftware]. 

Please take a moment to view the quick start guide below.


[soundsoftware]:http://code.soundsoftware.ac.uk/projects/auditory-models

[markdown]: http://softwaremaniacs.org/playground/showdown-highlight/

[github]:
https://github.com/audioplastic/soma






Quick start guide to SOMA
=========================

This is a quick start guide to using the SOMA package. It really is very, very quick indeed! The best way to appreciate some of the novelty of SOMA is to jump straight in at the deep end, start poking and prodding parameters and then see what comes out. Later on we can dissect the model to better understand what each stage is doing.





Make the SOMA package available to Matlab
-----------------------------------------

The first essential step is to make sure the soma package (the folder named +SOMA) is on the Matlab path. If you have just downloaded SOMA and would like to work through the demo script, then just set your present working directory to the directory containing SOMA_demo.m. This folder contains the "+SOMA" package directory. To get more serious work done with SOMA after you have got the hang of it, you can either...
 
 - Copy the +SOMA package directory into the working directories of your future projects every time you start a new project.
 - Add the +SOMA package directory to your Matlab path.




How this guide works
--------------------

Commands are listed in this readme along with screenshots of the results that they will produce. Just type or paste the commands directly into the command window if you want to follow along.

There are also a couple of demo scripts included with the package that demonstrate a typical work flow. Take some time to open, modify and run these scripts after reading the quick guide.



Import the SOMA package
-----------------------

Before a SOMA object can be created, the package must be imported first. Python and Java programmers will spot the similarity here. To do this issue the command... 

    import soma.*

If all goes well then no errors will be shown. To see the list of currently imported packages issue the command...

    import

This should display the following result

    >> import

    ans = 

        'soma.*'

Create an inner haircell process object
---------------------------------------

This is where we jump in at the deep end. The inner haircell process (ihcProc) inherits all of the functionality of the gammatone filtering process (gtfProc) which in turn inherits all of the functionality of the outer/middle ear process (omeProc) which in turn inherits all of the functionality of the stimulus definition process (sigProc). Assign the variable x to an instance of the ihcProc class using the following command.

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
        ...and many more

The stimulus related properties include...
 
 - sr = Sample rate of the stimulus
 - nSamp = The number of samples in the stimulus time series
 - dur = The stimulus duration
 - sig = the actual time series data

When the object is first created,the default signal is a brief click train. This can be visualized easily by doing a stem plot...

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

You will notice that some of the other properties also change size (and values contained) when the stimulus is modified. These other properties represent the signal at various stages along the auditory periphery. Properties prefixed by 'ome' are associated with outer middle ear processing. Properties prefixed by 'bmm' are associated with basilar membrane motion processing. Properties prefixed by 'ihc' are associated with inner-haircell mechanical-to-neural processing.

You can view the contents of any property, plot it, copy the value to another variable, or do pretty much any standard Matlab operation on the properties. However, some of the properties cannot be set directly by the user. These are the "Dependent" properties that contain values that are calculated by the model whenever they are requested by the user. These are generally properties that represent data generated by the model processing, such as the basilar membrane motion (bmm) or IHC firing probability (ihc) among others.

The best way to find the settable properties it to poke around trying to change things. If you try to set a Dependent property, then you'll be greeted with an error. Change various properties and see how other properties are automatically updated.

Currently, the model does not simulate any efferent processing and so the effects of parameter changes are all feed-forward. For example, if you change an ihc property, then the stapes velocity will not change, because no acoustic reflex feedback loop is implemented (Prof. Meddis' [MAP] model does contain this kind of advanced feedback simulation). Pretty much any parameter change will effect the ihc property as it is at the end of the chain.


More than just a plot routine: nerveView
========================================

The output of the final stage of the model can easily be viewed using one of any of Matlab's built in visualisation functions. For example ...

    pcolor(x.ihc'); 
    shading interp;

![pcolor](https://github.com/audioplastic/soma/raw/master/docs/images/pcolor.PNG)

However, the output is a little bland and uninformative. Furthermore, if you change one of the model's parameters, then this plot will not update itself. The ethos of SOMA is to update everything automatically, removing the burden of manual housekeeping tasks from the user. The nerveView class was designed to address this need.

The nerveView object sits separately on the workspace from the SOMA model, keeping watch over the state of the SOMA model and updating it's graphical properties whenever it detects a change. A nerve view object is created by giving it the handle of the SOMA object to watch as its argument.

    y = nerveView(x);

![clicksD](https://github.com/audioplastic/soma/raw/master/docs/images/clicks30d.PNG)

The large panel shows the firing rate probability in each channel over time. The right hand shows the excitation pattern integrated across the stimulus duration. The bottom pattern shows the firing probability integrated across channels, and is useful to see the ringing incurred by the filtering process.

Those preferring the more sedate standard Matlab colour scheme can switch the 'darkTheme' property of the nerveView object to zero or false.

    y.darkTheme = false;


![clicksL](https://github.com/audioplastic/soma/raw/master/docs/images/clicks30l.PNG)

The best way to learn SOMA from here is to go wild changing all manner of parameters and seeing their effects automatically updated in the nerveView figure. Docking the nerveView window stops it getting in the way as parameters are changed. For example, the compression could be disabled, the number of channels could be increased and their frequency bounds changed (note: SOMA spaces channels on the ERBn scale by default), and the phase locking limit of the inner haircells could be dramatically decreased to produce the following image. HAVE FUN!

    >> x.ihc_cmpType = 'none';
    ihc_cmpType change detected. Redrawing.
    >> x.bmm_fMax = 2000;
    bmm_fMax change detected. Redrawing.
    >> x.bmm_nChans = 128;
    bmm_nChans change detected. Redrawing.
    >> x.ihc_fCut = 250;
    ihc_fCut change detected. Redrawing.

![mashed](https://github.com/audioplastic/soma/raw/master/docs/images/mashed.PNG)

The nerveView class can also serve as a template for other interactive analyses. For example, an autocorrelogram could be implemented in a similarly structured class, allowing rapid and intuitive exploration of parameter changes for pitch research or front ends for automatic speech recognition systems.
