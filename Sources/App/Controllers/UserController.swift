//
//  File.swift
//  
//
//  Created by Дарья Воробей on 11.03.22.
//

import Foundation
import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        
        users.group("login") { user in
            print("login")
            user.post(use: login)
        }
        users.group("register") { user in
            print("register")
            user.post(use: create)
        }
        users
            .grouped(JWTBearerAuthentificator())
            .group("me") { usr in
                usr.get(use: me)
            }
    }
    
    func me(req: Request) throws -> EventLoopFuture<Me> {
        let user = try req.auth.require(User.self)
        let username = user.login
        
        return User.query(on: req.db)
            .filter(\.$login == username)
            .first()
            .unwrap(or: Abort(.notFound))
            .map { usr in
                return Me(id: UUID(), email: user.login)
            }
    }
    
    func login(req: Request) throws -> EventLoopFuture<String> {
        let userToLogin = try req.content.decode(UserLogin.self)
        return User.query(on: req.db)
            .filter(\.$login == userToLogin.login)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { dbUser in
                let verified = try dbUser.verify(password: dbUser.password)
                if verified == false {
                    throw Abort(.unauthorized)
                }
                req.auth.login(dbUser)
                let user = try req.auth.require(User.self)
                return try user.generateToken(req.application)
            }
    }
    
//    func register(req: Request) throws -> EventLoopFuture<String> {
//        let userToLogin = try req.content.decode(UserLogin.self)
//        try create(req: req)
//        try login(req: req)
//    }
    
    func get(req: Request) throws -> EventLoopFuture<User> {
        return User.query(on: req.db)
            .filter(\.$login == req.parameters.get("login")!)
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    func create(req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        return user.create(on: req.db).map { user }
    }
}
