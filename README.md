<p align="center" >
  <img src="https://raw.githubusercontent.com/choefele/AlexaSkillsKit/master/alexa%2Bswift.png" alt="Swift + Docker" title="Swift + Docker">
</p>

# AlexaSkillsKit
[![Build Status](https://travis-ci.org/choefele/AlexaSkillsKit.svg?branch=master)](https://travis-ci.org/choefele/AlexaSkillsKit)

AlexaSkillsKit is a Swift library that allows you to develop custom skills for [Amazon Alexa](https://developer.amazon.com/alexa), the voice service that powers Echo. It takes care of parsing JSON requests from Amazon, generating the proper responses and providing convenience methods to handle all other features that Alexa offers.

AlexaSkillsKit has been inspired by [alexa-app](https://github.com/matt-kruse/alexa-app), [SwiftOnLambda](https://github.com/algal/SwiftOnLambda) and [alexa-skills-kit-java](https://github.com/amzn/alexa-skills-kit-java).

A sample project using AlexaSkillsKit can be found in the [swift-lambda-app](https://github.com/choefele/swift-lambda-app) repo. This project also comes with a detailed description on how to deploy your custom skill.

It's early days – expect API changes until we reach 1.0!

## Implementing a Custom Alexa Skill

Start with implementing the `RequestHandler` protocol. AlexaSkillsKit parses requests from Alexa and passes the data on to methods required by this protocol. For example, a [launch request](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/custom-standard-request-types-reference#launchrequest) would result in AlexaSkillsKit calling the `handleLaunch()` method.

```Swift
import Foundation
import AlexaSkillsKit

public class AlexaSkillHandler : RequestHandler {
    public init() {}
    
    public func handleLaunch(request: LaunchRequest, session: Session, next: @escaping (StandardResult) -> ()) {
        let standardResponse = generateResponse(message: "Alexa Skill received launch request")
        next(.success(standardResponse: standardResponse, sessionAttributes: session.attributes))
    }
    
    public func handleIntent(request: IntentRequest, session: Session, next: @escaping (StandardResult) -> ()) {
        let standardResponse = generateResponse(message: "Alexa Skill received intent \(request.intent.name)")
        next(.success(standardResponse: standardResponse, sessionAttributes: session.attributes))
    }
    
    public func handleSessionEnded(request: SessionEndedRequest, session: Session, next: @escaping (VoidResult) -> ()) {
        next(.success())
    }
    
    func generateResponse(message: String) -> StandardResponse {
        let outputSpeech = OutputSpeech.plain(text: message)
        return StandardResponse(outputSpeech: outputSpeech)
    }
}
```

In the request handler, your custom skill can implement any logic your skill requires. To enable asynchronous code (for example calling another HTTP service), the result is passed on via the `next` callback. `next` takes a enum that's either `.success` and contains an Alexa response or `.failure` in case a problem occurred.

## Deployment

You can run your custom skill on AWS Lambda using an [Alexa Skills Kit trigger](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/developing-an-alexa-skill-as-a-lambda-function) as well as on any other Swift server environment via [Alexa's HTTPS API](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/developing-an-alexa-skill-as-a-web-service). You can use the same `RequestHandler` code in both cases.

Using Lambda, Amazon will take care of scaling and running your Swift code. Lambda, however, doesn't support Swift executables natively thus you have to package your Swift executable and its dependencies so it can be executed as a Node.js Lambda function.

A stand-alone server allows you to use alternate cloud providers and run multiple skills on the same server using any Swift web framework such as [Kitura](https://github.com/IBM-Swift/Kitura), [Vapor](https://github.com/vapor/vapor) or [Perfect](https://github.com/PerfectlySoft/Perfect). Even if you use Lambda for execution, configuring a server allows you to easily run and debug your custom skill in Xcode on a local computer.

A sample for a custom skill using both deployment methods is provided in the [swift-lambda-app](https://github.com/choefele/swift-lambda-app) project. Please have a look at this sample for step-by-step instructions on how to do this.

### Lambda

For Lambda, you need to create an executable that takes input from `stdin` and writes output to `stdout`. This can be done with the following code:

```Swift
import Foundation
import AlexaSkillsKit
import AlexaSkill

do {
    let data = FileHandle.standardInput.readDataToEndOfFile()
    let requestDispatcher = RequestDispatcher(requestHandler: AlexaSkillHandler())
    let responseData = try requestDispatcher.dispatch(data: data)
    FileHandle.standardOutput.write(responseData)
} catch let error as MessageError {
    let data = error.message.data(using: .utf8) ?? Data()
    FileHandle.standardOutput.write(data)
}
```

In combination with a Node.js wrapper script that calls your Swift executable, this code can be uploaded to Lambda. See the [sample project for more details](https://github.com/choefele/swift-lambda-app#deployment).

### Stand-Alone Server

Invocation of a `RequestHandler` as part of a Swift server is done via Amazon's HTTPS API where the Alexa service calls your server with a POST request. In the following code, [Kitura](https://github.com/IBM-Swift/Kitura) is used as a web framework but any other web framework would work equally well:

```Swift
import Foundation
import AlexaSkillsKit
import AlexaSkill
import Kitura

router.all("/") { request, response, next in
    var data = Data()
    let _ = try? request.read(into: &data)

    let requestDispatcher = RequestDispatcher(requestHandler: AlexaSkillHandler())
    requestDispatcher.dispatch(data: data) { result in
        switch result {
        case .success(let data):
            response.send(data: data).status(.OK)
        case .failure(let error):
            response.send(error.message).status(.badRequest)
        }
        
        next()
    }
}

Kitura.addHTTPServer(onPort: 8090, with: router)
Kitura.run()
```

Again, the sample project contains a [detailed description on how to use a local HTTP server](https://github.com/choefele/swift-lambda-app#development) for developing your Alexa skill. 

Also, you can use the same Swift server on a remote machine as the backend for your custom skill. Please check [Amazon's additional requirements](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/developing-an-alexa-skill-as-a-web-service#requirements-for-your-web-service) for this type of deployment.

## Supported Features
### Request Envelope
| Feature | Supported |
| --- | --- |
| version | yes |
| session | yes |
| context | |
| request | partially, see below |

### Requests
| Feature | Supported |
| --- | --- |
| LaunchRequest | yes |
| IntentRequest | yes |
| SessionEndedRequest | yes |
| AudioPlayer Requests | |
| PlaybackController Requests | |

### Response Envelope
| Feature | Supported |
| --- | --- |
| version | yes |
| sessionAttributes | yes |
| response | partially, see below |

### Response
| Feature | Supported |
| --- | --- |
| outputSpeech | partially (plain yes, SSML no) |
| card | yes |
| reprompt | yes |
| directives | |
| shouldEndSession | yes |

### Other
| Feature | Supported |
| --- | --- |
| Request handler | yes |
| Account Linking | |
| Multiple Languages | partially (locale attribute supported) |
| Response validation | |
| Request verification (stand-alone server) | |
