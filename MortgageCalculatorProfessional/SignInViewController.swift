//
//  ViewController.swift
//  MortgageCalculatorProfessional
//
//  Created by Alex on 11/2/16.
//  Copyright © 2016 Alex. All rights reserved.
//

import UIKit
import Firebase

@objc(SignInViewController)
class SignInViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = FIRAuth.auth()?.currentUser {
            self.signedIn(user)
        }
    }
    
    @IBAction func didTapSignIn(_ sender: AnyObject) {
        guard let email = emailField.text, let password = passwordField.text else { return }
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.displayAlert(eld: error.localizedDescription)
                return
            }
            self.signedIn(user!)
        }
    }
    @IBAction func didTapSignUp(_ sender: AnyObject) {
        guard let email = emailField.text, let password = passwordField.text else { return }
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.displayAlert(eld: error.localizedDescription)
                return
            }
            self.setDisplayName(user!)
        }
    }
    
    func displayAlert(eld: String) {
        var emsg = ""
        if eld == "There is no user record corresponding to this identifier. The user may have been deleted." {
            emsg = "Account does not exist. Please tap on Create Account."
        }
        else if eld == "The email address is badly formatted." {
            emsg = "Please enter a valid email."
        }
        else if eld == "An internal error has occurred, print and inspect the error details for more information." {
            emsg = "Password error"
        }
        let alert = UIAlertController(title: "Something went wrong", message: (emsg != "" ? emsg : eld), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setDisplayName(_ user: FIRUser) {
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = user.email!.components(separatedBy: "@")[0]
        changeRequest.commitChanges(){ (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.signedIn(FIRAuth.auth()?.currentUser)
        }
    }
    
    @IBAction func didRequestPasswordReset(_ sender: AnyObject) {
        let prompt = UIAlertController.init(title: nil, message: "Email:", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            FIRAuth.auth()?.sendPasswordReset(withEmail: userInput!) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        prompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        present(prompt, animated: true, completion: nil);
    }
    
    func signedIn(_ user: FIRUser?) {
        MeasurementHelper.sendLoginEvent()
        
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.photoURL = user?.photoURL
        AppState.sharedInstance.signedIn = true
        let notificationName = Notification.Name(rawValue: Constants.NotificationKeys.SignedIn)
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
        performSegue(withIdentifier: Constants.Segues.SignInToFp, sender: nil)
    }
}
