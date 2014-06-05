This simple VisualStudio 2013 project shows how to configure a VisualStudio 2013 project for the usage of the qtvsexpress tools

Before you can compile this sample, you have to setup the path to your Qt-directory. 
Open the property manager - qtvsexpress property sheet - User macros and change the QTDIR variable

Now you should be able to compile and run the sample.

If you are, everything is setup so you can use the QtCreate.ps1 script to add a new dialog.

I already prepared some lines of code that are currently commented out. If you follow the following instructions, 
afterwards you can just use these lines to show the new dialog:
- Open powershell and change current directory to >this< directory (the directory where this Readme.txt and the QtVsExpressSample.vcxproj is located)
- Enter './QtCreate -dialogname ExpressDialog'
- That's everything, your dialog should now be included in your project and can be compiled

To use the dialog open MainWnd.cpp and uncomment the commented lines of code. 

Run the project and press the button!

Lukas Haselsteiner, 2014