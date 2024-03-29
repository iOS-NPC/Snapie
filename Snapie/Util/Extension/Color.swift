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
    
    static let primary2 = Color(hex: "259D71")
    static let primary3 = Color(hex: "1A7454")
    static let primary4 = Color(hex: "135D42")
    static let primary5 = Color(hex: "56D1A5")
    static let primary6 = Color(hex: "7FDCBA")
    static let primary7 = Color(hex: "A7E7D0")
    static let primary8 = Color(hex: "CFF2E5")
    static let primary9 = Color(hex: "DFF6EE")
    static let primary10 = Color(hex: "F1F9F7")

    static let greyScale1 = Color(hex: "0D0D0D")
    static let greyScale2 = Color(hex: "262626")
    static let greyScale3 = Color(hex: "414141")
    static let greyScale4 = Color(hex: "595959")
    static let greyScale5 = Color(hex: "737373")
    static let greyScale6 = Color(hex: "8C8C8C")
    static let greyScale7 = Color(hex: "A6A6A6")
    static let greyScale8 = Color(hex: "BFBFBF")
    static let greyScale9 = Color(hex: "D9D9D9")
    static let greyScale10 = Color(hex: "F1F1F1")
    static let greyScale11 = Color(hex: "F4F4F4")
    static let greyScale12 = Color(hex: "FAFAFA")

}
