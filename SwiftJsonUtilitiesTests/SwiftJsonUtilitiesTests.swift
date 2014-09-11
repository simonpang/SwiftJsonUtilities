//
//  SwiftJsonUtilitiesTests.swift
//  SwiftJsonUtilitiesTests
//
//  Created by Simon Pang on 18/8/2014.
//  Copyright (c) 2014 Simon Pang. All rights reserved.
//

import UIKit
import XCTest

    
class Blog {
    var name : String?
    var id : Int?
    var needsPassword : Bool?
    var url : NSURL?
}

extension JsonUtilities.Parser {
    func blog() -> Blog? {
        let blog = Blog()
        blog.id = self.integer("id")
        blog.name = self.string("name")
        blog.needsPassword = self.bool("needspassword")
        blog.url = self.url("url")
        return blog
    }
}

class SwiftJsonUtilitiesTests: XCTestCase {
    
    struct TestData {
        static let json : AnyObject? = [
            "stat": "ok",
            "blogs": [
                "blog": [
                    [
                        "id" : 73,
                        "name" : "Bloxus test",
                        "needspassword" : true,
                        "url" : "http://remote.bloxus.com/"
                    ],
                    [
                        "id" : 74,
                        "name" : "Manila Test",
                        "needspassword" : false,
                        "url" : "http://flickrtest1.userland.com/"
                    ]
                ]
            ]
        ]
        
        static let jsonString = "{\"stat\":\"ok\",\"blogs\":{\"blog\":[{\"needspassword\":true,\"id\":73,\"name\":\"Bloxus test\",\"url\":\"http://remote.bloxus.com/\"},{\"needspassword\":false,\"id\":74,\"name\":\"Manila Test\",\"url\":\"http://flickrtest1.userland.com/\"}]}}"
    }
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDictionaryParsing() {
        
        var stat : String?
        var blogList = [Blog]()
        
        JsonUtilities.parse(TestData.json) { p in
            
            stat = p.string("stat")
            
            p.dict("blogs") {
                p.array("blog") {
                    
                    if let blog = p.blog() {
                        blogList.append(blog)
                    }
                    
                }
            }
        }

        XCTAssert(stat == "ok", "Pass")
        XCTAssert(blogList.count == 2, "Pass")
        
        XCTAssert(blogList[0].name == "Bloxus test", "Pass")
        XCTAssert(blogList[0].id == 73, "Pass")
        XCTAssert(blogList[0].needsPassword == true, "Pass")
        XCTAssert(blogList[0].url?.absoluteString == "http://remote.bloxus.com/", "Pass")
        
        XCTAssert(blogList[1].name == "Manila Test", "Pass")
        XCTAssert(blogList[1].id == 74, "Pass")
        XCTAssert(blogList[1].needsPassword == false, "Pass")
        XCTAssert(blogList[1].url?.absoluteString == "http://flickrtest1.userland.com/", "Pass")

    }

    func testNSDictionaryParsing() {
        var stat : String?
        
        var dict = NSMutableDictionary()
        dict.setObject("ok", forKey: "stat")
        
        JsonUtilities.parse(dict) { p in
            stat = p.string("stat")
        }
        
        XCTAssert(stat == "ok", "Pass")
    }

    func testNoValues() {
        
        var string : String?
        var dbl : Double?
        var boolean : Bool?
        var url: NSURL?

        JsonUtilities.parse(TestData.json) { p in
            
            string = p.string("no_such_field")
            XCTAssert(string == nil, "Pass")

            dbl = p.double("no_such_field")
            XCTAssert(dbl == nil, "Pass")

            boolean = p.bool("no_such_field")
            XCTAssert(boolean == nil, "Pass")
            
            url = p.url("no_such_field")
            XCTAssert(url == nil, "Pass")

            p.dict("no_such_dict") {
                XCTFail("Fail")
            }
            
            p.array("no_such_array") {
                XCTFail("Fail")
            }

        }
    }
    
    func testDataParsing() {
        var stat : String?
        
        let jsonData = TestData.jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        JsonUtilities.parse(jsonData) { p in
            stat = p.string("stat")
        }
        
        XCTAssert(stat == "ok", "Pass")
        
    }

    func testStringParsing() {
        var stat : String?
        
        JsonUtilities.parse(TestData.jsonString) { p in
            stat = p.string("stat")
        }
        
        XCTAssert(stat == "ok", "Pass")
        
    }

}

