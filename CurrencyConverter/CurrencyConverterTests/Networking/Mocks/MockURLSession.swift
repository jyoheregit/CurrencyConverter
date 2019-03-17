//
//  MockURLSession.swift
//  CurrencyConverterTests
//
//  Created by Joe on 17/03/19.
//  Copyright © 2019 Joe. All rights reserved.
//

import Foundation
@testable import CurrencyConverter

class MockURLSession: URLSessionProtocol {
    
    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextError: Error?
    
    private (set) var lastURL: URL?
    
    func successHttpURLResponse(url: URL) -> URLResponse {
        return HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        lastURL = url
        completionHandler(nextData, successHttpURLResponse(url: url), nextError)
        return nextDataTask
    }
}
