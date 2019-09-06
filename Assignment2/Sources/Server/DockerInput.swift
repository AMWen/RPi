import Foundation
import SmokeOperations
import Shell

public struct DockerInput: Codable, Validatable {
    /*
     Question 1a: construct a static variable called jsonDecode of type
     JSONDecoder and initialize it to a default decoder
     */
    static var jsonDecode = JSONDecoder()
    
    /*
     Question 1b: Create two immutable public variables:
     registry of type URL
     container of type String
     do not initialize them to default values
     */
    public let registry: URL
    public let container: String
    
    /*
     Question 1c: create an init method for DockerInput which accepts
     two arguments, registry and container and properly initializes
     the DockerInput's variables
     */
    init(registry: URL, container: String) {
        self.registry = registry
        self.container = container
    }
    
    /*
     Question 1d: create a failable initializer method for DockerInput which accepts
     a Data object and IN A GUARD LET STATEMENT attempts to json decode the DockerInput from that.
     If unsuccessful return nil, otherwise set self to the decoded value.
     */
    init?(data: Data) {
        guard let decoded = try? DockerInput.jsonDecode.decode(DockerInput.self, from: data) else { return nil }
        self = decoded
    }
    
    public func validate() throws {
        return
    }
}

extension DockerInput : Equatable {
    public static func ==(lhs: DockerInput, rhs: DockerInput) -> Bool {
        /*
         Question 1e: return the appropriate value of the == operator
         */
        return lhs.registry == rhs.registry && lhs.container == rhs.container
    }
}

extension DockerInput: CustomStringConvertible {
    public var description: String {
        return "DockerInput(registry: \(registry), container: \(container)"
    }
}
