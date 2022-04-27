//
//  File.swift
//  
//
//  Created by Дарья Воробей on 28.04.22.
//

import Foundation
import Vapor
import Fluent

protocol OfferRepository: Repository {
    func query() -> QueryBuilder<Offer>
    func query(_ id: Offer.IDValue) -> QueryBuilder<Offer>
    func query(_ ids: [Offer.IDValue]) -> QueryBuilder<Offer>
    func list() async throws -> [Offer]
    func get(_ ids: [Offer.IDValue]) async throws -> [Offer]
    func get(_ id: Offer.IDValue) async throws -> Offer?
    func create(_ model: Offer) async throws -> Offer
    func update(_ model: Offer) async throws -> Offer
    func delete(_ ids: [Offer.IDValue]) async throws
    func delete(_ id: Offer.IDValue) async throws
}
