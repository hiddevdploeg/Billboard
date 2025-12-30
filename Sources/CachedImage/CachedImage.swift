//
//  CachedImage.swift
//  AsyncImageStarter
//
//  Created by Tunde Adegoroye on 09/04/2022.
//

import SwiftUI

public struct CachedImage<Content: View>: View {
    
    @State private var manager = CachedImageManager()
    
    public let url: String
    public let animation: Animation?
    public let transition: AnyTransition
    public let content: (AsyncImagePhase) -> Content
    
    public init(url: String,
         animation: Animation? = nil,
         transition: AnyTransition = .identity,
         @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.animation = animation
        self.transition = transition
        self.content = content
    }
    
    
    public var body: some View {
        ZStack {
            switch manager.currentState {
            case .loading:
                content(.empty)
                    .transition(transition)
            case .success(let data):
                if let image = NSUIImage(data: data) {
                    content(.success(Image(nsuiImage: image)))
                        .transition(transition)
                } else {
                    content(.failure(CachedImageError.invalidData))
                        .transition(transition)
                }
            case .failed(let error):
                content(.failure(error))
                    .transition(transition)
            default:
                content(.empty)
                    .transition(transition)
            }
        }
        .animation(animation, value: manager.currentState)
        .task {
            await manager.load(url)
        }
    }
}

struct CachedImage_Previews: PreviewProvider {
    static var previews: some View {
        CachedImage(url: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/RedDot_Burger.jpg/600px-RedDot_Burger.jpg") { _ in EmptyView() }
    }
}

extension CachedImage {
    enum CachedImageError: Error {
        case invalidData
    }
}
