//
//  File.swift
//  
//
//  Created by Дарья Воробей on 9.03.22.
//

import Foundation
import Fluent

final class UserLogin: Model {
    typealias IDValue = Int
    
    static let schema = "customers"
    
    @ID(key: .id) var user_id: UUID?
    @Field(key: "email") var email: String
    @Field(key: "password") var password: String

    init() { }

    init(id: UUID? = nil, email: String, password: String) {
        self.user_id = id
        self.email = email
        self.password = password
    }
}
