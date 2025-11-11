//
//  SmartImageCache.swift
//  URLCachevsNSCache
//
//  Created by Eduardo Hoyos on 11/11/25.
//

import Foundation
import UIKit

final class SmartImageCache {
    static let shared = SmartImageCache()
    private let imageCache = NSCache<NSString, UIImage>()

    private init() {}

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        // Step 1: Try in-memory cache
        if let cached = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cached)
            return
        }

        // Step 2: Check URLCache for cached response
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)),
           let image = UIImage(data: cachedResponse.data) {
            imageCache.setObject(image, forKey: url.absoluteString as NSString)
            completion(image)
            return
        }

        // Step 3: Download and cache both
        URLSession.shared.dataTask(with: url) { data, response, _ in
            guard
                let data = data,
                let response = response,
                let image = UIImage(data: data)
            else {
                completion(nil)
                return
            }

            let cachedData = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedData, for: URLRequest(url: url))
            self.imageCache.setObject(image, forKey: url.absoluteString as NSString)

            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
