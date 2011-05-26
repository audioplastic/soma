Quick start guide to SOMA
=========================

This is a quick start guide to using the SOMA package. It really is very, very quick indeed! The best way to appreciate some of the novelty of SOMA is to jump straight in at the deep end, start poking and prodding parameters and then see what comes out. Later on we can disect the model to better understand what each stage is doing.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



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

![Workspace](/docs/images/Workspace.png)

Typing x into the command window without a semicolon will show all of the properties of the object...
