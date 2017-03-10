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


drop.resource("books", BookController())
drop.resource("posts", PostController())

drop.run()
