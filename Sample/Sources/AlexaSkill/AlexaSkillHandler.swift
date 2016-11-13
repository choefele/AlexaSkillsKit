import Foundation
import AlexaSkillsKit

public class AlexaSkillHandler : RequestHandler {
    public init() {
    }
    
    public func handleLaunch(request: LaunchRequest, session: Session, next: @escaping (StandardResult) -> ()) {
        next(.success(standardResponse: StandardResponse(), sessionAttributes: session.attributes))
    }
    
    public func handleIntent(request: IntentRequest, session: Session, next: @escaping (StandardResult) -> ()) {
        next(.success(standardResponse: StandardResponse(), sessionAttributes: session.attributes))
    }
    
    public func handleSessionEnded(request: SessionEndedRequest, session: Session, next: @escaping (VoidResult) -> ()) {
        next(.success())
    }
}
