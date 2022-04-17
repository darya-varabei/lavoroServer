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
    
    /// query the models and filter by an identifier
    func query(_ id: Apply.IDValue) -> QueryBuilder<Apply> {
        query().filter(\.$id == id)
    }
    
    /// query the models and filter by multiple identifiers
    func query(_ ids: [Apply.IDValue]) -> QueryBuilder<Apply> {
        query().filter(\.$id ~~ ids)
    }
    
    /// list all the available Todo items
    func list() async throws -> [Apply] {
        try await query().all()
    }
    
    /// get one Todo item by an identifier if it exists
    func get(_ id: Apply.IDValue) async throws -> Apply? {
        try await get([id]).first
    }
    
    /// get the list of the Todo items by multiple identifiers
    func get(_ ids: [Apply.IDValue]) async throws -> [Apply] {
        try await query(ids).all()
    }
    
    /// create a Todo model and return the updated model (with an id)
    func create(_ model: Apply) async throws -> Apply {
        try await model.create(on: req.db)
        return model
    }
    
    /// update a Todo model
    func update(_ model: Apply) async throws -> Apply {
        try await model.update(on: req.db)
        return model
    }
    
    /// delete a Todo item based on the identifier
    func delete(_ id: Apply.IDValue) async throws {
        try await delete([id])
    }
    
    /// delete multiple Todo items based on id values
    func delete(_ ids: [Apply.IDValue]) async throws {
        try await query(ids).delete()
    }
}


struct ApplicationController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let application = routes.grouped("application")
        application.get(use: index)
        application.post(use: create)
        application.group(":applicationID") { todo in
            todo.delete(use: delete)
        }
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
