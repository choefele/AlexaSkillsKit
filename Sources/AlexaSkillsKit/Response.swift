//
//  Response.swift
//  AlexaSkillsKit
//
//  Created by Claus Höfele on 12.10.16.
//
//

import Foundation

public struct StandardResponse {
    public var outputSpeech: OutputSpeech?
    public var card: Card?
    public var reprompt: OutputSpeech?
    public var shouldEndSession: Bool
    
    public init(outputSpeech: OutputSpeech? = nil, card: Card? = nil, reprompt: OutputSpeech? = nil, shouldEndSession: Bool) {
        self.outputSpeech = outputSpeech
        self.card = card
        self.reprompt = reprompt
        self.shouldEndSession = shouldEndSession
    }
}

public enum OutputSpeech {
    case plainText(String)
    case ssml(String)
}

public enum Card {
    case simple(title: String?, content: String?)
    case standard(title: String?, text: String?, image: Image?)
}

public struct Image {
    public var smallImageUrl: URL
    public var largeImageUrl: URL
}
