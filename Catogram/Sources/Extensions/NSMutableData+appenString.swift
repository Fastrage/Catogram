//
//  NSMutableData+appenString.swift
//  Catogram
//
//  Created by Олег Крылов on 19/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//

import Foundation
extension NSMutableData {
    func appendString(_ string: String) {
        guard let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false) else { return }
        append(data)
    }
}
