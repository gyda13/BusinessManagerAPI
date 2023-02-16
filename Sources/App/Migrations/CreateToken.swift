//
//  File.swift
//  
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//

import Fluent

struct CreateToken: Migration {
    
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tokens")
            .id()
            .field("value", .string, .required)
            .field("userID", .uuid, .required, .references("users", "id", onDelete: .cascade)).create()
    }
    
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tokens").delete()
    }
}

