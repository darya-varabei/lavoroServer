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

struct CreateApplication: Migration {
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("lavoro").delete()
    }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("application")
            .id()
            .field("sender", .uuid, .required)
            .field("reciever", .uuid, .required)
            .field("offer", .uuid, .required)
            .field("description", .string)
            .create()
    }
}
