//
//  DotLottieConfiguration.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 23/06/2021.
//

import Foundation
import Zip

/// Configuration model
public struct DotLottieCreator {
    /// URL to main animation JSON file
    public var url: URL
    
    /// Loop enabled - Default true
    public var loop: Bool = true
    
    /// appearance color in HEX - Default #ffffff
    public var themeColor: String = "#ffffff"
       
    /// URL to directory where we are saving the files
    public var directory: URL = DotLottieUtils.tempDirectoryURL
    
    public init(animationUrl: URL) {
        url = animationUrl
    }
    
    /// directory for dotLottie
    private var dotLottieDirectory: URL {
        directory.appendingPathComponent(fileName)
    }
    
    /// Animations directory
    private var animationsDirectory: URL {
        dotLottieDirectory.appendingPathComponent("animations")
    }
    
    /// checks if is a lottie file
    private var isLottie: Bool {
        url.isJsonFile
    }
    
    /// Filename
    private var fileName: String {
        url.deletingPathExtension().lastPathComponent
    }
    
    /// URL for main animation
    private var animationUrl: URL {
        animationsDirectory.appendingPathComponent(fileName).appendingPathExtension("json")
    }
    
    /// URL for manifest file
    private var manifestUrl: URL {
        dotLottieDirectory.appendingPathComponent("manifest").appendingPathExtension("json")
    }
    
    /// URL for output
    private var outputUrl: URL {
        directory.appendingPathComponent(fileName).appendingPathExtension("lottie")
    }
    
    /// Downloads file from URL and returns local URL
    /// - Parameters:
    ///   - url: Remote file URL
    ///   - saveUrl: Local file URL to persist
    ///   - completion: Local URL
    private static func download(from url: URL, to saveUrl: URL, completion: @escaping (Bool) -> Void) {
        /// file is not remote, save the animation content to the proper same URL and return
        guard url.isRemoteFile else {
            let animationData = try? Data(contentsOf: url)
            do {
                try animationData?.write(to: saveUrl)
                completion(true)
                return
            } catch {
                DotLottieUtils.log("Failed to save animation data: \(error.localizedDescription)")
                completion(false)
                return
            }
        }
        
        DotLottieUtils.log("Downloading from url: \(url.path)")
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard let data = data else {
                DotLottieUtils.log("Failed to download data: \(error?.localizedDescription ?? "no description")")
                completion(false)
                return
            }
            
            do {
                try data.write(to: saveUrl)
                completion(true)
            } catch {
                DotLottieUtils.log("Failed to save downloaded data: \(error.localizedDescription)")
                completion(false)
            }
        }).resume()
    }
    
    /// Creates folders File
    /// - Throws: Error
    private func createFolders() throws {
        try FileManager.default.createDirectory(at: dotLottieDirectory, withIntermediateDirectories: true, attributes: nil)
        try FileManager.default.createDirectory(at: animationsDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    /// Creates main animation File
    private func createAnimation(completion: @escaping (Bool) -> Void) {
        Self.download(from: url, to: animationUrl, completion: completion)
    }
    
    /// Creates manifest File
    /// - Throws: Error
    private func createManifest(completed: @escaping (Bool) -> Void) {
        let manifest = DotLottieManifest(animations: [
            DotLottieAnimation(id: fileName, loop: loop, themeColor: themeColor, speed: 1.0)
        ], version: "1.0", author: "LottieFiles", generator: "LottieFiles dotLottieLoader-iOS 0.1.4")
        
        do {
            let manifestData = try manifest.encode()
            try manifestData.write(to: manifestUrl)
            completed(true)
        } catch {
            completed(false)
        }
    }
    
    /// Creates dotLottieFile with given configurations
    /// - Parameters:
    ///   - configuration: configuration for DotLottie file
    /// - Returns: URL of .lottie file
    public func create(completion: @escaping (URL?) -> Void) {
        guard isLottie else {
            DotLottieUtils.log("Not a json file")
            completion(nil)
            return
        }
        
        do {
            try createFolders()
            createAnimation { success in
                guard success else { return }
                
                createManifest { success in
                    guard success else { return }
                    
                    do {
                        Zip.addCustomFileExtension(DotLottieUtils.dotLottieExtension)
                        try Zip.zipFiles(paths: [animationsDirectory, manifestUrl], zipFilePath: outputUrl, password: nil, compression: .DefaultCompression, progress: { progress in
                            DotLottieUtils.log("Compressing dotLottie file: \(progress)")
                        })
                        
                        DotLottieUtils.log("Created dotLottie file at \(outputUrl)")
                        completion(outputUrl)
                    } catch {
                        completion(nil)
                    }
                }
            }
        } catch {
            DotLottieUtils.log("Failed to create dotLottie file \(error)")
            completion(nil)
        }
    }
}
