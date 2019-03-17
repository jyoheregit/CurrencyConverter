//
//  MockCache.swift
//  CurrencyConverterTests
//
//  Created by Joe on 17/03/19.
//  Copyright © 2019 Joe. All rights reserved.
//

import Foundation
@testable import CurrencyConverter

class MockCache : Cacheable {
    
    var returnDataFromCache: Bool = false
    var savedData : Data?
    
    func fetch<T>(_ resource: Resource<T>) -> Data? {
        if (returnDataFromCache) {
            return mockDataWith(fileName: "testExchangeRate")
        }
        return nil
    }
    
    func save<T>(_ data: Data, for resource: Resource<T>) {
        savedData = data
    }
    
    func cacheExpired<T>(resource : Resource<T>) -> Bool {
        return false
    }
    
    func mockDataWith(fileName : String) -> Data {
        let bundle = Bundle(for: type(of: self))
        guard let pathString = bundle.path(forResource: fileName, ofType: "json") else {
            fatalError("\(fileName).json not found")
        }
        let encoding = String.Encoding.utf8.rawValue
        guard let jsonString = try? NSString(contentsOfFile: pathString, encoding: encoding) else {
            fatalError("Unable to convert \(fileName).json to String")
        }
        print("The JSON string is: \(jsonString)")
        guard let jsonData = jsonString.data(using: String.Encoding.utf8.rawValue) else {
            fatalError("Unable to convert \(fileName).json to NSData")
        }
        return jsonData
    }
}
