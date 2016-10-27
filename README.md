# AlexaSkillsKit
[![Build Status](https://travis-ci.org/choefele/AlexaSkillsKit.svg?branch=master)](https://travis-ci.org/choefele/AlexaSkillsKit)

AlexaSkillsKit is a Swift library that allows you to develop custom skills for [Amazon Alexa](https://developer.amazon.com/alexa), the voice service that powers Echo. It takes care of parsing JSON requests from Amazon, generating the proper responses and providing convenience methods to handle all other features that Alexa offers.

AlexaSkillsKit has been inspired by [alexa-app](https://github.com/matt-kruse/alexa-app), [SwiftOnLambda](https://github.com/algal/SwiftOnLambda) and [alexa-skills-kit-java](https://github.com/amzn/alexa-skills-kit-java).

It's early days – expect API changes until we reach 1.0!

## Usage

`AlexaSkillsKit` works on AWS Lambda using an Alexa Skills Kit trigger, but also as part of any other Swift server environment via Alexa's HTTPS API. 

Using Lambda, Amazon will take care of scaling and running your code. Lambda, however, doesn't support Swift executables natively thus the support depends on coming up with clever ways to work around that. A stand-alone server allows you to use alternate cloud providers and run multiple skills on the same server using any Swift web framework such as [Kitura](https://github.com/IBM-Swift/Kitura), [Vapor](https://github.com/vapor/vapor) or [Perfect](https://github.com/PerfectlySoft/Perfect).

### Lambda

A sample for a custom skill using Lambda is provided in [Samples/Lambda](https://github.com/choefele/AlexaSkillsKit/tree/master/Samples/Lambda). You'll need [Xcode 8](https://developer.apple.com/xcode/) and [docker](https://www.docker.com/products/overview) to build it.

- Make sure the sample builds by running `swift build`. This will install AlexaSkillsKit in the Packages folder and build the executable for macOS
- Lambda executables take their input via `stdin` and provide output via `stdout` – you can try this out by piping a test file into the executable `swift build && cat ../../Tests/AlexaSkillsKitTests/launch_request.json | ./.build/debug/Lambda`
- Execute `./build-lambda-package.sh` to build the executable for Linux. The Swift compiler will run inside a docker container that provides a build environment for Linux
- This will result in a zip file at .build/lambda/lambda.zip that contains the executable, its libraries and a Node.js shim that provides an execution context.
- Create a new Lambda function in the [AWS Console](https://console.aws.amazon.com/lambda/home) in the US East (N. Virginia) region
 - Use an Alexa Skills Kit trigger
 - Runtime: NodeJS 4.3
 - Code entry type: ZIP file (upload the lambda.zip file from the previous step)
 - Handler: index.handler
 - Role: Create from template or use existing role
- After creating the Lambda function, you can now test your code using an Alexa test event in the AWS console
- To create an Alexa skill
 - Go to the [Alexa console](https://developer.amazon.com/edw/home.html#/skills/list) and create a new skill
 - Skill type: Custom Interaction Model
 - Intent: `{ "intents": [{"intent": "TestIntent"}]}`
 - Sample utterances: "TestIntent test swift"
 - Service endpoint type: AWS Lambda ARN (use the ARN from the AWS Console)
 
Now you can test the skill in the Alexa Console using the utterance "test swift". More details on configuring Alexa skills can be found on [Amazon's developer portal](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/overviews/steps-to-build-a-custom-skill).

### Stand-Alone Server
_Coming soon_

## Supported Features
### Request Envelope
| Feature | Supported |
| --- | --- |
| version | yes |
| session | |
| context | |
| request | partially, see below|

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
| sessionAttributes | |
| response | partially, see below |

### Response
| Feature | Supported |
| --- | --- |
| outputSpeech | partially (plain yes, SSML no)|
| card | |
| reprompt | |
| directives | |
| shouldEndSession | yes |

### Other
| Feature | Supported |
| --- | --- |
| Account Linking | |
| Multiple Languages | partially (locale attribute supported)|
| Built-in Intents | |
