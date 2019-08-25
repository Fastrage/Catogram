//
//  FeedPresenter.swift
//  Catogram
//
//  Created Олег Крылов on 07/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//
//  Template generated by Edward
//

import Foundation

// MARK: View -
protocol FeedViewProtocol: AnyObject {
    func set(viewModel: FeedViewModel)
}

// MARK: Presenter -
protocol FeedPresenterProtocol: AnyObject {
    var view: FeedViewProtocol? { get set }
    
    func viewDidLoad()
    func getRandomImage()
    func voteUpForCurrentImage()
    func voteDownForCurrentImage()
    func favCurrentImage()
}

final class FeedPresenter: FeedPresenterProtocol {
    
    weak var view: FeedViewProtocol?
    private var randomImage: ImageResponse? = nil
    private let imageNetworkProtocol = NetworkService(urlFactory: URLFactory())
    
    func viewDidLoad() {
        getRandomImage()
    }
}

extension FeedPresenter {
    func getRandomImage() {
        self.imageNetworkProtocol.getRandomImage { result in
            switch result {
            case .success(let response):
                self.didLoad(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func voteUpForCurrentImage() {
        guard let randomImageId = randomImage?.id else {
            return
        }
        self.imageNetworkProtocol.voteForCurrentImage(id: (randomImageId), vote: 1, completion: { result in
            switch result {
            case .success(let response):
                print(response.message)
            case .failure(let error):
                print(error)
            }
        })
        self.getRandomImage()
    }
    
    func voteDownForCurrentImage() {
        guard let randomImageId = randomImage?.id else {
            return
        }
        self.imageNetworkProtocol.voteForCurrentImage(id: (randomImageId), vote: 0, completion: { result in
            switch result {
            case .success(let response):
                print(response.message)
            case .failure(let error):
                print(error)
            }
        })
        self.getRandomImage()
    }
    
    func favCurrentImage() {
        guard let randomImageId = randomImage?.id else {
            return
        }
        self.imageNetworkProtocol.favCurrentImage(id: (randomImageId), completion: { result in
            switch result {
            case .success(let response):
                print(response.message)
            case .failure(let error):
                print(error)
            }
        })
    }
}

private extension FeedPresenter {
    func makeViewModels(_ image: ImageResponse) -> FeedViewModel {
        return FeedViewModel(id: image.id ?? "",
                             url: image.url ?? "")
        }
    
    func didLoad(_ images: [ImageResponse]) {
        self.randomImage = images[0]
        guard let randomImage = self.randomImage else { return }
        let viewModel: FeedViewModel = self.makeViewModels(randomImage)
        self.view?.set(viewModel: viewModel)
    }
}
