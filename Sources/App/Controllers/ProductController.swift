//
//  File.swift
//  
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//

import Vapor
import Fluent


struct ProductController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let productRoutes = routes.grouped("api", "products")
        productRoutes.get( use: getAllHandler)
        productRoutes.get(":productID", use: getHandler)
      
        // get the user info from acronymID
        productRoutes.get(":productID", "user", use: getUserHnadler)
    
//        productRoutes.get(":acronymID", "categories", use: getCatogriesHandler)

        productRoutes.get("search", use: searchHandler)
        
        
        let tokenAuthMiddleware = Token.authenticator()
        let guardAuthMiddleware = User.guardMiddleware()
        let tokenAuthGroup =  productRoutes.grouped(tokenAuthMiddleware, guardAuthMiddleware)
        
        tokenAuthGroup.post( use: creatHandler)
        tokenAuthGroup.delete(":productID", use: deletHandler)
        tokenAuthGroup.put(":productID", use: updateHandler)
        
        
       // tokenAuthGroup.post(":productID", "categories", ":categoryID", use: addCatogriesHandler)
    }
    
    
    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Product]> {
        Product.query(on: req.db).all()
    }
    
    func creatHandler(_ req: Request) throws -> EventLoopFuture<Product> {
        let data = try req.content.decode(CreateProductData.self)
        let user = try req.auth.require(User.self)
        let product = try Product(productname: data.productname, laborcost: data.laborcost, actualcost: data.actualcost, totalprice: data.totalprice, profit: data.profit, quantity: data.quantity, userID: user.requireID())
        return product.save(on: req.db).map{
            product
        }
    }
    
    func getHandler(_ req: Request) throws -> EventLoopFuture<Product> {
       Product.find(req.parameters.get("ProductID"), on: req.db).unwrap(or: Abort(.notFound))
    }
    
    
    func deletHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Product.find(req.parameters.get("productID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { product in
            product.delete(on: req.db).transform(to: .noContent)
        }
       }
        
    func updateHandler(_ req: Request) throws -> EventLoopFuture<Product> {
        let updateProduct = try req.content.decode(CreateProductData.self)
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        return Product.find(req.parameters.get("productID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { product in
            product.productname = updateProduct.productname
            product.totalprice = updateProduct.totalprice
            product.laborcost = updateProduct.laborcost
            product.profit = updateProduct.profit
            product.actualcost = updateProduct.actualcost
            product.quantity = updateProduct.quantity
            product.$user.id = userID
            return product.save(on: req.db).map {
                product
            }
            
        }
    }
    
    
    func getUserHnadler(_ req: Request) throws -> EventLoopFuture<User.Public> {
        Product.find(req.parameters.get("productID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { product in
           product.$user.get(on: req.db).convertToPublic()
        }
    }
    
    
    
//    func getCatogriesHandler(_ req: Request) throws -> EventLoopFuture<[Category]> {
//        Acronym.find(req.parameters.get("acronymID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { acronym in
//            acronym.$categories.get(on: req.db)
//        }
//    }
//
    
//    func addCatogriesHandler(_ req: Request) throws ->
//    EventLoopFuture<HTTPStatus>{
//        let acronymQuery = Acronym.find(req.parameters.get("acronymID"), on: req.db).unwrap(or: Abort(.notFound))
//
//        let categoryQuery = Category.find(req.parameters.get("categoryID"), on: req.db).unwrap(or: Abort(.notFound))
//
//        return acronymQuery.and(categoryQuery).flatMap { acronym, category in
//            acronym.$categories.attach(category, on: req.db).transform(to: .created)
//        }
//    }
//
    
    
    func searchHandler(_ req: Request) throws ->
    EventLoopFuture<[Product]> {
        
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        
        return Product.query(on: req.db).group(.or) { or in
            or.filter(\.$productname == searchTerm)
//            or.filter(\.$user.value == searchTerm)
        }.all()
        
    }
    
    
}

struct CreateProductData: Content {
    
    let productname: String
    let laborcost: Double
    let actualcost: Double
    let totalprice: Double
    let profit: Double
    let quantity: Int
 

}

