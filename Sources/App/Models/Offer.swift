//
//  File.swift
//  
//
//  Created by Дарья Воробей on 9.03.22.
//

import Foundation
import Fluent

final class Offer: Model, Content {
  
    static let schema = "Model"
    
    @ID(key: .id)
    var id: UUID?
    
//    @Parent(key: "project_id")
//    var project_id: Project
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "location")
    var location: String
    
    @Field(key: "description")
    var description: String
    
    @Children(for: \.$id)
    var technologies: [Technology]
    
    init() {}
}
