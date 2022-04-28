//
//  File.swift
//  
//
//  Created by Дарья Воробей on 17.04.22.
//

import Foundation
import Vapor
import Fluent

struct FluentApplicationRepository: ApplicationRepository {
    var req: Request
    
    public init(_ req: Request) {
        self.req = req
    }
    
    func query() -> QueryBuilder<Apply> {
        Apply.query(on: req.db)
    }

    func query(_ id: Apply.IDValue) -> QueryBuilder<Apply> {
        query().filter(\.$id == id)
    }

    func query(_ ids: [Apply.IDValue]) -> QueryBuilder<Apply> {
        query().filter(\.$id ~~ ids)
    }

    func list() async throws -> [Apply] {
        try await query().all()
    }

    func get(_ id: Apply.IDValue) async throws -> Apply? {
        try await get([id]).first
    }

    func get(_ ids: [Apply.IDValue]) async throws -> [Apply] {
        try await query(ids).all()
    }

    func create(_ model: Apply) async throws -> Apply {
        try await model.create(on: req.db)
        return model
    }

    func update(_ model: Apply) async throws -> Apply {
        try await model.update(on: req.db)
        return model
    }

    func delete(_ id: Apply.IDValue) async throws {
        try await delete([id])
    }

    func delete(_ ids: [Apply.IDValue]) async throws {
        try await query(ids).delete()
    }
}


struct ApplicationController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let applications = routes.grouped("application")
        
        applications.group("view") { user in
            user.post(use: index)
        }
        
        applications.group("create") { user in
            user.post(use: create)
        }
        users
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
    
    func index(req: Request) async throws -> [Apply] {
        try await req.repositories.application.list()
    }
    
    func create(req: Request) async throws -> Apply {
        let application = try req.content.decode(Apply.self)
        return try await req.repositories.application.create(application)
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let id = req.parameters.get("applicationID", as: Apply.IDValue.self) else {
            throw Abort(.notFound)
        }
        try await req.repositories.application.delete(id)
        return .ok
    }
}
