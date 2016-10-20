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
    public var error: Error
}

public enum Reason {
    case userInitiated
    case error
    case exceededMaxReprompts
}

public struct Error {
    public var type: ErrorType
    public var reason: String
}

public enum ErrorType {
    case invalidResponse
    case deviceCommunicationError
    case internalError
}
