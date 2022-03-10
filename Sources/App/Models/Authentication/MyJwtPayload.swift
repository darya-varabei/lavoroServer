//
//  File.swift
//  
//
//  Created by Дарья Воробей on 10.03.22.
//

import Vapor
import JWT

struct MyJwtPayload: Authenticatable, JWTPayload {
    var id: UUID?
    var username: String
    var exp: ExpirationClaim
    
    func verify(using signer: JWTSigner) throws {
        try self.exp.verifyNotExpired()
    }
}
