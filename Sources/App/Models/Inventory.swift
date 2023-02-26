//
//  File.swift
//  
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//

import Fluent
import Vapor


final class Inventory: Model {
    
    static let schema = "inventories"
    
    @ID
    var id: UUID?
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    
    @Field(key: "inventoryname")
    var inventoryname: String
    
    
    @Field(key: "inventoryprice")
    var inventoryprice: Double
   
    
    @Field(key: "quantity")
    var quantity: Int
    
    
    
    @Parent(key: "userID")
    var user: User
    
 
    
    init() {
        
    }
    init(id: UUID? = nil, inventoryname: String, inventoryprice: Double, quantity: Int, userID: User.IDValue, createdAt: Date? = nil) {
        self.id = id
        self.inventoryname = inventoryname
        self.inventoryprice = inventoryprice
        self.quantity = quantity
        self.createdAt = createdAt
        self.$user.id = userID
    }
    
}


extension Inventory: Content {}

