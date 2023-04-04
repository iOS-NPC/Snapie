//
//  Color.swift
//  Snapie
//
//  Created by 남경민 on 2023/03/29.
//

import SwiftUI
 
extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
}

extension Color {
    static let primary1 = Color(hex: "3AC3EF")
    static let grey1 = Color(hex: "BDBDBD")
    static let grey2 = Color(hex: "BDC5CD")
    static let grey3 = Color(hex: "D9D9D9")
    static let grey4 = Color(hex: "E8E8E8")
    static let grey5 = Color(hex: "F6F6F6")
    static let grey6 = Color(hex: "FAFAFA")
    static let grey7 = Color(hex: "999999")

}
