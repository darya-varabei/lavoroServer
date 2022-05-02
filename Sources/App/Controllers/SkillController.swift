//
//  File.swift
//  
//
//  Created by Дарья Воробей on 17.04.22.
//

import Foundation
import Vapor
import Fluent

struct SkillRepositoryImpl: SkillRepository {
    var req: Request
    
    public init(_ req: Request) {
        self.req = req
    }
    
    func query() -> QueryBuilder<Skill> {
        Skill.query(on: req.db)
    }

    func query(_ id: Skill.IDValue) -> QueryBuilder<Skill> {
        query().filter(\.$id == id)
    }

    func query(_ ids: [Skill.IDValue]) -> QueryBuilder<Skill> {
        query().filter(\.$id ~~ ids)
    }

    func list() async throws -> [Skill] {
        try await query().all()
    }

    func get(_ id: Skill.IDValue) async throws -> Skill? {
        try await get([id]).first
    }

    func get(_ ids: [Skill.IDValue]) async throws -> [Skill] {
        try await query(ids).all()
    }

    func create(_ model: Skill) async throws -> Skill {
        try await model.create(on: req.db)
        return model
    }

    func update(_ model: Skill) async throws -> Skill {
        try await model.update(on: req.db)
        return model
    }

    func delete(_ id: Skill.IDValue) async throws {
        try await delete([id])
    }

    func delete(_ ids: [Skill.IDValue]) async throws {
        try await query(ids).delete()
    }
}


struct SkillController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let skill = routes.grouped("skill")//.grouped(JWTBearerAuthentificator)
        
        skill.group("list") { user in
            user.get(use: index)
        }
        
        skill.group("create") { user in
            user.post(use: create)
        }
        
        skill.group("user") { user in
            user.get(use: find)
        }
    }
    
    func index(req: Request) async throws -> [Skill] {
        try await req.repositories.skill.list()
    }
    
    func find(req: Request) async throws -> [Skill] {
        //let userId = req.parameters.get(":id")
        let userId = try? req.query.get(UUID.self, at: "id")
        print(userId)
        return try await req.repositories.skill.list()//.filter { $0.$owner.$id. == userId }//{ String(describing: $0.$owner.$id) == userId }
    }
    
    func create(req: Request) async throws -> Skill {
        let application = try req.content.decode(Skill.self)
        return try await req.repositories.skill.create(application)
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let id = req.parameters.get("id", as: Skill.IDValue.self) else {
            throw Abort(.notFound)
        }
        try await req.repositories.skill.delete(id)
        return .ok
    }
}
