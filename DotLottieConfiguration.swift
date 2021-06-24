//
//  DotLottieConfiguration.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 23/06/2021.
//

import Foundation

/// Configuration model
public struct DotLottieConfiguration {
    /// URL to main animation JSON file
    public var url: URL
    
    /// Loop enabled - Default true
    public var loop: Bool = true
    
    /// Theme color in HEX - Default #ffffff
    public var themeColor: String = "#ffffff"
        
    /// Array of alternative appearances (dark/light/custom)
    public var appearances: DotLottieAppearance?
       
    /// URL to directory where we are saving the files
    public var directory: URL = DotLottieUtils.tempDirectoryURL
    
    public init(animationUrl: URL) {
        url = animationUrl
    }
    
    var dotLottieDirectory: URL {
        directory.appendingPathComponent(fileName)
    }
    
    var animationsDirectory: URL {
        dotLottieDirectory.appendingPathComponent("animations")
    }
    
    var isLottie: Bool {
        url.isJsonFile
    }
    
    var fileName: String {
        url.deletingPathExtension().lastPathComponent
    }
    
    var animationUrl: URL {
        animationsDirectory.appendingPathComponent(fileName).appendingPathExtension("json")
    }
    
    var manifestUrl: URL {
        dotLottieDirectory.appendingPathComponent("manifest").appendingPathExtension("json")
    }
    
    var outputUrl: URL {
        directory.appendingPathComponent(fileName).appendingPathExtension("lottie")
    }
    
    /// Process appearances for animation
    private var processedAppearance: DotLottieAppearance {
        var dotLottieAppearance: DotLottieAppearance = [.light: fileName]
        
        appearances?.forEach({
            guard let url = URL(string: $0.value), url.isJsonFile else {
                DotLottieUtils.log("Value for appearance \($0.key) is not a valid JSON URL")
                return
            }
            
            do {
                let appearanceFileName = "\(fileName)-\($0.key.rawValue)"
                let apperanceUrl = animationsDirectory.appendingPathComponent(appearanceFileName).appendingPathExtension("json")
                let animationData = try Data(contentsOf: url)
                try animationData.write(to: apperanceUrl)
                
                dotLottieAppearance[$0.key] = appearanceFileName
            } catch {
                DotLottieUtils.log("Could not process value for appearance: \($0.key)")
            }
        })
        
        return dotLottieAppearance
    }
    
    func createFolders() throws {
        try FileManager.default.createDirectory(at: dotLottieDirectory, withIntermediateDirectories: true, attributes: nil)
        try FileManager.default.createDirectory(at: animationsDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    func createAnimation() throws {
        let animationData = try Data(contentsOf: url)
        try animationData.write(to: animationUrl)
    }
    
    func createManifest() throws {
        let manifest = DotLottieManifest(animations: [
            DotLottieAnimation(loop: loop, themeColor: themeColor, speed: 1.0, id: fileName)
        ], version: "1.0", author: "LottieFiles", generator: "LottieFiles dotLottieLoader-iOS 0.1.4", appearance: processedAppearance)
        let manifestData = try manifest.encode()
        try manifestData.write(to: manifestUrl)
    }
    
}
