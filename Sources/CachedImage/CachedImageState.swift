//
//  CachedImageState.swift
//  Billboard
//
//  Created by Hidde van der Ploeg on 26/11/2024.
//


import Foundation
public enum CachedImageState: Equatable {
    case loading
    case failed(error: Error)
    case success(data: Data)
    
    public static func == (lhs: CachedImageState,
                    rhs: CachedImageState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (let .failed(lhsError), let .failed(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (let .success(lhsData), let .success(rhsData)):
            return lhsData == rhsData
        default:
            return false
        }
    }
}
