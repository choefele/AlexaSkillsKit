import Foundation

open class RequestDispatcher {
    public let requestHandler: RequestHandler

    public init(requestHandler: RequestHandler) {
        self.requestHandler = requestHandler
    }

    open func dispatch(fileHandle: FileHandle) -> Data {
        return dispatch(data: fileHandle.readDataToEndOfFile())
    }

    open func dispatch(data: Data) -> Data {
        guard let requestParser = try? RequestParser(with: data),
            let requestType = requestParser.parseRequestType() else {
                return handleError("Error parsing request")
        }

        var response = (standardResponse: StandardResponse(), sessionAttributes: [:])
        switch requestType {
        case .intent:
            guard let intentRequest = requestParser.parseIntentRequest(),
                let session = requestParser.parseSession() else {
                return handleError("Error parsing intent")
            }

            requestHandler.handleIntent(request: intentRequest, session: session, next: { (standardResponse) in
                response = (standardResponse, [:])
            })
        default:
            response = (StandardResponse(), [:])
        }

        let responseGenerator = ResponseGenerator(standardResponse: response.standardResponse)
        guard let jsonData = try? responseGenerator.generateJSON(options: .prettyPrinted) else {
            return handleError("Error generating response")
        }
        
        return jsonData
    }

    func handleError(_ message: String) -> Data {
        return "{\"version\": \"1.0\", \"response\": {\"outputSpeech\": {\"type\": \"PlainText\", \"text\": \"\(message)\"}, \"shouldEndSession\": true }}".data(using: .utf8)!
    }
}
