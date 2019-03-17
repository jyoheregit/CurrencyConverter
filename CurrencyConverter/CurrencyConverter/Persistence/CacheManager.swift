//
//  CachedManager.swift
//  CurrencyConverter
//
//  Created by Joe on 16/03/19.
//  Copyright © 2019 Joe. All rights reserved.
//

import Foundation

protocol CacheManagerContract {
    func fetch<T>(_ resource: Resource<T>) -> Data?
    func save<T>(_ data: Data, for resource: Resource<T>)
}

final class CacheManager : CacheManagerContract {
    
    private let cache : Cacheable
    
    init(cache : Cacheable) {
        self.cache = cache
    }
    
    func fetch<T>(_ resource: Resource<T>) -> Data? {
        return cache.fetch(resource)
    }
    
    func save<T>(_ data: Data, for resource: Resource<T>) {
        cache.save(data, for: resource)
    }
}
