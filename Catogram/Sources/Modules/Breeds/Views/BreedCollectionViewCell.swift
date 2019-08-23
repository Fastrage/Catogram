//
//  BreedCollectionViewCell.swift
//  Catogram
//
//  Created by Олег Крылов on 17/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//

import UIKit

final class BreedCollectionViewCell: UICollectionViewCell {
    
    private let activityIndicator = UIActivityIndicatorView()
    let breedImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.breedImageView.image = nil
    }
}
extension BreedCollectionViewCell {
    
    func set(image: UIImage?) {
        self.breedImageView.image = image
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
}

private extension BreedCollectionViewCell {
    func setupView() {
        self.backgroundColor = UIColor.mainColor()
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
        self.addSubview(breedImageView)
        breedImageView.frame = self.bounds
        breedImageView.contentMode = .scaleAspectFill
        
        self.addSubview(activityIndicator)
        self.activityIndicator.frame.origin = CGPoint(x: self.breedImageView.bounds.midX, y: self.breedImageView.bounds.midY)
        
    }
}
