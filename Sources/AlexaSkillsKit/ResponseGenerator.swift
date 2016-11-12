import Foundation

public protocol ResponseGenerator: class {
    var standardResponse: StandardResponse? {get set}
    var sessionAttributes: [String: Any] {get set}
    
    func update(standardResponse: StandardResponse?, sessionAttributes: [String: Any])
    
    func generateJSONObject() -> [String: Any]
    func generateJSON(options: JSONSerialization.WritingOptions) throws -> Data
}

public extension ResponseGenerator {
    public func update(standardResponse: StandardResponse?, sessionAttributes: [String: Any]) {
        self.standardResponse = standardResponse
        self.sessionAttributes = sessionAttributes
    }
    
    public func generateJSON(options: JSONSerialization.WritingOptions = []) throws -> Data {
        let data = try JSONSerialization.data(withJSONObject: generateJSONObject(), options: options)
        
        // JSONSerialization bug with Bools: https://bugs.swift.org/browse/SR-3013
        var dataString = String(data: data, encoding: .utf8)
        if options.contains(.prettyPrinted) {
            dataString = dataString?.replacingOccurrences(of: "\"shouldEndSession\": 0", with: "\"shouldEndSession\" : false")
        } else {
            dataString = dataString?.replacingOccurrences(of: "\"shouldEndSession\":0", with: "\"shouldEndSession\":false")
        }
        
        return dataString?.data(using: .utf8) ?? data
    }
}
