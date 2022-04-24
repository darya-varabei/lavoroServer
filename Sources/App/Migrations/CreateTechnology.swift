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

struct CreateTechnology: Migration {
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("iolavoro").delete()
    }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("technology")
            .id()
            .field("owner", .uuid, .required)
            .foreignKey("owner", references: Offer.schema, .id)
            .field("name", .string)
            .field("level", .string)
            .create()
    }
}
