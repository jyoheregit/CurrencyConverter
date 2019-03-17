//
//  Cache.swift
//  CurrencyConverter
//
//  Created by Joe on 16/03/19.
//  Copyright © 2019 Joe. All rights reserved.
//

import Foundation

protocol Cacheable {
    func fetch<T>(_ resource: Resource<T>) -> Data?
    func save<T>(_ data: Data, for resource: Resource<T>)
    func cacheExpired<T>(resource : Resource<T>) -> Bool
}

final class Cache : Cacheable {
    var storage = FileStorage()
    
    func fetch<T>(_ resource: Resource<T>) -> Data? {
        let data = storage[resource.cacheKey]
        if (data != nil) && !cacheExpired(resource: resource) {
            print("From cache for resource \(resource.url)")
            return data
        }
        return nil
    }
    
    func save<T>(_ data: Data, for resource: Resource<T>) {
        print("Storing in cache for resource \(resource.url)")
        storage[resource.cacheKey] = data
    }
    
    func cacheExpired<T>(resource : Resource<T>) -> Bool {
        var hasCacheExpired = false
        if let creationDate = storage.createdDateForResourceWith(cacheKey: resource.cacheKey) {
            let createdSince = fabs(creationDate.timeIntervalSinceNow)
            print("creationDate : \(creationDate)")
            print("createdSince in seconds : \(createdSince)")
            if (createdSince > 1800) {
                storage.deleteFileOfResourceWith(cacheKey : resource.cacheKey)
                hasCacheExpired = true
            }
        }
        return hasCacheExpired
    }
}

class FileStorage {
    let baseURL = try? FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask, appropriateFor: nil,
                                               create: true)
    
    subscript(key: String) -> Data? {
        get {
            if let url = baseURL?.appendingPathComponent(key) {
                return try? Data(contentsOf: url)
            }
            return nil
        }
        set {
            if let url = baseURL?.appendingPathComponent(key) {
                _ = try? newValue?.write(to: url)
            }
        }
    }
    
    func createdDateForResourceWith(cacheKey : String) -> NSDate? {
        var creationDate : NSDate?
        guard let url = baseURL?.appendingPathComponent(cacheKey) else  { return nil }
        if let attrFile = try? FileManager.default.attributesOfItem(atPath: url.path) as NSDictionary {
            creationDate = attrFile[FileAttributeKey.creationDate] as? NSDate
        }
        return creationDate
    }
    
    func deleteFileOfResourceWith(cacheKey : String) {
        print("deleting file")
        if let url = baseURL?.appendingPathComponent(cacheKey) {
            try? FileManager.default.removeItem(at: url)
        }
    }
}
