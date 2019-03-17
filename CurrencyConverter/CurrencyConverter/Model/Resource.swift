//
//  Resource.swift
//  CurrencyConverter
//
//  Created by Joe on 16/03/19.
//  Copyright © 2019 Joe. All rights reserved.
//

import Foundation

struct Resource<T> where T: Decodable {
    let url: URL
    let parse: (Data) -> T?
    
    var cacheKey: String {
        return "cache" + String(url.hashValue)
    }
    
    init(url : URL) {
        self.url = url
        self.parse = { data in
            try? JSONDecoder().decode(T.self, from: data)
        }
    }
}
