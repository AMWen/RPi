import Foundation
import SmokeHTTP1
import SmokeOperationsHTTP1
import NIOHTTP1
import HeliumLogger
import LoggerAPI
import Shell

typealias SmokeHandlerSelector = StandardSmokeHTTP1HandlerSelector
typealias JSONDelegate = JSONPayloadHTTP1OperationDelegate
typealias HandlerSelector = SmokeHandlerSelector<ApplicationContext, JSONDelegate>

let logger = HeliumLogger()
Log.logger = logger

/*
 Question 4a: add an element to the services array which does for DockerService
 what we do below for EchoService. the path should "/docker" and we should still use
 a POST method
 */

let services = [
    (path: "/echo", method: HTTPMethod.POST, handler: EchoService.self.serviceHandler),
    (path: "/docker", method: HTTPMethod.POST, handler: DockerService.self.serviceHandler)
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

    /*
     Question 4b: Modify the following statement in the location indicated to
     execute the hostname command in a shell
     */
    let hostname = shell.hostname()
    Log.info("Verifying shell availability.  Hostname = \(hostname)")

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
