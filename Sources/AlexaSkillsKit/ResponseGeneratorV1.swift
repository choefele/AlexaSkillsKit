import Foundation

public class ResponseGeneratorV1: ResponseGenerator {
    public var standardResponse: StandardResponse?
    public var sessionAttributes: [String: Any]
    
    public init(standardResponse: StandardResponse = StandardResponse(), sessionAttributes: [String: Any] = [:]) {
        self.standardResponse = standardResponse
        self.sessionAttributes = sessionAttributes
    }
    
    public func generateJSONObject() -> [String: Any] {
        var json: [String: Any] = ["version": "1.0"]
        
        json["sessionAttributes"] = sessionAttributes.isEmpty ? nil : sessionAttributes
        json["response"] = standardResponse.map{ ResponseGeneratorV1.generateStandardResponse($0) }
        
        return json
    }
}

extension ResponseGeneratorV1 {
    class func generateStandardResponse(_ standardResponse: StandardResponse) -> [String: Any] {
        var jsonResponse = [String: Any]()
        
        if let outputSpeech = standardResponse.outputSpeech {
            jsonResponse["outputSpeech"] = ResponseGeneratorV1.generateOutputSpeech(outputSpeech)
        }
        
        if let reprompt = standardResponse.reprompt {
            let jsonOutputSpeech = ["outputSpeech": ResponseGeneratorV1.generateOutputSpeech(reprompt)]
            jsonResponse["reprompt"] = jsonOutputSpeech
        }
        
        if let card = standardResponse.card {
            jsonResponse["card"] = ResponseGeneratorV1.generateCard(card)
        }
        
        if !standardResponse.shouldEndSession {
            #if os(Linux)
                jsonResponse["shouldEndSession"] = NSNumber(booleanLiteral: standardResponse.shouldEndSession)
            #else
                jsonResponse["shouldEndSession"] = standardResponse.shouldEndSession
            #endif
        }
        
        return jsonResponse
    }
    
    class func generateOutputSpeech(_ outputSpeech: OutputSpeech) -> [String: Any] {
        switch outputSpeech {
        case .plain(let text): return ["type": "PlainText", "text": text]
        }
    }
    
    class func generateCard(_ card: Card) -> [String: Any] {
        switch card {
        case .simple(let title, let content):
            var jsonCard: [String: Any] = ["type": "Simple"]
            jsonCard["title"] = title
            jsonCard["content"] = content
            return jsonCard
        case .standard(let title, let text, let image):
            var jsonCard: [String: Any] = ["type": "Standard"]
            jsonCard["title"] = title
            jsonCard["text"] = text
            jsonCard["image"] = ["smallImageUrl": image?.smallImageUrl, "largeImageUrl": image?.largeImageUrl]
            return jsonCard
        }
    }
}
