//
//  LoginViewController.swift
//  MVVMShopApp
//
//  Created by Rasyadh Abdul Aziz on 17/05/19.
//  Copyright © 2019 Rasyadh Abdul Aziz. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        omitNavBackButtonTitle()
        subviewSettings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emailField.setRoundedCorner(cornerRadius: 8.0)
        passwordField.setRoundedCorner(cornerRadius: 8.0)
        loginButton.setRoundedCorner(cornerRadius: 8.0)
        emailField.setPadding(10.0)
        passwordField.setPadding(10.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureTransparentNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: - IBActions
    @IBAction func loginTouchUpInside(_ sender: Any) {
        if validateField() {
            SVProgressHUD.showSuccess(withStatus: Localify.get("messages.success.login"))
            SVProgressHUD.dismiss(withDelay: 0.75) {
                self.managerViewController?.showHomeScreen()
            }
        }
    }
    
    @IBAction func signupTouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "showSignup", sender: self)
    }
    
    // MARK: - Functions
    private func subviewSettings() {
        titleLabel.text = Localify.get("login.label.title")
        subtitleLabel.text = Localify.get("login.label.subtitle")
        emailField.placeholder = Localify.get("login.field.placeholder.email")
        passwordField.placeholder = Localify.get("login.field.placeholder.password")
        loginButton.setTitle(Localify.get("login.button.login"), for: .normal)
        signupButton.setTitle(Localify.get("login.button.signup"), for: .normal)
        
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    private func validateField() -> Bool {
        var errors = [String]()
        
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
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextResponder = textField.superview?.viewWithTag(textField.tag + 1) {
            nextResponder.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
            loginButton.sendActions(for: .touchUpInside)
        }
        
        return true
    }
}
