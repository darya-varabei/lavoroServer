import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    try app.register(collection: UserController())
    try app.register(collection: ApplicationController())
    try app.register(collection: EmployeeController())
    try app.register(collection: ProjectController())
    try app.register(collection: SkillController())
    try app.register(collection: TechnologyController())
    try app.register(collection: ResponseController())
    try app.register(collection: OfferController())
}
