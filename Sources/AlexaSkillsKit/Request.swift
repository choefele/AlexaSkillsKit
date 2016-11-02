import Foundation

/// `Session` contains additional context associated with a request that is
/// maintained between request invocations.
///
/// Session attributes will survive individual invocations of a skill if
/// attributes are passed back in the response as `sessionAttributes` (see
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

/// A value type containing an application ID. This can be used to verify that
/// the request was intended for your service.
public struct Application: Equatable {
    /// A string representing the appliation ID for your skill.
    public var applicationId: String
    
    /// Creates a new application with initial values.
    ///
    /// - Parameter applicationId: A string representing the appliation ID for your skill.
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

/// A value type that describes the user making the request.
public struct User: Equatable {
    /// A unique identifier for the user who made the request.
    public var userId: String
    /// A token identifying the user in another system to support account
    /// linking.
    public var accessToken: String?
    
    /// Creates a new user with initial values.
    ///
    /// - Parameters:
    ///   - userId: A unique identifier for the user who made the request.
    ///   - accessToken: A token identifying the user in another system to
    /// support account linking.
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

/// A type that represents that a user made a request to an Alexa skill, but did
/// not provide a specific intent.
public struct LaunchRequest: Equatable {
    /// A type containing standard request values.
    public var request: Request
    
    /// Creates a new launch request with initial values.
    ///
    /// - Parameter request: A type containing standard request values.
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

/// A type containing standard request values.
public struct Request: Equatable {
    /// Represents a unique identifier for the specific request.
    public var requestId: String
    /// Provides the date and time when Alexa sent the request.
    public var timestamp: Date
    /// A value type indicating the user’s locale.
    public var locale: Locale
    
    /// Creates a new request with initial values.
    ///
    /// - Parameters:
    ///   - requestId: Represents a unique identifier for the specific request.
    ///   - timestamp: Provides the date and time when Alexa sent the request.
    ///   - locale: A value type indicating the user’s locale.
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

/// A value typer that represents a request made to a skill based on what the
/// user wants to do.
public struct IntentRequest: Equatable {
    /// A type containing standard request values.
    public var request: Request
    /// A type containing intent-specific values.
    public var intent: Intent
    
    /// Creates a new intent request with initial values.
    ///
    /// - Parameters:
    ///   - request: A type containing standard request values.
    ///   - intent: A type containing intent-specific values.
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

/// A type containing values specific to an intent.
public struct Intent: Equatable {
    /// A string representing the name of the intent.
    public var name: String
    /// A map of key-value pairs that further describes what the user
    /// meant based on a predefined intent schema.
    public var slots: [String: Slot]

    /// Creates a new intent with initial values.
    ///
    /// - Parameters:
    ///   - name: A string representing the name of the intent.
    ///   - slots: A map of key-value pairs that further describes what the user
    /// meant based on a predefined intent schema.
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

/// A list of built-in intent names
///
/// - cancel: A value indicating a cancel intent.
/// - help: A value indicating a help intent.
/// - loopOff: A value indicating a loop off intent.
/// - loopOn: A value indicating a loop on intent.
/// - next: A value indicating a next intent.
/// - no: A value indicating a no intent.
/// - pause: A value indicating a pause intent.
/// - previous: A value indicating a previous intent.
/// - repeatThat: A value indicating a repeat intent.
/// - resume: A value indicating a resume intent.
/// - shuffleOff: A value indicating a shuffle off intent.
/// - shuffleOn: A value indicating a shuffle on intent.
/// - startOver: A value indicating a start over intent.
/// - stop: A value indicating a stop intent.
/// - yes: A value indicating a yes intent.
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

/// The value of an intent slot.
public struct Slot: Equatable {
    /// A string that represents the name of the slot.
    public var name: String
    /// A string that represents the value of the slot.
    public var value: String?

    /// Creates a new slot with initial values.
    ///
    /// - Parameters:
    ///   - name: A string that represents the name of the slot.
    ///   - value: A string that represents the value of the slot.
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

/// A value type that represents a request made to an Alexa skill to notify that
/// a session was ended.
public struct SessionEndedRequest: Equatable {
    /// A type containing standard request values.
    public var request: Request
    /// Describes why the session ended.
    public var reason: Reason
    
    /// Creates a new session ended request with initial values.
    ///
    /// - Parameters:
    ///   - request: A type containing standard request values.
    ///   - reason: Describes why the session ended.
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

/// Describes why a session ended.
///
/// - unknown: Value indicating an unknown reason.
/// - userInitiated: The user explicitly ended the session.
/// - error: An error occurred that caused the session to end.
/// - exceededMaxReprompts: The user either did not respond or responded with an
/// utterance that did not match any of the intents defined in your voice
/// interface.
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

/// An error type providing more information about the error that occurred.
public struct Error: Equatable {
    /// Enum indicating the type of error that occurred.
    public var type: ErrorType
    /// A string providing more information about the error.
    public var message: String
    
    /// Creates a new error with initial values.
    ///
    /// - Parameters:
    ///   - type: Enum indicating the type of error that occurred.
    ///   - message: A string providing more information about the error.
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

/// Enum that discribes the type of error that occurred.
///
/// - unknown: Value indicating an unknown error.
/// - invalidResponse: Value indicating an invalid response.
/// - deviceCommunicationError: Value indicating a device communication error.
/// - internalError: Value indicating an internal error.
public enum ErrorType {
    case unknown
    case invalidResponse
    case deviceCommunicationError
    case internalError
}
