import Foundation

public struct LaunchRequest {
    public var request: Request
}

public struct Request {
    public var requestId: String
    public var timestamp: Date
    public var locale: String
}

public struct IntentRequest {
    public var request: Request
    public var intent: Intent
}

public struct Intent {
    public var name: String
    public var slots: [String: Slot]
}

public struct Slot {
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
