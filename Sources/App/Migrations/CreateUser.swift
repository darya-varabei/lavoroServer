//
//  File.swift
//  
//
//  Created by Дарья Воробей on 12.03.22.
//

import Foundation
import Vapor
import Fluent
import SQLKit

struct CreateUser: Migration {
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("lavoro").delete()
    }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("user")
            .id()
            .field("login", .string, .required)
            .field("role", .string, .required)
            .field("password", .string)
            .field("photo", .data)
            .update()
    }
}
