//
//  Book.swift
//  flatironchallenge
//
//  Created by Johann Kerr on 3/10/17.
//
//

import Foundation
import Vapor


final class Book : Model {
    var id: Node?
    var exists: Bool = false
    
    var author: String
    var lastCheckedOut: Bool?
    var lastCheckedOutBy: String?
    var publisher: String
    var title: String
    var url: String
    
    
    init(author: String, publisher: String, title: String, url: String) {
        self.author = author
        self.publisher = publisher
        self.title = title
        self.url = url
        
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        author = try node.extract("author")
        lastCheckedOut = try node.extract("lastCheckedOut")
        lastCheckedOutBy = try node.extract("lastCheckedOutBy")
        publisher = try node.extract("publisher")
        title = try node.extract("title")
        url = try node.extract("url")
    }
    
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "author":author,
            "lastCheckedOut":lastCheckedOut,
            "lastCheckedOutBy":lastCheckedOutBy,
            "publisher":publisher,
            "title": title,
            "url":url
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("books") { books in
            books.id()
            books.string("author")
            books.string("lastCheckedOutBy", length: 255, optional: true, unique: false, default: nil)
            books.bool("lastCheckedOut", optional: true, unique: false, default: nil)
            books.string("publisher")
            books.string("url")
            books.string("title")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("books")
    }
    
    
    
}

