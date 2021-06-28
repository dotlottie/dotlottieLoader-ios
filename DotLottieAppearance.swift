//
//  DotLottieAppearance.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 28/06/2021.
//

import Foundation

public struct DotLottieAppearance: Codable {
    /// Theme - Dark/Light/Custom
    public var theme: DotLottieTheme
    
    /// Animation name / url
    public var animation: String
    
    /// Color configuration for custom settings
    public var colors: [DotLottieColor]?
    
    public init(_ theme: DotLottieTheme, animation: String, colors: [DotLottieColor]? = nil) {
        self.theme = theme
        self.animation = animation
        self.colors = colors
    }
}
