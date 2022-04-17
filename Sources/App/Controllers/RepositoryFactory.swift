//
//  File.swift
//  
//
//  Created by Дарья Воробей on 18.04.22.
//

import Foundation
import Vapor
import Fluent

struct RepositoryFactory {
    private var registry: RepositoryRegistry
    private var req: Request
    
     init(_ req: Request, _ registry: RepositoryRegistry) {
        self.req = req
        self.registry = registry
    }

    func make(_ id: RepositoryId) -> Repository {
        registry.make(id, req)
    }
}

extension Application {

    private struct Key: StorageKey {
        typealias Value = RepositoryRegistry
    }
    
    var repositories: RepositoryRegistry {
        if storage[Key.self] == nil {
            storage[Key.self] = .init(self)
        }
        return storage[Key.self]!
    }
}

extension Request {
    
    var repositories: RepositoryFactory {
        application.repositories.builder(self)
    }
}
