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
    
    public func parseLaunchRequest() -> LaunchRequest? {
        guard let jsonEnvelope = json as? [String: Any],
            let jsonRequest = jsonEnvelope["request"] as? [String: Any],
            let request = RequestParser.parseRequest(jsonRequest) else {
                return nil
        }
        
        return LaunchRequest(request: request)
    }
    
    public func parseIntentRequest() -> IntentRequest? {
        guard let jsonEnvelope = json as? [String: Any],
            let jsonRequest = jsonEnvelope["request"] as? [String: Any],
            let request = RequestParser.parseRequest(jsonRequest),
            let intent = RequestParser.parseIntent(jsonRequest) else {
                return nil
        }
        
        return IntentRequest(request: request, intent: intent)
    }
    
    public func parseSessionEndedRequest() -> SessionEndedRequest? {
        guard let jsonEnvelope = json as? [String: Any],
            let jsonRequest = jsonEnvelope["request"] as? [String: Any],
            let request = RequestParser.parseRequest(jsonRequest),
            let reason = RequestParser.parseReason(jsonRequest) else {
                return nil
        }
        
        return SessionEndedRequest(request: request, reason: reason)
    }
}

extension RequestParser {
    class func parseDate(_ string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        return dateFormatter.date(from: string)
    }
    
    class func parseRequest(_ jsonRequest: [String: Any]) -> Request? {
        guard let requestId = jsonRequest["requestId"] as? String,
            let timestampString = jsonRequest["timestamp"] as? String,
            let timestamp = RequestParser.parseDate(timestampString),
            let localeString = jsonRequest["locale"] as? String else {
                return nil
        }
        
        return Request(requestId: requestId, timestamp: timestamp, locale: Locale(identifier: localeString))
    }
    
    class func parseSlots(_ jsonSlots: [String: Any]) -> [String: Slot] {
        var slots = [String: Slot]()
        for (key, json) in jsonSlots {
            guard let jsonSlot = json as? [String: Any],
                let name = jsonSlot["name"] as? String else {
                    continue
            }
            
            let value = jsonSlot["value"] as? String
            slots[key] = Slot(name: name, value: value)
        }

        return slots
    }
    
    class func parseIntent(_ jsonRequest: [String: Any]) -> Intent? {
        guard let jsonIntent = jsonRequest["intent"] as? [String: Any],
            let name = jsonIntent["name"] as? String,
            let jsonSlots = jsonIntent["slots"] as? [String: Any] else {
                return nil
        }
        
        let slots = RequestParser.parseSlots(jsonSlots)
        return Intent(name: name, slots: slots)
    }
    
    class func parseReason(_ jsonRequest: [String: Any]) -> Reason? {
        guard let reason = jsonRequest["reason"] as? String else {
            return nil
        }
        
        switch reason {
        case "USER_INITIATED": return .userInitiated
        case "ERROR": return RequestParser.parseError(jsonRequest).map{ .error($0) }
        case "EXCEEDED_MAX_REPROMPTS": return .exceededMaxReprompts
        default: return nil
        }
    }
    
    class func parseError(_ jsonRequest: [String: Any]) -> Error? {
        guard let jsonError = jsonRequest["error"] as? [String: Any],
            let type = RequestParser.parseErrorType(jsonError),
            let message = jsonError["message"] as? String else {
                return nil
        }
        
        return Error(type: type, message: message)
    }
    
    class func parseErrorType(_ jsonError: [String: Any]) -> ErrorType? {
        guard let type = jsonError["type"] as? String else {
            return nil
        }
        
        switch type {
        case "INVALID_RESPONSE": return .invalidResponse
        case "DEVICE_COMMUNICATION_ERROR": return .deviceCommunicationError
        case "INTERNAL_ERROR": return .internalError
        default: return nil
        }
    }
}
