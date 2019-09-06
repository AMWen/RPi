//
//  ApplicationContext.swift
//  Services
//
//  Created by Van Simmons on 2/7/19.
//

import Foundation
import SmokeOperationsHTTP1
import NIOHTTP1

public struct ApplicationContext {
    public static let allowedErrors = [
        (ServiceError.generic(reason: "A Generic Error"), 400),
        (ServiceError.failedPull(reason: "Pull failed.  More information available in the log file"), 500)
    ]

    public static let operationDelegate = JSONPayloadHTTP1OperationDelegate();

    public init() {}
}
