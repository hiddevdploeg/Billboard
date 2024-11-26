//
//  CachedImageManager.swift
//  AsyncImageStarter
//
//  Created by Tunde Adegoroye on 09/04/2022.
//

import Foundation
import Observation
@Observable public final class CachedImageManager {
    
    private(set) var currentState: CachedImageState?
    
    private let imageRetriver = ImageRetriver()
    
    @MainActor
    public func load(_ imgUrl: String,
              cache: ImageCache = .shared) async {
        
        self.currentState = .loading
        
        if let imageData = cache.object(forkey: imgUrl as NSString) {
            self.currentState = .success(data: imageData)
            return
        }
        
        do {
            let data = try await imageRetriver.fetch(imgUrl)
            self.currentState = .success(data: data)
            cache.set(object: data as NSData,
                      forKey: imgUrl as NSString)            
        } catch {
            self.currentState = .failed(error: error)
        }
    }
}

