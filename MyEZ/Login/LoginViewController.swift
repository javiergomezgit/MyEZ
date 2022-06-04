//
//  LoginViewController.swift
//  MyEZ
//
//  Created by Javier Gomez on 9/1/17.
//  Copyright © 2017 JDev. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth



extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:    [NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}


class LoginViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailText.delegate = self
        self.passText.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func emailTextChanged(_ sender: UITextField) {
        if emailText.text != "" && passText.text != "" {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
        
    }
    
    //Validate when textfield changes
    @IBAction func passwordTextChanged(_ sender: UITextField) {
        if emailText.text != "" && passText.text != "" {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        
        signinInShopify(email: emailText.text!, password: passText.text!)
        
        
        
    }
    

    func signinInShopify(email: String, password: String) {
        
//        let idShopify = ""
//        let shopDomain = "ez-inflatables-inc.myshopify.com"
//        let apiKey = "e78a3a7c6015dbc918bf038db8596328"
//        
//        let client = Graph.Client(shopDomain: shopDomain, apiKey: apiKey)
//        
//        let input = Storefront.CustomerAccessTokenCreateInput.create(email: email, password: password)
//
//        let mutation = Storefront.buildMutation { $0
//            .customerAccessTokenCreate(input: input) { $0
//                .customerAccessToken { $0
//                    .accessToken()
//                    .expiresAt()
//                }
//                .userErrors { $0
//                    .field()
//                    .message()
//                }
//            }
//        }
//            
//        let task = client.mutateGraphWith(mutation, completionHandler: { (response, error) in
//            if let response = response {
//                
//                let values = response.fields as? [String: Any]
//                
//                let value = values?.values.first
//           
//                let tokenAndInfo = value as? [String: Any]
//                
//                let accessToken = tokenAndInfo!["customerAccessToken"] as? [String: Any]
//                
//                let token = accessToken!["accessToken"] as! String
//                
//                self.signinInFirebase(email: email, password: password, idShopify: token)
//               
//            } else {
//                print (error)
//            }
//        })
//        task.resume()
        
    }
    
    func signinInFirebase(email: String, password: String, idShopify: String) {
       
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if user != nil {
                print ("Welcome " + (user?.user.email)! + "\nThis is your ID: " + (user?.user.uid)!)
                
                let preferences = UserDefaults.standard
                
//                if preferences.object(forKey: "newUser") == nil {
//                    preferences.set(true, forKey: "newUser")
//                }
                
                preferences.set((user?.user.uid)!, forKey: "session")

                self.saveInfoInLocalVariables(idShopify: idShopify)
                
            } else {
                self.alert(message: "Sorry, wrong credentials", title: "Try again!")
            }
        }
    }
    
    func saveInfoInLocalVariables(idShopify: String) {
        
        var databaseReference : DatabaseReference!
        databaseReference = Database.database().reference()
        
        userInformation.userId = (Auth.auth().currentUser?.uid)!
        userInformation.email = (Auth.auth().currentUser?.email)!
        
        databaseReference.child("users").child(userInformation.userId).observeSingleEvent(of: .value, with: {
            (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if snapshot.exists() {
               // let account = value?["account"] as? [String: String]
                
                if let units = value?["units"] as? NSDictionary {
                    for unit in units {
                        userUnits[unit.key as! String] = UnitInfo(model: unit.value as! String, imageUnit: NSData())
                    }
                }
                
                userInformation.idShopify = idShopify
                userInformation.name = value?["name"] as? String ?? ""
                userInformation.website = value?["website"] as? String ?? ""
                userInformation.companyName = value?["companyName"] as? String ?? ""
                userInformation.zipCode = value?["zipCode"] as? String ?? ""
                userInformation.phone =  value?["phone"] as? String ?? ""
                userInformation.typeUser = value?["typeUser"] as? String ?? ""
                userInformation.weight = String(value?["weightOwned"] as? Int ?? 0)
                userInformation.subscribed = value?["subscribed"] as? Bool ?? false
                
                self.saveInfoIntoUserDefaults()
                
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "loginMain", sender: self)
                    
                }
            } else {
                self.saveExtraInfoUser(userId: (Auth.auth().currentUser?.uid)!, email: (Auth.auth().currentUser?.email)!, idShopify: idShopify)

            }
        })
        {
            (error) in
            print(error.localizedDescription)
            
            
        }
    }
    
    func saveInfoIntoUserDefaults() {
           
           UserDefaults.standard.set([
               "userId": userInformation.userId,
               "idShopify": userInformation.idShopify,
               "emailUser": userInformation.email,
               "name": userInformation.name,
               "zipCode": userInformation.zipCode,
               "website": userInformation.website,
               "companyName": userInformation.companyName,
               "phone": userInformation.phone,
               "subscribed": userInformation.subscribed
               ], forKey: "userInformationSession")
       }
    
    func saveExtraInfoUser(userId: String, email: String, idShopify: String) {
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
    
    @IBAction func forgotPassButton(_ sender: UIButton) {
        if emailText.text == "" {
            self.alert(message: "Please fill in with your e-mail in the text field", title: "Missing email")
        } else {
            Auth.auth().sendPasswordReset(withEmail: emailText.text!) { (error) in
                if error == nil {
                    self.alert(message: "Check your email for more details", title: "Reset password")
                } else {
                    if let errCode = AuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                        case .invalidEmail:
                            self.alert(message: "Please fill the information with a valid email", title: "Invalid email")
                        case .emailAlreadyInUse:
                            self.alert(message: "Email is already in use", title: "Email in use")
                        default:
                            self.alert(message: error!.localizedDescription, title: "System error")
                        }
                    }
                }
            }
        }
    }
    
    func alert(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}


//OLD FUNCTIONS
/*
 func savePassword(_ password: String, for account: String) {
 
 let password = password.data(using: String.Encoding.utf8)!
 let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
 kSecAttrAccount as String: account,
 kSecValueData as String: password]
 let status = SecItemAdd(query as CFDictionary, nil)
 
 guard status == errSecSuccess else { return print("save error")}
 }
 
 @IBAction func facebookACtion(_ sender: UIButton) {
 
 let login = SignUpFacebook()
 
 login.facebookLogin(controller: self)
 
 
 if facebookLogin() {
 self.performSegue(withIdentifier: "loginMain", sender: self)
 }
 }

 func facebookLogin() -> Bool {
 let loginManager = FBSDKLoginManager()
 var loggedIn = false
 loginManager.logIn(withReadPermissions: ["public_profile", "user_friends"], from: self) { (result, error) in
 if error != nil {
 print (error)
 loggedIn = false
 return
 }
 
 //            print ("Logged in to Facebook")
 //
 //            print (result?.grantedPermissions)
 //            print (result)
 //            print (result?.token)
 
 
 let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
 //            print (credential.provider)
 //            print (credential)
 //            print (result?.token)
 
 Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in
 if let error = error {
 print (error)
 return
 } else {
 //                    print (user?.user.displayName)
 //                    print (user?.user.email)
 //                    print (user?.user.providerID)
 //                    print (user?.user.providerData)
 
 var displayLabel = "Name: " + String(describing: user?.user.displayName!) + "\n"
 displayLabel += "Email: " + String(describing: user?.user.email!) + "\n"
 displayLabel += "ID Firebase: " + String(describing: user!.user.uid) + "\n"
 displayLabel += "Face token: " + String(describing: FBSDKAccessToken.current().tokenString!)
 print (displayLabel)
 
 loggedIn = true
 }
 })
 }
 return loggedIn
 }
 

 */
