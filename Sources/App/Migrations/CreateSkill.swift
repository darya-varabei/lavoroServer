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

struct CreateSkill: Migration {
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("lavoro").delete()
    }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("skill")
            .id()
            .field("name", .string, .required)
            .field("owner", .uuid, .required)
            .foreignKey("owner", references: Employee.schema, .id)
            .field("level", .string)
            .create()
    }
}
