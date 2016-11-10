import Foundation
import AlexaSkillsKit
import Kitura
import HeliumLogger

HeliumLogger.use()

let router = Router()
router.get("/ping") { request, response, next in
    response.send("pong")
    next()
}

Kitura.addHTTPServer(onPort: 8090, with: router)
Kitura.run()
