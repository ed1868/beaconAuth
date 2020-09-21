//
//  LoginController.swift
//  ZoneRv1
//
//  Created by Eddie Ruiz on 9/21/20.
//  Copyright © 2020 AI Nomads. All rights reserved.
//

import Foundation

import Firebase
import JGProgressHUD


protocol AuthenticationControllerProtocol {
    func checkFormStatus()
}



class LoginController: UIViewController {
    
    
    // MARK - PROPERTIES
    private var viewModel = loginViewModel()
    
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        
//        iv.image = UIImage(systemName: "bubble.right")
//        var chat = UIImage(named: "Chat")
//        var chatImageView = UIImageView(image: chat)
        
        
        iv.image = UIImage(named: "zoner")
        iv.tintColor = .white
        
        return iv
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private lazy var emailContainerView: UIView = {
        return InputContainerView(image: UIImage(systemName: "envelope"), textField:emailTextField)
    }()
    

    private let passwordTextField: UITextField = {
       let tf = CustomTextField(placeholder: "Password")
        
        tf.isSecureTextEntry = true

        return tf
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
        return  InputContainerView(image: UIImage(systemName: "lock"), textField: passwordTextField)

    }()
    
    

    
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
    }()
    
    
    
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Dont have an account? ", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        
//          SIGN UP SECTION
//        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white]))
//        button.addTarget(self, action: #selector(handleShowSignup), for: .touchUpInside)
        
        
        // AI CONTACT SECTION
        
        attributedTitle.append(NSAttributedString(string: "Contact AI Nomads", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white]))
//
        button.setAttributedTitle(attributedTitle, for: .normal)
//
        button.addTarget(self, action: #selector(handleAppleContact), for: .touchUpInside)
        return button
    }()
    
    // MARK - LIFECYCLE
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    // MARK - SELECTORS
    
    @objc func handleLogin(){
        print("HANDLING LOGIN....")
        
         guard let email = emailTextField.text else { return }
    
         guard let password = passwordTextField.text else { return }
        
        showLoader(true, withText: "Loging into your Zone")
        
        AuthService.shared.logUserIn(withEmail: email,password: password) { result, error in
            if let error = error {
                                print("DEBUG: FAILED TO LOG IN USER WITH ERROR : \(error.localizedDescription)")
                self.showLoader(false)
                                return
                            }
                            print("DEBUG: LOG IN SUCCESFULL")
                            self.showLoader(false)
                            self.dismiss(animated: true, completion: nil)
                        }
    }
    
    @objc func handleShowSignup(){
        let controller = RegistrationController()
        
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    @objc func handleAppleContact(){
        print("WE ARE TRYING TO CONTACT AI NOMADS")
    }
    
    
    @objc func textDidChange(sender: UITextField){
        print("CHECKING IF TEXT HAS CHANGED....")
        print("DEBUG: Sender text : \(sender.text)")
        
        if(sender == emailTextField){
            viewModel.email = sender.text
        }else{
            viewModel.password = sender.text
        }
        
        checkFormStatus()
    }
    // MARK - HELPERS
    

    
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientLayer()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        iconImage.setDimensions(height: 120, width: 120)
        

        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   loginButton])

        stack.axis = .vertical
        stack.spacing = 16

        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        
        
        
        // TEXT TARGETING FOR FORM CONTROLLING
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    
 
    

}


extension LoginController: AuthenticationControllerProtocol {
    func checkFormStatus() {
        print("CHECKING THE FORM STATUS.....")
        
        if(viewModel.formIsValid){
            loginButton.isEnabled = true
            loginButton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        }else{
            loginButton.isEnabled = false
            loginButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
        
    }
}
