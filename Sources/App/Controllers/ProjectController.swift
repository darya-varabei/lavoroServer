//
//  File.swift
//  
//
//  Created by Дарья Воробей on 17.04.22.
//

import Foundation
import Vapor
import Fluent

struct ProjectRepositoryImpl: ProjectRepository {
    var req: Request
    
    public init(_ req: Request) {
        self.req = req
    }
    
    func query() -> QueryBuilder<Project> {
        Project.query(on: req.db)
    }

    func query(_ id: Project.IDValue) -> QueryBuilder<Project> {
        query().filter(\.$id == id)
    }

    func query(_ ids: [Project.IDValue]) -> QueryBuilder<Project> {
        query().filter(\.$id ~~ ids)
    }

    func list() async throws -> [Project] {
        try await query().all()
    }

    func get(_ id: Project.IDValue) async throws -> Project? {
        try await get([id]).first
    }

    func get(_ ids: [Project.IDValue]) async throws -> [Project] {
        try await query(ids).all()
    }

    func create(_ model: Project) async throws -> Project {
        try await model.create(on: req.db)
        return model
    }

    func update(_ model: Project) async throws -> Project {
        try await model.update(on: req.db)
        return model
    }

    func delete(_ id: Project.IDValue) async throws {
        try await delete([id])
    }

    func delete(_ ids: [Project.IDValue]) async throws {
        try await query(ids).delete()
    }
}


struct ProjectController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let project = routes.grouped("project")
        
        project.group("view") { user in
            user.post(use: index)
        }
        
        project.group("create") { user in
            user.post(use: create)
        }
        project
            .grouped(JWTBearerAuthentificator())
            .group("me") { usr in
                usr.get(use: me)
            }
//        let application = routes.grouped("application")
//        application.get(use: index)
//        application.post(use: create)
//        application.group(":applicationID") { todo in
//            todo.delete(use: delete)
//        }
    }
    
    func index(req: Request) async throws -> [Project] {
        try await req.repositories.project.list()
    }
    
    func create(req: Request) async throws -> Project{
        let project = try req.content.decode(Project.self)
        return try await req.repositories.project.create(project)
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let id = req.parameters.get("applicationID", as: Project.IDValue.self) else {
            throw Abort(.notFound)
        }
        try await req.repositories.project.delete(id)
        return .ok
    }
}
