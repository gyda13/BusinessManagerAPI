//
//  File.swift
//  
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//


import Vapor


struct UsersController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let usersRoutes = routes.grouped("api", "users")
        usersRoutes.get( use: getAllHandler)
        usersRoutes.post( use: creatHandler)
        usersRoutes.get(":userID", use: getHandler)
        usersRoutes.get(":userID", "products", use: getProductHnadler)
        usersRoutes.get(":userID", "inventories", use: getInventoryHnadler)
        
        let basicAuthMiddleware = User.authenticator()
        let basicAuthGroup = usersRoutes.grouped(basicAuthMiddleware)
        basicAuthGroup.post("login", use: loginHandler)
      
        
    }
    
    
    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[User.Public]> {
        User.query(on: req.db).all().convertToPublic()
    }
    
    func creatHandler(_ req: Request) throws -> EventLoopFuture<User.Public> {
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        return user.save(on: req.db).map {
            user.convertToPublic()
        }
    }
    
    func getHandler(_ req: Request) throws -> EventLoopFuture<User.Public> {
        User.find(req.parameters.get("userID"), on: req.db).unwrap(or: Abort(.notFound)).convertToPublic()
    }
    
    
    func getProductHnadler(_ req: Request) throws -> EventLoopFuture<[Product]> {
        User.find(req.parameters.get("userID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { user in
            user.$products.get(on: req.db)
        }
    }
    
    func getInventoryHnadler(_ req: Request) throws -> EventLoopFuture<[Inventory]> {
    
        User.find(req.parameters.get("userID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { user in
            user.$inventories.get(on: req.db)
        }
    }
    
 
    
    func loginHandler(_ req: Request) throws -> EventLoopFuture<Token> {
        
        let user = try req.auth.require(User.self)
        let token = try Token.generate(for: user)
        return token.save(on: req.db).map {token}
    }
 
    
    
    //the middleware will take the username and password past the login rout find the user and authenticate them if the authientication failed 401 error appear
    
    
    
}


