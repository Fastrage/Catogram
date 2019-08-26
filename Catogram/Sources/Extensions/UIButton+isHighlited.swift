//
//  UIButton+isHighlited.swift
//  Catogram
//
//  Created by Олег Крылов on 21/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//

import UIKit
class CustomButton: UIButton {
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .lightGray : .clear
        }
    }
}
