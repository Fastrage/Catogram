//
//  DetailedPresenter.swift
//  Catogram
//
//  Created Олег Крылов on 21/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//
//  Template generated by Edward
//

import Foundation

// MARK: View -
protocol DetailedViewProtocol: AnyObject {
    func set(viewModel: DetailedViewModel)
    func goBack()
}

// MARK: Presenter -
protocol DetailedPresenterProtocol: AnyObject {
	var view: DetailedViewProtocol? { get set }
    func viewDidLoad()
    func userTapRemoveFromFavoutires(id: String)
    func userTapRemoveFromUploaded(id: String)
}

final class DetailedPresenter: DetailedPresenterProtocol {
    
    weak var view: DetailedViewProtocol?

    private var detailedImage: ImageResponse? = nil
    private let imageNetworkProtocol = NetworkService(urlFactory: URLFactory())
    
    func viewDidLoad() {
    }
}

extension DetailedPresenter {
    func userTapRemoveFromFavoutires(id: String) {
        self.imageNetworkProtocol.deleteFromFavourites(id: id) { result in
            switch result {
            case .success(let response):
                print(response)
                self.view?.goBack()
            case .failure(let error):
                print(error)
                self.view?.goBack()
            }
        }
    }
    
    func userTapRemoveFromUploaded(id: String) {
        self.imageNetworkProtocol.deleteFromUploaded(id: id) { result in
            switch result {
            case .success(let response):
                print(response)
                self.view?.goBack()
            case .failure(let error):
                print(error)
                self.view?.goBack()
            }
        }
    }
}
