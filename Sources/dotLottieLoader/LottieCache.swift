//
//  LRULottieCache.swift
//  Lottie
//
//  Created by Evandro Hoffmann on 20/10/22.
//

import Foundation

/// A DotLottie Cache that will store lottie files up to `cacheSize`.
///
/// Once `cacheSize` is reached, the least recently used lottie will be ejected.
/// The default size of the cache is 100.
public class LottieCache: LottieCacheProvider {

  // MARK: Lifecycle

  public init() {
    cache.countLimit = Self.defaultCacheCountLimit
  }

  // MARK: Public

  /// The global shared Cache.
  public static let sharedCache = LottieCache()

  /// The size of the cache.
  public var cacheSize = defaultCacheCountLimit {
    didSet {
      cache.countLimit = cacheSize
    }
  }

  /// Clears the Cache.
  public func clearCache() {
    cache.removeAllObjects()
  }

  public func file(forKey key: String) -> LottieFile? {
    cache.object(forKey: key as NSString)
  }

  public func setFile(_ lottie: LottieFile, forKey key: String) {
    cache.setObject(lottie, forKey: key as NSString)
  }

  // MARK: Private

  private static let defaultCacheCountLimit = 100

  private var cache = NSCache<NSString, LottieFile>()

}
