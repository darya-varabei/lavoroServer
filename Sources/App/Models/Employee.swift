//
//  File.swift
//  
//
//  Created by Дарья Воробей on 9.03.22.
//

import Foundation
import Fluent
import Vapor

final class Employee: Model, Content {
    static let schema = "employee"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "id")
    var user: User
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "surname")
    var surname: String
    
    @Field(key: "age")
    var age: Int
    
    @Field(key: "location")
    var location: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "relocate")
    var relocate: Bool
    
    @Field(key: "interests")
    var interests: String
    
    @Field(key: "photo")
    var photo: Data
    
    @Children(for: \.$owner)
    var skills: [Skill]
    
    required init() {}
    
    init(id: UUID? = nil, name: String, surname: String, age: Int, location: String, description: String, relocate: Bool, interests: String) {
        self.id = id
        self.name = name
        self.surname = surname
        self.age = age
        self.location = location
        self.description = description
        self.relocate = relocate
        self.interests = interests
    }
}
