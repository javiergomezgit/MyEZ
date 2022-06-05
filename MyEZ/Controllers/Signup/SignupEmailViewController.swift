//
//  SignupEmailViewController.swift
//  MyEZ
//
//  Created by Javier Gomez on 9/8/17.
//  Copyright © 2017 JDev. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
//import SwiftyJSON

class SignupEmailViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var verifyPasswordText: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var isEmpty = true
    var idShopify = ""
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func emailChanged(_ sender: UITextField){
        if emailText.text == "" {
            self.isEmpty = true
        } else {
           // checkIfUserExistsInShopify()
        }
        
    }
    
    @IBAction func passwordChanged(_ sender: UITextField) {
        if passwordText.text == "" {
            self.isEmpty = true
        }
    }
    
    @IBAction func verifyMatchingPass(_ sender: Any) {
        if verifyPasswordText.text != passwordText.text {
            alert(message: "Passwords not matching, try again.", title: "Not matching")
            passwordText.text = ""
            verifyPasswordText.text = ""
        }
    }
    
    @IBAction func verifyPasswordChanged(_ sender: UITextField) {
        if verifyPasswordText.text == "" {
            self.isEmpty = true
        } else {
            self.isEmpty = false
            nextButton.isEnabled = true
        }
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        
        if emailText.text != "" && passwordText.text != "" {
            
            createUserInShopify(username: emailText.text!, password: passwordText.text!)
            
        } else {
            alert(message: "Please type your email and password", title: "Missing Email/Password")
        }
    }
    
    func saveExtraInfoUser(userId: String, email: String) {
        var ref : DatabaseReference!
        ref = Database.database().reference()
        
        extraInfo.completedSigningUp = false
        
        let account = ["email": email, "completedSigningUp" : false, "idShopify" : idShopify] as [String : Any]
        
        ref.child("users").child(userId).child("account").setValue(account) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print (error)
            }
        }
        
        //Go to add info
        self.performSegue(withIdentifier: "signupAddinfo", sender: self)
    }
 
    @IBAction func openTermsOnline(_ sender: UIButton) {
        
        if let url = URL(string: "https://www.ezinflatables.com/pages/terms-and-conditions") {
            UIApplication.shared.open(url, options: [:])
        }

    }
    
    func alert(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func createUserInFirebase(idShopify: String) {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
                if error == nil {
                    userInformation.userId = (user?.user.uid)!
                    userInformation.email = self.emailText.text!

                    self.idShopify = idShopify
                    self.saveExtraInfoUser(userId: (user?.user.uid)!, email: self.emailText.text!)

                } else {
                    if let errCode = AuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                        case .invalidEmail:
                            self.alert(message: "Please enter a valid email", title: "Invalid email")
                        case .emailAlreadyInUse:
                            self.alert(message: "Email is already in use", title: "Email in use")
                        default:
                            self.alert(message: error!.localizedDescription, title: "System error")
                        }
                    }
                }
            })
    }
    
    func createUserInShopify(username: String, password: String) {

//        let shopDomain = "ez-inflatables-inc.myshopify.com"
//        let apiKey = "e78a3a7c6015dbc918bf038db8596328"
//        
//        let client = Graph.Client(shopDomain: shopDomain, apiKey: apiKey)
//        
//        let input = Storefront.CustomerCreateInput.create(email: username, password: password)
//
//        let mutation = Storefront.buildMutation { $0
//            .customerCreate(input: input) { $0
//                .customer { $0
//                    .id()
//                    .email()
//                    .firstName()
//                    .lastName()
//                }
//                .userErrors { $0
//                    .field()
//                    .message()
//                }
//            }
//        }
//
//        let task = client.mutateGraphWith(mutation, completionHandler: { (response, error) in
//            
//            if error == nil {
//                let fields = response!.fields as [String : Any]
//                
//                let customerValue = fields["customerCreate"] as! [String : Any]
//                print (customerValue)
//                
//                let userErrors = customerValue["userErrors"] as! [Any]
//                
//                if userErrors.isEmpty {
//
//                    let customer = customerValue["customer"] as! [String : Any]
//                    print (customer["email"])
//                    print (customer["id"])
//                    
//                    self.createUserInFirebase(idShopify: customer["id"] as! String)
//                    
//                    //save id for shopify
//                    
//                } else {
//                    let userError = userErrors[0] as? [String : Any]
//                    self.alert(message: userError!["message"] as! String, title: "Error")
//                }
//                
//               
//                                
//            } else {
//                print ("error getting data")
//            }
//        
//        })
//        task.resume()
    }
}
