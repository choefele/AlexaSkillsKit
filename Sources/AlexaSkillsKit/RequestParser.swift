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
    
    class func dateFromISOString(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        return dateFormatter.date(from: string)
    }
    
    class func parseRequest(_ jsonRequest: [String: Any]) -> Request? {
        guard let requestId = jsonRequest["requestId"] as? String,
            let timestampString = jsonRequest["timestamp"] as? String,
            let timestamp = RequestParser.dateFromISOString(string: timestampString),
            let localeString = jsonRequest["locale"] as? String else {
            return nil
        }
        
        return Request(requestId: requestId, timestamp: timestamp, locale: Locale(identifier: localeString))
    }
    
    public func parseLaunchRequest() -> LaunchRequest? {
        guard let jsonEnvelope = json as? [String: Any],
            let jsonRequest = jsonEnvelope["request"] as? [String: Any],
            let request = RequestParser.parseRequest(jsonRequest) else {
                
            return nil
        }
        
        return LaunchRequest(request: request)
    }
}
