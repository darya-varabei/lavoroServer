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
    
    app.databases.use(.postgres(
        hostname: Environment.get("PG_HOST") ?? "localhost",
        username: Environment.get("PG_USERNAME") ?? "dariavarabei",
        password: Environment.get("PG_PASSWORD") ?? "admin123",
        database: Environment.get("PG_DATABASE") ?? "iolavoro"
    ), as: .psql)
    
    app.repositories.register(.application) { req in
        
        FluentApplicationRepository(req)
        
    }
    //app.databases.use(.postgres(hostname: "localhost", username: "dariavarabei", password: "admin123"), as: .psql)
    
    app.migrations.add(CreateUser())
    app.migrations.add(CreateApplication())
    app.migrations.add(CreateProject())
    app.migrations.add(CreateEmployee())
    app.migrations.add(CreateOffer())
    app.migrations.add(CreateResponse())
    app.migrations.add(CreateSkill())
    app.migrations.add(CreateTechnology())
    
    let privateKey = try String(contentsOfFile: "/Users/dariavarabei/Desktop/lavoro-server/LavoroAPI/myjwt.key")
    let privateSigner = try JWTSigner.rs256(key: .private(pem: privateKey.bytes))

    let publicKey = try String(contentsOfFile: "/Users/dariavarabei/Desktop/lavoro-server/LavoroAPI/myjwt.key.pub")
    let publicSigner = try JWTSigner.rs256(key: .public(pem: publicKey.bytes))
   
    app.jwt.signers.use(privateSigner, kid: .private)
    app.jwt.signers.use(publicSigner, kid: .public, isDefault: true)
   
    try routes(app)
}
