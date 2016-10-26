import Foundation
import AlexaSkillsKit

func echo(string: String) -> String {
    let errorMessage = "{\"version\": \"1.0\", \"response\": {\"outputSpeech\": {\"type\": \"PlainText\", \"text\": \"%@\"}, \"shouldEndSession\": true }, \"sessionAttributes\": {}}"
    
    guard let data = string.data(using: .utf8),
        let requestParser = try? RequestParser(with: data),
        let _ = requestParser.parseRequestType() else {
            return String(format: errorMessage, "Error 1")
    }
    
    let outputSpeech = OutputSpeech.plain(text: "Test Swift on Lambda")
    let standardResponse = StandardResponse(outputSpeech: outputSpeech, shouldEndSession: true)
    let responseGenerator = ResponseGenerator(standardResponse: standardResponse)
    guard let jsonData = try? responseGenerator.generateJSON(options: .prettyPrinted) else {
        return String(format: errorMessage, "Error 2")
    }
    
    return String(data: jsonData, encoding: .utf8) ?? String(format: errorMessage, "Error 3")
}
readTransformPrint(transform:echo)
