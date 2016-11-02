import Foundation

public protocol RequestHandler {
    func handleLaunch(request: LaunchRequest, session: Session, next: @escaping (StandardResponse) -> ())
    func handleIntent(request: IntentRequest, session: Session, next: @escaping (StandardResponse) -> ())
    func handleSessionEnded(request: SessionEndedRequest, session: Session, next: @escaping () -> ())
}
