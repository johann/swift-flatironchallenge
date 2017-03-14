//
//  MainUser.swift
//  flatironchallenge
//
//  Created by Johann Kerr on 3/10/17.
//
//

import Foundation
import Turnstile
import Auth
import TurnstileCrypto
import TurnstileWeb
import Fluent
import HTTP

final class MainUser: User {
    var exists: Bool = false
    var id: Node?
    var username: String = ""
    var password = ""
    var apiKeyID = URandom().secureToken
    var apiKeySecret = URandom().secureToken
    
    
    static func authenticate(credentials: Credentials) throws -> User {
        var user: MainUser?
        
        switch credentials {
        case let credentials as UsernamePassword:
            let fetchedUser = try MainUser.query().filter("username", credentials.username).first()
            if let password = fetchedUser?.password, password != "", (try? BCrypt.verify(password: credentials.password, matchesHash: password)) == true {
                user = fetchedUser
            }
        case let credentials as Identifier:
            user = try MainUser.find(credentials.id)
        case let credentials as APIKey:
            user = try MainUser.query().filter("api_key_id", credentials.id).filter("api_key_secret", credentials.secret).first()
        default:
            throw UnsupportedCredentialsError()
        }
        if let user = user {
            return user
        } else {
            throw IncorrectCredentialsError()
        }
    }
    
    static func register(credentials: Credentials) throws -> User {
        var newUser: MainUser
        switch credentials {
        case let credentials as UsernamePassword:
            newUser = MainUser(credentials: credentials)
        default:
            throw UnsupportedCredentialsError()
        }
        
        if try MainUser.query().filter("username", newUser.username).first() == nil {
            try newUser.save()
            return newUser
        } else {
            throw AccountTakenError()
            
        }
    }
    
    
    init(credentials: UsernamePassword) {
        self.username = credentials.username
        self.password = BCrypt.hash(password: credentials.password)
    }
    
    init(node: Node, in context: Context) throws {
        self.id = try node.extract("id")
        self.username = try node.extract("username")
        self.password = try node.extract("password")
        self.apiKeyID = try node.extract("api_key_id")
        self.apiKeySecret = try node.extract("api_key_secret")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node:[
            "id":id,
            "username":username,
            "password":password,
            "api_key_id":apiKeyID,
            "api_key_secret":apiKeySecret
            ])
        
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("users"){ users in
            users.id()
            users.string("username")
            users.string("password")
            users.string("api_key_id")
            users.string("api_key_secret")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("users")
    }
    
    
}



extension Request {
    
    func user() throws -> MainUser {
        guard let user = try auth.user() as? MainUser else {
            throw "Invalid user type"
        }
        return user
    }
}

extension String: Error {}

