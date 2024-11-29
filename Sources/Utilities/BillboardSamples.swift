//
//  BillboardSamples.swift
//
//
//  Created by Hidde van der Ploeg on 30/06/2023.
//

import Foundation


public struct BillboardSamples {
    
    static let sampleDefaultAd : BillboardAd = BillboardAd(appStoreID: "1596487035",
                                                           name: "NowPlaying",
                                                           title: "Learn everything about any song",
                                                           description: "A music companion app that lets you discover the stories behind and song, album or artist.",
                                                           category: .music,
                                                           media: URL(string: "https://pub-378e0dd96b5343108a04317ebddebb4e.r2.dev/nowplaying.png")!,
                                                           backgroundColor: "344442",
                                                           textColor: "EFDED7",
                                                           tintColor: "EFDED7",
                                                           fullscreen: false,
                                                           transparent: true)
    
    static let sampleFullScreenAd : BillboardAd = BillboardAd(appStoreID: "1661833753",
                                                              name: "Sample Ad",
                                                              title: "Red Pandas",
                                                              description: "Red Pandas are the cutest animals out there. So this is a sample ad to show just that",
                                                              media: URL(string: "https://images.unsplash.com/photo-1600094329163-a2b52f913831?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1287&q=80")!,
                                                              backgroundColor: "060303",
                                                              textColor: "ffffff",
                                                              tintColor: "ffffff",
                                                              fullscreen: true,
                                                              transparent: false)
}
