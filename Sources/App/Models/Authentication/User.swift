//
//  File.swift
//  
//
//  Created by Дарья Воробей on 9.03.22.
//

import Foundation
import Fluent
import Vapor
import JWT

final class User: Model, Content {
    static let schema = "user"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "login")
    var login: String
    
    @Field(key: "role")
    var role: String
    
    init() { }
    
    init(id: UUID? = nil, login: String, password: String, role: String) {
        self.id = id
        self.login = login
        self.role = role
        self.password = password
    }
}

extension User: ModelAuthenticatable {
    
    static var usernameKey: KeyPath<User, Field<String>> = \User.$login
    static var passwordHashKey: KeyPath<User, Field<String>> = \User.$password
    
    func verify(password: String) throws -> Bool {
        return password == self.password
    }
}

struct JWTBearerAuthentificator: JWTAuthenticator {
    typealias Payload = MyJwtPayload
    
    func authenticate(jwt: Payload, for request: Request) -> EventLoopFuture<Void> {
        do {
            try jwt.verify(using: request.application.jwt.signers.get()!)
            return User
                .find(jwt.id, on: request.db)
                .unwrap(or: Abort(.notFound))
                .map { user in
                    request.auth.login(user)//.log(user)
                }
        } catch {
            return request.eventLoop.makeSucceededVoidFuture()
        }
    }
}

extension User {
    func generateToken(_ app: Application) throws -> String {
        var expDate = Date()
        expDate.addTimeInterval(432000)
        
        let exp = ExpirationClaim(value: expDate)
        
        return try app.jwt.signers.get(kid: .private)!.sign(MyJwtPayload(id: self.id, username: self.login, exp: exp))
    }
}

final class Identifier: Content {
    var id: UUID
    
    init(id: UUID) {
        self.id = id
    }
}
