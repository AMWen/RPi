
# Assignment 3

The intent of this homework set is to make sure that you can correctly implement a BLE server on the Pi and a BLE client on the Mac. And talk between them.

1. have a base set of code from which we can build our future bluetooth and GPIO servers.

As usual:

1. this code will be incorporated into your final project, 
2. **ALL** answers are to be given in line. Please do not erase the formatted comments as we will be grading by reading through this project. Make changes to this files specified ONLY in the places specified by the comments. Put your code and or comments ONLY in those places! 

## Overall requirements:

1. Your submitted project must have zero errors and zero warnings
2. It must when run on Pi, produce output as shown on the instructor's Mac.
3. You MUST do the work yourself, do not talk together on this one, any questions should be addressed to the discussion boards so that everyone may see them and the instructors may determine if they are appropriate

Before beginning, please make sure that you updated and synced assignments repo on both your Mac and your R/Pi.

Then do `swift build --destination /Library/Developer/Destinations/arm64-5.0-RELEASE.json` in the Assignment 3 directory on both.  Additionally execute the following command:

```
docker run --restart unless-stopped --detach --name swift-runtime cscix65g/swift-runtime:arm64-latest
```

If you have not already done so, you will want to install LightBlue Explorer on your phone for testing https://itunes.apple.com/us/app/lightblue-explorer/id557428110?mt=8

Working code will be graded as follows:

  * Question 1 (50 points total):  In the locations shown in CustomService.swift answer the questions.  10 points each
  * Question 2 (10 points total): In the location shown in BLEServer.swift answer Question 2
  * Question 3 (20 points total): In the locations show in BLEServer.swift answer Question 3
  * Question 4 (20 points): Using the techniques shown in class, construct a docker image and run it on your Raspberry Pi.  Create a file in your Assignment 3 folder called Output.txt and place your docker file output to demonstrate that you have done so.


Non working code will produce a maximum of 75 points overall to be scored subjectively. 
