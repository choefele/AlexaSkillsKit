import Foundation
import AlexaSkillsKit

func transform(fileHandle: FileHandle) -> Data {
    guard let requestParser = try? RequestParser(fileHandle: fileHandle),
        let _ = requestParser.parseRequestType() else {
            return "{\"version\": \"1.0\", \"response\": {\"outputSpeech\": {\"type\": \"PlainText\", \"text\": \"Error 1\"}, \"shouldEndSession\": true }}".data(using: .utf8)!
    }

    let outputSpeech = OutputSpeech.plain(text: "Test Swift on Lambda")
    let standardResponse = StandardResponse(outputSpeech: outputSpeech, shouldEndSession: true)
    let responseGenerator = ResponseGenerator(standardResponse: standardResponse)
    guard let jsonData = try? responseGenerator.generateJSON(options: .prettyPrinted) else {
        return "{\"version\": \"1.0\", \"response\": {\"outputSpeech\": {\"type\": \"PlainText\", \"text\": \"Error 2\"}, \"shouldEndSession\": true }}".data(using: .utf8)!
    }
    
    return jsonData
}

let result = transform(fileHandle: FileHandle.standardInput)
FileHandle.standardOutput.write(result)
