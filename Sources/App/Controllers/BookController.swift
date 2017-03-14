//
//  BookController.swift
//  flatironchallenge
//
//  Created by Johann Kerr on 3/10/17.
//
//

import Vapor
import HTTP

final class BookController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try Book.all().makeNode().converted(to: JSON.self)
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        var book = try request.book()
        print(book)
        try book.save()
        return book
    }
    
    func show(request: Request, book: Book) throws -> ResponseRepresentable {
        return book
    }
    
    func delete(request: Request, book: Book) throws -> ResponseRepresentable {
        try book.delete()
        return JSON([:])
    }
    
    func clear(request: Request) throws -> ResponseRepresentable {
        try Book.query().delete()
        return JSON([])
    }
    
    func update(request: Request, book: Book) throws -> ResponseRepresentable {
        let new = try request.book()
        dump(new)
        dump(book)
        var book = book
        if let author = new.author {
            book.author = author
        }
        if let title = new.title {
            book.title = title
        }
        if let publisher = new.publisher {
            book.publisher = publisher
        }
        
        if let lastCheckedOut = new.lastCheckedOut {
            book.lastCheckedOut = lastCheckedOut
            
        }
        if let lastCheckoutOutBy = new.lastCheckedOutBy {
            book.lastCheckedOutBy = lastCheckoutOutBy
            
        }
        if let url = new.url {
            book.url = url
        }
        
        try book.save()
        return book
    }
    
    func replace(request: Request, book: Book) throws -> ResponseRepresentable {
        print("replacing")
        //try book.delete()
        return try update(request: request, book: book)
       // return try create(request: request)
    }
    
    func makeResource() -> Resource<Book> {
        return Resource(
            index: index,
            store: create,
            show: show,
            replace: replace,
            modify: update,
            destroy: delete,
            clear: clear
        )
    }
}

extension Request {
    func book() throws -> Book {
        guard let json = json else { throw Abort.badRequest }
        return try Book(node: json)
    }
}

