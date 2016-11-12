import Foundation
import Dispatch

open class RequestDispatcher {
    public struct Error: Swift.Error {
        public let message: String
    }

    public enum Result {
        case success(data: Data)
        case failure(error: Error)
    }

    public let requestHandler: RequestHandler
    public let requestParser: RequestParser
    public let responseGenerator: ResponseGenerator

    public init(requestHandler: RequestHandler, requestParser: RequestParser = RequestParserV1(), responseGenerator: ResponseGenerator = ResponseGeneratorV1()) {
        self.requestHandler = requestHandler
        self.requestParser = requestParser
        self.responseGenerator = responseGenerator
    }

    /// Synchronous dispatch that waits for the request handler to 
    /// asynchronously compute the result data.
    ///
    /// - Parameter data: Input data.
    /// - Returns: Output data.
    /// - Throws: Error.
    open func dispatch(data: Data) throws -> Data {
        var dispatchResult = Result.failure(error: Error(message: "Error waiting for result"))

        let dispatchSemaphore = DispatchSemaphore(value: 1)
        dispatch(data: data) { result in
            dispatchResult = result
            dispatchSemaphore.signal()
        }
        dispatchSemaphore.wait()

        switch dispatchResult {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }

    /// Asynchronous dispatch that calls the completion handler once the request
    /// handler finished computing the result data.
    ///
    /// - Parameters:
    ///   - data: Input data.
    ///   - completion: Completion handler.
    open func dispatch(data: Data, completion: @escaping (Result) -> ()) {
        guard let _ = try? requestParser.update(with: data),
            let requestType = requestParser.parseRequestType() else {
                completion(.failure(error: Error(message: "Error parsing request")))
                return
        }

        switch requestType {
        case .launch:
            guard let launchRequest = requestParser.parseLaunchRequest(),
                let session = requestParser.parseSession() else {
                    completion(.failure(error: Error(message: "Error parsing launch request")))
                    return
            }
            
            requestHandler.handleLaunch(request: launchRequest, session: session, next: { standardResponse in
                self.generateResponse(standardResponse: standardResponse, completion: completion)
            })
            
        case .intent:
            guard let intentRequest = requestParser.parseIntentRequest(),
                let session = requestParser.parseSession() else {
                completion(.failure(error: Error(message: "Error parsing intent request")))
                return
            }

            requestHandler.handleIntent(request: intentRequest, session: session, next: { standardResponse in
                self.generateResponse(standardResponse: standardResponse, completion: completion)
            })
        default:
            completion(.failure(error: Error(message: "Unknow request type")))
        }
    }
}

extension RequestDispatcher {
    func generateResponse(standardResponse: StandardResponse, completion: (Result) -> ()) -> () {
        responseGenerator.update(standardResponse: standardResponse, sessionAttributes: [:])
        guard let jsonData = try? responseGenerator.generateJSON(options: .prettyPrinted) else {
            completion(.failure(error: Error(message: "Error generating response")))
            return
        }
        
        completion(.success(data: jsonData))
    }
}
