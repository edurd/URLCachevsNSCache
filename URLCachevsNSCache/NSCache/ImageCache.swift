//
//  ImageCache.swift
//  URLCachevsNSCache
//
//  Created by Eduardo Hoyos on 11/11/25.
//

import UIKit

final class ImageCache {
    static let shared = NSCache<NSString, UIImage>()

    private init() {}
}

func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
    // 1. Check cache first
    if let cachedImage = ImageCache.shared.object(forKey: url.absoluteString as NSString) {
        completion(cachedImage)
        return
    }

    // 2. Fetch image from network
    URLSession.shared.dataTask(with: url) { data, _, _ in
        guard let data = data, let image = UIImage(data: data) else {
            completion(nil)
            return
        }

        // 3. Save to cache
        ImageCache.shared.setObject(image, forKey: url.absoluteString as NSString)

        DispatchQueue.main.async {
            completion(image)
        }
    }.resume()
}
