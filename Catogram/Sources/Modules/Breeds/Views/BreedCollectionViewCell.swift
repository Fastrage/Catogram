//
//  BreedCollectionViewCell.swift
//  Catogram
//
//  Created by Олег Крылов on 17/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//

import UIKit

class BreedCollectionViewCell: UICollectionViewCell {
    
    private let activityIndicator = UIActivityIndicatorView()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func prepareForReuse() {
        self.imageView.image = nil
    }
    
    func set(image: UIImage?) {
        imageView.image = image
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
        
        self.addSubview(imageView)
        imageView.frame = self.bounds
        imageView.contentMode = .scaleAspectFill
        
        self.addSubview(activityIndicator)
        self.activityIndicator.frame.origin = CGPoint(x: self.imageView.bounds.midX, y: self.imageView.bounds.midY)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
