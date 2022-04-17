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
        return database.schema("lavoro").delete()
    }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("technology")
            .id()
            .field("offer_id", .uuid, .required)
            .field("name", .string)
            .field("level", .string)
            .create()
    }
}
