//
//  File.swift
//  
//
//  Created by Дарья Воробей on 17.04.22.
//

import Foundation
import Vapor
import Fluent
import JWT

struct TechnologyRepositoryImpl: TechnologyRepository {
    var req: Request
    
    public init(_ req: Request) {
        self.req = req
    }
    
    func query() -> QueryBuilder<Technology> {
        Technology.query(on: req.db)
    }

    func query(_ id: Technology.IDValue) -> QueryBuilder<Technology> {
        query().filter(\.$id == id)
    }

    func query(_ ids: [Technology.IDValue]) -> QueryBuilder<Technology> {
        query().filter(\.$id ~~ ids)
    }

    func list() async throws -> [Technology] {
        try await query().all()
    }

    func get(_ id: Technology.IDValue) async throws -> Technology? {
        try await get([id]).first
    }

    func get(_ ids: [Technology.IDValue]) async throws -> [Technology] {
        try await query(ids).all()
    }

    func create(_ model: Technology) async throws -> Technology {
        try await model.create(on: req.db)
        return model
    }

    func update(_ model: Technology) async throws -> Technology {
        try await model.update(on: req.db)
        return model
    }

    func delete(_ id: Technology.IDValue) async throws {
        try await delete([id])
    }

    func delete(_ ids: [Technology.IDValue]) async throws {
        try await query(ids).delete()
    }
}


struct TechnologyController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let technology = routes.grouped("technology")//.grouped(JWTBearerAuthentificator) 
        
        technology.group("list") { user in
            user.post(use: index)
        }
        
        technology.group("create") { user in
            user.post(use: create)
        }
    }
    
    func index(req: Request) async throws -> [Technology] {
        try await req.repositories.technology.list()
    }
    
    func create(req: Request) async throws -> Technology {
        let application = try req.content.decode(Technology.self)
        return try await req.repositories.technology.create(application)
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let id = req.parameters.get("id", as: Technology.IDValue.self) else {
            throw Abort(.notFound)
        }
        try await req.repositories.technology.delete(id)
        return .ok
    }
}
