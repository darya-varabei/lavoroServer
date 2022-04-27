//
//  File.swift
//  
//
//  Created by Дарья Воробей on 28.04.22.
//

import Foundation
import Vapor
import Fluent

protocol TechnologyRepository: Repository {
    func query() -> QueryBuilder<Technology>
    func query(_ id: Technology.IDValue) -> QueryBuilder<Technology>
    func query(_ ids: [Technology.IDValue]) -> QueryBuilder<Technology>
    func list() async throws -> [Technology]
    func get(_ ids: [Technology.IDValue]) async throws -> [Technology]
    func get(_ id: Technology.IDValue) async throws -> Technology?
    func create(_ model: Technology) async throws -> Technology
    func update(_ model: Technology) async throws -> Technology
    func delete(_ ids: [Technology.IDValue]) async throws
    func delete(_ id: Technology.IDValue) async throws
}
