//
//  File.swift
//  
//
//  Created by Дарья Воробей on 9.03.22.
//

import Foundation
import Fluent
import Vapor

final class Offer: Model, Content {
  
    static let schema = "offer"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "owner")
    var project: Project
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "relocate")
    var relocate: Bool
    
    @Field(key: "mode")
    var mode: String
    
    @Field(key: "salary")
    var salary: String
    
    @Field(key: "location")
    var location: String
    
    @Field(key: "description")
    var description: String
    
    @Children(for: \.$offer_id)
    var technologies: [Technology]
    
    required init() {}
    
    init(id: UUID, name: String, location: String, description: String, technologies: [Technology], salary: String, mode: String, relocate: Bool) {
        self.id = id
        self.name = name
        self.location = location
        self.description = description
        self.technologies = technologies
        self.salary = salary
        self.mode = mode
        self.relocate = relocate
    }
}
