//
//  DotLottieManifest.swift
//  LottieFiles
//
//  Created by Evandro Harrison Hoffmann on 27/06/2020.
//  Copyright © 2020 LottieFiles. All rights reserved.
//

import Foundation

/// Manifest model for .lottie File
public struct DotLottieManifest: Codable {
    public var animations: [DotLottieAnimation]
    public var version: String
    public var author: String
    public var generator: String
    public var themes: [DotLottieTheme]?
    
    /// Decodes data to Manifest model
    /// - Parameter data: Data to decode
    /// - Throws: Error
    /// - Returns: .lottie Manifest model
    public static func decode(from data: Data) throws -> DotLottieManifest? {
        try? JSONDecoder().decode(DotLottieManifest.self, from: data)
    }
    
    /// Encodes to data
    /// - Parameter encoder: JSONEncoder
    /// - Throws: Error
    /// - Returns: encoded Data
    func encode(with encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        try encoder.encode(self)
    }

    /// Loads manifest from given URL
    /// - Parameter path: URL path to Manifest
    /// - Returns: Manifest Model
    public static func load(from url: URL) throws -> DotLottieManifest? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? decode(from: data)
    }
    
}

/// Animation model for .lottie File
public struct DotLottieAnimation: Codable {
    public var loop: Bool
    public var themeColor: String
    public var speed: Float
    public var id: String
}

/*
 {
    "animations":[
        {"id":"lf30_p25uf33d","speed":1,"loop":true,"themeColor":"#ffffff"}
    ],
    "author":"LottieFiles",
    "generator":"LottieFiles dotLottieLoader-iOS 0.1.4",
    "version":"1.0",
    "themes":{
        "light": {
            "animation": "lf30_p25uf33d",
            "colorSettings": [
                {
                    "layer": ["Love 2", "Heart Outlines 2", "Group 1", "Stroke 1", "Color"],
                    "color": "#fafafa"
                }
            ]
        }
    }
 }
 */

public struct DotLottieTheme: Codable {
    public var theme: DotLottieThemeType
    public var animation: String
    public var colors: [DotLottieColorConfiguration]?
    
    public init(_ theme: DotLottieThemeType, animation: String, colors: [DotLottieColorConfiguration]? = nil) {
        self.theme = theme
        self.animation = animation
        self.colors = colors
    }
}

public struct DotLottieColorConfiguration: Codable {
    public var layer: [String]
    public var color: String
    
    public init(layer: [String], color: String) {
        self.layer = layer
        self.color = color
    }
}

/// Type of Theme
public enum DotLottieThemeType: RawRepresentable, Equatable, Hashable, Codable {
    case dark
    case light
    case custom(String)

    public typealias RawValue = String

    public init?(rawValue: RawValue) {
        switch rawValue {
        case "dark": self = .dark
        case "light": self = .light
        case (let value): self = .custom(value)
        }
    }

    public var rawValue: RawValue {
        switch self {
        case .dark: return "dark"
        case .light: return "light"
        case .custom(let value): return value
        }
    }
    
    public static func == (lhs: DotLottieThemeType, rhs: DotLottieThemeType) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
    
    public var hashValue: Int {
        rawValue.hashValue
    }
}
