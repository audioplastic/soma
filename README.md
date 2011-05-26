SOMA
=====

**[S]**IMPLE

**[O]**BJECT-ORIENTED

**[M]**ODEL OF

**[A]**UDITION


- - - - - - - - - - - - - - - - - 

This document is written in [markdown] syntax.




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

The model is basically a very smart data structure. The user puts the input stimulus into one of the fields of the structure and data automatically becomes available in other fields of the structure that represent the stimulus information at various stages on its journey along the auditory periphery. If, for example, an outer-middle ear parameter is changed by the user, the effects of this change ripple along the processing chain so that all subsequent representations are updated to account for this change. The data structure understands what it needs to do in order to update itself appropriately and the user does not need to "re run" the model as they would if the model were implemented based on a functional programming paradigm. To jump straight in, please see the [quick start guide].

This self updating behaviour is achieved by cunning use of "Dependent" variables. The source code is available in the "+SOMA" package directory.




Model of audition
-----------------

The SOMA model simulates the auditory periphery as a hierarchy of four discrete modules. 

 - At the base level there is the stimulus module. Given an input stimulus input as a column vector time series along with a sample rate, this module is aware of the length of the stimulus, a time axis, and other statistics about the time series.

 - Next, there is an outer-middle ear module that simulates this part of the periphery as a broad band-pass filter.

 - Cochlear frequency decomposition occurs next. This is simulated by a bank of gammatone filters.

 - The final stage is a crude inner hair cell model simulating mechanical to neural transduction. This is achieved by half-wave rectification and low pass filtering of the signal within each cochlear frequency band. The signal is also passed through a compressive non-linearity at this stage to simulate the lumped compressive action of the cochlear filtering and neural transduction in one hit.

For a more detailed description of the function of each of the stages in the auditory periphery, please refer to the documentation available in the more established auditory models over at [soundsoftware]. Otherwise, please take a moment to view the [quick start guide].


[soundsoftware]:http://code.soundsoftware.ac.uk/projects/auditory-models

[quick start guide]: https://github.com/audioplastic/soma/raw/master/docs/quickstart.md

[markdown]: http://softwaremaniacs.org/playground/showdown-highlight/
