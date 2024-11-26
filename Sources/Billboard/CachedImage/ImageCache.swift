//
//  ImageCache.swift
//  AsyncImageStarter
//
//  Created by Tunde Adegoroye on 09/04/2022.
//

import Foundation


public class ImageCache: @unchecked Sendable {
    
    typealias CacheType = NSCache<NSString, NSData>
    
    public static let shared = ImageCache()
    
    private init() {}
    
    private lazy var cache: CacheType = {
        let cache = CacheType()
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 52428800 Bytes > 50MB
        return cache
    }()
    
    public func object(forkey key: NSString) -> Data? {
        cache.object(forKey: key) as? Data
    }
    
    public func set(object: NSData, forKey key: NSString) {
        cache.setObject(object, forKey: key)
    }
}
