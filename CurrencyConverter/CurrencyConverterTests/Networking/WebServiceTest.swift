//
//  WebServiceTest.swift
//  CurrencyConverterTests
//
//  Created by Joe on 17/03/19.
//  Copyright © 2019 Joe. All rights reserved.
//

import XCTest
@testable import CurrencyConverter

class WebServiceTest: XCTestCase {

    var sut: WebService!
    let session = MockURLSession()
    let mockCache = MockCache()
    
    override func setUp() {
        super.setUp()
        sut = WebService(session: session, cacheManager: CacheManager(cache: mockCache))
        mockCache.returnDataFromCache = false
    }
    
    func testFetchForResourceCallsWithCorrectUrl() {
        guard let testURL = URL(string: "http://apilayer.net/api/list") else {
            XCTFail("URL is nil")
            return
        }
        session.nextData = nil
        sut.fetch(Resource<Currency>(url: testURL)) { (_, _) in }
        XCTAssert(session.lastURL?.absoluteString == testURL.absoluteString)
    }

    func testFetchForResourceCalledDataTaskResume() {
        guard let testURL = URL(string: "http://apilayer.net/api/list") else {
            XCTFail("URL is nil")
            return
        }
        session.nextData = nil
        sut.fetch(Resource<Currency>(url: testURL)) { (_, _) in }
        XCTAssertTrue(session.nextDataTask.resumeWasCalled)
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
   
    func testFetchForCurrencyResourceShouldReturnProperCurrencyData() {
        guard let testURL = URL(string: "http://apilayer.net/api/list") else {
            XCTFail("URL is nil")
            return
        }
        session.nextData = mockDataWith(fileName: "testCurrency")
        sut.fetch(Resource<Currency>(url: testURL)) { (currency, error) in
            XCTAssertNotNil(currency)
            XCTAssertEqual(currency?.success, true)
            XCTAssertEqual(currency?.terms, "https://currencylayer.com/terms")
            XCTAssertEqual(currency?.privacy, "https://currencylayer.com/privacy")
            XCTAssertEqual(currency?.currencies?.count, 9)
            let currencies = currency?.currencies
            XCTAssertEqual(currencies?["AED"],"United Arab Emirates Dirham")
            XCTAssertEqual(currencies?["AFN"],"Afghan Afghani")
            XCTAssertEqual(currencies?["ALL"],"Albanian Lek")
            XCTAssertEqual(currencies?["AMD"],"Armenian Dram")
            XCTAssertEqual(currencies?["ANG"],"Netherlands Antillean Guilder")
            XCTAssertEqual(currencies?["AOA"],"Angolan Kwanza")
            XCTAssertEqual(currencies?["ARS"],"Argentine Peso")
            XCTAssertEqual(currencies?["AUD"],"Australian Dollar")
            XCTAssertEqual(currencies?["AWG"],"Aruban9 Florin")
            XCTAssertEqual(currencies?["IND"], nil)
        }
        XCTAssert(session.lastURL?.absoluteString == testURL.absoluteString)

    }
    
    func testFetchForExchangeRateResourceShouldReturnProperExchangeRate() {
        guard let testURL = URL(string: "http://www.apilayer.net/api/live?source=AED") else {
            XCTFail("URL is nil")
            return
        }
        session.nextData = mockDataWith(fileName: "testExchangeRate")
        sut.fetch(Resource<ExchangeRate>(url: testURL)) { (exchangeRate, error) in
            XCTAssertNotNil(exchangeRate)
            XCTAssertEqual(exchangeRate?.success, true)
            XCTAssertEqual(exchangeRate?.terms, "https://currencylayer.com/terms")
            XCTAssertEqual(exchangeRate?.privacy, "https://currencylayer.com/privacy")
            XCTAssertEqual(exchangeRate?.timestamp, 1551954785)
            XCTAssertEqual(exchangeRate?.source, "AED")
            let quotes = exchangeRate?.quotes
            XCTAssertEqual(quotes?["AEDAED"], 1)
            XCTAssertEqual(quotes?["AEDAFN"], 20.559406)
            XCTAssertEqual(quotes?["AEDALL"], 30.014237)
            XCTAssertEqual(quotes?["AEDAMD"], 132.920473)
            XCTAssertEqual(quotes?["AEDANG"], 0.493596)
            XCTAssertEqual(quotes?["AEDAOA"], 85.651652)
            XCTAssertEqual(quotes?["AEDARS"], 11.088139)
            XCTAssertEqual(quotes?["AEDAUD"], 0.386551)
            XCTAssertEqual(quotes?["AEDAWG"], 0.490029)
            XCTAssertEqual(quotes?["AEDAZN"], 0.464169)
            XCTAssertEqual(quotes?["AEDIND"], nil)
        }
        XCTAssert(session.lastURL?.absoluteString == testURL.absoluteString)
    }

    func testFetchDataFromCache() {
        guard let testURL = URL(string: "http://www.apilayer.net/api/live?source=AED") else {
            XCTFail("URL is nil")
            return
        }
        mockCache.returnDataFromCache = true
        sut.fetch(Resource<ExchangeRate>(url: testURL)) { (exchangeRate, error) in
            XCTAssertNotNil(exchangeRate)
            XCTAssertEqual(exchangeRate?.success, true)
            XCTAssertEqual(exchangeRate?.terms, "https://currencylayer.com/terms")
            XCTAssertEqual(exchangeRate?.privacy, "https://currencylayer.com/privacy")
            XCTAssertEqual(exchangeRate?.timestamp, 1551954785)
            XCTAssertEqual(exchangeRate?.source, "AED")
            let quotes = exchangeRate?.quotes
            XCTAssertEqual(quotes?["AEDAED"], 1)
            XCTAssertEqual(quotes?["AEDAFN"], 20.559406)
            XCTAssertEqual(quotes?["AEDALL"], 30.014237)
            XCTAssertEqual(quotes?["AEDAMD"], 132.920473)
            XCTAssertEqual(quotes?["AEDANG"], 0.493596)
            XCTAssertEqual(quotes?["AEDAOA"], 85.651652)
            XCTAssertEqual(quotes?["AEDARS"], 11.088139)
            XCTAssertEqual(quotes?["AEDAUD"], 0.386551)
            XCTAssertEqual(quotes?["AEDAWG"], 0.490029)
            XCTAssertEqual(quotes?["AEDAZN"], 0.464169)
            XCTAssertEqual(quotes?["AEDIND"], nil)
        }
        //so not from network request
        XCTAssertNil(session.lastURL?.absoluteString)
        XCTAssertFalse(session.nextDataTask.resumeWasCalled)
    }
    
}
