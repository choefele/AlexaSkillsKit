import Foundation

public struct LaunchRequest {
    public var request: Request
}

public struct Request {
    public var requestId: String
    public var timestamp: Date
    public var locale: Locale
}

public struct IntentRequest {
    public var request: Request
    public var intent: Intent
}

public struct Intent {
    public var name: String
    public var slots: [String: Slot]
}

public struct Slot: Equatable {
    public init(name: String, value: String? = nil) {
        self.name = name
        self.value = value
    }
    
    public static func ==(lhs: Slot, rhs: Slot) -> Bool {
        return lhs.name == rhs.name && lhs.value == rhs.value
    }

    public var name: String
    public var value: String?
}

public struct SessionEndedRequest {
    public var request: Request
    public var reason: Reason
}

public enum Reason: Equatable {
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
    
    public static func ==(lhs: Error, rhs: Error) -> Bool {
        return lhs.type == rhs.type && lhs.message == rhs.message
    }
}

public enum ErrorType {
    case invalidResponse
    case deviceCommunicationError
    case internalError
}
