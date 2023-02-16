//
//  File.swift
//  
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//

import Fluent


struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("businessname", .string ,.required)
            .field("email", .string ,.required)
            .field("password", .string ,.required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("user").delete()
    }
}

