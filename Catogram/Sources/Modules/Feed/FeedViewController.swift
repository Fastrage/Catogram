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

class FeedViewController: UIViewController, FeedViewProtocol {
    
    

	var presenter: FeedPresenterProtocol
    private let imageDownloader = ImageDownloader()
    
    private let wallpaperImageView = UIImageView()
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
    func setupFeedView() {
        self.view.addSubview(wallpaperImageView)
        self.view.addSubview(voteUpButton)
        self.view.addSubview(voteDownButton)
        self.view.addSubview(favItButton)
        self.view.addSubview(activityIndicator)
        
        print(self.view.bounds)
        print(self.view.frame)
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler(sender:)))
        
        self.wallpaperImageView.addGestureRecognizer(tapGestureRecognizer)
        self.wallpaperImageView.isUserInteractionEnabled = true
        self.wallpaperImageView.frame.size = self.view.bounds.size
        self.wallpaperImageView.frame.size.height = self.view.bounds.size.height - 223
        self.wallpaperImageView.contentMode = .scaleAspectFit
        
        self.activityIndicator.frame.origin = CGPoint(x: self.wallpaperImageView.bounds.midX, y: self.wallpaperImageView.bounds.midY)
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.color = .red
        self.activityIndicator.startAnimating()
        
        self.voteUpButton.frame = CGRect(x: 0, y: 0, width: 60, height: self.view.frame.height - 223)
        self.voteUpButton.layer.backgroundColor = UIColor.green.cgColor
        self.voteUpButton.addTarget(self, action: #selector(voteUpForCurrentImage)
            , for: .touchDown)
        self.voteUpButton.setTitle("Vote UP", for: .normal)
        self.voteUpButton.setTitleColor(.black, for: .normal)
        
    
        self.voteDownButton.frame = CGRect(x: self.view.frame.width - 60, y: 0, width: 60, height: self.view.frame.height - 223)
        self.voteDownButton.layer.backgroundColor = UIColor.red.cgColor
        self.voteDownButton.addTarget(self, action: #selector(voteDownForCurrentImage), for: .touchDown)
        self.voteDownButton.setTitle("Vote Down", for: .normal)
        self.voteDownButton.setTitleColor(.black, for: .normal)
        

        self.favItButton.frame = CGRect(x: 0, y: self.view.bounds.maxY-283, width: self.view.frame.width, height: 60)
        self.favItButton.layer.backgroundColor = UIColor.yellow.cgColor
        self.favItButton.addTarget(self, action: #selector(favCurrentImage), for: .touchDown)
        self.favItButton.setTitle("Add to favorites", for: .normal)
        self.favItButton.setTitleColor(.black, for: .normal)
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
        imageDownloader.getPhoto(url1: cat.url) { result in
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