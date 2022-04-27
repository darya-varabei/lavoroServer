//
//  File.swift
//  
//
//  Created by Дарья Воробей on 28.04.22.
//

import Foundation
import Vapor
import Fluent

protocol EmployeeRepository: Repository {
    func query() -> QueryBuilder<Employee>
    func query(_ id: Employee.IDValue) -> QueryBuilder<Employee>
    func query(_ ids: [Employee.IDValue]) -> QueryBuilder<Employee>
    func list() async throws -> [Employee]
    func get(_ ids: [Employee.IDValue]) async throws -> [Employee]
    func get(_ id: Employee.IDValue) async throws -> Employee?
    func create(_ model: Employee) async throws -> Employee
    func update(_ model: Employee) async throws -> Employee
    func delete(_ ids: [Employee.IDValue]) async throws
    func delete(_ id: Employee.IDValue) async throws
}
