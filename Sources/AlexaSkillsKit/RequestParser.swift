//
//  RequestParser.swift
//  AlexaSkillsKit
//
//  Created by Claus Höfele on 13.10.16.
//
//

import Foundation

public enum RequestType {
    case launch
    case intent
    case sessionEnded
}

public class RequestParser {
    public let json: Any
    
    public convenience init(contentsOf url: URL) throws {
        let data = try Data(contentsOf: url)
        try self.init(with: data)
    }
    
    public convenience init(with data: Data) throws {
        let json = try JSONSerialization.jsonObject(with: data)
        self.init(json: json)
    }
    
    public init(json: Any) {
        self.json = json
    }
    
    public func parseRequestType() -> RequestType? {
        guard let jsonEnvelope = json as? [String: Any],
            let jsonRequest = jsonEnvelope["request"] as? [String: Any],
            let type = jsonRequest["type"] as? String else {
            
            return nil
        }
        
        switch type {
        case "LaunchRequest": return .launch
        case "IntentRequest": return .intent
        case "SessionEndedRequest": return .sessionEnded
        default: return nil
        }
    }
}
