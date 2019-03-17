//
//  WebService.swift
//  CurrencyConverter
//
//  Created by Joe on 16/03/19.
//  Copyright © 2019 Joe. All rights reserved.
//

import Foundation

protocol ServiceProtocol {
    typealias CompletionHandler<T> = ((_ parsedData : T?, _ error: Error?) -> ())
    func fetch<T>(_ resource: Resource<T>, completionHandler: @escaping (CompletionHandler<T>))
}

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with url: URL, completionHandler: @escaping (DataTaskResult)) -> URLSessionDataTask
}

extension URLSession : URLSessionProtocol { }

class WebService : ServiceProtocol {
    
    private let session: URLSessionProtocol
    private let cacheManager: CacheManager

    init(session: URLSessionProtocol = URLSession.shared, cacheManager : CacheManager) {
        self.session = session
        self.cacheManager = cacheManager
    }
    
    func fetch<T>(_ resource: Resource<T>, completionHandler: @escaping (CompletionHandler<T>)) {
        
        let dataResource = Resource<Data>(url: resource.url)
        if let data = cacheManager.fetch(dataResource) {
            completionHandler(resource.parse(data), nil)
        }
        else {
            self.session.dataTask(with: resource.url) { [weak self] (data, response, error) in
                print("Network Call")
                guard let data = data else {
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                    return
                }
                self?.cacheManager.save(data, for: resource)
                DispatchQueue.main.async {
                    completionHandler(resource.parse(data), error)
                }
            }.resume()
        }
    }
}



