//
//  SignupViewController.swift
//  MVVMShopApp
//
//  Created by Rasyadh Abdul Aziz on 18/05/19.
//  Copyright © 2019 Rasyadh Abdul Aziz. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignupViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        omitNavBackButtonTitle()
        subviewSettings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        [usernameField, emailField, passwordField].forEach { field in
            field?.setRoundedCorner(cornerRadius: 8.0)
            field?.setPadding(10.0)
        }
        signupButton.setRoundedCorner(cornerRadius: 8.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureTransparentNavigationBar()
    }
    
    // MARK: - IBActions
    @IBAction func signupTouchUpInside(_ sender: Any) {
        if validateField() {
            SVProgressHUD.showSuccess(withStatus: Localify.get("messages.success.signup"))
            SVProgressHUD.dismiss(withDelay: 0.75) {
                self.managerViewController?.showHomeScreen()
            }
        }
    }
    
    // MARK: - Functions
    private func subviewSettings() {
        titleLabel.text = Localify.get("signup.label.title")
        subtitleLabel.text = Localify.get("signup.label.subtitle")
        usernameField.placeholder = Localify.get("signup.field.placeholder.username")
        emailField.placeholder = Localify.get("signup.field.placeholder.email")
        passwordField.placeholder = Localify.get("signup.field.placeholder.password")
        signupButton.setTitle(Localify.get("signup.button.signup"), for: .normal)
    }
    
    private func validateField() -> Bool {
        var errors = [String]()
        
        if usernameField.text!.isEmpty {
            errors.append(Localify.get("field_validation.invalid.message.username_empty"))
        }
        
        if emailField.text!.isEmpty {
            errors.append(Localify.get("field_validation.invalid.message.email_empty"))
        }
        else if !emailField.text!.isValidEmail() {
            errors.append(Localify.get("field_validation.invalid.message.email_invalid"))
        }
        
        if passwordField.text!.isEmpty {
            errors.append(Localify.get("field_validation.invalid.message.password_empty"))
        }
        else if passwordField.text!.count < 6 {
            errors.append(Localify.get("field_validation.invalid.message.password_length"))
        }
        
        if errors.isEmpty {
            return true
        }
        else {
            let message = errors.joined(separator: "\n")
            Alertify.displayAlert(
                title: Localify.get("field_validation.invalid.title"),
                message: message,
                sender: self)
            
            return false
        }
    }
}

// MARK: - TextField Delegate
extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextResponder = textField.superview?.viewWithTag(textField.tag + 1) {
            nextResponder.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
            signupButton.sendActions(for: .touchUpInside)
        }
        
        return true
    }
}
