import Fluent
import FluentPostgresDriver
import Vapor
import JWT

extension String {
    var bytes: [UInt8] { .init(self.utf8) }
}

extension JWKIdentifier {
    static let `public` = JWKIdentifier(string: "public")
    static let `private` = JWKIdentifier(string: "private")
}

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

//    app.databases.use(.postgres(
//        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
//        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
//        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
//        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
//        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
//    ), as: .psql)
    // configure.swift
    app.repositories.register(.application) { req in
        
        FluentApplicationRepository(req)
        
    }
    app.databases.use(.postgres(hostname: "localhost", username: "dariavarabei", password: "admin123"), as: .psql)
    
    app.migrations.add(CreateUser())
    app.migrations.add(CreateApplication())
    app.migrations.add(CreateEmployee())
    app.migrations.add(CreateOffer())
    app.migrations.add(CreateProject())
    app.migrations.add(CreateResponse())
    app.migrations.add(CreateSkill())
    app.migrations.add(CreateTechnology())
    
    let privateKey = try String(contentsOfFile: app.directory.workingDirectory + "myjwt.key")
    let privateSigner = try JWTSigner.rs256(key: .private(pem: privateKey.bytes))

    let publicKey = try String(contentsOfFile: app.directory.workingDirectory + "myjwt.key.pub")
    let publicSigner = try JWTSigner.rs256(key: .public(pem: publicKey.bytes))
   
    app.jwt.signers.use(privateSigner, kid: .private)
    app.jwt.signers.use(publicSigner, kid: .public, isDefault: true)
    // register routes
    try routes(app)
}
