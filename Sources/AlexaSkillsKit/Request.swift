import Foundation

public struct LaunchRequest: Equatable {
    public var request: Request
    
    public init(request: Request) {
        self.request = request
    }
    
    public static func ==(lhs: LaunchRequest, rhs: LaunchRequest) -> Bool {
        return lhs.request == rhs.request
    }
}

public struct Request: Equatable {
    public var requestId: String
    public var timestamp: Date
    public var locale: Locale
    
    public init(requestId: String, timestamp: Date, locale: Locale) {
        self.requestId = requestId
        self.timestamp = timestamp
        self.locale = locale
    }
    
    public static func ==(lhs: Request, rhs: Request) -> Bool {
        return lhs.requestId == rhs.requestId && lhs.timestamp == rhs.timestamp && lhs.locale == rhs.locale
    }
}

public struct IntentRequest: Equatable {
    public var request: Request
    public var intent: Intent
    
    public init(request: Request, intent: Intent) {
        self.request = request
        self.intent = intent
    }
    
    public static func ==(lhs: IntentRequest, rhs: IntentRequest) -> Bool {
        return lhs.request == rhs.request && lhs.intent == rhs.intent
    }
}

public struct Intent: Equatable {
    public var name: String
    public var slots: [String: Slot]
    
    public init(name: String, slots: [String: Slot]) {
        self.name = name
        self.slots = slots
    }
    
    public static func ==(lhs: Intent, rhs: Intent) -> Bool {
        return lhs.name == rhs.name && lhs.slots == rhs.slots
    }
}

public struct Slot: Equatable {
    public var name: String
    public var value: String?

    public init(name: String, value: String? = nil) {
        self.name = name
        self.value = value
    }
    
    public static func ==(lhs: Slot, rhs: Slot) -> Bool {
        return lhs.name == rhs.name && lhs.value == rhs.value
    }
}

public struct SessionEndedRequest: Equatable {
    public var request: Request
    public var reason: Reason
    
    public init(request: Request, reason: Reason) {
        self.request = request
        self.reason = reason
    }
    
    public static func ==(lhs: SessionEndedRequest, rhs: SessionEndedRequest) -> Bool {
        return lhs.request == rhs.request && lhs.reason == rhs.reason
    }
}

public enum Reason: Equatable {
    case unknown
    case userInitiated
    case error(Error)
    case exceededMaxReprompts
    
    public static func ==(lhs: Reason, rhs: Reason) -> Bool {
        switch (lhs, rhs) {
        case (.userInitiated, .userInitiated): return true
        case (.error(let errorLhs), .error(let errorRhs)) where errorLhs == errorRhs: return true
        case (.exceededMaxReprompts, .exceededMaxReprompts): return true
        default: return false
        }
    }
}

public struct Error: Equatable {
    public var type: ErrorType
    public var message: String
    
    public init(type: ErrorType, message: String) {
        self.type = type
        self.message = message
    }
    
    public static func ==(lhs: Error, rhs: Error) -> Bool {
        return lhs.type == rhs.type && lhs.message == rhs.message
    }
}

public enum ErrorType {
    case unknown
    case invalidResponse
    case deviceCommunicationError
    case internalError
}
