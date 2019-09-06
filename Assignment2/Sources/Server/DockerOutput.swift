import Foundation
import SmokeOperations
import NIOHTTP1

public struct DockerOutput: Codable, Validatable {
    /*
     Question 2a: construct a static variable jsonEncoder of type JSONEncoder and intialize it with a default instance
     */
    static var jsonEncoder = JSONEncoder()
    
    public let result: String
    public let code: Int
    
    public init() {
        result = ""
        code = 500
    }
    
    public init(result: String, code: HTTPResponseStatus = .ok) {
        self.result = result
        self.code = Int(code.code)
    }
    
    public func validate() throws { }
    
    public var json: Data {
        /*
         Question 2b: return the DockerOutput properly encoded as JSON in the form of a Data object
         */
        return try! Data(DockerOutput.jsonEncoder.encode(self))
    }
}

extension DockerOutput : Equatable {
    public static func ==(lhs: DockerOutput, rhs: DockerOutput) -> Bool {
        return lhs.result == rhs.result && lhs.code == rhs.code
    }
}

extension DockerOutput: CustomStringConvertible {
    public var description: String { return "DockerOutput(result: \"\(result)\"), code = \(code)" }
}
