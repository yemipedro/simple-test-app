//
//  DashBoardVC.swift
//  Simple test app
//
//  Created by Yemi Pedro  on 07/10/20.
//

import UIKit

class DashBoardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashboardData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DashboardDetailsVC") as! DashboardDetailsVC
        vc.dashboardData = [dashboardData[indexPath.row]]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = dashboardData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = obj.userName
        return cell
    }
    
    
    @IBOutlet weak var tblView : UITableView!
    
    var dashboardData = [Profile]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraint)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
        let Url = String(format: baseURL + URLS.GetData.rawValue)
        guard let serviceUrl = URL(string: Url) else { return }
        
        var request = URLRequest(url: serviceUrl)
       // request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue((UserDefaults.standard.value(forKey: "token") as! String), forHTTPHeaderField: "token")
        print((UserDefaults.standard.value(forKey: "token") as! String))

        let task = URLSession.shared.userModelTask(with: request) { userModel, response, error in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            if let userModel = userModel {
                if let _ = userModel.sucess {
                    if !(userModel.sucess!) {
                        UserDefaults.standard.setValue(nil, forKey: "token")
                        DispatchQueue.main.async {
                         sceneDelegate?.gotoLogin()
                        }
                        return
                    }
                }
                else {
                    UserDefaults.standard.setValue(nil, forKey: "token")
                    DispatchQueue.main.async {
                     sceneDelegate?.gotoLogin()
                    }
                    return
                }
                self.dashboardData = (userModel.test?.data.profile)!
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
        task.resume()
    }
    
    @IBAction func logout() {
        UserDefaults.standard.setValue(nil, forKey: "token")
        DispatchQueue.main.async {
         sceneDelegate?.gotoLogin()
        }
    }
}
