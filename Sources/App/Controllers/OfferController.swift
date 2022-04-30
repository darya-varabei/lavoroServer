//
//  File.swift
//  
//
//  Created by Дарья Воробей on 17.04.22.
//

import Foundation
import Vapor
import Fluent

struct OfferRepositoryImpl: OfferRepository {
    var req: Request
    
    public init(_ req: Request) {
        self.req = req
    }
    
    func query() -> QueryBuilder<Offer> {
        Offer.query(on: req.db)
    }

    func query(_ id: Offer.IDValue) -> QueryBuilder<Offer> {
        query().filter(\.$id == id)
    }

    func query(_ ids: [Offer.IDValue]) -> QueryBuilder<Offer> {
        query().filter(\.$id ~~ ids)
    }

    func list() async throws -> [Offer] {
        try await query().all()
    }

    func get(_ id: Offer.IDValue) async throws -> Offer? {
        try await get([id]).first
    }

    func get(_ ids: [Offer.IDValue]) async throws -> [Offer] {
        try await query(ids).all()
    }

    func create(_ model: Offer) async throws -> Offer {
        try await model.create(on: req.db)
        return model
    }

    func update(_ model: Offer) async throws -> Offer {
        try await model.update(on: req.db)
        return model
    }

    func delete(_ id: Offer.IDValue) async throws {
        try await delete([id])
    }

    func delete(_ ids: [Offer.IDValue]) async throws {
        try await query(ids).delete()
    }
}


struct OfferController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let offer = routes.grouped("offer")//.grouped(JWTBearerAuthentificator)
        
        offer.group("list") { user in
            user.post(use: index)
        }
        
        offer.group("create") { user in
            user.post(use: create)
        }
    }
    
    func index(req: Request) async throws -> [Offer] {
        try await req.repositories.offer.list()
    }
    
    func create(req: Request) async throws -> Offer {
        let application = try req.content.decode(Offer.self)
        return try await req.repositories.offer.create(application)
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let id = req.parameters.get("id", as: Offer.IDValue.self) else {
            throw Abort(.notFound)
        }
        try await req.repositories.offer.delete(id)
        return .ok
    }
}
