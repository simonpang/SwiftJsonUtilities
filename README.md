# SwiftJsonUtilities

A Swift library to make JSON parsing in Swift language as simple as possible. 

Swift is strict with type checking, making parsing JSON objects difficult. Here's a [blog post](http://owensd.io/2014/06/18/json-parsing.html) written by David.

This project aims to remove most of the complexity of JSON handling in Swift by using DSL style syntax.

## How To Use It
### Installation

Add SwiftJsonUtilities.swift to your project.

### Example

Sample JSON to parse:
```
{
    "blogs": {
        "blog": [
            {
                "id": 73,
                "name": "Bloxus test",
                "needspassword": true,
                "url": "http://remote.bloxus.com/"
            },
            {
                "id": 74,
                "name": "Manila Test",
                "needspassword": false,
                "url": "http://flickrtest1.userland.com/"
            }
        ]
    },
    "stat": "ok"
}
```

Define a Blog class to represent a blog post:
```
class Blog {
    var name : String?
    var id : Int?
    var needsPassword : Bool?
    var url : String?
}

```


Actual parsing code. The parse() method accepts object types of NSData, String, NSDictionary or NSArray.


```
        JsonUtilities.parse(json) { p in
            
            var stat = p.string("stat")
            var title = p.string("title")
            
            var blogList = [Blog]()
            
            p.dict("blogs") {
                p.array("blog") {
                    
                    let blog           = Blog()
                    blog.id            = p.integer("id")
                    blog.name          = p.string("name")
                    blog.needsPassword = p.bool("needspassword")
                    blog.url           = p.string("url")

                    blogList.append(blog)
                    
                }
            }
        }

```


Custom datatype parsing can be supported by defining a custom method on extension of class JsonUtilities.Parser. The below code snippet define a method url() to parse NSURL object. The method can be called inside a parsing context.

```
extension JsonUtilities.Parser {
  func url(key: String) -> NSURL? {
      if let urlString = string(key) {
          return NSURL(string: urlString)
      }
      return nil
  }
}

// Usage:
JsonUtilities.parse(json) { p in
   
   // Parse an url object
   blog.url = p.url("url")
}
```

We can define a custom method to parse Blog objects:
```
extension JsonUtilities.Parser {
    func blog() -> Blog? {
        let blog = Blog()
        blog.id             = self.integer("id")
        blog.name           = self.string("name")
        blog.needsPassword  = self.bool("needspassword")
        blog.url            = self.url("url")
        return blog
    }
}


// Usage:
JsonUtilities.parse(TestData.json) { p in
    
    var blogList = [Blog]()
    
    p.dict("blogs") {
        p.array("blog") {
            
            if let blog = p.blog() {
                blogList.append(blog)
            }
            
        }
    }
}

```





## Alternate Solutions

- [json-swift] by David (https://github.com/owensd/json-swift/)
- [SwiftyJSON] by lingoer (https://github.com/lingoer/SwiftyJSON)


## License

This project is under MIT License, please feel free to contribute and use it

Simon Pang

