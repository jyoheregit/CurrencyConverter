//
//  MockFileStorage.swift
//  CurrencyConverterTests
//
//  Created by Joe on 17/03/19.
//  Copyright © 2019 Joe. All rights reserved.
//

import Foundation
@testable import CurrencyConverter

class MockFileStorage: FileStorage {
    
    var modifyFileCreationDate = false
    
    override func createdDateForResourceWith(cacheKey : String) -> NSDate? {
       var creationDate = NSDate()
        if (modifyFileCreationDate) {
            creationDate = creationDate.addingTimeInterval(-31.0 * 60.0)
        }
        return creationDate
    }
}


