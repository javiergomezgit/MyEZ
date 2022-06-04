//
//  ContactViewController.swift
//  MyEZ
//
//  Created by Javier Gomez on 11/15/17.
//  Copyright © 2017 JDev. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet weak var ceoButton: UIButton!
    @IBOutlet weak var cooButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var callUsButton: UIButton!

    @IBAction func goinToFacebook(_ sender: UIButton) {
        socialMediaAction(linkSocialMedia: "https://www.facebook.com/209605312428497", appSocialMedia: "fb://profile/209605312428497")
    }
    
    @IBAction func goinToInstagram(_ sender: UIButton) {
        socialMediaAction(linkSocialMedia: "http://instagram.com/ez_inflatables", appSocialMedia: "instagram://user?username=ez_inflatables")
    }
    
    @IBAction func goinToYoutube(_ sender: UIButton) {
        socialMediaAction(linkSocialMedia: "https://youtube.com/channel/UCYG_F4nyo3UCXv3cO-X6iAw", appSocialMedia: "youtube://www.youtube.com/channel/UCYG_F4nyo3UCXv3cO-X6iAw")
    }
    
    @IBAction func goinToTwitter(_ sender: UIButton) {
        socialMediaAction(linkSocialMedia: "https://twitter.com/ezinflatables", appSocialMedia: "twitter://user?screen_name=ezinflatables")
    }
    
    func socialMediaAction(linkSocialMedia: String, appSocialMedia: String) {
        
        if UIApplication.shared.canOpenURL(URL(string: appSocialMedia)!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: appSocialMedia)!, options: [:])
            } else {
                //Fallback earlier versions
            }
        } else {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: linkSocialMedia)!, options: [:])
            } else {
                //Fallback earlier versions
            }
        }
    }
    
    func sendEmail(email: String){
        if let url = URL(string: "mailto:\(email)?subject=Contact%20from%20the%20App") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                // Fallback on earlier versions
                alert(message: "Please contact us by sending an email to: --> info@ezinflatables.com", title: "Contact Us")
            }
        } else {
            alert(message: "Please contact us by sending an email to: --> info@ezinflatables.com", title: "Contact Us")
        }
    }
    
    @IBAction func callUsAction(_ sender: UIButton) {
        if let url = URL(string: "tel://+18883445867"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func goingToChat(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goingToChat", sender: self)
    }
    

    func facebookAction(){
        if UIApplication.shared.canOpenURL(URL(string: "fb://profile/209605312428497")!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: "fb://profile/209605312428497")!, options: [:])
            } else {
                // Fallback on earlier versions
            }
        } else {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: "https://www.facebook.com/209605312428497")!, options: [:])
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func twitterAction(){
        let twitterURL = NSURL(string: "twitter://user?screen_name=ezinflatables")!
        
        
        if UIApplication.shared.canOpenURL(twitterURL as URL) {
            UIApplication.shared.open(twitterURL as URL, options: [.universalLinksOnly : (Any).self], completionHandler: nil)
        } else {
            UIApplication.shared.open(NSURL(string: "https://twitter.com/ezinflatables")! as URL, options: [.universalLinksOnly : (Any).self], completionHandler: nil)
        }
    }
    
    func instaAction(){
        let instagramAppURL = NSURL (string: "instagram://user?username=ez_inflatables")!
        let instagramWebUrl = NSURL(string: "http://instagram.com/ez_inflatables")!
        
        if UIApplication.shared.canOpenURL(instagramAppURL as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(instagramAppURL as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(instagramAppURL as URL)
            }
        } else {
            //redirect to safari because the user doesn't have Instagram
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(instagramWebUrl as URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(instagramWebUrl as URL)
            }
        }
    }
    
    func youtubeAction() {
        let youtubeId = "www.youtube.com/channel/UCYG_F4nyo3UCXv3cO-X6iAw"
        let url = URL(string:"youtube://\(youtubeId)")!
        
        
        if UIApplication.shared.canOpenURL(URL(string: "youtube://\(youtubeId)")!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        } else {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: "https://youtube.com/channel/UCYG_F4nyo3UCXv3cO-X6iAw")!, options: [:])
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    
    override func viewDidLoad() {
        facebookButton.imageView?.contentMode = .scaleAspectFit
        instagramButton.imageView?.contentMode = .scaleAspectFit
        youtubeButton.imageView?.contentMode = .scaleAspectFit
        twitterButton.imageView?.contentMode = .scaleAspectFit

        
    }
    
    @IBAction func contactCeoButton(_ sender: UIButton) {
        sendEmail(email: "eddie@ezinflatables.com")
    }
    
    @IBAction func contactCooButton(_ sender: UIButton) {
        sendEmail(email: "art@ezinflatables.com")
    }
    
//    @IBAction func contactTechButton(_ sender: UIButton) {
//        presentMenu(titleMenu: "JAVIER - TECH", email: "javier@ezinflatables.com", phone: "8883445867", buttonClicked: techButton)
//    }
//
//    @IBAction func contactPrButton(_ sender: UIButton) {
//        presentMenu(titleMenu: "NICOLE - CIO", email: "nicole@ezinflatables.com", phone: "8883445867", buttonClicked: prButton)
//
//    }
//
//    @IBAction func contactSalesButton(_ sender: UIButton) {
//        presentMenu(titleMenu: "THAMARA - Sales", email: "thamara@ezinflatables.com", phone: "8883445867", buttonClicked: salesButton)
//    }
    
    
  //  let contactCpoController = PopMenuViewController(actions: [PopMenuDefaultAction(title: "Action Title 1", image: UIImage(named: "newbi"), color: .white, didSelect: { action in print("\(String(describing: action.title)) is tapped")}), PopMenuDefaultAction(title: "Action Title 2", image: UIImage(named: "junior"), didSelect: { action in print("tilte 111232333 is tapped")})])

    
//    @objc private func presentMenu(titleMenu: String, email: String, phone: String, buttonClicked: UIButton) {
//
//        let manager = PopMenuManager.default
//
//        let actionTitle = PopMenuDefaultAction(title: titleMenu, color: Color.init(red: 83/255, green: 94/255, blue: 110/255, alpha: 1.0))
//
//        let actionEmail = PopMenuDefaultAction(title: "EMAIL", image: UIImage(named: "emailContact"),  didSelect: { action in
//            self.emailAction(email: email)
//        })
//        actionEmail.imageRenderingMode = .alwaysOriginal
//       // action.iconWidthHeight = 40
//
//        let actionPhone = PopMenuDefaultAction(title: "PHONE", image: UIImage(named: "phoneContact"), didSelect: { action in
//            self.phoneAction(phone: phone)
//        })
//        actionPhone.imageRenderingMode = .alwaysOriginal
//        //  action1.iconWidthHeight = 40
//
//        manager.actions = [actionTitle, actionEmail, actionPhone]
//
//        manager.popMenuAppearance.popMenuBackgroundStyle = .dimmed(color: Color.black, opacity: 0.3)  //.blurred(.extraLight)
//        manager.popMenuAppearance.popMenuColor.actionColor =  PopMenuActionColor.tint(UIColor(red: 6/255, green: 147/255, blue: 178/255, alpha: 1.0))
//        manager.popMenuAppearance.popMenuColor.backgroundColor = .solid(fill: Color.white) //.gradient(fill: .yellow, .purple) // A gradient from yellow to purple
//
//        manager.popMenuAppearance.popMenuFont = UIFont(name: "AvenirNext-DemiBold", size: 14)!
//        //manager.popMenuAppearance.popMenuFont = .systemFont(ofSize: 15, weight: .bold)
//
//        manager.present(sourceView: buttonClicked)
//    }
    
    
    func alert(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
