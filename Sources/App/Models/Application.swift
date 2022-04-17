//
//  File.swift
//  
//
//  Created by Дарья Воробей on 9.03.22.
//

import Foundation
import Fluent
import Vapor

final class Apply: Model, Content {

    static let schema = "application"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "id")
    var sender: User
    
    @Parent(key: "id")
    var reciever: User
    
    @Parent(key: "id")
    var offer: Offer
    
    @Field(key: "description")
    var description: String
    
    init(id: UUID, sender: User, reciever: User, offer: Offer, description: String) {
        self.id = id
        self.sender = sender
        self.reciever = reciever
        self.offer = offer
        self.description = description
    }
    
    required init() {}
}
