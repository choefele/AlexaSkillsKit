import Foundation

public struct MessageError: Swift.Error {
    public let message: String
    
    public init(message: String) {
        self.message = message
    }
}

public enum Result<T> {
    case success(T)
    case failure(MessageError)
}

public typealias StandardResult = Result<(standardResponse: StandardResponse, sessionAttributes: [String: Any])>
public typealias VoidResult = Result<Void>

public protocol RequestHandler {
    func handleLaunch(request: LaunchRequest, session: Session, next: @escaping (StandardResult) -> ())
    func handleIntent(request: IntentRequest, session: Session, next: @escaping (StandardResult) -> ())
    func handleSessionEnded(request: SessionEndedRequest, session: Session, next: @escaping (VoidResult) -> ())
}
