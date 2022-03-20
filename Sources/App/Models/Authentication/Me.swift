//
//  File.swift
//  
//
//  Created by Дарья Воробей on 12.03.22.
//

import Foundation
import Vapor

struct Me: Content {
    var id: UUID?
    var email: String
}
