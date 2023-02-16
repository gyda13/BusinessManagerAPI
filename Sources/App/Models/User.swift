//
//  File.swift
//  
//
//  Created by gyda almohaimeed on 25/07/1444 AH.
//

import Fluent
import Vapor


final class User: Model {
    
    static let schema = "users"
    
    @ID
    var id: UUID?
    
    @Field(key: "businessname")
    var businessname: String
    
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    
    @Children(for: \.$user)
    var products: [Product]

    @Children(for: \.$user)
    var inventories: [Inventory]

    
   
    
    init(){
    }
    
    
    init(id: UUID? = nil, businessname: String, email: String, password: String) {
        self.id = id
        self.businessname = businessname
        self.email = email
        self.password = password
    }
   
    struct Public: Content {
        var id: UUID?
        var businessname: String
        var email: String
    }
  
      
}


extension User: Content {}


extension User {
    func convertToPublic() -> User.Public {
        User.Public(id: self.id, businessname: self.businessname, email: self.email)
    }
}



extension EventLoopFuture where Value: User {
    func convertToPublic() -> EventLoopFuture<User.Public> {
        self.map {
            user in
            user.convertToPublic()
        }
    }
}


extension Collection where Element: User {
    func convertToPublic() -> [User.Public] {
        self.map {$0.convertToPublic()}
    }
}


extension EventLoopFuture where Value == Array<User> {
    func convertToPublic() -> EventLoopFuture<[User.Public]> {
        self.map {$0.convertToPublic()}
    }
}


extension User: ModelAuthenticatable {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$password
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}
