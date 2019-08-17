//
//  FavouritesCollectionViewCell.swift
//  Catogram
//
//  Created by Олег Крылов on 12/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//

import UIKit

final class FavouritesCollectionViewCell: UICollectionViewCell {
    
    
    private let activityIndicator = UIActivityIndicatorView()
    let favouritesImageView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(favouritesImageView)
        self.favouritesImageView.contentMode = .scaleAspectFill
        self.favouritesImageView.frame = self.bounds
        self.favouritesImageView.clipsToBounds = true
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension FavouritesCollectionViewCell {
    func set(image: UIImage?) {
        favouritesImageView.image = image
        if image == nil {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    private func setupView() {
        self.backgroundColor = .gray
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
        self.addSubview(favouritesImageView)
        self.favouritesImageView.frame = self.bounds
        
        self.addSubview(activityIndicator)
        self.activityIndicator.frame.origin = CGPoint(
            x: self.favouritesImageView.bounds.midX,
            y: self.favouritesImageView.bounds.midY)
    }
}
