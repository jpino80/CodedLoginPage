//
//  ViewController.swift
//  CodedLoginPage
//
//  Created by Joe Pino on 2/20/18.
//  Copyright © 2018 Joe Pino. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginController: UIViewController {
    
    var mainController: MainController?

    let topViewArea: UIView = {
        let topView = UIView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.backgroundColor = .white
        
        return topView
        
    }()
    
    lazy var logoImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "tuckerlogo"))
        
        //this enables autolayout
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectLogoImageView)))
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()

    let bottomViewArea: UIView = {
        let bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        return bottomView
        
    }()
    
    
    let inputContainterViewReg: UIView = {
        let inputContainer = UIView()
        inputContainer.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.backgroundColor = UIColor(white: 1, alpha: 0.85)
        inputContainer.layer.cornerRadius = 5
        
        return inputContainer
    }()
    
    let inputContainterViewLog: UIView = {
        let inputContainer = UIView()
        inputContainer.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.backgroundColor = UIColor(white: 1, alpha: 0.85)
        inputContainer.layer.cornerRadius = 5
        
        return inputContainer
    }()
    
    
    
//Login....................................
    let nameSeparatorView: UIView = {
        let nameSeparator = UIView()
        nameSeparator.translatesAutoresizingMaskIntoConstraints = false
        nameSeparator.backgroundColor = .gray
        
        return nameSeparator
    }()
    
    let emailField: UITextField = {
        
        let usernameTextField = UITextField()
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.placeholder = "Email"
       
        return usernameTextField
    }()
    
    let passwordField: UITextField = {
        
        let passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        
        return passwordTextField
        
    }()
    
    let loginButton: UIButton = {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log in", for: .normal)
        button.backgroundColor = .darkGray
        
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
        
    }()
    
    
    @objc func handleLogin(){
        
        guard let email = emailField.text, let password = passwordField.text
            else {
                print("Form Error")
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil{
                print(error!)
                return
            }
            self.mainController?.fetchUserAndSetupNavBarTitle()
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    

    
//register.................................
    let registerNameSeparatorView: UIView = {
        let nameSeparator = UIView()
        nameSeparator.translatesAutoresizingMaskIntoConstraints = false
        nameSeparator.backgroundColor = .gray
        
        return nameSeparator
    }()
    
    let registetEmailSeparatorView: UIView = {
        let nameSeparator = UIView()
        nameSeparator.translatesAutoresizingMaskIntoConstraints = false
        nameSeparator.backgroundColor = .gray
        
        return nameSeparator
    }()
    
    let registerUsernameField: UITextField = {
        
        let usernameTextField = UITextField()
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.placeholder = "Username"
        
        return usernameTextField
    }()
    
    let registerEmailField: UITextField = {
        
        let emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "Email"
        
        return emailTextField
    }()
    
    let registerPasswordField: UITextField = {
        
        let passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        
        return passwordTextField
        
    }()
    
    let registerButton: UIButton = {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .darkGray
        
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        return button
        
    }()
    

    
    
    let loginRegisterSegmentedControl : UISegmentedControl = {
        
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.gray
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLRSwitch), for: .valueChanged)
        
        
        return sc
    }()
    
    @objc func handleLRSwitch(){
        
        let lrIndex = loginRegisterSegmentedControl.selectedSegmentIndex

        
        if lrIndex == 1 {
            inputContainterViewLog.removeFromSuperview()
            loginButton.removeFromSuperview()
            setupInputViewLayoutRegister()
            logoImage.isUserInteractionEnabled = true
        }
        else if lrIndex == 0 {
            inputContainterViewReg.removeFromSuperview()
            registerButton.removeFromSuperview()
            setupInputViewLayoutLogin()
            logoImage.isUserInteractionEnabled = false
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupTopViewLayout()
        setupBottomViewLayout()
        setupInputViewLayoutRegister()
    }
    
    func setupTopViewLayout(){
        
        view.addSubview(topViewArea)
        topViewArea.translatesAutoresizingMaskIntoConstraints = false
        
        topViewArea.topAnchor.constraint(equalTo: view.topAnchor, constant: 1).isActive = true
        topViewArea.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3).isActive = true
        topViewArea.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        topViewArea.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        topViewArea.addSubview(logoImage)
        
        logoImage.centerXAnchor.constraint(equalTo: topViewArea.centerXAnchor, constant: 0).isActive = true
        logoImage.centerYAnchor.constraint(equalTo: topViewArea.centerYAnchor, constant: 0).isActive = true
        logoImage.widthAnchor.constraint(equalTo: 	topViewArea.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    func setupBottomViewLayout(){
        
        view.addSubview(bottomViewArea)
        bottomViewArea.translatesAutoresizingMaskIntoConstraints = false
        bottomViewArea.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:1.0)
        bottomViewArea.topAnchor.constraint(equalTo: topViewArea.bottomAnchor, constant: 0).isActive = true
        bottomViewArea.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        bottomViewArea.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        bottomViewArea.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        bottomViewArea.addSubview(loginRegisterSegmentedControl)
        
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: bottomViewArea.centerXAnchor, constant: 0).isActive = true
        loginRegisterSegmentedControl.topAnchor.constraint(equalTo: bottomViewArea.topAnchor, constant: 10).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: bottomViewArea.widthAnchor, multiplier: 0.6).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
    }
    
    
    func setupInputViewLayoutRegister(){
        
        bottomViewArea.addSubview(inputContainterViewReg)
        bottomViewArea.addSubview(registerButton)
        
        inputContainterViewReg.topAnchor.constraint(equalTo: loginRegisterSegmentedControl.bottomAnchor, constant: 10).isActive = true
        //inputContainterViewReg.centerXAnchor.constraint(equalTo: bottomViewArea.centerXAnchor, constant: 0).isActive = true
        inputContainterViewReg.leadingAnchor.constraint(equalTo: bottomViewArea.leadingAnchor, constant: 20).isActive = true
        inputContainterViewReg.trailingAnchor.constraint(equalTo: bottomViewArea.trailingAnchor, constant: -20).isActive = true
        inputContainterViewReg.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        inputContainterViewReg.addSubview(registerUsernameField)
        registerUsernameField.topAnchor.constraint(equalTo: inputContainterViewReg.topAnchor, constant: 0).isActive = true
        //registerUsernameField.centerXAnchor.constraint(equalTo: inputContainterViewReg.centerXAnchor, constant: 0).isActive = true
        registerUsernameField.leadingAnchor.constraint(equalTo: inputContainterViewReg.leadingAnchor, constant: 5).isActive = true
        registerUsernameField.trailingAnchor.constraint(equalTo: inputContainterViewReg.trailingAnchor, constant: -5).isActive = true
        registerUsernameField.heightAnchor.constraint(equalTo: inputContainterViewReg.heightAnchor, multiplier: 1/3).isActive = true
        
        inputContainterViewReg.addSubview(registerNameSeparatorView)
        registerNameSeparatorView.topAnchor.constraint(equalTo: registerUsernameField.bottomAnchor, constant: 0).isActive = true
        //.centerXAnchor.constraint(equalTo: inputContainterViewReg.centerXAnchor, constant: 0).isActive = true
        registerNameSeparatorView.leadingAnchor.constraint(equalTo: inputContainterViewReg.leadingAnchor, constant: 0).isActive = true
        registerNameSeparatorView.trailingAnchor.constraint(equalTo: inputContainterViewReg.trailingAnchor, constant:  0).isActive = true
        registerNameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputContainterViewReg.addSubview(registerEmailField)
        registerEmailField.topAnchor.constraint(equalTo: registerUsernameField.bottomAnchor, constant: 0).isActive = true
        //registerEmailField.centerXAnchor.constraint(equalTo: inputContainterViewReg.centerXAnchor, constant: 0).isActive = true
        registerEmailField.leadingAnchor.constraint(equalTo: inputContainterViewReg.leadingAnchor, constant: 5).isActive = true
        registerEmailField.trailingAnchor.constraint(equalTo: inputContainterViewReg.trailingAnchor, constant: -5).isActive = true
        registerEmailField.heightAnchor.constraint(equalTo: inputContainterViewReg.heightAnchor, multiplier: 1/3).isActive = true
        
        inputContainterViewReg.addSubview(registetEmailSeparatorView)
        registetEmailSeparatorView.topAnchor.constraint(equalTo: registerEmailField.bottomAnchor, constant: 0).isActive = true
        //registetEmailSeparatorView.centerXAnchor.constraint(equalTo: inputContainterViewReg.centerXAnchor, constant: 0).isActive = true
        registetEmailSeparatorView.leadingAnchor.constraint(equalTo: inputContainterViewReg.leadingAnchor, constant: 0).isActive = true
        registetEmailSeparatorView.trailingAnchor.constraint(equalTo: inputContainterViewReg.trailingAnchor, constant:  0).isActive = true
        registetEmailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputContainterViewReg.addSubview(registerPasswordField)
        registerPasswordField.topAnchor.constraint(equalTo: registerEmailField.bottomAnchor, constant: 0).isActive = true
        //registerPasswordField.centerXAnchor.constraint(equalTo: inputContainterViewReg.centerXAnchor, constant: 0).isActive = true
        registerPasswordField.leadingAnchor.constraint(equalTo: inputContainterViewReg.leadingAnchor, constant: 5).isActive = true
        registerPasswordField.trailingAnchor.constraint(equalTo: inputContainterViewReg.trailingAnchor, constant: -5).isActive = true
        registerPasswordField.heightAnchor.constraint(equalTo: inputContainterViewReg.heightAnchor, multiplier: 1/3).isActive = true
        
        registerButton.topAnchor.constraint(equalTo: inputContainterViewReg.bottomAnchor, constant: 5).isActive = true
        //registerButton.centerXAnchor.constraint(equalTo: bottomViewArea.centerXAnchor, constant: 0).isActive = true
        registerButton.leadingAnchor.constraint(equalTo: inputContainterViewReg.leadingAnchor, constant: 0).isActive = true
        registerButton.trailingAnchor.constraint(equalTo: inputContainterViewReg.trailingAnchor, constant: 0).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func setupInputViewLayoutLogin(){
        
        bottomViewArea.addSubview(inputContainterViewLog)
        bottomViewArea.addSubview(loginButton)
    
        inputContainterViewLog.topAnchor.constraint(equalTo: loginRegisterSegmentedControl.bottomAnchor, constant: 10).isActive = true
        //inputContainterViewLog.centerXAnchor.constraint(equalTo: bottomViewArea.centerXAnchor, constant: 0).isActive = true
        inputContainterViewLog.leadingAnchor.constraint(equalTo: bottomViewArea.leadingAnchor, constant: 20).isActive = true
        inputContainterViewLog.trailingAnchor.constraint(equalTo: bottomViewArea.trailingAnchor, constant: -20).isActive = true
        inputContainterViewLog.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        inputContainterViewLog.addSubview(emailField)
        emailField.topAnchor.constraint(equalTo: inputContainterViewLog.topAnchor, constant: 0).isActive = true
        //usernameField.centerXAnchor.constraint(equalTo: inputContainterViewLog.centerXAnchor, constant: 0).isActive = true
        emailField.leadingAnchor.constraint(equalTo: inputContainterViewLog.leadingAnchor, constant: 5).isActive = true
        emailField.trailingAnchor.constraint(equalTo: inputContainterViewLog.trailingAnchor, constant: 5).isActive = true
        emailField.heightAnchor.constraint(equalTo: inputContainterViewLog.heightAnchor, multiplier: 0.5).isActive = true
        
        inputContainterViewLog.addSubview(nameSeparatorView)
        nameSeparatorView.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 0).isActive = true
        //nameSeparatorView.centerXAnchor.constraint(equalTo: inputContainterViewLog.centerXAnchor, constant: 0).isActive = true
        nameSeparatorView.leadingAnchor.constraint(equalTo: inputContainterViewLog.leadingAnchor, constant: 0).isActive = true
        nameSeparatorView.trailingAnchor.constraint(equalTo: inputContainterViewLog.trailingAnchor, constant:  0).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputContainterViewLog.addSubview(passwordField)
        passwordField.bottomAnchor.constraint(equalTo: inputContainterViewLog.bottomAnchor, constant: 0).isActive = true
        //passwordField.centerXAnchor.constraint(equalTo: inputContainterViewLog.centerXAnchor, constant: 0).isActive = true
        passwordField.leadingAnchor.constraint(equalTo: inputContainterViewLog.leadingAnchor, constant: 5).isActive = true
        passwordField.trailingAnchor.constraint(equalTo: inputContainterViewLog.trailingAnchor, constant: 5).isActive = true
        passwordField.heightAnchor.constraint(equalTo: inputContainterViewLog.heightAnchor, multiplier: 0.5).isActive = true
        
        loginButton.topAnchor.constraint(equalTo: inputContainterViewLog.bottomAnchor, constant: 5).isActive = true
        //loginButton.centerXAnchor.constraint(equalTo: bottomViewArea.centerXAnchor, constant: 0).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: inputContainterViewLog.leadingAnchor, constant: 0).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: inputContainterViewLog.trailingAnchor, constant: 0).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    

}

