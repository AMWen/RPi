//
//  LEDService.swift
//  Bluetooth
//
//  Created by Van Simmons on 4/21/19.
//

import Foundation
import SmokeHTTP1
import SmokeOperations
import SmokeOperationsHTTP1
import LoggerAPI
import NIOHTTP1
import Dispatch
import SwiftyLinkerKit

struct LEDService: Service {
    typealias InputType = LEDInput
    typealias OutputType = LEDOutput
    
    static let jsonEncoder = JSONEncoder()
    static let jsonDecoder = JSONDecoder()
    static let shield  = LKRBShield.default
    static let smallShield  = LKRBShield.default

    /*
    Question 2 a when the ledState variable changes provide a didSet
    method which will turn the LED on for true or off for false
     */

    static var ledState: Bool = false {
        didSet {
            led.on = ledState ? true : false
        }
    }

    /*
     Question 2 b replace the initialization below with
     an initializing closure which properly creates and LKLed
     and connects it your enclosure at position row 2, col 1
     */

    static let led:LKLed =  {
        let led = LKLed()
        guard let shield  = LKRBShield.default else { return led }
        
        led.shield(shield, connectedTo: .digital2722)
        return led
    }()
    
    static let df: DateFormatter = {
        let d = DateFormatter()
        d.dateFormat = "mmss"
        return d
    }()
    
    // decode the input stream from the request
    static let inputDecoder = { (request: SmokeHTTP1RequestHead, data: Data?) throws -> LEDInput in
        Log.info("Handling LEDService request: \(request)")
        guard let data = data, let decoded = LEDInput(data: data) else {
            Log.error("No request body for request \(request)")
            throw ApplicationContext.allowedErrors[0].0
        }
        return decoded
    }
    
    // transform the input into the output
    typealias LEDResultHandler = (SmokeResult<LEDOutput>) -> Void
    static let transform = { (input: LEDInput, context: ApplicationContext) -> LEDOutput in
        let output = LEDOutput(ledState: input.ledState)
        Log.info("Transforming LEDService Input: \(input)")
        guard let shield = shield else {
            Log.info("Shield or Display note available.  Completing transform")
            return LEDOutput(ledState: "off")
        }
        /*
         Question 2 c provide code here which makes the led follow the command
         sent in across the network
         */
        led.on = input.ledState == "on" ? true : false
        Log.info("Finished Transforming LEDService Input: \(input) to Output: \(output)")
        return output
    }
    
    // encode the output into the response
    static let outputEncoder = { (request: SmokeHTTP1RequestHead, output: LEDOutput, responseHandler: HTTP1ResponseHandler) in
        var body = ( contentType: "application/json", data: Data() )
        var responseCode = HTTPResponseStatus.ok
        if let encoded = output.ledState.data(using: .utf8)  {
            body = ( contentType: "application/json", data: encoded )
        } else {
            responseCode = HTTPResponseStatus.internalServerError
            body = ( contentType: "application/json", data: try! jsonEncoder.encode(["message": "output failure"]) )
        }
        let response = HTTP1ServerResponseComponents(
            additionalHeaders: [],
            body: body
        )
        Log.info("Encoding LEDService Output: \(response)")
        responseHandler.completeInEventLoop(status: responseCode, responseComponents: response)
    }
    
    static let serviceHandler = OperationHandler<ApplicationContext, SmokeHTTP1RequestHead, HTTP1ResponseHandler>(
        inputProvider: LEDService.inputDecoder,
        operation: LEDService.transform,
        outputHandler: LEDService.outputEncoder,
        allowedErrors: ApplicationContext.allowedErrors,
        operationDelegate: ApplicationContext.operationDelegate
    )
}
