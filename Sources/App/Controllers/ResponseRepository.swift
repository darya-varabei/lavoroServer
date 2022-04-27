//
//  File.swift
//  
//
//  Created by Дарья Воробей on 28.04.22.
//

import Foundation
import Vapor
import Fluent

protocol ResponseRepository: Repository {
    func query() -> QueryBuilder<Response>
    func query(_ id: Response.IDValue) -> QueryBuilder<Response>
    func query(_ ids: [Response.IDValue]) -> QueryBuilder<Response>
    func list() async throws -> [Response]
    func get(_ ids: [Response.IDValue]) async throws -> [Response]
    func get(_ id: Response.IDValue) async throws -> Response?
    func create(_ model: Response) async throws -> Response
    func update(_ model: Response) async throws -> Response
    func delete(_ ids: [Response.IDValue]) async throws
    func delete(_ id: Response.IDValue) async throws
}
