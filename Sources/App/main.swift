import Vapor
import VaporPostgreSQL

let drop = Droplet()
try drop.addProvider(VaporPostgreSQL.Provider.self)
drop.preparations += Book.self

drop.get { req in
    return try drop.view.make("welcome", [
        "message": drop.localization[req.lang, "welcome", "title"]
        ])
}

drop.get("seedBooks") { request in
    
    
    let url = "https://www.googleapis.com/books/v1/volumes?q=subject:suspense&maxResults=40"
    let response = try drop.client.get(url)
    var petArray = [Book]()
    let next = response.data["data","after"]?.string ?? ""
    let linkArray = response.data["items", "volumeInfo"]?.array?.flatMap({$0.object}) ?? []
    
    var books = [Book]()
    for link in linkArray {
        let title = link["title"]?.string ?? ""
        let publisher = link["publisher"]?.string ?? ""
        let authorArray = link["authors"]?.array ?? []
        let author = authorArray.first?.string ?? ""
        let imageLinks = link["imageLinks"]?.object ?? [:]
        let thumbnail = imageLinks["thumbnail"]?.string ?? ""
        let largeImage = thumbnail.replacingOccurrences(of: "&zoom=1", with: "")
        
        var book = Book(author: author, publisher: publisher, title: title, url: thumbnail)
        try book.save()
        books.append(book)
        
        
        
    }
    //
    
    return try JSON(node:["success":books.makeNode()])
    
    
    
    
}


drop.resource("books", BookController())
drop.resource("posts", PostController())

drop.run()
