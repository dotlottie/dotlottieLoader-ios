//
//  DotLottieColor.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 28/06/2021.
//

import Foundation

public struct DotLottieColor: Codable {
    /// Layer tree
    public var layer: [String]
    
    /// Color in HEX
    public var color: String
    
    public init(layer: [String], color: String) {
        self.layer = layer
        self.color = color
    }
    
    /// Layer key path
    public var layerKeyPath: String {
        layer.joined(separator: ".")
    }
}
