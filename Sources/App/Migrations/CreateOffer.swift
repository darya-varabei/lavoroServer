//
//  File.swift
//  
//
//  Created by Дарья Воробей on 17.04.22.
//

import Foundation
import Fluent

struct CreateOffer: Migration {
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("lavoro").delete()
    }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("offer")
            .id()
            .field("owner", .uuid, .required)
            .foreignKey("owner", references: Project.schema, .id)
            .field("name", .string, .required)
            .field("location", .string, .required)
            .field("description", .string)
            .create()
    }
}
