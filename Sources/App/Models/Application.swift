//
//  File.swift
//  
//
//  Created by Дарья Воробей on 9.03.22.
//

import Foundation
import Fluent

final class Apply: Model, Content {

    static let schema = "Model"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "sender_id")
    var sender: User
    
    @Parent(key: "reciever_id")
    var reciever: User
    
    @Parent(key: "offer_id")
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
    
    init() {}
}
