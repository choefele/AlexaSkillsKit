//
//  ResponseGenerator.swift
//  AlexaSkillsKit
//
//  Created by Claus Höfele on 22.10.16.
//
//

import Foundation

public class ResponseGenerator {
    public let standardResponse: StandardResponse
    
    public init(standardResponse: StandardResponse) {
        self.standardResponse = standardResponse
    }
    
    public func generateJson() -> [String: Any] {
        var json: [String: Any] = ["version": "1.0"]
        json["response"] = ResponseGenerator.generateStandardResponse(standardResponse)
        return json
    }
}

extension ResponseGenerator {
    class func generateStandardResponse(_ standardResponse: StandardResponse) -> [String: Any] {
        var jsonResponse = [String: Any]()
        
        if let outputSpeech = standardResponse.outputSpeech {
            jsonResponse["outputSpeech"] = ResponseGenerator.generateOutputSpeech(outputSpeech)
        }
        
        return jsonResponse
    }
    
    class func generateOutputSpeech(_ outputSpeech: OutputSpeech) -> [String: Any] {
        switch outputSpeech {
        case .plain(let text): return ["type": "PlainText", "text": text]
        }
    }
}
