//
//  FeedViewController.swift
//  Catogram
//
//  Created Олег Крылов on 07/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//
//  Template generated by Edward
//

import UIKit

final class FeedViewController: UIViewController, FeedViewProtocol {
    
    
    
    private let presenter: FeedPresenterProtocol
    private let imageDownloader = ImageDownloader()
    
    private let wallpaperImageView = UIImageView()
    private let stackView = UIStackView()
    private let voteUpButton = UIButton()
    private let voteDownButton = UIButton()
    private let favItButton = UIButton()
    private let activityIndicator = UIActivityIndicatorView()
    
    
    init(presenter: FeedPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFeedView()
        presenter.view = self
        presenter.viewDidLoad()
    }
    
}

extension FeedViewController {
    private func setupFeedView() {
        self.view.addSubview(wallpaperImageView)
        self.view.addSubview(stackView)
        self.stackView.addSubview(voteUpButton)
        self.stackView.addSubview(voteDownButton)
        self.stackView.addSubview(favItButton)
        self.view.addSubview(activityIndicator)
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler(sender:)))
        
        
        self.wallpaperImageView.addGestureRecognizer(tapGestureRecognizer)
        self.wallpaperImageView.isUserInteractionEnabled = true
        self.wallpaperImageView.frame.size = self.view.bounds.size
        self.wallpaperImageView.frame.size.height = self.view.bounds.size.height - 223
        self.wallpaperImageView.contentMode = .scaleAspectFit
        
        
        self.activityIndicator.frame.origin = CGPoint(x: self.wallpaperImageView.bounds.midX, y: self.wallpaperImageView.bounds.midY)
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.color = .gray
        self.activityIndicator.startAnimating()
        
        
        self.stackView.frame = CGRect(x: 0, y: self.view.bounds.maxY-283, width: self.view.frame.width, height: 60)
        self.stackView.backgroundColor = UIColor.white
        
        
        self.voteUpButton.frame = CGRect(x: self.stackView.bounds.origin.x,
                                         y: self.stackView.bounds.origin.y,
                                         width: self.stackView.bounds.size.width/3,
                                         height: 60)
        self.voteUpButton.addTarget(self, action: #selector(voteUpForCurrentImage)
            , for: .touchDown)
        self.voteUpButton.backgroundColor = .white
        self.voteUpButton.setImage(UIImage.init(named: "like", in: .main, compatibleWith: nil), for: .normal)
        self.voteUpButton.imageView?.contentMode = .scaleAspectFit
        
        
        
        self.voteDownButton.frame = CGRect(x: self.stackView.bounds.origin.x + (self.stackView.bounds.size.width/3)*2,
                                           y: self.stackView.bounds.origin.y,
                                           width: self.stackView.bounds.size.width/3,
                                           height: 60)
        self.voteDownButton.addTarget(self, action: #selector(voteDownForCurrentImage), for: .touchDown)
        self.voteDownButton.backgroundColor = .white
        self.voteDownButton.setImage(UIImage.init(named: "dislike",
                                                  in: .main,
                                                  compatibleWith: nil), for: .normal)
        self.voteDownButton.imageView?.contentMode = .scaleAspectFit
        
        
        self.favItButton.frame = CGRect(x: self.stackView.bounds.origin.x + self.stackView.bounds.size.width/3,
                                        y: self.stackView.bounds.origin.y,
                                        width: self.stackView.bounds.size.width/3,
                                        height: 60)
        self.favItButton.addTarget(self, action: #selector(favCurrentImage), for: .touchDown)
        self.favItButton.backgroundColor = .white
        self.favItButton.setImage(UIImage.init(named: "star",
                                               in: .main,
                                               compatibleWith: nil), for: .normal)
        self.favItButton.imageView?.contentMode = .scaleAspectFit
    }
    
    
    
    @objc func voteUpForCurrentImage() {
        presenter.voteUpForCurrentImage()
    }
    
    @objc func voteDownForCurrentImage() {
        presenter.voteUpForCurrentImage()
    }
    
    @objc func favCurrentImage() {
        presenter.favCurrentImage()
    }
    
    func setupViewWithCat(cat: ImageResponse) {
        self.activityIndicator.startAnimating()
        imageDownloader.getPhoto(url: cat.url) { result in
            switch result {
            case .success(let response):
                self.wallpaperImageView.image = response
                self.activityIndicator.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
    }
    @objc func tapHandler(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.wallpaperImageView.frame = UIScreen.main.bounds
            self.wallpaperImageView.backgroundColor = .black
            self.wallpaperImageView.contentMode = .scaleAspectFill
            self.wallpaperImageView.clipsToBounds = true
            self.wallpaperImageView.isUserInteractionEnabled = true
            
            self.navigationController?.isNavigationBarHidden = true
            self.tabBarController?.tabBar.isHidden = true
            self.voteUpButton.isHidden = true
            self.voteDownButton.isHidden = true
            self.favItButton.isHidden = true
        }
    }
    
}

extension UIButton {
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .lightGray : .white
        }
    }
}
