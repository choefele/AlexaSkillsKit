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
    class func generateStandardResponse(_ response: StandardResponse) -> [String: Any] {
        return [:]
    }
}
