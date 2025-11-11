//
//  URLCacheInit.swift
//  URLCachevsNSCache
//
//  Created by Eduardo Hoyos on 11/11/25.
//

import Foundation


class URLCacheInit {
    
    // Configure a custom shared cache
    let urlCache = URLCache(
        memoryCapacity: 50 * 1024 * 1024, // 50 MB memory
        diskCapacity: 200 * 1024 * 1024,  // 200 MB disk
        directory: nil                    // Use default cache directory
    )

    init() {
        URLCache.shared = urlCache
    }

    func usingURLSession() {
        let url = URL(string: "https://api.example.com/profile")!
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let response = response {
                print("✅ Response size: \(data.count) bytes")
            }
        }
        task.resume()
    }
}

