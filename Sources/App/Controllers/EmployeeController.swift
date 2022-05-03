//
//  File.swift
//  
//
//  Created by Дарья Воробей on 17.04.22.
//

import Foundation
import Vapor
import Fluent

struct EmployeeRepositoryImpl: EmployeeRepository {
    var req: Request
    
    public init(_ req: Request) {
        self.req = req
    }
    
    func query() -> QueryBuilder<Employee> {
        Employee.query(on: req.db)
    }

    func query(_ id: User.IDValue) -> QueryBuilder<Employee> {
        query().filter(\.$user.$id == id)
    }

    func query(_ ids: [Employee.IDValue]) -> QueryBuilder<Employee> {
        query().filter(\.$id ~~ ids)
    }

    func list() async throws -> [Employee] {
        try await query().with(\.$skills).all()
    }

    func get(_ id: Employee.IDValue) async throws -> Employee? {
        try await get([id]).first
    }

    func get(_ ids: [Employee.IDValue]) async throws -> [Employee] {
        try await query(ids).all()
    }

    func create(_ model: Employee) async throws -> Employee {
        try await model.create(on: req.db)
        return model
    }

    func update(_ model: Employee) async throws -> Employee {
        try await model.update(on: req.db)
        return model
    }

    func delete(_ id: Employee.IDValue) async throws {
        try await delete([id])
    }

    func delete(_ ids: [Employee.IDValue]) async throws {
        try await query(ids).delete()
    }
}


struct EmployeeController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let employee = routes.grouped("applicant")
           // .grouped(JWTBearerAuthentificator)
        
        employee.group("list") { user in
            user.get(use: index)
        }
        
        employee.group("create") { user in
            user.post(use: create)
        }
        
        employee.group("update") { user in
            user.put(use: update)
        }
        
        employee.group("delete") { user in
            user.delete(use: delete)
        }
        
        employee.group("getSingle") { user in
            user.post(use: getById)
        }
    }
    
    func index(req: Request) async throws -> [Employee] {
        try await req.repositories.employee.list()
    }
    
    func getById(req: Request) async throws -> Employee {
        let application = try req.content.decode(Identifier.self)
        return try await req.repositories.employee.query(application.id).first()!
    }
    
    func create(req: Request) async throws -> Employee {
        let application = try req.content.decode(Employee.self)
        return try await req.repositories.employee.create(application)
    }
    
    func update(req: Request) async throws -> Employee {
        let application = try req.content.decode(Employee.self)
        return try await req.repositories.employee.update(application)
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        let application = try req.content.decode(Employee.self)
        try await req.repositories.employee.delete(application.id!)
        return .ok
    }
}
