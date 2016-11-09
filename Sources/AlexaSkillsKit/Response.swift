import Foundation

public struct StandardResponse: Equatable {
    public var outputSpeech: OutputSpeech?
    public var card: Card?
    public var reprompt: OutputSpeech?
    public var shouldEndSession: Bool
    
    public init(outputSpeech: OutputSpeech? = nil, card: Card? = nil, reprompt: OutputSpeech? = nil, shouldEndSession: Bool = true) {
        self.outputSpeech = outputSpeech
        self.card = card
        self.reprompt = reprompt
        self.shouldEndSession = shouldEndSession
    }
    
    public static func ==(lhs: StandardResponse, rhs: StandardResponse) -> Bool {
        return lhs.outputSpeech == rhs.outputSpeech &&
            lhs.card == rhs.card &&
            lhs.reprompt == rhs.reprompt &&
            lhs.shouldEndSession == rhs.shouldEndSession
    }
}

//
public enum OutputSpeech: Equatable {
    case plain(text: String)
    
    public static func ==(lhs: OutputSpeech, rhs: OutputSpeech) -> Bool {
        switch (lhs, rhs) {
        case (.plain(let textLhs), .plain(let textRhs)) where textLhs == textRhs: return true
        default: return false
        }
    }
}

public enum Card: Equatable {
    case simple(title: String?, content: String?)
    case standard(title: String?, text: String?, image: Image?)
    
    public static func ==(lhs: Card, rhs: Card) -> Bool {
        switch (lhs, rhs) {
        case (.simple(let titleLhs, let contentLhs), .simple(let titleRhs, let contentRhs)) where titleLhs == titleRhs && contentLhs == contentRhs: return true
        case (.standard(let titleLhs, let contentLhs, let imageLhs), .standard(let titleRhs, let contentRhs, let imageRhs)) where titleLhs == titleRhs && contentLhs == contentRhs && imageLhs == imageRhs: return true
        default: return false
        }
    }
}

public struct Image: Equatable {
    public var smallImageUrl: URL
    public var largeImageUrl: URL
    
    public init(smallImageUrl: URL, largeImageUrl: URL) {
        self.smallImageUrl = smallImageUrl
        self.largeImageUrl = largeImageUrl
    }
    
    public static func ==(lhs: Image, rhs: Image) -> Bool {
        return lhs.smallImageUrl == rhs.smallImageUrl &&
            lhs.largeImageUrl == rhs.largeImageUrl
    }
}
