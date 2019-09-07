//
//  BluetoothService.swift
//  Server
//
//  Created by Van Simmons on 4/22/19.
//

import Foundation
import SmokeHTTP1
import SmokeOperations
import SmokeOperationsHTTP1
import LoggerAPI
import NIOHTTP1
import Dispatch

struct BluetoothService: Service {
    typealias InputType = BluetoothInput
    typealias OutputType = BluetoothOutput
    
    static let jsonEncoder = JSONEncoder()
    static let jsonDecoder = JSONDecoder()
    #if os(Linux)
    static var peripheral: PeripheralManager?
    
    static var bluetoothState: Bool = false {
        didSet {
            /* Problem 1.1a Stop and Start the BLE Server based on the state of
             of this variable
             */
            do {
                if bluetoothState {
                    print("Trying BLEServer.setup()")
                    peripheral = try BLEServer.setup()
                    try peripheral?.start()
                } else {
                    BLEServer.stop(peripheral: peripheral)
                }
                Log.info("bluetoothState didSet")
            } catch {
                print ("Peripheral failed to start")
            }
        }
    }
    #endif
    
    // decode the input stream from the request
    static let inputDecoder = { (request: SmokeHTTP1RequestHead, data: Data?) throws -> BluetoothInput in
        Log.info("Handling BluetoothService request: \(request)")
        guard let data = data, let decoded = BluetoothInput(data: data) else {
            Log.error("No request body for request \(request)")
            throw ApplicationContext.allowedErrors[0].0
        }
        return decoded
    }
    
    // transform the input into the output
    typealias BluetoothResultHandler = (SmokeResult<BluetoothOutput>) -> Void
    static let transform = { (input: BluetoothInput, context: ApplicationContext) -> BluetoothOutput in
        let output = BluetoothOutput(bluetoothState: input.bluetoothState)
        Log.info("Transforming BluetoothService Input: \(input)")
        /* Problem 3.1b
         start or stop the BLEServer based on the state of the input
         */
        #if os(Linux)
        bluetoothState = input.bluetoothState == "on"
        #endif
        Log.info("Finished Transforming BluetoothService Input: \(input) to Output: \(output)")
        return output
    }
    
    // encode the output into the response
    static let outputEncoder = { (request: SmokeHTTP1RequestHead, output: BluetoothOutput, responseHandler: HTTP1ResponseHandler) in
        var body = ( contentType: "application/json", data: Data() )
        var responseCode = HTTPResponseStatus.ok
        if let encoded = output.bluetoothState.data(using: .utf8)  {
            body = ( contentType: "application/json", data: encoded )
        } else {
            responseCode = HTTPResponseStatus.internalServerError
            body = ( contentType: "application/json", data: try! jsonEncoder.encode(["message": "output failure"]) )
        }
        let response = HTTP1ServerResponseComponents(
            additionalHeaders: [],
            body: body
        )
        Log.info("Encoding BluetoothService Output: \(response)")
        responseHandler.completeInEventLoop(status: responseCode, responseComponents: response)
    }
    
    static let serviceHandler = OperationHandler<ApplicationContext, SmokeHTTP1RequestHead, HTTP1ResponseHandler>(
        inputProvider: BluetoothService.inputDecoder,
        operation: BluetoothService.transform,
        outputHandler: BluetoothService.outputEncoder,
        allowedErrors: ApplicationContext.allowedErrors,
        operationDelegate: ApplicationContext.operationDelegate
    )
}
