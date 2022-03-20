//
//  File.swift
//  
//
//  Created by Дарья Воробей on 9.03.22.
//

import Foundation
import Fluent

final class Technology: Model, Content {

    static let schema = "technology"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "id")
    var offer_id: Offer
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "level")
    var level: String
    
    init(id: UUID? = nil, name: String, level: String, offer_id: Offer) {
        self.id = id
        self.name  = name
        self.level = level
    }
    
    init() {}
}