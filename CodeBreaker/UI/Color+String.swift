//
//  Color+String.swift
//  CodeBreaker
//
//  Created by YiHui020 on 2026/5/26.
//

import Foundation
import SwiftUI

// MARK: - 完整的 Color 字符串转换扩展
extension Color {
    
    // MARK: - 预设颜色表
    private static let namedColors: [String: Color] = [
        "black": .black,
        "blue": .blue,
        "brown": .brown,
        "clear": .clear,
        "cyan": .cyan,
        "gray": .gray,
        "grey": .gray,
        "green": .green,
        "indigo": .indigo,
        "mint": .mint,
        "orange": .orange,
        "pink": .pink,
        "purple": .purple,
        "red": .red,
        "teal": .teal,
        "white": .white,
        "yellow": .yellow,
        "primary": .primary,
        "secondary": .secondary,
        "accent": .accentColor,
        "accentcolor": .accentColor
    ]
    
    // MARK: - 从字符串创建 Color（支持多种格式）
    init?(from string: String) {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        // 优先使用预设颜色
        if let color = Self.namedColors[trimmed] {
            self = color
            return
        }
        
        // 十六进制格式
        if trimmed.hasPrefix("#"), let color = Color(hex: trimmed) {
            self = color
            return
        }
        
        // RGBA 格式必须放前面，否则会被 RGB 捕获
        if trimmed.hasPrefix("rgba"), let color = Color(rgbaString: trimmed) {
            self = color
            return
        }
        
        // RGB 格式
        if trimmed.hasPrefix("rgb") || trimmed.contains(",") {
            if let color = Color(rgbString: trimmed) {
                self = color
                return
            }
        }
        
        return nil
    }
    
    // MARK: - 十六进制转换
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        let r, g, b, a: Double
        
        switch hexSanitized.count {
        case 3:
            r = Double((rgb >> 8) & 0xF) / 15.0
            g = Double((rgb >> 4) & 0xF) / 15.0
            b = Double(rgb & 0xF) / 15.0
            a = 1.0
        case 4:
            r = Double((rgb >> 12) & 0xF) / 15.0
            g = Double((rgb >> 8) & 0xF) / 15.0
            b = Double((rgb >> 4) & 0xF) / 15.0
            a = Double(rgb & 0xF) / 15.0
        case 6:
            r = Double((rgb >> 16) & 0xFF) / 255.0
            g = Double((rgb >> 8) & 0xFF) / 255.0
            b = Double(rgb & 0xFF) / 255.0
            a = 1.0
        case 8:
            r = Double((rgb >> 24) & 0xFF) / 255.0
            g = Double((rgb >> 16) & 0xFF) / 255.0
            b = Double((rgb >> 8) & 0xFF) / 255.0
            a = Double(rgb & 0xFF) / 255.0
        default:
            return nil
        }
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
    
    // MARK: - RGB 字符串转换
    init?(rgbString: String) {
        let cleaned = rgbString
            .replacingOccurrences(of: "rgb(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: " ", with: "")
        
        let components = cleaned.split(separator: ",").compactMap { Double($0) }
        guard components.count >= 3 else { return nil }
        
        let r = components[0] / 255.0
        let g = components[1] / 255.0
        let b = components[2] / 255.0
        let a = components.count >= 4 ? components[3] : 1.0
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
    
    // MARK: - RGBA 字符串转换
    init?(rgbaString: String) {
        let cleaned = rgbaString
            .replacingOccurrences(of: "rgba(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: " ", with: "")
        
        let components = cleaned.split(separator: ",").compactMap { Double($0) }
        guard components.count >= 4 else { return nil }
        
        let r = components[0] / 255.0
        let g = components[1] / 255.0
        let b = components[2] / 255.0
        let a = components[3]
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
    
    // MARK: - UIColor/NSColor 转换
    #if canImport(UIKit)
    func toUIColor() -> UIColor { UIColor(self) }
    init?(fromUIColor color: UIColor) { self.init(color) }
    #endif
    
    #if canImport(AppKit)
    func toNSColor() -> NSColor { NSColor(self) }
    init?(fromNSColor color: NSColor) { self.init(color) }
    #endif
    
    // MARK: - 转换为字符串
    func toHexString(includeAlpha: Bool = false) -> String {
        guard let c = toRGBComponents() else { return "#000000" }
        let r = Int(c.red * 255)
        let g = Int(c.green * 255)
        let b = Int(c.blue * 255)
        let a = Int(c.alpha * 255)
        return includeAlpha ? String(format: "#%02X%02X%02X%02X", r, g, b, a)
                            : String(format: "#%02X%02X%02X", r, g, b)
    }
    
    func toRGBString() -> String? {
        guard let c = toRGBComponents() else { return nil }
        return "rgb(\(Int(c.red*255)),\(Int(c.green*255)),\(Int(c.blue*255)))"
    }
    
    func toRGBAString() -> String? {
        guard let c = toRGBComponents() else { return nil }
        return "rgba(\(Int(c.red*255)),\(Int(c.green*255)),\(Int(c.blue*255)),\(String(format: "%.2f", c.alpha)))"
    }
    
    func toColorNameString() -> String? {
        let myHex = toHexString(includeAlpha: true)
        for (name, color) in Self.namedColors {
            if color.toHexString(includeAlpha: true) == myHex {
                return name
            }
        }
        return nil
    }
    
    private func toRGBComponents() -> (red: Double, green: Double, blue: Double, alpha: Double)? {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        return (Double(r), Double(g), Double(b), Double(a))
        #elseif canImport(AppKit)
        let nsColor = NSColor(self)
        guard let rgb = nsColor.usingColorSpace(.sRGB) else { return nil }
        return (Double(rgb.redComponent), Double(rgb.greenComponent),
                Double(rgb.blueComponent), Double(rgb.alphaComponent))
        #else
        return nil
        #endif
    }
    
    private func isEqual(to color: Color) -> Bool {
        guard let c1 = toRGBComponents(), let c2 = color.toRGBComponents() else { return false }
        let epsilon = 0.01
        return abs(c1.red-c2.red)<epsilon && abs(c1.green-c2.green)<epsilon
            && abs(c1.blue-c2.blue)<epsilon && abs(c1.alpha-c2.alpha)<epsilon
    }
}

// MARK: - CodeBreaker 游戏颜色支持
extension Color {
    var gameString: String {
        if let name = toColorNameString() { return name }
        return toHexString(includeAlpha: true)
    }
    
    static func fromGameString(_ string: String) -> Color? {
        return Color(from: string)
    }
}
