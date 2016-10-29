import Foundation
import AlexaSkillsKit

func transform(fileHandle: FileHandle) -> Data {
    guard let requestParser = try? RequestParser(fileHandle: fileHandle),
        let requestType = requestParser.parseRequestType() else {
            return "{\"version\": \"1.0\", \"response\": {\"outputSpeech\": {\"type\": \"PlainText\", \"text\": \"Error parsing request\"}, \"shouldEndSession\": true }}".data(using: .utf8)!
    }
    
    let response: (standardResponse: StandardResponse, sessionAttributes: [String: Any])
    switch requestType {
    case .intent:
        let intentRequest = requestParser.parseIntentRequest()
        let session = requestParser.parseSession()
        response = handleIntent(request: intentRequest!, session: session)
    default:
        response = generateTestResponse()
    }

    
    let responseGenerator = ResponseGenerator(standardResponse: response.standardResponse, sessionAttributes: response.sessionAttributes)
    guard let jsonData = try? responseGenerator.generateJSON(options: .prettyPrinted) else {
        return "{\"version\": \"1.0\", \"response\": {\"outputSpeech\": {\"type\": \"PlainText\", \"text\": \"Error generating response\"}, \"shouldEndSession\": true }}".data(using: .utf8)!
    }
    
    return jsonData
}

func generateTestResponse() -> (StandardResponse, [String: Any]) {
    let outputSpeech = OutputSpeech.plain(text: "Test Swift on Lambda")
    let standardResponse = StandardResponse(outputSpeech: outputSpeech, shouldEndSession: true)
    
    return (standardResponse, [:])
}

func handleIntent(request intentRequest: IntentRequest, session: Session?) -> (StandardResponse, [String: Any]) {
    switch intentRequest.intent.name {
    case "OneIntent": return generateSessionStartResponse(intentRequest: intentRequest, session: session)
    case "TwoIntent": return generateSessionContinueResponse(intentRequest: intentRequest, session: session)
    case "ThreeIntent": return generateSessionStopResponse(intentRequest: intentRequest, session: session)
        default: return generateTestResponse()
    }
}

func generateSessionStartResponse(intentRequest: IntentRequest, session: Session?) -> (StandardResponse, [String: Any]) {
    let sessionAttributes = ["session": "available"]

    let outputSpeech = OutputSpeech.plain(text: "Session start, session value is \(sessionAttributes["session"] ?? "missing")")
    let standardResponse = StandardResponse(outputSpeech: outputSpeech, shouldEndSession: false)
    
    return (standardResponse, sessionAttributes)
}

func generateSessionContinueResponse(intentRequest: IntentRequest, session: Session?) -> (StandardResponse, [String: Any]) {
    let sessionAttributes = session?.attributes
    
    let outputSpeech = OutputSpeech.plain(text: "Session continue, session value is \(sessionAttributes?["session"] ?? "missing")")
    let standardResponse = StandardResponse(outputSpeech: outputSpeech, shouldEndSession: false)
    
    return (standardResponse, sessionAttributes ?? [:])
}

func generateSessionStopResponse(intentRequest: IntentRequest, session: Session?) -> (StandardResponse, [String: Any]) {
    let outputSpeech = OutputSpeech.plain(text: "Test session end")
    let standardResponse = StandardResponse(outputSpeech: outputSpeech, shouldEndSession: false)
    
    return (standardResponse, [:])
}

let result = transform(fileHandle: FileHandle.standardInput)
FileHandle.standardOutput.write(result)
