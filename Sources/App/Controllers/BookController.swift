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
        var book = book
        book.author = new.author
        book.title = new.title
        book.categories = new.categories
        book.publisher = new.publisher
        book.url = new.url
        book.lastCheckedOutBy = new.lastCheckedOutBy
        book.lastCheckedOut = new.lastCheckedOut
        try book.save()
        return book
    }
    
    func replace(request: Request, book: Book) throws -> ResponseRepresentable {
        try book.delete()
        return try create(request: request)
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

