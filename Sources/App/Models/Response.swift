//
//  File.swift
//  
//
//  Created by Дарья Воробей on 17.04.22.
//

import Foundation
import Fluent
import Vapor

final class Response: Model, Content {

    static let schema = "response"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: .id)
    var application: Apply
    
    @Field(key: "description")
    var description: String
    
    init(id: UUID, application: Apply, description: String) {
        self.id = id
        self.application = application
        self.description = description
    }
    
    required init() {}
}
