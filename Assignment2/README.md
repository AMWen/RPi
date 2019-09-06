 
# Assignment 2
 
 The intent of this homework set is to:
 
 1. make sure that you can correctly use important concepts from Swift
 1. have a base set of code from which we can build our future bluetooth and GPIO servers.
 
 This code will be incorporated into your final project, so it is very important that we get it right.  To the extent possible, I have given you a template for all the neccesary code here and have only asked you to fill in the details. You are being asked to  demonstrate that you understand the meaning of those details

 To complete this assignment, you need to have a basic understanding of the following Swift concepts:

 * Type Aliases
 * Base operations, in particular the ternary operator
 * Base data types, in particular Int and Tuple
 * Arrays 
 * Basic control flow including: if, guard and switch
 * Why and when we avoid the use of "for" as a control flow mechanism and use functional constructs instead
 * The Swift types: enum, struct and class and their syntax, differences and similarities
 * Properties of enums, structs and classes
 * Functions and in particular higher order functions which take closures as arguments
 * Closures and in particular the trailing closure syntax
 * How to read the signature and therefore the type of a func or closure
 * Parameterized types (aka Generics) and their uses
 * Optional types and why they are genericized enums
 * The if-let and guard-let constructs

 It sounds like a lot I know, but these are parts of the language that you will use every day if programming professionally.  There's just no getting around them.
 
 **ALL** answers are to be given in line.  Please do not erase the formatted   comments as we will
 be grading by reading through this project. 
 
 You should make changes to this file **ONLY**
 in the places specified by the comments.  Put your code and or comments ONLY in
 those places!  Where the instructions specify a limit on the length of your answers, please be aware that we are serious about this.  Swift is built to facilitate concise coding style.
 This homework set has been created to teach you this style.
 
 As you work through this assignment you should reference the learn-swift workspace which has been provided in the course materials repository.
 
 You are **strongly** advised to work the problems in order.  And as you progress to make sure that
 the code stays in a state where it compiles and runs.  An excellent practice to get into  is to do frequent commits of your work so that you don't lose it and can roll back to previous   versions if you make a mistake.  Xcode will help you with this.
 
## Overall requirements:

 1. Your submitted project must have zero errors and zero warnings
 1. It must successfully run to completion, generating a 200 status code and a output message indicating that you successfully pulled a docker repo.
 1. You MUST do the work yourself, do not talk together on this one, any questions should be addressed to the discussion boards so that everyone may see them and the instructors may determine if they are appropriate
 
 The reason for these requirements are that if you do not understand how to use Swift at this level you will not 
 be able to do the other assignments.  It is VITAL that we get you the help you need if you are  having difficulties.

Before beginning, please install the [ARM64 Swift cross-compiler](https://github.com/CSCIX65G/SwiftCrossCompilers/releases/download/5.0/Swift-arm64-5.0.pkg)  on your Mac. We will use this in the next assignment. Also make sure that you have docker installed on your Mac.    
Then do: `swift build -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.13"` and `swift run -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.13"` in the Assignment 2 directory on your Mac.  

From another window do the following:

```
curl -X "POST" "http://localhost:8080/echo" -H 'Content-Type: application/json; charset=utf-8' -d $'{ "container": "busybox", "registry": "index.docker.io" }'
```

You should receive:

```
{ "container": "busybox", "registry": "index.docker.io" }
```
This proves you have compile working.

Go into the working copy and answer the questions as assigned. Working code will be graded as follows:

**Question 1 (40 points total):** Perform all actions as directed in the file Sources/DockerService/DockerInput.swift. Part a: 5 points, b: 5 points, c: 10 points,  d: 10 points, e: 5 points, f: 5 points

**Question 2 (10 points total):** Perform all actions as directed in the file Sources/DockerService/DockerOutput.swift. Part a: 5 points, b: 5 points

**Question 3 (50 points total):** Perform all actions as directed in the file Sources/Server/DockerService.swift. Part a: 5 points, b: 5 points, c: 5 points, d: 10 points, e: 5 points, f: 5 points, g: 5 points, h: 5 points, i: 5 points 

**Question 4 (10 points bonus):** Perform all actions as directed in the file Sources/Server/main.swift. Part a: 5 points, b: 5 points, 

 To test your work, run the following command:

```
curl -X "POST" "http://localhost:8080/docker" -H 'Content-Type: application/json; charset=utf-8' -d $'{ "container": "busybox", "registry": "index.docker.io" }'
```

You should receive a response like this:

```
{"result":"Using default tag: latest\nlatest: Pulling from library\/busybox\nDigest: sha256:061ca9704a714ee3e8b80523ec720c64f6209ad3f97c0ff7cb9ec7d19f15149f\nStatus: Image is up to date for busybox:latest\n","code":200}
```

Non-working code will produce a maximum of 75 points overall to be scored subjectively.
