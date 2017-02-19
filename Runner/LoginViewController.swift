//
//  LoginViewController.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-02-18.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = self.view.frame
        imageView.image = UIImage(named: "road-track-athletic")
        imageView.alpha = 0.7
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let inputsContainerView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.3)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let loginRegisterButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("REGISTER", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(white: 1, alpha: 0.3)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(loginRegisterButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let nameTextField: UITextField = {
        
        let text = UITextField()
        text.textColor = UIColor.white
        text.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.9)])
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let nameSeparatorView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        
        let text = UITextField()
        text.textColor = UIColor.white
        text.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.9)])
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let emailSeparatorView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        
        let text = UITextField()
        text.textColor = UIColor.white
        text.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.9)])
        text.translatesAutoresizingMaskIntoConstraints = false
        text.isSecureTextEntry = true
        return text
    }()
    
    let loginRegisterSegmentedControl: UISegmentedControl = {
        let segControl = UISegmentedControl(items: ["LOGIN", "REGISTER"])
        segControl.tintColor = UIColor.white
        segControl.backgroundColor = UIColor(white: 1, alpha: 0.3)
        segControl.selectedSegmentIndex = 1
        segControl.translatesAutoresizingMaskIntoConstraints = false
        segControl.addTarget(self, action: #selector(handleLoginRegisterChanged), for: .valueChanged)
        return segControl
    }()
    
    var inputsContainerHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        view.addSubview(bgImageView)
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(loginRegisterSegmentedControl)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupLoginRegisterSegmentedControl()
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    func handleLoginRegisterChanged() {
        
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        // Change height of input container view
        inputsContainerHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        // Change height of nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        // show/hide name text placeholder and separator view
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true : false
        nameSeparatorView.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true : false
        
        // Change height of email text field
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        // Change height of password text field
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupLoginRegisterSegmentedControl() {
        
        // x, y, width, height constraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -10).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupInputsContainerView() {
        
        // x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        inputsContainerHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        // x, y, width, height constraints
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        // x, y, width, height constraints
        nameSeparatorView.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -20).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // x, y, width, height constraints
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        // x, y, width, height constraints
        emailSeparatorView.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -20).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // x, y, width, height constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupLoginRegisterButton() {
        
        // x, y, width, height constraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 10).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func loginRegisterButtonPressed() {
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }
        else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            
            print("[LOGIN VIEW CONTROLLER] email and/or password fields are not valid.")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            print("[LOGIN VIEW CONTROLLER] User successfuly logged in.")

            // Successfully logged user in
            self.presentFeedViewController()
            
        })
    }
    
    func handleRegister() {
        
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            
            print("[LOGIN VIEW CONTROLLER] email and/or password fields are not valid.")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                
                print(error.debugDescription)
                return
            }
            
            // Successfully authenticated user
            guard let uid = user?.uid else { return }
            
            let firebaseRef = FIRDatabase.database().reference(fromURL: "https://runner-23510.firebaseio.com/")
            let usersReference = firebaseRef.child("users").child(uid)
            
            let values = ["name": name, "email": email]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    print(err.debugDescription)
                    return
                }
                
                print("[LOGIN VIEW CONTROLLER] User successfuly registered and saved to database.")

                self.presentFeedViewController()
            })
        })
    }
    
    func presentFeedViewController() {
        
        let feedViewModel = FeedViewModel()
        let layout  = feedViewModel.layout
        let feedVC = FeedViewController(collectionViewLayout: layout)
        feedVC.feedViewModel = feedViewModel
        let feedNavController = UINavigationController(rootViewController: feedVC)
        self.present(feedNavController, animated: true, completion: nil)
    }
}
