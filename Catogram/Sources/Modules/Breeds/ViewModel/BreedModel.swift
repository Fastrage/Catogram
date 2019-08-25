//
//  BreedModel.swift
//  Catogram
//
//  Created by Олег Крылов on 14/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//

import UIKit

struct Breed: Decodable {
    let id: String?
    let name: String?
    let wikipedia_url: String?
    let temperament: String?
    let life_span: String?
    let origin: String?
    let description: String?
    let weight: Weight

}

struct Weight: Decodable {
    let imperial: String?
    let metric: String?
}
