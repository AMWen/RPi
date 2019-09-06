//
//  DockerService.swift
//  Services
//
//  Created by Van Simmons on 2/7/19.
//
import Foundation
import SmokeHTTP1
import SmokeOperations
import SmokeOperationsHTTP1
import LoggerAPI
import NIOHTTP1
import Shell

struct DockerService: Service {
    
    /*
     Question 3a: Construct typealiases which turn DockerInput and DockerOutput into
     InputType and OutputType, respectively
     */
    typealias InputType = DockerInput
    typealias OutputType = DockerOutput
    
    /*
     Question 3b:On the following line, state the type of inputDecoder
     function taking SmokeHTTP1Request and returning DockerInput
     */
    // type(of: inputDecoder)
    static let inputDecoder = { (request: SmokeHTTP1RequestHead, data: Data?) throws -> DockerInput in
        Log.debug("Handling DockerService request: \(request)")
        /*
         Question 3c: Construct a variable named decoded of type DockerInput
         from the request and return it.  You MUST do this using a "guard let" construct
         Failure to construct should throw a generic service failure
         Hint: you want to do much the same thing as is being done in EchoService
         */
        guard let data = data, let decoded = DockerInput(data: data) else {
            Log.error("No request body for request \(request)")
            throw ApplicationContext.allowedErrors[0].0
        }
        
        Log.info("Handling DockerServer request: \(request)")
        return decoded
    }
    
    // transform the input into the output
    typealias DockerResultHandler = (SmokeResult<DockerOutput>) -> Void
    static let transform = { (input: DockerInput, context: ApplicationContext) -> DockerOutput in
        /*
         Question 3d: invoke a "/usr/local/bin/docker pull" command, using the techniques shown in class for executing
         shell commands.  You will want to pass it the registry and container variables from the input. Save
         the return value from the shell comamnd into a variable called result.
         */
        let registryContainer = "\(input.registry)/\(input.container)"
        let result = shell.usr.local.bin.docker("pull", registryContainer)
        
        /*
         Question 3e: construct a variable called resultString which is equal to result.stdout if
         the docker pull finished successfully and equal to "stdout: \(result.stdout)\nstderr: \(result.stderr)"
         if it did not.  You must use the ternary operator for this question
         */
        let resultString = result.isSuccess ? result.stdout : "stdout: \(result.stdout)\nstderr: \(result.stderr)"
        
        /*
         Question 3f: construct a variable called resultCode which is equal to HTTPResponseStatus.ok if
         the docker pull finished successfully and equal to HTTPResponseStatus.internalServerError
         if it did not.  You must use the ternary operator for this question
         */
        let resultCode = result.isSuccess ? HTTPResponseStatus.ok : HTTPResponseStatus.internalServerError
        
        /*
         Question 3g: construct a variable 'output' of type DockerOutput using resultString as the result and
         resultCode as code
         */
        let output = DockerOutput(result: resultString, code: resultCode)
        
        /*
         Question 3h: construct a response object wrapping the DockerOutput you have constructed and send
         it to the responseHandler
         */
        return output
    }
    
    // encode the output into the response
    static let outputEncoder = { (request: SmokeHTTP1RequestHead, output: DockerOutput, responseHandler: HTTP1ResponseHandler) in
        /*
         Question 3i: Complete the request using the DockerOutput which has been passed in,
         in a manner similar to EchoService
         */
        var body = ( contentType: "application/json", data: Data() )
        var responseCode = HTTPResponseStatus.ok
        let encoded = output.json
        body = ( contentType: "application/json", data: encoded )
        
        let response = HTTP1ServerResponseComponents(
            additionalHeaders: [],
            body: body
        )
        Log.info("Encoding DockerService Output: \(response)")
        responseHandler.completeInEventLoop(status: responseCode, responseComponents: response)
    }
    
    static let serviceHandler = OperationHandler<ApplicationContext, SmokeHTTP1RequestHead, HTTP1ResponseHandler>(
        inputProvider: DockerService.inputDecoder,
        operation: DockerService.transform,
        outputHandler: DockerService.outputEncoder,
        allowedErrors: ApplicationContext.allowedErrors,
        operationDelegate: ApplicationContext.operationDelegate
    )
}
