//
//  File.swift
//  
//
//  Created by Дарья Воробей on 30.04.22.
//

import Foundation
import Vapor

struct CurrentUser: Content {

    var id: UUID
    var role: String
    var token: String
    
    init(id: UUID, role: String, token: String) {
        self.id = id
        self.role = role
        self.token = token
    }
}
