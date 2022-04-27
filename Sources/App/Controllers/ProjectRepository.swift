//
//  File.swift
//  
//
//  Created by Дарья Воробей on 28.04.22.
//

import Foundation
import Vapor
import Fluent

protocol ProjectRepository: Repository {
    func query() -> QueryBuilder<Project>
    func query(_ id: Project.IDValue) -> QueryBuilder<Project>
    func query(_ ids: [Project.IDValue]) -> QueryBuilder<Project>
    func list() async throws -> [Project]
    func get(_ ids: [Project.IDValue]) async throws -> [Project]
    func get(_ id: Project.IDValue) async throws -> Project?
    func create(_ model: Project) async throws -> Project
    func update(_ model: Project) async throws -> Project
    func delete(_ ids: [Project.IDValue]) async throws
    func delete(_ id: Project.IDValue) async throws
}
