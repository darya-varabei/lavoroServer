//
//  File.swift
//  
//
//  Created by Дарья Воробей on 9.03.22.
//

import Foundation
import Fluent

final class Offer: Model, Content {
  
    static let schema = "offer"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "project_id")
    var project: Project
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "location")
    var location: String
    
    @Field(key: "description")
    var description: String
    
    @Children(for: \.$offer_id)
    var technologies: [Technology]
    
    init() {}
    
    init(id: UUID, name: String, location: String, description: String, technologies: [Technology]) {
        self.id = id
        self.name = name
        self.location = location
        self.description = description
        self.technologies = technologies
    }
}
