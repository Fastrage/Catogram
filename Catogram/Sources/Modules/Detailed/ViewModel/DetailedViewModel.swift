//
//  DetailedViewModel.swift
//  Catogram
//
//  Created by Олег Крылов on 21/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//

import Foundation
struct DetailedViewModel {
    let id: String
    let url: String
    let subId: String?
    
    init(id: String, url: String, subId: String?) {
        self.id = id
        self.url = url
        self.subId = subId
    }
}
