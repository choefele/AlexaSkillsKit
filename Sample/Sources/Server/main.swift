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
