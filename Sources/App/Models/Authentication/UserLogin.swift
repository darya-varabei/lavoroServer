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

final class UserLogin: Model, Content {
    static let schema = "Model"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Children(for: \.$user)
    var user: User
    
    init() { }
    
    init(id: UUID? = nil, email: String, password: String) {
        self.user_id = id
        self.email = email
        self.password = password
    }
}

extension UserLogin: ModelAuthenticatable {
    
    static var usernameKey: KeyPath<User, Field<String>> = \User.$username
    static var passwordHashKey: KeyPath<User, Field<String>> = \User.$password
    
    func verify(password: String) throws -> Bool {
        return try Bcrypt.verify(password, created: self.password)
    }
}

struct JWTBearerAuthentificator: JWTAuthenticator {
    typealias Payload = 
}
