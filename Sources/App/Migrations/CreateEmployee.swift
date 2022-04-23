//
//  File.swift
//  
//
//  Created by Дарья Воробей on 17.04.22.
//

import Foundation
import Vapor
import Fluent
import SQLKit

struct CreateEmployee: Migration {
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("lavoro").delete()
    }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("employee")
            .id()
            .field("userId", .uuid, .required)
            .field("name", .string, .required)
            .field("surname", .string, .required)
            .field("age", .int, .required)
            .field("location", .string, .required)
            .field("description", .string)
            .field("relocate", .bool)
            .field("interests", .string)
            .create()
    }
}
