//
//  File.swift
//  
//
//  Created by Дарья Воробей on 17.04.22.
//

import Foundation
import Vapor
import Fluent

protocol Repository {
    init(_ req: Request)
}

extension RepositoryId {
    static let application = RepositoryId("application")
    static let employee = RepositoryId("employee")
    static let offer = RepositoryId("offer")
    static let project = RepositoryId("project")
    static let response = RepositoryId("response")
    static let skill = RepositoryId("skill")
    static let technology = RepositoryId("technology")
}

extension RepositoryFactory {

    var application: ApplicationRepository {
        guard let result = make(.application) as? ApplicationRepository else {
            fatalError("Todo repository is not configured")
        }
        return result
    }
    
    var employee: EmployeeRepository {
        guard let result = make(.employee) as? EmployeeRepository else {
            fatalError("Todo repository is not configured")
        }
        return result
    }
    
    var offer: OfferRepository {
        guard let result = make(.offer) as? OfferRepository else {
            fatalError("Todo repository is not configured")
        }
        return result
    }
    
    var project: ProjectRepository {
        guard let result = make(.project) as? ProjectRepository else {
            fatalError("Todo repository is not configured")
        }
        return result
    }
    
    var response: ResponseRepository {
        guard let result = make(.response) as? ResponseRepository else {
            fatalError("Todo repository is not configured")
        }
        return result
    }
    
    var skill: SkillRepository {
        guard let result = make(.skill) as? SkillRepository else {
            fatalError("Todo repository is not configured")
        }
        return result
    }
    
    var technology: TechnologyRepository {
        guard let result = make(.technology) as? TechnologyRepository else {
            fatalError("Todo repository is not configured")
        }
        return result
    }
}


struct RepositoryId: Hashable, Codable {

    public let string: String
    
    public init(_ string: String) {
        self.string = string
    }
}

final class RepositoryRegistry {

    private let app: Application
    private var builders: [RepositoryId: ((Request) -> Repository)]

    init(_ app: Application) {
        self.app = app
        self.builders = [:]
    }

    func builder(_ req: Request) -> RepositoryFactory {
        .init(req, self)
    }
    
    func make(_ id: RepositoryId, _ req: Request) -> Repository {
        guard let builder = builders[id] else {
            fatalError("Repository for id `\(id.string)` is not configured.")
        }
        return builder(req)
    }
    
    func register(_ id: RepositoryId, _ builder: @escaping (Request) -> Repository) {
        builders[id] = builder
    }
}

