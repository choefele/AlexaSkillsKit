import Foundation
import Dispatch

open class RequestDispatcher {
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
        var dispatchResult = Result<Data>.failure(MessageError(message: "Error waiting for result"))

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
    open func dispatch(data: Data, completion: @escaping (Result<Data>) -> ()) {
        guard let _ = try? requestParser.update(with: data),
            let requestType = requestParser.parseRequestType() else {
                completion(.failure(MessageError(message: "Error parsing request")))
                return
        }

        switch requestType {
        case .launch:
            guard let launchRequest = requestParser.parseLaunchRequest(),
                let session = requestParser.parseSession() else {
                    completion(.failure(MessageError(message: "Error parsing launch request")))
                    return
            }
            
            requestHandler.handleLaunch(request: launchRequest, session: session, next: { result in
                self.handleResponse(result: result, completion: completion)
            })
            
        case .intent:
            guard let intentRequest = requestParser.parseIntentRequest(),
                let session = requestParser.parseSession() else {
                completion(.failure(MessageError(message: "Error parsing intent request")))
                return
            }

            requestHandler.handleIntent(request: intentRequest, session: session, next: { result in
                self.handleResponse(result: result, completion: completion)
            })
        
        case .sessionEnded:
            guard let sessionEndedRequest = requestParser.parseSessionEndedRequest(),
                let session = requestParser.parseSession() else {
                    completion(.failure(MessageError(message: "Error parsing session ended request")))
                    return
            }
            
            requestHandler.handleSessionEnded(request: sessionEndedRequest, session: session, next: { result in
                self.handleResponse(result: result, completion: completion)
            })
        }
    }
}

extension RequestDispatcher {
    func handleResponse(result: StandardResult, completion: (Result<Data>) -> ()) -> () {
        switch result {
        case .success(let result):
            generateResponse(standardResponse: result.standardResponse, sessionAttributes: result.sessionAttributes, completion: completion)
        default:
            completion(.failure(MessageError(message: "Error handling request")))
        }
    }
    
    func handleResponse(result: VoidResult, completion: (Result<Data>) -> ()) -> () {
        switch result {
        case .success:
            generateResponse(standardResponse: nil, sessionAttributes: [:], completion: completion)
        default:
            completion(.failure(MessageError(message: "Error handling request")))
        }
    }
    
    func generateResponse(standardResponse: StandardResponse?, sessionAttributes: [String: Any], completion: (Result<Data>) -> ()) -> () {
        responseGenerator.update(standardResponse: standardResponse, sessionAttributes: sessionAttributes)
        guard let jsonData = try? responseGenerator.generateJSON(options: .prettyPrinted) else {
            completion(.failure(MessageError(message: "Error generating response")))
            return
        }
        
        completion(.success(jsonData))
    }
}
