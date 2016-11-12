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
        case .intent:
            guard let intentRequest = requestParser.parseIntentRequest(),
                let session = requestParser.parseSession() else {
                completion(.failure(error: Error(message: "Error parsing intent")))
                return
            }

            requestHandler.handleIntent(request: intentRequest, session: session, next: { standardResponse in
                self.responseGenerator.update(standardResponse: standardResponse, sessionAttributes: [:])
                guard let jsonData = try? self.responseGenerator.generateJSON(options: .prettyPrinted) else {
                    completion(.failure(error: Error(message: "Error generating response")))
                    return
                }
                
                completion(.success(data: jsonData))
            })
        default:
            completion(.failure(error: Error(message: "Unknow request type")))
        }
    }
}
