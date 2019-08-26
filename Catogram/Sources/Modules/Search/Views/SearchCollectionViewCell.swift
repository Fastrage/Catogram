//
//  SearchCollectionViewCell.swift
//  Catogram
//
//  Created by Олег Крылов on 25/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//
import UIKit

final class SearchCollectionViewCell: UICollectionViewCell {
    
    private let activityIndicator = UIActivityIndicatorView()
    private let favouritesImageView = UIImageView()
    
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
    
    override func prepareForReuse() {
        self.favouritesImageView.image = nil
    }
}

extension SearchCollectionViewCell {
    func set(image: UIImage?) {
        favouritesImageView.image = image
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
}

private extension SearchCollectionViewCell {
    func setupView() {
        self.backgroundColor = UIColor.mainColor()
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
