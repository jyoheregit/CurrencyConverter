//
//  ExchangeRate.swift
//  CurrencyConverter
//
//  Created by Joe on 16/03/19.
//  Copyright © 2019 Joe. All rights reserved.
//

import Foundation

struct ExchangeRate: Decodable {
    let success: Bool?
    let terms : String?
    let privacy : String?
    let timestamp: TimeInterval?
    let source: String?
    let quotes: Dictionary<String, Double>?
    
    func quotesArray() -> [Quote]? {
        return quotes?
                .sorted { $0.0 < $1.0 }
                .filter {
                    if let source = source {
                        let name = $0.key.replacingOccurrences(of: source, with: "")
                        if name == "" { return false }
                    }
                    return true
                }.map {
                    var name = $0.key
                    if let source = source {
                        name = name.replacingOccurrences(of: source, with: "")
                    }
                    return Quote(name: name, value: $0.1)
                }
    }
}

struct Quote {
    var name : String
    var value : Double
}

extension ExchangeRate {
    
    static func urlForCurrency(currency: String) -> URL? {
        let url = URL(string: "http://www.apilayer.net/api/live?access_key=393d7e91eea017841fc9bf9fe784e94f&source=\(currency)")
        return url
    }
}
