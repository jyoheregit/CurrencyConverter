//
//  MockURLSessionDataTask.swift
//  CurrencyConverterTests
//
//  Created by Joe on 17/03/19.
//  Copyright © 2019 Joe. All rights reserved.
//

import Foundation
@testable import CurrencyConverter

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

class MockURLSessionDataTask: URLSessionDataTask {
    private (set) var resumeWasCalled = false
    
    override func resume() {
        resumeWasCalled = true
    }
}
