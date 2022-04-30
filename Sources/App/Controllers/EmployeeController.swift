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

    func query(_ id: Employee.IDValue) -> QueryBuilder<Employee> {
        query().filter(\.$id == id)
    }

    func query(_ ids: [Employee.IDValue]) -> QueryBuilder<Employee> {
        query().filter(\.$id ~~ ids)
    }

    func list() async throws -> [Employee] {
        try await query().all()
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
        let employee = routes.grouped("employee")
           // .grouped(JWTBearerAuthentificator)
        
        employee.group("list") { user in
            user.get(use: index)
        }
        
        employee.group("create") { user in
            user.post(use: create)
        }
    }
    
    func index(req: Request) async throws -> [Employee] {
        try await req.repositories.employee.list()
    }
    
    func create(req: Request) async throws -> Employee {
        let application = try req.content.decode(Employee.self)
        return try await req.repositories.employee.create(application)
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let id = req.parameters.get("id", as: Employee.IDValue.self) else {
            throw Abort(.notFound)
        }
        try await req.repositories.employee.delete(id)
        return .ok
    }
}


//struct EmployeeRepository: ApplicationRepository {
//    var req: Request
//    
//    public init(_ req: Request) {
//        self.req = req
//    }
//    
//    func query() -> QueryBuilder<Employee> {
//        Employee.query(on: req.db)
//    }
//
//    func query(_ id: Employee.IDValue) -> QueryBuilder<Employee> {
//        query().filter(\.$id == id)
//    }
//
//    func query(_ ids: [Employee.IDValue]) -> QueryBuilder<Employee> {
//        query().filter(\.$id ~~ ids)
//    }
//
//    func list() async throws -> [Employee] {
//        try await query().all()
//    }
//
//    func get(_ id: Employee.IDValue) async throws -> Employee? {
//        try await get([id]).first
//    }
//
//    func get(_ ids: [Employee.IDValue]) async throws -> [Employee] {
//        try await query(ids).all()
//    }
//
//    func create(_ model: Employee) async throws -> Employee {
//        try await model.create(on: req.db)
//        return model
//    }
//
//    func update(_ model: Employee) async throws -> Employee {
//        try await model.update(on: req.db)
//        return model
//    }
//
//    func delete(_ id: Employee.IDValue) async throws {
//        try await delete([id])
//    }
//
//    func delete(_ ids: [Employee.IDValue]) async throws {
//        try await query(ids).delete()
//    }
//}
//
//
//struct EmployeeController: RouteCollection {
//    
//    func boot(routes: RoutesBuilder) throws {
//        let employee = routes.grouped("employee")
//        employee.get(use: index)
//        employee.post(use: create)
//        employee.group(":employeeID") { employee in
//            employee.delete(use: delete)
//        }
//    }
//    
//    func index(req: Request) async throws -> [Employee] {
//        try await req.repositories.application.list()
//    }
//    
//    func create(req: Request) async throws -> Employee {
//        let employee = try req.content.decode(Employee.self)
//        return try await req.repositories.application.create(employee)
//    }
//    
//    func delete(req: Request) async throws -> HTTPStatus {
//        guard let id = req.parameters.get("employeeID", as: Employee.IDValue.self) else {
//            throw Abort(.notFound)
//        }
//        try await req.repositories.application.delete(id)
//        return .ok
//    }
//}
