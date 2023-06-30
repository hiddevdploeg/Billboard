//
//  BillboardConstant.swift
//
//
//  Created by Hidde van der Ploeg on 30/06/2023.
//

import Foundation


struct BillboardConstants {
    static let adsURL = URL(string:"https://billboard-source.vercel.app/ads.json")
    
    static let sampleFullscreenAd : BillboardAd = BillboardAd(appStoreID: "1661833753",
                                                              name: "Sample Ad",
                                                              title: "Red Pandas",
                                                              description: "Red Pandas are the cutest animals out there. So this is a sample ad to show just that",
                                                              media: URL(string: "https://images.unsplash.com/photo-1600094329163-a2b52f913831?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1287&q=80")!,
                                                              backgroundColor: "060303",
                                                              textColor: "ffffff",
                                                              ctaColor: "ffffff",
                                                              isFullscreen: true,
                                                              transparentBG: false)
}
