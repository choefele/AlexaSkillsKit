//
//  ResponseGenerator.swift
//  AlexaSkillsKit
//
//  Created by Claus Höfele on 22.10.16.
//
//

import Foundation

public class ResponseGenerator {
    public let response: StandardResponse
    
    public init(response: StandardResponse) {
        self.response = response
    }
    
    public func generateJson() -> [String: Any] {
        var json: [String: Any] = ["version": "1.0"]
        json["response"] = ResponseGenerator.generateResponse(response)
        return json
    }
}

extension ResponseGenerator {
    class func generateResponse(_ response: StandardResponse) -> [String: Any] {
        return [:]
    }
}
