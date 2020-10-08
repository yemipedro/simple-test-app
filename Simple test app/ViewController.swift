//
//  ViewController.swift
//  Simple test app
//
//  Created by Yemi Pedro on 06/10/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var textUserName : UITextField!
    @IBOutlet var textPassword : UITextField!
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraint)
    }
    
    @IBAction func btnLoginClicked(sender: UIButton) {
        activityIndicator.startAnimating()
        let Url = String(format: baseURL + URLS.Login.rawValue)
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary = ["username" : self.textUserName.text!, "password" : self.textPassword.text!]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        let task = URLSession.shared.loginModelTask(with: request) { loginModel, response, error in
            if let loginModel = loginModel {
                if loginModel.sucess {
                    //save token
                    UserDefaults.standard.set(loginModel.token, forKey: "token")
                    UserDefaults.standard.synchronize()
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        sceneDelegate?.gotoDashboard()
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.showErrorAlert(message: loginModel.message ?? "")
                    }
                }
            }
        }
        task.resume()
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

