//
//  File.swift
//  
//
//  Created by Дарья Воробей on 9.03.22.
//

import Foundation
import Fluent
import Vapor

final class Project: Model, Content {
   
    static let schema = "project"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: .id)
    var user: User
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "location")
    var location: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "category")
    var category: String
    
    @Field(key: "mode")
    var mode: String
    
    @Field(key: "photo")
    var photo: Data?
    
    @Children(for: \.$project)
    var offers: [Offer]
    
    required init() {}
    
    init(project_id: UUID, owner: User, name: String, location: String, description: String, offers: [Offer], user: UUID) {
        self.id = project_id
        self.name = name
        self.location = location
        self.description = description
        self.offers = offers
        self.$user.id = user
    }
}
