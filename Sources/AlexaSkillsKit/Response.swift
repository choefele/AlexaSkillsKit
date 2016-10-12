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
}

public enum OutputSpeech {
    case plainText(String)
    case ssml(String)
}

public enum Card {
    case simple(title: String?, content: String?)
    case standard(title: String?, text: String?, image: Image?)
    case linkAccount
}

public struct Image {
    public var smallImageUrl: URL
    public var largeImageUrl: URL
}
