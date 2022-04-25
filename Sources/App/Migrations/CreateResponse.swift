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

struct CreateResponse: Migration {
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("lavoro").delete()
    }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("response")
            .id()
            .field("apply", .uuid, .required)
            .foreignKey("apply", references: Apply.schema, .id)
            .field("description", .string, .required)
            .create()
    }
}
