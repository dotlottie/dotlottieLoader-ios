//
//  DotLottieFile.swift
//  LottieFiles
//
//  Created by Evandro Harrison Hoffmann on 27/06/2020.
//  Copyright © 2020 LottieFiles. All rights reserved.
//

import Foundation
import Zip

/// Detailed .lottie file structure
public struct DotLottieFile {
    public let remoteUrl: URL
    public let localUrl: URL
    
    public static let manifestFileName: String = "manifest.json"
    public static let animationsFolderName: String = "animations"
    public static let imagesFolderName: String = "images"
    
    /// Manifest.json file loading
    public var manifest: DotLottieManifest? {
        let path = localUrl.appendingPathComponent(DotLottieFile.manifestFileName)
        return try? DotLottieManifest.load(from: path)
    }
    
    /// Animation url for main animation
    public var animationUrl: URL? {
        guard let animationId = manifest?.animations.first?.id else { return nil }
        let dotLottieJson = "\(DotLottieFile.animationsFolderName)/\(animationId).json"
        return localUrl.appendingPathComponent(dotLottieJson)
    }
    
    /// Animations folder url
    public var animationsUrl: URL {
        localUrl.appendingPathComponent("\(DotLottieFile.animationsFolderName)")
    }
    
    /// All files in animations folder
    public var animations: [URL] {
        FileManager.default.urls(for: animationsUrl) ?? []
    }
    
    /// Images folder url
    public var imagesUrl: URL {
        localUrl.appendingPathComponent("\(DotLottieFile.imagesFolderName)")
    }
    
    /// All images in images folder
    public var images: [URL] {
        FileManager.default.urls(for: imagesUrl) ?? []
    }
    
    /// Constructor with url.
    /// Returns nil if is not a .lottie file and decompression failed
    /// - Parameters:
    ///   - url: URL to .lottie file
    ///   - cache: Cache type 
    public init?(url: URL, cache: DotLottieCache) {
        self.remoteUrl = url
        self.localUrl = DotLottieUtils.animationsDirectoryURL(for: url)
        
        guard url.isDotLottieFile else { return nil }
        guard decompress(from: url, in: localUrl, cache: cache) else { return nil }
    }
    
    /// Decompresses .lottie file and saves to local temp folder
    /// - Parameters:
    ///   - url: url to .lottie file
    ///   - directory: url to destination of decompression contents
    ///   - cache: Cache type   
    /// - Returns: success true/false
    private func decompress(from url: URL, in directory: URL, cache: DotLottieCache) -> Bool {
        guard cache.shouldDecompress(from: url) else {
            DotLottieUtils.log("File already decompressed at \(directory.path)")
            return true
        }
        
        Zip.addCustomFileExtension(DotLottieUtils.dotLottieExtension)
        
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            try Zip.unzipFile(url, destination: directory, overwrite: true, password: nil)
            DotLottieUtils.log("File decompressed to \(directory.path)")
            return true
        } catch {
            DotLottieUtils.log("Extraction of dotLottie archive failed with error: \(error)")
            return false
        }
    }
    
    /// Creates dotLottieFile from animation json
    /// - Parameters:
    ///   - url: url of JSON lottie animation
    ///   - directory: directory to save file
    ///   - loop: loop enabled
    ///   - themeColor: theme color
    /// - Returns: URL of .lottie file
    static func compress(jsonLottieAt url: URL, in directory: URL = DotLottieUtils.tempDirectoryURL, loop: Bool = true, themeColor: String = "#ffffff") -> URL? {
        Zip.addCustomFileExtension(DotLottieUtils.dotLottieExtension)
        
        do {
            let fileName = url.deletingPathExtension().lastPathComponent
            let dotLottieDirectory = directory.appendingPathComponent(fileName)
            try FileManager.default.createDirectory(at: dotLottieDirectory, withIntermediateDirectories: true, attributes: nil)
            
            let animationsDirectory = dotLottieDirectory.appendingPathComponent("animations")
            try FileManager.default.createDirectory(at: animationsDirectory, withIntermediateDirectories: true, attributes: nil)
            
            let animationData = try Data(contentsOf: url)
            try animationData.write(to: animationsDirectory.appendingPathComponent(fileName).appendingPathExtension("json"))
            
            let manifest = DotLottieManifest(animations: [
                DotLottieAnimation(loop: loop, themeColor: themeColor, speed: 1.0, id: fileName)
            ], version: "1.0", author: "LottieFiles", generator: "LottieFiles dotLottieLoader-iOS 0.1.4")
            let manifestUrl = dotLottieDirectory.appendingPathComponent("manifest").appendingPathExtension("json")
            let manifestData = try manifest.encode()
            try manifestData.write(to: manifestUrl)
            
            let dotLottieUrl = directory.appendingPathComponent(fileName).appendingPathExtension("lottie")
            try Zip.zipFiles(paths: [animationsDirectory, manifestUrl], zipFilePath: dotLottieUrl, password: nil, compression: .DefaultCompression, progress: { progress in
                DotLottieUtils.log("Compressing dotLottie file: \(progress)")
            })
            
            return dotLottieUrl
        } catch {
            DotLottieUtils.log("Extraction of dotLottie archive failed with error: \(error)")
            return nil
        }
    }
    
}
