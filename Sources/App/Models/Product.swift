//
//  File.swift
//  
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//


import Fluent
import Vapor


final class Product: Model {
    
    static let schema = "products"
    
    @ID
    var id: UUID?
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Field(key: "productname")
    var productname: String
    
    
    @Field(key: "laborcost")
    var laborcost: Double
    
    @Field(key: "actualcost")
    var actualcost: Double
    
    
    
    @Field(key: "totalprice")
    var totalprice: Double
    
    
    @Field(key: "profit")
    var profit: Double
    
    
    @Field(key: "quantity")
    var quantity: Int
    
    
    
    @Parent(key: "userID")
    var user: User
    

    
    init() {  }
    
    init(id: UUID? = nil, productname: String, laborcost: Double, actualcost: Double, totalprice: Double, profit: Double, quantity: Int, userID: User.IDValue, createdAt: Date? = nil) {
        self.id = id
        self.productname = productname
        self.laborcost = laborcost
        self.actualcost = actualcost
        self.totalprice = totalprice
        self.profit = profit
        self.createdAt = createdAt
        self.quantity = quantity
        self.$user.id = userID
        
    }
      
}


extension Product: Content {}

