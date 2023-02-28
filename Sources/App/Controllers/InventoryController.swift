//
//  File.swift
//  
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//

import Vapor
import Fluent


struct InventoryController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let inventoryRoutes = routes.grouped("api", "inventories")
        inventoryRoutes.get( use: getAllHandler)
        inventoryRoutes.get(":inventoryID", use: getHandler)
      
        inventoryRoutes.get(":inventoryID", "user", use: getUserHnadler)
    

        inventoryRoutes.get("search", use: searchHandler)
        
        
        let tokenAuthMiddleware = Token.authenticator()
        let guardAuthMiddleware = User.guardMiddleware()
        let tokenAuthGroup =  inventoryRoutes.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        
        tokenAuthGroup.post( use: creatHandler)
        tokenAuthGroup.delete(":inventoryID", use: deletHandler)
        tokenAuthGroup.put(":inventoryID", use: updateHandler)
        
        
    }
    
    
    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Inventory]> {
        Inventory.query(on: req.db).all()
    }
    
    func creatHandler(_ req: Request) throws -> EventLoopFuture<Inventory> {
        let data = try req.content.decode(CreateInventoryData.self)
        let user = try req.auth.require(User.self)
        let inventory = try Inventory(inventoryname: data.inventoryname, inventoryprice: data.inventoryprice, quantity: data.quantity, userID: user.requireID())
        return   inventory.save(on: req.db).map{
            inventory
        }
    }
    
    
    func getHandler(_ req: Request) throws -> EventLoopFuture<Inventory> {
       Inventory.find(req.parameters.get("inventoryID"), on: req.db).unwrap(or: Abort(.notFound))
    }
    
    
    func deletHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Inventory.find(req.parameters.get("inventoryID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { inventory in
            inventory.delete(on: req.db).transform(to: .noContent)
        }
       }
        
    func updateHandler(_ req: Request) throws -> EventLoopFuture<Inventory> {
        let updateInventory = try req.content.decode(CreateInventoryData.self)
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        return Inventory.find(req.parameters.get("inventoryID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { inventory in
            inventory.inventoryname = updateInventory.inventoryname
            inventory.inventoryprice = updateInventory.inventoryprice
            inventory.quantity = updateInventory.quantity
            inventory.$user.id = userID
            return inventory.save(on: req.db).map {
                inventory
            }
            
        }
    }
    
    
    func getUserHnadler(_ req: Request) throws -> EventLoopFuture<User.Public> {
        Inventory.find(req.parameters.get("inventoryID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { inventory in
            inventory.$user.get(on: req.db).convertToPublic()
        }
    }
    
 
    
    func searchHandler(_ req: Request) throws ->
    EventLoopFuture<[Inventory]> {
        
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        
        return Inventory.query(on: req.db).group(.or) { or in
            or.filter(\.$inventoryname == searchTerm)
//            or.filter(\.$user.value == searchTerm)
        }.all()
        
    }
    
    
}

struct CreateInventoryData: Content {
 
    let inventoryname: String
    let inventoryprice: Double
    let quantity: Int
    
}


