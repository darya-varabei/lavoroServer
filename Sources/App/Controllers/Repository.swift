//
//  File.swift
//  
//
//  Created by Дарья Воробей on 17.04.22.
//

import Foundation
import Vapor
import Fluent

protocol Repository {
    init(_ req: Request)
}

protocol ApplicationRepository: Repository {
    func query() -> QueryBuilder<Apply>
    func query(_ id: Apply.IDValue) -> QueryBuilder<Apply>
    func query(_ ids: [Apply.IDValue]) -> QueryBuilder<Apply>
    func list() async throws -> [Apply]
    func get(_ ids: [Apply.IDValue]) async throws -> [Apply]
    func get(_ id: Apply.IDValue) async throws -> Apply?
    func create(_ model: Apply) async throws -> Apply
    func update(_ model: Apply) async throws -> Apply
    func delete(_ ids: [Apply.IDValue]) async throws
    func delete(_ id: Apply.IDValue) async throws
}

extension RepositoryId {
    static let application = RepositoryId("application")
}

extension RepositoryFactory {

    var application: ApplicationRepository {
        guard let result = make(.application) as? ApplicationRepository else {
            fatalError("Todo repository is not configured")
        }
        return result
    }
}


struct RepositoryId: Hashable, Codable {

    public let string: String
    
    public init(_ string: String) {
        self.string = string
    }
}

final class RepositoryRegistry {

    private let app: Application
    private var builders: [RepositoryId: ((Request) -> Repository)]

    init(_ app: Application) {
        self.app = app
        self.builders = [:]
    }

    func builder(_ req: Request) -> RepositoryFactory {
        .init(req, self)
    }
    
    func make(_ id: RepositoryId, _ req: Request) -> Repository {
        guard let builder = builders[id] else {
            fatalError("Repository for id `\(id.string)` is not configured.")
        }
        return builder(req)
    }
    
    func register(_ id: RepositoryId, _ builder: @escaping (Request) -> Repository) {
        builders[id] = builder
    }
}

