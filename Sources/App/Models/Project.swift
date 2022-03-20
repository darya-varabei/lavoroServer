//
//  File.swift
//  
//
//  Created by Дарья Воробей on 9.03.22.
//

import Foundation
import Fluent

class Project: Model, Content {
   
    static let schema = "Model"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var owner: User
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "location")
    var location: String
    
    @Field(key: "descripttion")
    var description: String
    
    @Children(for: \.$id)
    var offers: [Offer]
    
    required init() {}
    
    init(project_id: UUID, owner: User, name: String, location: String, description: String, offers: [Offer]) {
        self.id = project_id
        self.owner = owner
        self.name = name
        self.location = location
        self.description = description
        self.offers = offers
    }
}
