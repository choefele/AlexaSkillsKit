import Foundation

public struct MessageError: Swift.Error, Equatable {
    public let message: String
    
    public init(message: String) {
        self.message = message
    }
    
    public static func ==(lhs: MessageError, rhs: MessageError) -> Bool {
        return lhs.message == rhs.message
    }
}

public enum Result<T> {
    case success(T)
    case failure(MessageError)
    
    // Can't implement Equatable unless session attributes are changed from 
    // [String: Any] to something that can be compared
}

public typealias StandardResult = Result<(standardResponse: StandardResponse, sessionAttributes: [String: Any])>
public typealias VoidResult = Result<Void>

public protocol RequestHandler {
    func handleLaunch(request: LaunchRequest, session: Session, next: @escaping (StandardResult) -> ())
    func handleIntent(request: IntentRequest, session: Session, next: @escaping (StandardResult) -> ())
    func handleSessionEnded(request: SessionEndedRequest, session: Session, next: @escaping (VoidResult) -> ())
}
