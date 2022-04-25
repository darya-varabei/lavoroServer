//
//  File.swift
//  
//
//  Created by Дарья Воробей on 9.03.22.
//

import Foundation
import Fluent
import Vapor

extension FieldKey {
    static var sender: Self { "sender" }
    static var reciever: Self { "reciever" }
    static var offer: Self { "offer" }
    static var description: Self { "description" }
}


final class Apply: Model, Content {

    static let schema = "apply"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: .sender)
    var sender: User
    
    @Field(key: "reciever")
    var reciever: UUID
    
    @Parent(key: .offer)
    var offer: Offer
    
    @Field(key: "description")
    var description: String
    
    init(id: UUID, sender: User, reciever: UUID, offer: Offer, description: String, senderId: UUID) {
        self.id = id
        self.reciever = reciever
        self.offer = offer
        self.description = description
        self.$sender.id = senderId
    }
    
    required init() {}
}
