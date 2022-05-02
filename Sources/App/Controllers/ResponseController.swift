//
//  File.swift
//  
//
//  Created by Дарья Воробей on 17.04.22.
//

import Foundation
import Vapor
import Fluent

struct ResponseRepositoryImpl: ResponseRepository {
    var req: Request
    
    public init(_ req: Request) {
        self.req = req
    }
    
    func query() -> QueryBuilder<Response> {
        Response.query(on: req.db)
    }

    func query(_ id: Response.IDValue) -> QueryBuilder<Response> {
        query().filter(\.$id == id)
    }

    func query(_ ids: [Response.IDValue]) -> QueryBuilder<Response> {
        query().filter(\.$id ~~ ids)
    }

    func list() async throws -> [Response] {
        try await query().all()
    }

    func get(_ id: Response.IDValue) async throws -> Response? {
        try await get([id]).first
    }

    func get(_ ids: [Response.IDValue]) async throws -> [Response] {
        try await query(ids).all()
    }

    func create(_ model: Response) async throws -> Response {
        try await model.create(on: req.db)
        return model
    }

    func update(_ model: Response) async throws -> Response {
        try await model.update(on: req.db)
        return model
    }

    func delete(_ id: Response.IDValue) async throws {
        try await delete([id])
    }

    func delete(_ ids: [Response.IDValue]) async throws {
        try await query(ids).delete()
    }
}


struct ResponseController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let responses = routes.grouped("response")
            //.grouped(JWTBearerAuthentificator)
        
        responses.group("list") { user in
            user.get(use: index)
        }
        
        responses.group("create") { user in
            user.post(use: create)
        }
    }
    
    func index(req: Request) async throws -> [Response] {
        try await req.repositories.response.list()
    }
    
    func create(req: Request) async throws -> Response {
        let response = try req.content.decode(Response.self)
        return try await req.repositories.response.create(response)
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let id = req.parameters.get("id", as: Response.IDValue.self) else {
            throw Abort(.notFound)
        }
        try await req.repositories.response.delete(id)
        return .ok
    }
}
