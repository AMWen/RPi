import Foundation
import SmokeHTTP1
import SmokeOperationsHTTP1
import NIOHTTP1
import HeliumLogger
import LoggerAPI
#if os(Linux)
import Shell
#endif

typealias SmokeHandlerSelector = StandardSmokeHTTP1HandlerSelector
typealias JSONDelegate = JSONPayloadHTTP1OperationDelegate
typealias HandlerSelector = StandardSmokeHTTP1HandlerSelector<ApplicationContext, JSONPayloadHTTP1OperationDelegate>

let logger = HeliumLogger()
Log.logger = logger

let services = [
    (path: "/echo", method: HTTPMethod.POST, handler: EchoService.self.serviceHandler),
    (path: "/ble", method: HTTPMethod.POST, handler: BluetoothService.self.serviceHandler)
]

func createHandlerSelector() -> HandlerSelector {
    var handlerSelector = HandlerSelector(
        defaultOperationDelegate: ApplicationContext.operationDelegate
    )
    services.forEach { service in
        handlerSelector.addHandlerForUri(service.path, httpMethod: service.method, handler: service.handler)
    }
    return handlerSelector
}

do {
    Log.info("Starting Server")
    #if os(Linux)
    Log.info("Verifying shell availability.  Hostname = \(shell.hostname())")
    #endif
    
    let handlerSelector = createHandlerSelector()
    let server = try SmokeHTTP1Server.startAsOperationServer(
        withHandlerSelector: handlerSelector,
        andContext: ApplicationContext()
    )
    try server.waitUntilShutdownAndThen {
        Log.info("shutdown server = \(server)")
    }
    Log.info("started server = \(server)")
} catch {
    Log.error("Unable to start Operation Server: '\(error)'")
}
