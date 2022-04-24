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
        return database.schema("apply")
            .id()
//            .foreignKey(.sender, references: User.schema, .id)
//            .foreignKey(.reciever, references: User.schema, .id)
//            .foreignKey(.offer, references: Offer.schema, .id)
            .field("description", .string)
            .create()
    }
}
