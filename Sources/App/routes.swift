import Fluent
import Vapor

func routes(_ app: Application) throws {
  
    let productController = ProductController()
    try app.register(collection: productController)
    
    
    let usersController = UsersController()
    try app.register(collection: usersController)

    let inventoryController = InventoryController()
    try app.register(collection: inventoryController)
  
   

  
}
