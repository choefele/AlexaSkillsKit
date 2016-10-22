import Foundation

public protocol RequestHandler {
    func handleLaunch(request: LaunchRequest, next: @escaping (StandardResponse) -> ())
    func handleIntent(request: IntentRequest, next: @escaping (StandardResponse) -> ())
    func handleSessionEnded(request: SessionEndedRequest, next: @escaping () -> ())
}
