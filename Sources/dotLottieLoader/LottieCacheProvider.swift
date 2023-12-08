//
//  LottieCacheProvider.swift
//  Lottie
//
//  Created by Evandro Hoffmann on 20/10/22.
//

import Foundation

/// `LottieCacheProvider` is a protocol that describes a DotLottie Cache.
/// DotLottie Cache is used when loading `DotLottie` models. Using a DotLottie Cache
/// can increase performance when loading an animation multiple times.
///
/// Lottie comes with a prebuilt LRU DotLottie Cache.
public protocol LottieCacheProvider {

  func file(forKey: String) -> LottieFile?

  func setFile(_ lottie: LottieFile, forKey: String)

  func clearCache()

}
