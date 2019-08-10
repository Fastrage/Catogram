//
//  UIColor.swift
//  Catogram
//
//  Created by Олег Крылов on 08/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    static func mainColor() -> UIColor {
        return #colorLiteral(red: 0.8806782365, green: 0.3662539124, blue: 0.1602896452, alpha: 1)
    }
}

