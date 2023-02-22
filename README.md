# BusinessManagerAPI (Hassad App)



# Users route
Routes | HTTP | Description
--- | --- | ---
http://127.0.0.1:8080/api/users | `GET` | Get all users.
http://127.0.0.1:8080/api/users | `POST` | Create a account , body : email,password,businessname.
 
Create account body example:

```json
{
    "email": String,
    "businessname": String,
    "password": String
}
```
Response:
```json
{
    "id": UserID,
    "businessname": String,
    "email": String
}
```

Routes | HTTP | Description
--- | --- | ---
http://127.0.0.1:8080/api/users/login | `Post` | login , type: basic Auth email(as Username),password.

Response:
```json
{
    "id": TokenID,
    "user": {
        "id": UserID
    },
    "value": TokenValue
}
```


# Products route
Routes | HTTP | Description
--- | --- | ---
http://127.0.0.1:8080/api/products | `Post` | add products , type: Bearer token , body:productname,laborcost,actualcost,totalprice,profit,quantity
http://127.0.0.1:8080/api/users/:userID/products |`Get` | get all products for one user


choose bearer token auth type and use your last token with the add products request
add product body example:
```json
{
    "productname": String,
     "laborcost": Double,
    "actualcost": Double,
    "totalprice": Double,
    "profit": Double,
    "quantity": Int
}
```
Response:
```json
{
    "profit": Double,
    "quantity": Int,
    "totalprice": Double,
    "id": String ProductID,
    "actualcost": Double,
    "productname": String,
    "laborcost": Double,
    "createdAt": String,
    "user": {
        "id": UserID
    }
}
```






