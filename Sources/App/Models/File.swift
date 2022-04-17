//
//  File.swift
//  
//
//  Created by Дарья Воробей on 17.04.22.
//

import Foundation
import Fluent

final class Response: Model, Content {

    static let schema = "application"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "id")
    var application: Application
    
    @Field(key: "description")
    var description: String
    
    init(id: UUID, application: Application, description: String) {
        self.id = id
        self.application = application
        self.description = description
    }
    
    init() {}
}
