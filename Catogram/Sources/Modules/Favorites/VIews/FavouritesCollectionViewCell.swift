//
//  FavouritesCollectionViewCell.swift
//  Catogram
//
//  Created by Олег Крылов on 12/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//

import UIKit

final class FavouritesCollectionViewCell: UICollectionViewCell {
    
    let favouritesImageView = UIImageView()
    private let imageDownloader = ImageDownloader()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(favouritesImageView)
        self.favouritesImageView.contentMode = .scaleAspectFill
        self.favouritesImageView.frame = self.bounds
        self.favouritesImageView.clipsToBounds = true        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension FavouritesCollectionViewCell {
    func update(with viewModel: FavouritesViewModel) {
        imageDownloader.getPhoto(url: viewModel.imageUrl) { result in
            switch result {
            case .success(let response):
                
                self.favouritesImageView.image = response
            case .failure(let error):
                print(error)
            }
        }
    }
}
