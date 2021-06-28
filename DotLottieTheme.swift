//
//  DotLottieTheme.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 28/06/2021.
//

import Foundation

public enum DotLottieTheme: RawRepresentable, Equatable, Hashable, Codable {
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
    
    public static func == (lhs: DotLottieTheme, rhs: DotLottieTheme) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
    
    public var hashValue: Int {
        rawValue.hashValue
    }
}
