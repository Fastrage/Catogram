//
//  BreedsViewController.swift
//  Catogram
//
//  Created Олег Крылов on 14/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//
//  Template generated by Edward
//
import UIKit

final class BreedsViewController: UIViewController, BreedsViewProtocol {
    
    private var presenter: BreedsPresenterProtocol
    private var downloadTasks = [Int: ImageTask]()
    
    private let breedsTextField = PickerViewTextField()
    private let verticalScrollView = UIScrollView()
    private let descriptionTextView = UITextView()
    private let urlShortcutTextView = UITextView()
    private let breedListActivityIndicator = UIActivityIndicatorView()
    private let pickerView = UIPickerView()
    private let toolBar = UIToolbar()
    private let breedsPhotosCollectionView: UICollectionView
    private var breedsList: [Breed] = []
    private var catImages: [BreedImagesViewModel] = []
    
    init(presenter: BreedsPresenterProtocol) {
        self.presenter = presenter
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        self.breedsPhotosCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupBreedsView()
        presenter.view = self
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopCurrentTasks()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupFrames()
    }
}

extension BreedsViewController {
    func setBreedList(breeds: [Breed]) {
        self.breedsList = breeds
        self.breedsTextField.isHidden = false
        self.stopActivityIndicator()
    }
    
    func set(images: [BreedImagesViewModel]) {
        self.catImages = images
        self.breedsPhotosCollectionView.reloadData()
    }
    
    func showAlert(for alert: String) {
        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}

private extension BreedsViewController {
    
    func setupDownloadTask(index: Int) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        guard let url = URL(string: self.catImages[index].url) else { return }
        if downloadTasks[index] == nil || downloadTasks[index]?.url != url || self.catImages[index].image == nil {
            let imageTask = ImageTask(position: index, url: url, session: session, delegate: self)
            downloadTasks[index] = imageTask
        }
    }
    
    func stopCurrentTasks() {
        for task in downloadTasks {
            task.value.pause()
        }
        self.downloadTasks.removeAll()
    }
    
    func startActivityIndicator() {
        self.breedListActivityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        self.breedListActivityIndicator.stopAnimating()
    }
        
    func setupCollectionView() {
        self.breedsPhotosCollectionView.dataSource = self
        self.breedsPhotosCollectionView.delegate = self
        self.breedsPhotosCollectionView.register(BreedCollectionViewCell.self, forCellWithReuseIdentifier: "BreedCell")
        self.breedsPhotosCollectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.breedsPhotosCollectionView.backgroundColor = .white
    }
    
    func setupBreedsView() {
        self.view.addSubview(breedsTextField)
        self.view.addSubview(breedListActivityIndicator)
        self.view.addSubview(verticalScrollView)
        self.verticalScrollView.addSubview(breedsPhotosCollectionView)
        self.verticalScrollView.addSubview(descriptionTextView)
        self.verticalScrollView.addSubview(urlShortcutTextView)
        
        self.view.backgroundColor = .white
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.breedsTextField.inputView = pickerView
        self.breedsTextField.backgroundColor = .white
        self.breedsTextField.placeholder = "Выберите породу"
        self.breedsTextField.textAlignment = .center
        self.breedsTextField.isEnabled = true
        self.breedsTextField.layer.cornerRadius = 10
        self.breedsTextField.layer.borderWidth = 2
        self.breedsTextField.layer.borderColor = UIColor.black.cgColor
        self.breedsTextField.rightView = UIImageView(image: AppImages.arrow)
        self.breedsTextField.rightViewMode = UITextField.ViewMode.always
        self.breedsTextField.isHidden = true
        
        self.startActivityIndicator()
        self.breedListActivityIndicator.color = .gray
        
        self.verticalScrollView.backgroundColor = .white
        
        self.descriptionTextView.backgroundColor = .white
        self.descriptionTextView.isUserInteractionEnabled = true
        self.descriptionTextView.isEditable = false
        self.descriptionTextView.isScrollEnabled = false
        
        self.toolBar.barStyle = UIBarStyle.default
        self.toolBar.isTranslucent = true
        self.toolBar.tintColor = UIColor.mainColor()
        self.toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector (donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.toolBar.setItems([spaceButton, doneButton], animated: false)
        self.toolBar.isUserInteractionEnabled = true
        
        self.breedsTextField.inputAccessoryView = toolBar
    }
    
    func setupFrames() {
        self.breedsTextField.frame = CGRect(x: 5,
                                            y: 5,
                                            width: self.view.bounds.width - 10,
                                            height: 30)
        self.breedListActivityIndicator.frame.origin = CGPoint(x: self.breedsTextField.bounds.midX,
                                                               y: self.breedsTextField.bounds.midY)
        self.verticalScrollView.frame = CGRect(x: 0,
                                               y: self.breedsTextField.frame.maxY + 5,
                                               width: self.view.bounds.width ,
                                               height: (self.view.bounds.height - self.breedsTextField.bounds.height))
        self.breedsPhotosCollectionView.frame = CGRect(x: 5,
                                                       y: self.verticalScrollView.bounds.minY,
                                                       width: self.verticalScrollView.bounds.width - 10,
                                                       height: self.verticalScrollView.bounds.width * 1.2)
        self.descriptionTextView.frame = CGRect(x: 5,
                                             y: self.breedsPhotosCollectionView.bounds.maxY,
                                             width: self.verticalScrollView.bounds.width - 10 ,
                                             height: 300)
    }
    
    @objc func donePicker() {
        self.view.endEditing(true)
    }
    
    func setupDescriptionLabel(row: Int) {
        
        let attributedText = NSMutableAttributedString(string: "\(breedsList[row].name ?? "") \n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        attributedText.append(NSMutableAttributedString(string: "id: \(breedsList[row].id ?? "") \n\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.darkGray]))
        attributedText.append(NSMutableAttributedString(string: "\(breedsList[row].description ?? "") \n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        attributedText.append(NSMutableAttributedString(string: "Характер: \(breedsList[row].temperament ?? "") \n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        attributedText.append(NSMutableAttributedString(string: "Страна произхождения: \(breedsList[row].origin ?? "") \n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        attributedText.append(NSMutableAttributedString(string: "Продолжительность жизни: \(breedsList[row].life_span ?? "") лет \n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        attributedText.append(NSMutableAttributedString(string: "Средний вес: \(breedsList[row].weight.metric ?? "") кг. \n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        attributedText.append(NSMutableAttributedString(string: "wikipedia", attributes: [NSAttributedString.Key.link: "\(breedsList[row].wikipedia_url ?? "")"]))
        self.descriptionTextView.attributedText = attributedText
        self.descriptionTextView.textAlignment = .center
        self.descriptionTextView.sizeToFit()
    }
}

extension BreedsViewController: UIPickerViewDelegate {
}

extension BreedsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breedsList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breedsList[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.stopCurrentTasks()
        self.breedsTextField.text = breedsList[row].name ?? "Порода"
        self.setupDescriptionLabel(row: row)
        presenter.userSelectBreed(breed: breedsList[row].id ?? "")
        self.verticalScrollView.contentSize.height = self.breedsPhotosCollectionView.bounds.height + self.descriptionTextView.bounds.height + self.urlShortcutTextView.bounds.height
    }
}

extension BreedsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if catImages[indexPath.row].image == nil {
            setupDownloadTask(index: indexPath.row)
            downloadTasks[indexPath.row]?.resume()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        downloadTasks[indexPath.row]?.pause()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let presenter = DetailedPresenter()
        let detailedViewController = DetailedViewController(presenter: presenter, segueFrom: .breeds)
        let detailedView = DetailedViewModel(id: String(catImages[indexPath.row].id), url: catImages[indexPath.row].url, subId: nil)
        detailedViewController.set(viewModel: detailedView)
        navigationController?.pushViewController(detailedViewController, animated: true)
    }
}

extension BreedsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.catImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BreedCell", for: indexPath) as! BreedCollectionViewCell
        guard let image = catImages[indexPath.row].image else {
            cell.showLoading()
            return cell
        }
        cell.hideLoading()
        cell.set(image: image)
        return cell
    }
}

extension BreedsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.breedsPhotosCollectionView.bounds.width - 10
        let height = self.breedsPhotosCollectionView.bounds.height - 10
        return CGSize(width: width, height: height)
    }
}

extension BreedsViewController: ImageTaskDownloadedDelegate {
    func imageDownloaded(position: Int, image: UIImage) {
        self.catImages[position].image = image
        self.breedsPhotosCollectionView.reloadItems(at: [IndexPath(row: position, section: 0)])
    }
}
