//
//  CacheManagerTest.swift
//  CurrencyConverterTests
//
//  Created by Joe on 17/03/19.
//  Copyright © 2019 Joe. All rights reserved.
//

import XCTest
@testable import CurrencyConverter

class CacheTest: XCTestCase {

    var sut: Cache!
    let storage = MockFileStorage()
    let resource = Resource<ExchangeRate>(url: URL(string: "http://test.exchange.rate")!)
    
    override func setUp() {
        sut = Cache()
        sut.storage = storage
        self.storage.modifyFileCreationDate = false
        self.storage.deleteFileOfResourceWith(cacheKey: resource.cacheKey)
    }
    
    func testSaveAndFetchDataFromCache() {
        let data = mockDataWith(fileName: "testExchangeRate")
        sut.save(data, for: resource)
        let returnedData = sut.fetch(resource)
        XCTAssertNotNil(returnedData)
    }
    
    func testCacheExpiredIsFalse() {
        let data = mockDataWith(fileName: "testExchangeRate")
        let resource = Resource<ExchangeRate>(url: URL(string: "http://test.exchange.rate")!)
        sut.save(data, for: resource)
        let cacheExpired = sut.cacheExpired(resource: resource)
        XCTAssertFalse(cacheExpired)
    }
    
    func testCacheExpiredIsTrue() {
        let data = mockDataWith(fileName: "testExchangeRate")
        let resource = Resource<ExchangeRate>(url: URL(string: "http://test.exchange.rate")!)
        sut.save(data, for: resource)
        self.storage.modifyFileCreationDate = true
        let cacheExpired = sut.cacheExpired(resource: resource)
        XCTAssertTrue(cacheExpired)
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
