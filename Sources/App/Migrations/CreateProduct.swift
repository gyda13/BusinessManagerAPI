//
//  File.swift
//  
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//

import Fluent


struct CreateProduct: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("products")
            .id()
            .field("productname", .string ,.required)
            .field("laborcost", .string ,.required)
            .field("actualcost", .double ,.required)
            .field("totalprice", .double,.required)
            .field("profit", .double ,.required)
            .field("quantity", .int ,.required)
            .field("createdAt", .date)
            .field("userID", .uuid, .required, .references("users", "id"))
            .create()
            
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("products").delete()
    }
}

