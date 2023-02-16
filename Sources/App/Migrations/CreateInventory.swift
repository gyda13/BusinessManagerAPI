//
//  File.swift
//  
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//

import Fluent


struct CreateInventory: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("inventories")
            .id()
            .field("inventoryname", .string ,.required)
            .field("inventoryprice", .double,.required)
            .field("quantity", .int ,.required)
            .field("createdAt", .date)
        
            .field("userID", .uuid, .required, .references("users", "id"))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("inventories").delete()
    }
}

