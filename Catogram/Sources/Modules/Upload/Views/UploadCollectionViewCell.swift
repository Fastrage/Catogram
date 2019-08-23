//
//  UploadCollectionViewCell.swift
//  Catogram
//
//  Created by Олег Крылов on 18/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//

import UIKit

final class UploadCollectionViewCell: UICollectionViewCell {
    
    private let activityIndicator = UIActivityIndicatorView()
    private let uploadImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.uploadImageView.image = nil
    }
}

extension UploadCollectionViewCell {
    func set(image: UIImage?) {
        self.uploadImageView.image = image
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
}

private extension UploadCollectionViewCell {
    func setupView() {
        self.backgroundColor = UIColor.mainColor()
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
        self.addSubview(uploadImageView)
        uploadImageView.frame = self.bounds
        uploadImageView.contentMode = .scaleAspectFill
        
        self.addSubview(activityIndicator)
        self.activityIndicator.frame.origin = CGPoint(x: self.uploadImageView.bounds.midX, y: self.uploadImageView.bounds.midY)
        
    }
    
    
}

