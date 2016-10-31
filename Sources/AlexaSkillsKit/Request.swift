import Foundation

/// Provides additional context associated with a request that is maintained
/// between request invocations.
///
/// Session attributes will survive individual request invocations if attributes
/// are passed back in the response as `sessionAttributes` (see 
/// `ResponseGenerator`) and the `shouldEndSession` flag is set to `false` (see
/// `StandardResponse`).
///
/// The information in `user` and `application` properties is the same as in the
/// `Context` type.
///
/// - SeeAlso: `StandardResponse.shouldEndSession`, `ResponseGenerator`
public struct Session: Equatable {
    /// A Bool value that indicates whether this session was created from
    /// scratch for this request.
    public var isNew: Bool
    /// Unique identifier for a session.
    public var sessionId: String
    /// Application information.
    public var application: Application
    /// Session attributes.
    public var attributes: [String: Any]
    /// User information.
    public var user: User
    
    /// Creates a new session with initial values.
    ///
    /// - Parameters:
    ///   - isNew: A Bool value that indicates whether this session was created from
    ///            scratch for this request.
    ///   - sessionId: Unique identifier for a session.
    ///   - application: Application information.
    ///   - attributes: Session attributes.
    ///   - user: User information.
    public init(isNew: Bool, sessionId: String, application: Application, attributes: [String: Any], user: User) {
        self.isNew = isNew
        self.sessionId = sessionId
        self.application = application
        self.attributes = attributes
        self.user = user
    }
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Session, rhs: Session) -> Bool {
        return lhs.isNew == rhs.isNew &&
            lhs.sessionId == rhs.sessionId
    }
}

public struct Application: Equatable {
    public var applicationId: String
    
    public init(applicationId: String) {
        self.applicationId = applicationId
    }
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Application, rhs: Application) -> Bool {
        return lhs.applicationId == rhs.applicationId
    }
}

public struct User: Equatable {
    public var userId: String
    public var accessToken: String?
    
    public init(userId: String, accessToken: String? = nil) {
        self.userId = userId
        self.accessToken = accessToken
    }
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.userId == rhs.userId &&
            lhs.accessToken == rhs.accessToken
    }
}

public struct LaunchRequest: Equatable {
    public var request: Request
    
    public init(request: Request) {
        self.request = request
    }
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
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
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Request, rhs: Request) -> Bool {
        return lhs.requestId == rhs.requestId &&
            lhs.timestamp == rhs.timestamp &&
            lhs.locale == rhs.locale
    }
}

public struct IntentRequest: Equatable {
    public var request: Request
    public var intent: Intent
    
    public init(request: Request, intent: Intent) {
        self.request = request
        self.intent = intent
    }
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: IntentRequest, rhs: IntentRequest) -> Bool {
        return lhs.request == rhs.request && lhs.intent == rhs.intent
    }
}

public struct Intent: Equatable {

    public var name: String
    public var slots: [String: Slot]

    public init(name: String, slots: [String: Slot] = [:]) {
        self.name = name
        self.slots = slots
    }

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Intent, rhs: Intent) -> Bool {
        return lhs.name == rhs.name && lhs.slots == rhs.slots
    }
}

public enum BuiltInIntent: String {
    case cancel = "AMAZON.CancelIntent"
    case help = "AMAZON.HelpIntent"
    case loopOff = "AMAZON.LoopOffIntent"
    case loopOn = "AMAZON.LoopOnIntent"
    case next = "AMAZON.NextIntent"
    case no = "AMAZON.NoIntent"
    case pause = "AMAZON.PauseIntent"
    case previous = "AMAZON.PreviousIntent"
    case repeatThat = "AMAZON.RepeatIntent" // can't use repeat as enum value in 3.0
    case resume = "AMAZON.ResumeIntent"
    case shuffleOff = "AMAZON.ShuffleOffIntent"
    case shuffleOn = "AMAZON.ShuffleOnIntent"
    case startOver = "AMAZON.StartOverIntent"
    case stop = "AMAZON.StopIntent"
    case yes = "AMAZON.YesIntent"
}

public struct Slot: Equatable {
    public var name: String
    public var value: String?

    public init(name: String, value: String? = nil) {
        self.name = name
        self.value = value
    }
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
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
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: SessionEndedRequest, rhs: SessionEndedRequest) -> Bool {
        return lhs.request == rhs.request &&
            lhs.reason == rhs.reason
    }
}

public enum Reason: Equatable {
    case unknown
    case userInitiated
    case error(Error)
    case exceededMaxReprompts
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
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
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
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
