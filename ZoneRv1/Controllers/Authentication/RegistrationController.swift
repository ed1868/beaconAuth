//
//  RegistrationController.swift
//  ZoneRv1
//
//  Created by Eddie Ruiz on 9/21/20.
//  Copyright © 2020 AI Nomads. All rights reserved.
//

import Foundation

import Firebase


class RegistrationController: UIViewController {
    
    
    // MARK - PROPERTIES
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleToFill
        button.clipsToBounds = true
        return button
    }()
    
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let usernameTextField = CustomTextField(placeholder: "Username")
    private let fullnameTextField = CustomTextField(placeholder: "Full Name")
    private let beaconIdTextField = CustomTextField(placeholder: "Beacon ID")
    private let beaconMessageTextField = CustomTextField(placeholder: "Promotion")
    
    private lazy var fullNameContainerView: UIView = {
        return InputContainerView(image: UIImage(systemName: "person.circle"), textField:fullnameTextField)
    }()
    
    private lazy var usernameContainerView: UIView = {
        return InputContainerView(image: UIImage(systemName: "person.circle"), textField:usernameTextField)
    }()
    
    private lazy var emailContainerView: UIView = {
        return InputContainerView(image: UIImage(systemName: "envelope"), textField:emailTextField)
    }()
    
    private lazy var beaconIdContainerView: UIView = {
        return InputContainerView(image: UIImage(systemName: "globe"), textField:beaconIdTextField)
    }()
    private lazy var beaconMessageContainerView: UIView = {
        return InputContainerView(image: UIImage(systemName: "cart"), textField:beaconMessageTextField)
    }()
    
    private let passwordTextField: UITextField = {
       let tf = CustomTextField(placeholder: "Password")
        
        tf.isSecureTextEntry = true

        return tf
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
        return  InputContainerView(image: UIImage(systemName: "lock"), textField: passwordTextField)

    }()
    
    
    private let logInFromSignUpButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Have an Account? ", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        
        
        attributedTitle.append(NSAttributedString(string: "Sign in", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    
    
    
    // MARK - LIFECYCLE
    
    
    // MARK - SELECTORS
    
    @objc func handleSelectPhoto(){
        print("YOU HAVE ENTERED SELECT PHOTO HANDLER")
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
        
        
    }
    
    
    @objc func textDidChange(sender: UITextField){
        print("CHECKING IF TEXT HAS CHANGED....")
        print("DEBUG: Sender text : \(sender.text)")
        
        
        switch sender {
        case emailTextField:
            viewModel.email = sender.text

        case passwordTextField:
            viewModel.password = sender.text

        case fullnameTextField:
            viewModel.fullname  = sender.text

            
        case usernameTextField:
            
            viewModel.username = sender.text
            
        case beaconIdTextField:
            
            viewModel.beaconId = sender.text
            
        case beaconMessageTextField :
            
            viewModel.beaconMessage = sender.text
    
        default:
            print("Que paso tio?")
        }
        
    
        
        checkFormStatus()
    }
    
    
    @objc func keyboardWillShow(){
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 88
        }
    }
    
    
    @objc func keyboardWillHide() {
        if view.frame.origin.y != 0 {
              self.view.frame.origin.y = 0
          }
    }
    // MARK - HELPERS
    

    
    @objc func handleShowLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func handleSignUp(){
        print("YOU HAVE ENTERED THE HANDLE SIGN UP ALGORITHM")
        print("what up")
        guard let email = emailTextField.text else { return }
        print("-----EMAIL\(email)-------")
        guard let username = usernameTextField.text?.lowercased() else { return }
        print("-----USERNAME\(username)-------")
        guard let password = passwordTextField.text else { return }
        print("-----PASSWORD\(password)-------")
        guard let fullname = fullnameTextField.text else { return }
        print("-----FULLNAME\(fullname)-------")
        guard let beaconId = beaconIdTextField.text else { return }
        print("-----BEACONID\(beaconId)-------")
        
        
        guard let beaconPromotion = beaconMessageTextField.text else { return }
        print("-----PROMOTION\(beaconPromotion)-------")
        guard let profileImage = profileImage else { return }
        print("-----PROFILE IMAGE\(profileImage)-------")
        let credentials = registrationCredentials(email: email, password: password, username: username, fullname: fullname,profileImage: profileImage, beaconId: beaconId, beaconPromotion: beaconPromotion)
        
        print("los credentials \(credentials)")
        
        showLoader(true, withText: "Creating your zone..")
        
        AuthService.shared.createUser(credentials: credentials) { error in
            if let error = error {
                                      print("DEBUG: FAILED TO UPLOAD USER DATA WITH ERROR : \(error.localizedDescription)")
                self.showLoader(false)
                                      return
                                  }
                                  print("DEBUG: DID CREATE USER ...")
            self.showLoader(false)
            guard let controller = UIApplication.shared.keyWindow?.rootViewController as? HomeController
            else {return}
            self.dismiss(animated: true, completion: nil)
                            controller.configureUI()
                                  
                                  
                              }
        }

    // MARK - HELPERS
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObserves()
    }
    
    
    func configureUI(){
        configureGradientLayer()
        
               view.addSubview(plusPhotoButton)
               plusPhotoButton.centerX(inView: view)
               plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
               plusPhotoButton.setDimensions(height: 120, width: 120)
      
        
        
        
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   usernameContainerView,
                                                    fullNameContainerView,
                                                     passwordContainerView,
                                                     beaconIdContainerView,
                                                     beaconMessageContainerView,
                                                     signUpButton
                                                    ])

          stack.axis = .vertical
          stack.spacing = 16

          view.addSubview(stack)
          stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
          
          view.addSubview(logInFromSignUpButton)
          logInFromSignUpButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        
        
        
        
        
        
    }
    
    
    func configureNotificationObserves(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        beaconIdTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        beaconMessageTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// Mark: = UI IMAGE PICKER CONTROLLER DELEGATE

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        
        profileImage = image
        
        
        plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.cornerRadius = 45
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
    }
}


extension RegistrationController: AuthenticationControllerProtocol {
    func checkFormStatus() {
        print("CHECKING THE FORM STATUS.....")
        
        if(viewModel.formIsValid){
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        }else{
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
        
    }
}
