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
        
    /// Array of alternative appearances (dark/light/custom)
    public var appearance: [DotLottieAppearance]?
       
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
    
    /// Process appearances for animation
    private var processedappearances: [DotLottieAppearance] {
        var dotLottieAppearance: [DotLottieTheme: DotLottieAppearance] = [.light: DotLottieAppearance(.light, animation: fileName)]
        
        appearance?.forEach({
            guard let url = URL(string: $0.animation), url.isJsonFile else {
                DotLottieUtils.log("Value for appearance \($0.theme) is not a valid JSON URL")
                return
            }
            
            do {
                let fileName = "\(url.deletingPathExtension().lastPathComponent)-\($0.theme.rawValue)"
                let apperanceUrl = animationsDirectory.appendingPathComponent(fileName).appendingPathExtension("json")
                let animationData = try Data(contentsOf: url)
                try animationData.write(to: apperanceUrl)
                
                dotLottieAppearance[$0.theme] = DotLottieAppearance($0.theme, animation: fileName, colors: $0.colors)
            } catch {
                DotLottieUtils.log("Could not process value for appearance: \($0.theme)")
            }
        })
        
        return dotLottieAppearance.map({ $0.value })
    }
    
    /// Creates folders File
    /// - Throws: Error
    private func createFolders() throws {
        try FileManager.default.createDirectory(at: dotLottieDirectory, withIntermediateDirectories: true, attributes: nil)
        try FileManager.default.createDirectory(at: animationsDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    /// Creates main animation File
    /// - Throws: Error
    private func createAnimation() throws {
        let animationData = try Data(contentsOf: url)
        try animationData.write(to: animationUrl)
    }
    
    /// Creates manifest File
    /// - Throws: Error
    private func createManifest() throws {
        let manifest = DotLottieManifest(animations: [
            DotLottieAnimation(loop: loop, themeColor: themeColor, speed: 1.0, id: fileName)
        ], version: "1.0", author: "LottieFiles", generator: "LottieFiles dotLottieLoader-iOS 0.1.4", appearance: processedappearances)
        let manifestData = try manifest.encode()
        try manifestData.write(to: manifestUrl)
    }
    
    /// Creates dotLottieFile with given configurations
    /// - Parameters:
    ///   - configuration: configuration for DotLottie file
    /// - Returns: URL of .lottie file
    public func create() -> URL? {
        guard isLottie else {
            DotLottieUtils.log("Not a json file")
            return nil
        }
        
        do {
            try createFolders()
            try createAnimation()
            try createManifest()
            
            Zip.addCustomFileExtension(DotLottieUtils.dotLottieExtension)
            try Zip.zipFiles(paths: [animationsDirectory, manifestUrl], zipFilePath: outputUrl, password: nil, compression: .DefaultCompression, progress: { progress in
                DotLottieUtils.log("Compressing dotLottie file: \(progress)")
            })
            
            DotLottieUtils.log("Created dotLottie file at \(outputUrl)")
            return outputUrl
        } catch {
            DotLottieUtils.log("Failed to create dotLottie file \(error)")
            return nil
        }
    }
}
