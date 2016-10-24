import Foundation
import AlexaSkillsKit

func echo(string: String) -> String {
    guard let data = string.data(using: .utf8),
        let requestParser = try? RequestParser(with: data),
        let _ = requestParser.parseRequestType() else {
            return "error parsing input\n"
    }
    
    let outputSpeech = OutputSpeech.plain(text: "text")
    let standardResponse = StandardResponse(outputSpeech: outputSpeech, shouldEndSession: true)
    let responseGenerator = ResponseGenerator(standardResponse: standardResponse)
    let json = responseGenerator.generateJson()
    guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
        return "error generating JSON\n"
    }
    
    return String(data: jsonData, encoding: .utf8) ?? "error converting to String"
}
readTransformPrint(transform:echo)
