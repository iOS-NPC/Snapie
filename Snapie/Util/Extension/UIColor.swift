//
//  UIColor.swift
//  Snapie
//
//  Created by 남경민 on 2023/03/29.
//

import UIKit
extension UIColor {
    // MARK: hex code를 이용하여 정의
    // ex. UIColor(hex: 0xF5663F)
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    // MARK: 메인 테마 색 또는 자주 쓰는 색을 정의
    // ex. label.textColor = .mainOrange

    class var primary1: UIColor { UIColor(hex: 0x3AC3EF)}
    class var grey1: UIColor { UIColor(hex: 0xBDBDBD)}
    class var grey2: UIColor { UIColor(hex: 0xBDC5CD)}
    class var grey3: UIColor { UIColor(hex: 0xD9D9D9)}
    class var grey4: UIColor { UIColor(hex: 0xE8E8E8)}
    class var grey5: UIColor { UIColor(hex: 0xF6F6F6)}
    class var grey6: UIColor { UIColor(hex: 0xFAFAFA)}
    
    
    class var mainOrange: UIColor { UIColor(hex: 0xF5663F) }
    class var greyScale1: UIColor { UIColor(hex: 0x0D0D0D) }
    class var greyScale2: UIColor { UIColor(hex: 0x262626) }
    class var greyScale3:UIColor { UIColor(hex: 0x414141) }
    class var greyScale4: UIColor { UIColor(hex: 0x595959) }
    class var greyScale5: UIColor { UIColor(hex: 0x737373) }
    class var greyScale6: UIColor { UIColor(hex: 0x8C8C8C) }
    class var greyScale7: UIColor { UIColor(hex: 0xA6A6A6) }
    class var greyScale8: UIColor { UIColor(hex: 0xBFBFBF) }
    class var greyScale9: UIColor { UIColor(hex: 0xD9D9D9) }
    class var greyScale10: UIColor { UIColor(hex: 0xF1F1F1) }
    class var greyScale11: UIColor { UIColor(hex: 0xF4F4F4) }
    class var greyScale12: UIColor { UIColor(hex: 0xFAFAFA) }
    class var loadingGrey: UIColor { UIColor(hex: 0xADADAD) }
    
    class var primary2 : UIColor { UIColor(hex: 0x259D71) }
}

