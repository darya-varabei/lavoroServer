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

struct CreateProject: Migration {
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("lavoro").delete()
    }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("project")
            .id()
            .field("owner", .uuid, .required)
            .field("name", .string, .required)
            .field("location", .string, .required)
            .field("description", .string)
            .field("photo", .data, .required)
    }
}
