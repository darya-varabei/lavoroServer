//
//  File.swift
//  
//
//  Created by Дарья Воробей on 28.04.22.
//

import Foundation
import Vapor
import Fluent

protocol SkillRepository: Repository {
    func query() -> QueryBuilder<Skill>
    func query(_ id: Skill.IDValue) -> QueryBuilder<Skill>
    func query(_ ids: [Skill.IDValue]) -> QueryBuilder<Skill>
    func list() async throws -> [Skill]
    func get(_ ids: [Skill.IDValue]) async throws -> [Skill]
    func get(_ id: Skill.IDValue) async throws -> Skill?
    func create(_ model: Skill) async throws -> Skill
    func update(_ model: Skill) async throws -> Skill
    func delete(_ ids: [Skill.IDValue]) async throws
    func delete(_ id: Skill.IDValue) async throws
}
