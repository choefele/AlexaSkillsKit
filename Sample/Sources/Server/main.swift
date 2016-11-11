import Foundation
import AlexaSkillsKit
import AlexaSkill
import Kitura
import HeliumLogger

HeliumLogger.use()

let router = Router()
router.get("/ping") { request, response, next in
    response.send("pong")
    next()
}

router.all("/") { request, response, next in
    var data = Data()
    let _ = try? request.read(into: &data)

    do {
        let requestDispatcher = RequestDispatcher(requestHandler: AlexaSkillHandler())
        let responseData = try requestDispatcher.dispatch(data: data)
        response.send(data: responseData).status(.OK)
    } catch let error as RequestDispatcher.Error {
        response.send(error.message).status(.badRequest)
    }

    next()
}

Kitura.addHTTPServer(onPort: 8090, with: router)
Kitura.run()
