//
//  UserController.swift
//  flatironchallenge
//
//  Created by Johann Kerr on 3/10/17.
//
//

import Foundation
import PostgreSQL
import Vapor
import Auth
import HTTP
import Cookies
import Turnstile
import TurnstileCrypto
import TurnstileWeb
import Fluent

/*
final class UserController {
    
    func addRoutes(drop: Droplet) {
        drop.get("login", handler:login)
        drop.get("register", handler:register)
        drop.post("login", handler:loginData)
        drop.post("register", handler:registerData)
        drop.post("logout", handler:logout)
    }
    
    func register(request: Request) throws -> ResponseRepresentable {
        return try drop.view.make("register")
    }
    
    func login(request: Request) throws -> ResponseRepresentable {
        return try drop.view.make("login")
    }
    
    
    func registerData(request: Request) throws -> ResponseRepresentable {
        guard let username = request.formURLEncoded?["username"]?.string, let password = request.formURLEncoded?["password"]?.string else {
            return try drop.view.make("register", ["flash":"Missing email or password"])
            
        }
        let credentials = UsernamePassword(username: username, password: password)
        do {
            _ = try MainUser.register(credentials: credentials)
            try request.auth.login(credentials, persist: true)
            return Response(redirect: "/")
        } catch let e as TurnstileError {
            return try drop.view.make("register", Node(node:["flash": e.description]))
        }
    }
    
    
    func loginData(request: Request) throws -> ResponseRepresentable {
        guard let username = request.formURLEncoded?["username"]?.string,
            let password = request.formURLEncoded?["password"]?.string else {
                return try drop.view.make("login", ["flash": "Missing username or password"])
        }
        let credentials = UsernamePassword(username: username, password: password)
        do {
            try _ = MainUser.authenticate(credentials: credentials)
            try request.auth.login(credentials)
            return Response(redirect: "/")
        } catch _ {
            return try drop.view.make("login", ["flash": "Invalid username or password"])
        }
    }
    
    func logout(request: Request) throws -> ResponseRepresentable {
        request.subject.logout()
        return Response(redirect: "/")
    }
    
    func registerJSON(request: Request) throws -> ResponseRepresentable{
        
        guard let username = request.json?["username"]?.string, let password = request.json?["password"]?.string else {
            throw Abort.badRequest
        }
        
        do {
            
            let credentials = UsernamePassword(username: username, password: password)
            
//            var user = try MainUser.re
            //var user = try MainUser.register(fullName: fullName, username: username, credentials: credentials) as! MainUser
            // var user = try MainUser.register(credentials: credentials) as! MainUser
            try request.auth.login(credentials)
            try user.save()
            return try JSON(node: ["status": "ok", "user":user.makeNode()] )
            
            
        } catch let e as TurnstileError {
            print(e.description)
            return try JSON(node:["status": e.description])
        }
        
        
        
        
        
    }
    
    //MARK:- Login
    func loginJSON(request: Request) throws -> ResponseRepresentable{
        guard let email = request.json?["username"]?.string, let password = request.json?["password"]?.string else {
            throw Abort.badRequest
        }
        
        
        let credentials = UsernamePassword(username: email, password: password)
        
        do {
            let user = try MainUser.authenticate(credentials: credentials)
            try request.auth.login(credentials)
            return try JSON(node: ["status":"ok",
                                   "user": try user.makeNode()
                ])
            
        } catch let e {
            
            return try JSON(node: ["status": e.localizedDescription] )
        }
        
    }
    
    
    
    
}
*/
