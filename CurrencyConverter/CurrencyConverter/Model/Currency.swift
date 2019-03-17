//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Joe on 16/03/19.
//  Copyright © 2019 Joe. All rights reserved.
//

import Foundation

struct Currency: Decodable {
    let success: Bool?
    let terms : String?
    let privacy : String?
    let currencies : Dictionary<String, String>?
    
    func currencyArray() -> [Symbol]? {
        return currencies?
            .sorted { $0.1 < $1.1 }
            .map {
            return Symbol(id: $0.0, name: $0.1)
        }
    }
}

struct Symbol {
    var id : String
    var name : String
}

extension Currency {
    static var url = URL(string: "http://apilayer.net/api/list?access_key=393d7e91eea017841fc9bf9fe784e94f")
}
