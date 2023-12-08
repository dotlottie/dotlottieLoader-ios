//
//  DotLottieAnimation.swift
//  dotLottie-ios
//
//  Created by Evandro Hoffmann on 05/08/2020.
//  Copyright (c) 2020 dotLottie. All rights reserved.
//
import Foundation

public class DotLottieLoader {
    
    public enum SynchronouslyBlockingCurrentThread {
      /// Loads an DotLottie from a specific filepath synchronously. Returns a `Result<DotLottieFile, Error>`
      /// Please use the asynchronous methods whenever possible. This operation will block the Thread it is running in.
      ///
      /// - Parameter filepath: The absolute filepath of the lottie to load. EG "/User/Me/starAnimation.lottie"
      /// - Parameter LottieCache: A cache for holding loaded lotties. Defaults to `LRULottieCache.sharedCache`. Optional.
      public static func loadedFrom(
        filepath: String,
        LottieCache: LottieCacheProvider? = LottieCache.sharedCache)
        -> Result<LottieFile, Error>
      {
        /// Check cache for lottie
        if
          let LottieCache = LottieCache,
          let lottie = LottieCache.file(forKey: filepath)
        {
          return .success(lottie)
        }

        do {
          /// Decode the lottie.
          let url = URL(fileURLWithPath: filepath)
          let data = try Data(contentsOf: url)
          let lottie = try LottieFile(data: data, filename: url.deletingPathExtension().lastPathComponent)
          LottieCache?.setFile(lottie, forKey: filepath)
          return .success(lottie)
        } catch {
          /// Decoding Error.
          return .failure(error)
        }
      }

      /// Loads a DotLottie model from a bundle by its name synchronously. Returns a `Result<DotLottieFile, Error>`
      /// Please use the asynchronous methods whenever possible. This operation will block the Thread it is running in.
      ///
      /// - Parameter name: The name of the lottie file without the lottie extension. EG "StarAnimation"
      /// - Parameter bundle: The bundle in which the lottie is located. Defaults to `Bundle.main`
      /// - Parameter subdirectory: A subdirectory in the bundle in which the lottie is located. Optional.
      /// - Parameter LottieCache: A cache for holding loaded lotties. Defaults to `LRULottieCache.sharedCache`. Optional.
      public static func named(
        _ name: String,
        bundle: Bundle = Bundle.main,
        subdirectory: String? = nil,
        LottieCache: LottieCacheProvider? = LottieCache.sharedCache)
        -> Result<LottieFile, Error>
      {
        /// Create a cache key for the lottie.
        let cacheKey = bundle.bundlePath + (subdirectory ?? "") + "/" + name

        /// Check cache for lottie
        if
          let LottieCache = LottieCache,
          let lottie = LottieCache.file(forKey: cacheKey)
        {
          return .success(lottie)
        }

        do {
          /// Decode animation.
          let data = try bundle.dotLottieData(name, subdirectory: subdirectory)
          let lottie = try LottieFile(data: data, filename: name)
          LottieCache?.setFile(lottie, forKey: cacheKey)
          return .success(lottie)
        } catch {
          /// Decoding error.
          return .failure(error)
        }
      }
    }

    /// Loads a DotLottie model from a bundle by its name. Returns `nil` if a file is not found.
    ///
    /// - Parameter name: The name of the lottie file without the lottie extension. EG "StarAnimation"
    /// - Parameter bundle: The bundle in which the lottie is located. Defaults to `Bundle.main`
    /// - Parameter subdirectory: A subdirectory in the bundle in which the lottie is located. Optional.
    /// - Parameter LottieCache: A cache for holding loaded lotties. Defaults to `LRULottieCache.sharedCache`. Optional.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
    public static func named(
      _ name: String,
      bundle: Bundle = Bundle.main,
      subdirectory: String? = nil,
      LottieCache: LottieCacheProvider? = LottieCache.sharedCache)
      async throws -> LottieFile
    {
      try await withCheckedThrowingContinuation { continuation in
        DotLottieLoader.named(name, bundle: bundle, subdirectory: subdirectory, LottieCache: LottieCache) { result in
          continuation.resume(with: result)
        }
      }
    }

    /// Loads a DotLottie model from a bundle by its name. Returns `nil` if a file is not found.
    ///
    /// - Parameter name: The name of the lottie file without the lottie extension. EG "StarAnimation"
    /// - Parameter bundle: The bundle in which the lottie is located. Defaults to `Bundle.main`
    /// - Parameter subdirectory: A subdirectory in the bundle in which the lottie is located. Optional.
    /// - Parameter LottieCache: A cache for holding loaded lotties. Defaults to `LRULottieCache.sharedCache`. Optional.
    /// - Parameter dispatchQueue: A dispatch queue used to load animations. Defaults to `DispatchQueue.global()`. Optional.
    /// - Parameter handleResult: A closure to be called when the file has loaded.
    public static func named(
      _ name: String,
      bundle: Bundle = Bundle.main,
      subdirectory: String? = nil,
      LottieCache: LottieCacheProvider? = LottieCache.sharedCache,
      dispatchQueue: DispatchQueue = .global(),
      handleResult: @escaping (Result<LottieFile, Error>) -> Void)
    {
      dispatchQueue.async {
        let result = SynchronouslyBlockingCurrentThread.named(
          name,
          bundle: bundle,
          subdirectory: subdirectory,
          LottieCache: LottieCache)

        DispatchQueue.main.async {
          handleResult(result)
        }
      }
    }

    /// Loads an DotLottie from a specific filepath.
    /// - Parameter filepath: The absolute filepath of the lottie to load. EG "/User/Me/starAnimation.lottie"
    /// - Parameter LottieCache: A cache for holding loaded lotties. Defaults to `LRULottieCache.sharedCache`. Optional.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
    public static func loadedFrom(
      filepath: String,
      LottieCache: LottieCacheProvider? = LottieCache.sharedCache)
      async throws -> LottieFile
    {
      try await withCheckedThrowingContinuation { continuation in
        DotLottieLoader.loadedFrom(filepath: filepath, LottieCache: LottieCache) { result in
          continuation.resume(with: result)
        }
      }
    }

    /// Loads an DotLottie from a specific filepath.
    /// - Parameter filepath: The absolute filepath of the lottie to load. EG "/User/Me/starAnimation.lottie"
    /// - Parameter LottieCache: A cache for holding loaded lotties. Defaults to `LRULottieCache.sharedCache`. Optional.
    /// - Parameter dispatchQueue: A dispatch queue used to load animations. Defaults to `DispatchQueue.global()`. Optional.
    /// - Parameter handleResult: A closure to be called when the file has loaded.
    public static func loadedFrom(
      filepath: String,
      LottieCache: LottieCacheProvider? = LottieCache.sharedCache,
      dispatchQueue: DispatchQueue = .global(),
      handleResult: @escaping (Result<LottieFile, Error>) -> Void)
    {
      dispatchQueue.async {
        let result = SynchronouslyBlockingCurrentThread.loadedFrom(
          filepath: filepath,
          LottieCache: LottieCache)

        DispatchQueue.main.async {
          handleResult(result)
        }
      }
    }

    /// Loads a DotLottie model from the asset catalog by its name. Returns `nil` if a lottie is not found.
    /// - Parameter name: The name of the lottie file in the asset catalog. EG "StarAnimation"
    /// - Parameter bundle: The bundle in which the lottie is located. Defaults to `Bundle.main`
    /// - Parameter LottieCache: A cache for holding loaded lottie files. Defaults to `LRULottieCache.sharedCache` Optional.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
    public static func asset(
      named name: String,
      bundle: Bundle = Bundle.main,
      LottieCache: LottieCacheProvider? = LottieCache.sharedCache)
      async throws -> LottieFile
    {
      try await withCheckedThrowingContinuation { continuation in
        DotLottieLoader.asset(named: name, bundle: bundle, LottieCache: LottieCache) { result in
          continuation.resume(with: result)
        }
      }
    }

    ///    Loads a DotLottie model from the asset catalog by its name. Returns `nil` if a lottie is not found.
    ///    - Parameter name: The name of the lottie file in the asset catalog. EG "StarAnimation"
    ///    - Parameter bundle: The bundle in which the lottie is located. Defaults to `Bundle.main`
    ///    - Parameter LottieCache: A cache for holding loaded lottie files. Defaults to `LRULottieCache.sharedCache` Optional.
    ///    - Parameter dispatchQueue: A dispatch queue used to load animations. Defaults to `DispatchQueue.global()`. Optional.
    ///    - Parameter handleResult: A closure to be called when the file has loaded.
    public static func asset(
      named name: String,
      bundle: Bundle = Bundle.main,
      LottieCache: LottieCacheProvider? = LottieCache.sharedCache,
      dispatchQueue: DispatchQueue = .global(),
      handleResult: @escaping (Result<LottieFile, Error>) -> Void)
    {
      dispatchQueue.async {
        /// Create a cache key for the lottie.
        let cacheKey = bundle.bundlePath + "/" + name

        /// Check cache for lottie
        if
          let LottieCache = LottieCache,
          let lottie = LottieCache.file(forKey: cacheKey)
        {
          /// If found, return the lottie.
          DispatchQueue.main.async {
            handleResult(.success(lottie))
          }
          return
        }

        do {
          /// Load data from Asset
          let data = try Data(assetName: name, in: bundle)

          /// Decode lottie.
          let lottie = try LottieFile(data: data, filename: name)
          LottieCache?.setFile(lottie, forKey: cacheKey)
          DispatchQueue.main.async {
            handleResult(.success(lottie))
          }
        } catch {
          /// Decoding error.
          DispatchQueue.main.async {
            handleResult(.failure(error))
          }
        }
      }
    }

    /// Loads a DotLottie animation asynchronously from the URL.
    ///
    /// - Parameter url: The url to load the animation from.
    /// - Parameter animationCache: A cache for holding loaded animations. Defaults to `LRUAnimationCache.sharedCache`. Optional.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
    public static func loadedFrom(
      url: URL,
      session: URLSession = .shared,
      LottieCache: LottieCacheProvider? = LottieCache.sharedCache)
      async throws -> LottieFile
    {
      try await withCheckedThrowingContinuation { continuation in
        DotLottieLoader.loadedFrom(url: url, session: session, LottieCache: LottieCache) { result in
          continuation.resume(with: result)
        }
      }
    }

    /// Loads a DotLottie animation asynchronously from the URL.
    ///
    /// - Parameter url: The url to load the animation from.
    /// - Parameter animationCache: A cache for holding loaded animations. Defaults to `LRUAnimationCache.sharedCache`. Optional.
    /// - Parameter handleResult: A closure to be called when the animation has loaded.
    public static func loadedFrom(
      url: URL,
      session: URLSession = .shared,
      LottieCache: LottieCacheProvider? = LottieCache.sharedCache,
      handleResult: @escaping (Result<LottieFile, Error>) -> Void)
    {
      if let LottieCache = LottieCache, let lottie = LottieCache.file(forKey: url.absoluteString) {
        handleResult(.success(lottie))
      } else {
        let task = session.dataTask(with: url) { data, _, error in
          do {
            if let error = error {
              throw error
            }
            guard let data = data else {
              throw DotLottieError.noDataLoaded
            }
            let lottie = try LottieFile(data: data, filename: url.deletingPathExtension().lastPathComponent)
            DispatchQueue.main.async {
              LottieCache?.setFile(lottie, forKey: url.absoluteString)
              handleResult(.success(lottie))
            }
          } catch {
            DispatchQueue.main.async {
              handleResult(.failure(error))
            }
          }
        }
        task.resume()
      }
    }

}
