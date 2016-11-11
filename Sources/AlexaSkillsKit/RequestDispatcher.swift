import Foundation

open class RequestDispatcher {
    public enum Result {
        case success(data: Data)
        case failure(message: String)
    }

    public let requestHandler: RequestHandler

    public init(requestHandler: RequestHandler) {
        self.requestHandler = requestHandler
    }

    open func dispatch(fileHandle: FileHandle) -> Result {
        return dispatch(data: fileHandle.readDataToEndOfFile())
    }

    open func dispatch(data: Data) -> Result {
        guard let requestParser = try? RequestParser(with: data),
            let requestType = requestParser.parseRequestType() else {
                return .failure(message: "Error parsing request")
        }

        var response = (standardResponse: StandardResponse(), sessionAttributes: [:])
        switch requestType {
        case .intent:
            guard let intentRequest = requestParser.parseIntentRequest(),
                let session = requestParser.parseSession() else {
                return .failure(message: "Error parsing intent")
            }

            requestHandler.handleIntent(request: intentRequest, session: session, next: { (standardResponse) in
                response = (standardResponse, [:])
            })
        default:
            response = (StandardResponse(), [:])
        }

        let responseGenerator = ResponseGenerator(standardResponse: response.standardResponse)
        guard let jsonData = try? responseGenerator.generateJSON(options: .prettyPrinted) else {
            return .failure(message: "Error generating response")
        }
        
        return .success(data: jsonData)
    }
}
