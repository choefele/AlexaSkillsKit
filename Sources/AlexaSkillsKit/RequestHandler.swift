//
//  RequestHandler.swift
//  AlexaSkillsKit
//
//  Created by Claus Höfele on 12.10.16.
//
//

import Foundation

public protocol RequestHandler {
    func handleLaunch(request: LaunchRequest) -> StandardResponse
    func handleIntent(request: IntentRequest) -> StandardResponse
    func handleSessionEnded(request: SessionEndedRequest)
}
