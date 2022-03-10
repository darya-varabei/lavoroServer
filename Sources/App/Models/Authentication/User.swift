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

//final class UserLogin: Model {
//    typealias IDValue = Int
//
//    static let schema = "customers"
//
//    @ID(key: .id) var user_id: UUID?
//    @Field(key: "email") var email: String
//    @Field(key: "password") var password: String
//
//    init() { }
//
//    init(id: UUID? = nil, email: String, password: String) {
//        self.user_id = id
//        self.email = email
//        self.password = password
//    }
//}

final class User: Model, Content {
    static let schema = "Model"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
//    @Children(for: \.$user)
//    var user: UserLogin
    
    init() { }
    
    init(id: UUID? = nil, email: String, password: String) {
        self.id = id
        self.email = email
        self.password = password
    }
}

extension User: ModelAuthenticatable {
    
    static var usernameKey: KeyPath<User, Field<String>> = \User.$email
    static var passwordHashKey: KeyPath<User, Field<String>> = \User.$password
    
    func verify(password: String) throws -> Bool {
        return try Bcrypt.verify(password, created: self.password)
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
                    request.auth.login(user)
                }
        } catch {
            return request.eventLoop.makeSucceededFuture()
        }
    }
}

extension User {
    func generateToken(_ app: Application) throws -> String {
        var expDate = Date()
        expDate.addTimeInterval(432000)
        
        let exp = ExpirationClaim(value: expDate)
        
        return try app.jwt.signers.get(kid: .private)!.sign(MyJwtPayload(id: self.id, username: self.email, exp: exp))
    }
}
