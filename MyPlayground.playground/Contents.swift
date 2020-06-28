import UIKit

var str = "Hello, playground"
let backendURL = "http://localhost:8000";
var url = URL(string: "\(backendURL)/users/asdf/readArticles")!
print(url)
