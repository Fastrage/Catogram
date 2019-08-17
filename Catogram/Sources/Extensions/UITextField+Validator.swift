//
//  UITextField+Validator.swift
//  Catogram
//
//  Created by Олег Крылов on 08/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//

import UIKit.UITextField

extension String {
    func validatedText(validationType: ValidatorType) throws -> String {
        let validator = VaildatorFactory.validatorFor(type: validationType)
        return try validator.validated(self)
    }
    
    
}

class PickerViewTextField: UITextField {
    override func caretRect(for position: UITextPosition) -> CGRect {
    return CGRect.zero
    }
}
