//
//  JsonUtilities.swift
//  JsonUtilities
//
//  Created by Simon Pang on 18/8/2014.
//  Copyright (c) 2014 Simon Pang. All rights reserved.
//

import Foundation

class JsonUtilities {
    
    typealias JsonDict = [String : AnyObject]
    typealias JsonArray = [AnyObject]
    typealias JsonObject = (dict: JsonDict?, array: JsonArray?)
    typealias ContextHandler = Void -> Void
    
    class Parser {
        
        var context = [JsonObject]()
        
        init(_ json : AnyObject?) {
            if json != nil {
                pushContext(json!)
            }
        }
        
        private func asArray() -> JsonArray? {
            return context.last?.array
        }
        
        private func asDict() -> JsonDict? {
            return context.last?.dict
        }
        
        private func pushContext(json: AnyObject) {
            if let dict = json as? JsonDict {
                context.append(JsonObject(dict: dict, array:nil))
            }
            else if let array = json as? JsonArray {
                context.append(JsonObject(dict: nil, array:array))
            }
        }
        
        private func popContext() {
            context.removeLast()
        }
        
        func dict(key: String, handler: ContextHandler) {
            if let value : AnyObject = asDict()?[key] {
                pushContext(value)
                handler()
                popContext()
            }
        }
        
        func array(key: String, handler: ContextHandler) {
            let value : AnyObject? = asDict()?[key]
            if let valueAsArray = value as? JsonArray {
                for item in valueAsArray {
                    pushContext(item)
                    handler()
                    popContext()
                }
            }
        }
        
        func array(handler: ContextHandler) {
            if let array = asArray() {
                for item in array {
                    pushContext(item)
                    handler()
                    popContext()
                }
            }
        }
        
        func string(key: String) -> String? {
            let value : AnyObject? = asDict()?[key]
            return value as? String
        }
        
        func integer(key: String) -> Int? {
            let value : AnyObject? = asDict()?[key]
            return value as? Int
        }
        
        func double(key: String) -> Double? {
            let value : AnyObject? = asDict()?[key]
            return value as? Double
        }
        
        func bool(key: String) -> Bool? {
            let value : AnyObject? = asDict()?[key]
            return value as? Bool
        }
        
        func url(key: String) -> NSURL? {
            if let value : AnyObject? = asDict()?[key]{
                if let stringValue = value as? String {
                    return NSURL(string: stringValue)
                }
            }
            return nil
        }
        
    }
    
    
    class func parse(json : AnyObject?, handler : Parser -> Void) {
        
        // Handle NSData
        if let data = json as? NSData {
            if let json : AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) {
                handler(Parser(json))
            }
            return
        }
        
        // Handle Json objects
        handler(Parser(json))
    }

}
