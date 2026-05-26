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
    
    // MARK: - 从字符串创建 Color（支持多种格式）
    init?(from string: String) {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        // 1. 预设颜色名称
        let presetColors: [String: Color] = [
            "black": .black,
            "blue": .blue,
            "brown": .brown,
            "clear": .clear,
            "cyan": .cyan,
            "gray": .gray,
            "green": .green,
            "indigo": .indigo,
            "mint": .mint,
            "orange": .orange,
            "pink": .pink,
            "purple": .purple,
            "red": .red,
            "teal": .teal,
            "white": .white,
            "yellow": .yellow
        ]
        
        if let color = presetColors[trimmed] {
            self = color
            return
        }
        
        // 2. 十六进制格式 (#RRGGBB 或 #RRGGBBAA)
        if trimmed.hasPrefix("#") {
            if let color = Color(hex: trimmed) {
                self = color
                return
            }
        }
        
        // 3. RGB 格式 "rgb(255,0,0)" 或 "255,0,0"
        if trimmed.hasPrefix("rgb") || trimmed.contains(",") {
            if let color = Color(rgbString: trimmed) {
                self = color
                return
            }
        }
        
        // 4. RGBA 格式 "rgba(255,0,0,0.5)" 或 "255,0,0,0.5"
        if trimmed.hasPrefix("rgba") {
            if let color = Color(rgbaString: trimmed) {
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
        case 3: // #RGB
            r = Double((rgb >> 8) & 0xF) / 15.0
            g = Double((rgb >> 4) & 0xF) / 15.0
            b = Double(rgb & 0xF) / 15.0
            a = 1.0
        case 4: // #RGBA
            r = Double((rgb >> 12) & 0xF) / 15.0
            g = Double((rgb >> 8) & 0xF) / 15.0
            b = Double((rgb >> 4) & 0xF) / 15.0
            a = Double(rgb & 0xF) / 15.0
        case 6: // #RRGGBB
            r = Double((rgb >> 16) & 0xFF) / 255.0
            g = Double((rgb >> 8) & 0xFF) / 255.0
            b = Double(rgb & 0xFF) / 255.0
            a = 1.0
        case 8: // #RRGGBBAA
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
    
    // MARK: - UIColor/NSColor 转换（跨平台）
    #if canImport(UIKit)
    func toUIColor() -> UIColor {
        return UIColor(self)
    }
    
    init?(fromUIColor color: UIColor) {
        self.init(color)
    }
    #endif
    
    #if canImport(AppKit)
    func toNSColor() -> NSColor {
        return NSColor(self)
    }
    
    init?(fromNSColor color: NSColor) {
        self.init(color)
    }
    #endif
    
    // MARK: - 转换为字符串（多种格式）
    
    /// 转换为十六进制字符串（默认格式：#RRGGBB）
    func toHexString(includeAlpha: Bool = false) -> String {
        guard let components = self.toRGBComponents() else {
            return "#000000"
        }
        
        let r = Int(components.red * 255)
        let g = Int(components.green * 255)
        let b = Int(components.blue * 255)
        let a = Int(components.alpha * 255)
        
        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X", r, g, b, a)
        } else {
            return String(format: "#%02X%02X%02X", r, g, b)
        }
    }
    
    /// 转换为 RGB 字符串 "rgb(255,0,0)"
    func toRGBString() -> String? {
        guard let components = self.toRGBComponents() else { return nil }
        
        let r = Int(components.red * 255)
        let g = Int(components.green * 255)
        let b = Int(components.blue * 255)
        
        return "rgb(\(r),\(g),\(b))"
    }
    
    /// 转换为 RGBA 字符串 "rgba(255,0,0,0.5)"
    func toRGBAString() -> String? {
        guard let components = self.toRGBComponents() else { return nil }
        
        let r = Int(components.red * 255)
        let g = Int(components.green * 255)
        let b = Int(components.blue * 255)
        let a = components.alpha
        
        return "rgba(\(r),\(g),\(b),\(String(format: "%.2f", a)))"
    }
    
    /// 转换为预设颜色名称字符串（如果是预设颜色）
    func toColorNameString() -> String? {
        let colorMap: [(Color, String)] = [
            (.black, "black"), (.blue, "blue"), (.brown, "brown"),
            (.clear, "clear"), (.cyan, "cyan"), (.gray, "gray"),
            (.green, "green"), (.indigo, "indigo"), (.mint, "mint"),
            (.orange, "orange"), (.pink, "pink"), (.purple, "purple"),
            (.red, "red"), (.teal, "teal"), (.white, "white"), (.yellow, "yellow")
        ]
        
        for (color, name) in colorMap {
            if self.isEqual(to: color) {
                return name
            }
        }
        
        return nil
    }
    
    /// 获取 RGB 分量
    private func toRGBComponents() -> (red: Double, green: Double, blue: Double, alpha: Double)? {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        return (Double(red), Double(green), Double(blue), Double(alpha))
        #elseif canImport(AppKit)
        let nsColor = NSColor(self)
        guard let rgbColor = nsColor.usingColorSpace(.sRGB) else {
            return nil
        }
        
        return (Double(rgbColor.redComponent),
                Double(rgbColor.greenComponent),
                Double(rgbColor.blueComponent),
                Double(rgbColor.alphaComponent))
        #endif
    }
    
    /// 判断两个颜色是否相等
    private func isEqual(to color: Color) -> Bool {
        guard let components1 = self.toRGBComponents(),
              let components2 = color.toRGBComponents() else {
            return false
        }
        
        let epsilon = 0.01
        return abs(components1.red - components2.red) < epsilon &&
               abs(components1.green - components2.green) < epsilon &&
               abs(components1.blue - components2.blue) < epsilon &&
               abs(components1.alpha - components2.alpha) < epsilon
    }
}

// MARK: - 便捷扩展：为您的 CodeBreaker 游戏添加颜色字符串支持
extension Color {
    // 为游戏中的 Peg 提供字符串表示
    var gameString: String {
        switch self {
        case .red: return "red"
        case .blue: return "blue"
        case .green: return "green"
        case .yellow: return "yellow"
        case .orange: return "orange"
        case .purple: return "purple"
        case .pink: return "pink"
        case .black: return "black"
        case .white: return "white"
        case .gray: return "gray"
        default: return "unknown"
        }
    }
    
    // 从游戏字符串创建颜色
    static func fromGameString(_ string: String) -> Color? {
        switch string.lowercased() {
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "yellow": return .yellow
        case "orange": return .orange
        case "purple": return .purple
        case "pink": return .pink
        case "black": return .black
        case "white": return .white
        case "gray", "grey": return .gray
        default: return nil
        }
    }
}

//// MARK: - 使用示例
//struct ColorConversionExample {
//    func examples() {
//        // 1. 从预设颜色名称创建
//        let red1 = Color(from: "red")
//        let red2 = Color(from: "RED")
//        
//        // 2. 从十六进制创建
//        let hexColor1 = Color(from: "#FF0000")      // 红色
//        let hexColor2 = Color(from: "#FF0000FF")    // 红色（带透明度）
//        let hexColor3 = Color(from: "#F00")         // 简写红色
//        let hexColor4 = Color(from: "#F00F")        // 简写红色（带透明度）
//        
//        // 3. 从 RGB 创建
//        let rgbColor = Color(from: "rgb(255,0,0)")
//        let rgbSimple = Color(from: "255,0,0")
//        
//        // 4. 从 RGBA 创建
//        let rgbaColor = Color(from: "rgba(255,0,0,0.5)")
//        let rgbaSimple = Color(from: "255,0,0,0.5")
//        
//        // 5. 转换为各种字符串格式
//        let myColor = Color.red
//        let hexString = myColor.toHexString()           // "#FF0000"
//        let hexWithAlpha = myColor.toHexString(includeAlpha: true)  // "#FF0000FF"
//        let rgbString = myColor.toRGBString()           // "rgb(255,0,0)"
//        let rgbaString = myColor.toRGBAString()         // "rgba(255,0,0,1.00)"
//        let colorName = myColor.toColorNameString()     // "red"
//        
//        // 6. 游戏专用转换
//        let gameColor = Color.fromGameString("green")   // .green
//        let gameString = Color.green.gameString          // "green"
//    }
//}
