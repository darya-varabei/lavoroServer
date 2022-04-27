//
//  File.swift
//  
//
//  Created by Дарья Воробей on 28.04.22.
//

import Foundation
import Vapor
import Fluent

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
