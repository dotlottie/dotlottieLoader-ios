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
public class DotLottieFile {
    public static let manifestFileName: String = "manifest.json"
    public static let animationsFolderName: String = "animations"
    public static let imagesFolderName: String = "images"
    
    private let fileUrl: URL
    
    /// Manifest.json file loading
    var manifest: DotLottieManifest? {
        let path = fileUrl.appendingPathComponent(DotLottieFile.manifestFileName)
        return try? DotLottieManifest.load(from: path)
    }
    
    /// List of `LottieAnimation` in the file
    public var animations: [Animation] = []

    /// Animations folder url
    lazy var animationsUrl: URL = fileUrl.appendingPathComponent("\(DotLottieFile.animationsFolderName)")

    /// All files in animations folder
    lazy var animationUrls: [URL] = FileManager.default.urls(for: animationsUrl) ?? []

    /// Images folder url
    lazy var imagesUrl: URL = fileUrl.appendingPathComponent("\(DotLottieFile.imagesFolderName)")

    /// All images in images folder
    lazy var imageUrls: [URL] = FileManager.default.urls(for: imagesUrl) ?? []

    /// Loads `DotLottie` from `Data` object containing a compressed animation.
    ///
    /// - Parameters:
    ///  - data: Data of .lottie file
    ///  - filename: Name of .lottie file
    ///  - Returns: Deserialized `DotLottie`. Optional.
    init(data: Data, filename: String) throws {
        fileUrl = DotLottieUtils.tempDirectoryURL.appendingPathComponent(filename.asFilename())
        try decompress(data: data, to: fileUrl)
    }
    
    /// Decompresses .lottie file from `URL` and saves to local temp folder
    ///
    /// - Parameters:
    ///  - url: url to .lottie file
    ///  - destinationURL: url to destination of decompression contents
    private func decompress(from url: URL, to destinationURL: URL) throws {
        try? FileManager.default.removeItem(at: destinationURL)
        try FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
        try Zip.unzipFile(url, destination: destinationURL, overwrite: true, password: nil)
        try loadContent()
        try? FileManager.default.removeItem(at: destinationURL)
        try? FileManager.default.removeItem(at: url)
    }
    
    /// Decompresses .lottie file from `Data` and saves to local temp folder
    ///
    /// - Parameters:
    ///  - url: url to .lottie file
    ///  - destinationURL: url to destination of decompression contents
    private func decompress(data: Data, to destinationURL: URL) throws {
        let url = destinationURL.appendingPathExtension("lottie")
        try FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
        try data.write(to: url)
        try decompress(from: url, to: destinationURL)
    }
    
    /// Loads file content to memory
    private func loadContent() throws {
        animations = try loadManifest().animations.map { dotLottieAnimation in
            let configuration = DotLottieConfiguration(
                id: dotLottieAnimation.id,
                imagesUrl: imagesUrl,
                loop: dotLottieAnimation.loop ?? false,
                speed: Double(dotLottieAnimation.speed ?? 1))
            
            return DotLottieFile.Animation(
                animationUrl: animationsUrl.appendingPathComponent("\(dotLottieAnimation.id).json"),
                configuration: configuration)
        }
    }
    
    private func loadManifest() throws -> DotLottieManifest {
        let path = fileUrl.appendingPathComponent(DotLottieFile.manifestFileName)
        return try DotLottieManifest.load(from: path)
    }
    
    public struct Animation {
        public var animationUrl: URL
        public var configuration: DotLottieConfiguration
    }
}

extension String {
    
    // MARK: Fileprivate
    
    fileprivate func asFilename() -> String {
        lastPathComponent().removingPathExtension()
    }
    
    // MARK: Private
    
    private func lastPathComponent() -> String {
        (self as NSString).lastPathComponent
    }
    
    private func removingPathExtension() -> String {
        (self as NSString).deletingPathExtension
    }
}
