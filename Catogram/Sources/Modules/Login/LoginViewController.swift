//
//  LoginViewController.swift
//  Catogram
//
//  Created Олег Крылов on 07/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//
//  Template generated by Edward
//

import UIKit

final class LoginViewController: UIViewController, LoginViewProtocol, Coordinatble {
    
    
    
    
    private var appCoordinator: AppCoordinator?
    private let presenter: LoginPresenterProtocol
    
    private let wallpaper = UIImageView()
    private let loginTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    private let logoutButton = UIButton()
    
    
    init(presenter: LoginPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.appCoordinator = AppCoordinator(window: window)
        bindKeyboardNotification()
        presenter.view = self
        presenter.viewDidLoad()
    }
    
    
    
    
    
}

extension LoginViewController {
    
    func setupLoginView(login: String?) {
        
        self.view.addSubview(wallpaper)
        self.view.addSubview(loginButton)
        self.view.addSubview(loginTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(logoutButton)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        self.wallpaper.frame.size = self.view.bounds.size
        self.wallpaper.frame.origin = CGPoint(x: 0, y: -100)
        self.wallpaper.contentMode = .scaleAspectFit
        self.wallpaper.image = UIImage(named: "thecatapi_256xW", in: .main, compatibleWith: nil)
        
        
        self.loginTextField.placeholder = "E-mail adress"
        self.loginTextField.text = login ?? ""
        self.loginTextField.textAlignment = .center
        self.loginTextField.keyboardType = .emailAddress
        self.loginTextField.textContentType = .none
        self.loginTextField.returnKeyType = .next
        self.loginTextField.backgroundColor = .white
        self.loginTextField.frame = CGRect(x: self.view.bounds.minX + 46 ,
                                           y: self.view.bounds.midY + 50,
                                           width: self.view.bounds.width - 92,
                                           height: 30)
        self.loginTextField.layer.cornerRadius = 10
        self.loginTextField.layer.borderWidth = 2
        self.loginTextField.layer.borderColor = UIColor.black.cgColor
        
        
        self.passwordTextField.placeholder = "Password"
        self.passwordTextField.text = ""
        self.passwordTextField.textAlignment = .center
        self.passwordTextField.textContentType = .password
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.returnKeyType = .done
        self.passwordTextField.backgroundColor = .white
        self.passwordTextField.frame = CGRect(x: self.loginTextField.frame.minX ,
                                              y: self.loginTextField.frame.maxY + 16,
                                              width: self.loginTextField.frame.width,
                                              height: self.loginTextField.frame.height)
        self.passwordTextField.layer.cornerRadius = 10
        self.passwordTextField.layer.borderWidth = 2
        self.passwordTextField.layer.borderColor = UIColor.black.cgColor
        
        self.logoutButton.frame = self.passwordTextField.frame
        self.logoutButton.isHidden = true
        self.logoutButton.setTitle("Logout", for: .normal)
        self.logoutButton.layer.cornerRadius = 10
        self.logoutButton.layer.borderWidth = 2
        self.logoutButton.layer.backgroundColor = UIColor.mainColor().cgColor
        self.logoutButton.addTarget(self, action: #selector(self.logoutButtonTapped), for: .touchDown)
        
        
        
        self.loginButton.frame = CGRect(x: self.passwordTextField.frame.minX,
                                        y: self.passwordTextField.frame.maxY + 16,
                                        width: self.passwordTextField.frame.width,
                                        height: self.passwordTextField.frame.height)
        if login == nil {
            self.loginButton.setTitle("Login", for: .normal) } else {
            self.loginButton.setTitle("Continue as", for: .normal)
            self.passwordTextField.isHidden = true
            self.logoutButton.isHidden = false
        }
        self.loginButton.layer.cornerRadius = 10
        self.loginButton.layer.borderWidth = 2
        self.loginButton.layer.backgroundColor = UIColor.mainColor().cgColor
        loginButton.addTarget(self, action: #selector(self.loginButtonTapped), for: .touchDown)
    }
    
    
    
    func bindKeyboardNotification() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { notification in
            let keyboardHeight: CGFloat = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
            self.view.frame.origin = CGPoint(x: 0, y: -keyboardHeight/2)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { notification in
            self.view.frame.origin = CGPoint(x: 0, y: 0)
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func logoutButtonTapped() {
        presenter.performLogout()
    }
    
    @objc func loginButtonTapped() {
        let login = self.loginTextField.text
        let password = self.passwordTextField.text
        guard let unwrapedLogin = login else {
            return
        }
        guard let unwrapedPassword = password else {
            return
        }
        if self.loginButton.titleLabel?.text == "Continue as" {
            presenter.setUserIdForCurrentSession(login: unwrapedLogin)
            performSegueToTabbar()
        } else {
            presenter.preformLogin(login: unwrapedLogin, password: unwrapedPassword)
        }
    }

    func performSegueToTabbar() {
        appCoordinator?.setupTabBar()
    }
    
    func showAlert(for alert: String) {
        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}


