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
