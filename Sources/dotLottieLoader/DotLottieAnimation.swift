//
//  DotLottieAnimation.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 28/06/2021.
//

import Foundation

public struct DotLottieAnimation: Codable {
    /// Loop enabled
    public var loop: Bool
    
    // appearance color in HEX
    public var themeColor: String
    
    /// Animation Playback Speed
    public var speed: Float
    
    /// Id of Animation
    public var id: String
}
