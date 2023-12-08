//
//  DotLottieUtils.swift
//  LottieFiles
//
//  Created by Evandro Harrison Hoffmann on 27/06/2020.
//  Copyright © 2020 LottieFiles. All rights reserved.
//

import Foundation

public struct DotLottieUtils {
    public static let dotLottieExtension = "lottie"
    public static let jsonExtension = "json"
    
    /// Enables log printing
    public static var isLogEnabled: Bool = false
    
    /// Prints log if enabled
    /// - Parameter text: Text to log
    public static func log(_ text: String) {
        guard isLogEnabled else { return }
        print("[dotLottie] \(text)")
    }
    
    /// Temp folder to app directory
    public static var tempDirectoryURL: URL {
        if #available(iOS 10.0, *) {
            return FileManager.default.temporaryDirectory
        }
        
        return URL(fileURLWithPath: NSTemporaryDirectory())
    }
    
    /// Temp animations folder
    public static var animationsDirectoryURL: URL {
        DotLottieUtils.tempDirectoryURL.appendingPathComponent("animations")
    }
    
    /// Returns url for animations foder with animation name
    /// - Parameter url: Animation url
    /// - Returns: url to animation temp folder
    public static func animationsDirectoryURL(for url: URL) -> URL {
        return animationsDirectoryURL.appendingPathComponent(url.lastPathComponent)
    }
    
    /// Temp downloads folder
    public static var downloadsDirectoryURL: URL {
        DotLottieUtils.tempDirectoryURL.appendingPathComponent("downloads")
    }
    
    /// Returns temp download url for file
    /// - Parameter url: Animation url
    /// - Returns: url to animation temp folder
    public static func downloadsDirectoryURL(for url: URL) -> URL {
        DotLottieUtils.downloadsDirectoryURL.appendingPathComponent(url.lastPathComponent)
    }
    
    /// Returns url to file in local bundle with given name
    /// - Parameter name: name of animation file
    /// - Returns: URL to local animation
    public static func bundleURL(for name: String) -> URL? {
        guard let url = Bundle.main.url(forResource: name, withExtension: dotLottieExtension, subdirectory: nil) else {
            guard let url = Bundle.main.url(forResource: name, withExtension: jsonExtension, subdirectory: nil) else {
                return nil
            }
            return url
        }
        return url
    }
}

extension URL {
    
    /// Checks if url is a lottie file
    public var isDotLottieFile: Bool {
        return pathExtension == DotLottieUtils.dotLottieExtension
    }
    
    /// Checks if url is a json file
    public var isJsonFile: Bool {
        return pathExtension == DotLottieUtils.jsonExtension
    }
    
    /// Checks if url has already been downloaded
    public var isLottieFileDownloaded: Bool {
        let url = DotLottieUtils.downloadsDirectoryURL(for: self)
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    /// Checks if url has been decompressed
    public var isLottieFileDecompressed: Bool {
        let url = DotLottieUtils.animationsDirectoryURL(for: self)
            .appendingPathComponent(LottieFile.animationsFolderName)
        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) {
            return isDirectory.boolValue
        }
        
        return false
    }
    
    /// Checks if file is remote
    public var isRemoteFile: Bool {
        absoluteString.contains("http")
    }
    
    public var urls: [URL] {
        FileManager.default.urls(for: self) ?? []
    }
}

extension FileManager {
    /// Lists urls for all files in a directory
    /// - Parameters:
    ///   - url: URL of directory to search
    ///   - skipsHiddenFiles: If should or not show hidden files
    /// - Returns: Returns urls of all files matching criteria in the directory
    public func urls(for url: URL, skipsHiddenFiles: Bool = true ) -> [URL]? {
        try? contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [])
    }
}

// MARK: - DotLottieError

public enum DotLottieError: Error {
  /// URL response has no data.
  case noDataLoaded
  /// Asset with this name was not found in the provided bundle.
  case assetNotFound(name: String, bundle: Bundle?)
  /// Animation loading from asset is not supported on macOS 10.10.
  case loadingFromAssetNotSupported

  @available(*, deprecated, message: "Unused")
  case invalidFileFormat
  @available(*, deprecated, message: "Unused")
  case invalidData
  @available(*, deprecated, message: "Unused")
  case animationNotAvailable
}

// MARK: - Data

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension Data {

  init(assetName: String, in bundle: Bundle) throws {
    #if canImport(UIKit)
    if let asset = NSDataAsset(name: assetName, bundle: bundle) {
      self = asset.data
      return
    } else {
      throw DotLottieError.assetNotFound(name: assetName, bundle: bundle)
    }
    #else
    if #available(macOS 10.11, *) {
      if let asset = NSDataAsset(name: assetName, bundle: bundle) {
        self = asset.data
        return
      } else {
        throw DotLottieError.assetNotFound(name: assetName, bundle: bundle)
      }
    }
    throw DotLottieError.loadingFromAssetNotSupported
    #endif
  }
}

// MARK: - Bundle

extension Bundle {
  func dotLottieData(_ name: String, subdirectory: String? = nil) throws -> Data {
    // Check for files in the bundle at the given path
    let name = name.removingDotLottieSuffix()
    if let url = url(forResource: name, withExtension: "lottie", subdirectory: subdirectory) {
      return try Data(contentsOf: url)
    }

    let assetKey = subdirectory != nil ? "\(subdirectory ?? "")/\(name)" : name
    return try Data(assetName: assetKey, in: self)
  }
}

extension String {
  fileprivate func removingDotLottieSuffix() -> String {
    // Allow filenames to be passed with a ".lottie" extension (but not other extensions)
    // to keep the behavior from Lottie 2.x - instead of failing to load the file
    guard hasSuffix(".lottie") else {
      return self
    }

    return (self as NSString).deletingPathExtension
  }
}
