//
//  DashboardDetailsVC.swift
//  Simple test app
//
//  Created by Yemi Pedro on 07/10/20.
//

import UIKit

class DashboardDetailsVC: UIViewController {

    
    var dashboardData = [Profile]()
    
    @IBOutlet weak var name : UILabel!
    
    @IBOutlet weak var gender : UILabel!
    @IBOutlet weak var dob : UILabel!
    @IBOutlet weak var aboutUser : UILabel!
    
    @IBOutlet weak var jobTitle : UILabel!
    @IBOutlet weak var company : UILabel!
    @IBOutlet weak var age : UILabel!
    
    @IBOutlet weak var distance : UILabel!
    @IBOutlet weak var religian : UILabel!
    @IBOutlet weak var hobbies : UILabel!
    
    @IBOutlet weak var displayPic : UIImageView!
    
    @IBOutlet weak var personality : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.name.text = "name: \(dashboardData.first?.userName ?? "")"
        self.gender.text = "gender: \(dashboardData.first?.gender.rawValue ?? "")"
        self.aboutUser.text = "about: \(dashboardData.first?.aboutUser ?? "")"
        self.jobTitle.text = "jobTitle: \(dashboardData.first?.jobTitle ?? "")"
        self.dob.text = "Dob: \(dashboardData.first?.dob ?? "")"
        
        self.company.text = "Company: \(dashboardData.first?.company ?? "")"
        self.age.text = "Age: \(String(dashboardData.first?.age ?? 0))"
        self.distance.text = "Distance:  \(String(dashboardData.first?.distance ?? 0))"
        self.religian.text = "religian: \(dashboardData.first?.religionName.rawValue ?? "")"
        self.hobbies.text = "Hobbies: \(dashboardData.first?.hobbies.map({$0.hobbieName}).joined(separator: ",") ?? "")"
        self.personality.text = "Personalit: \(dashboardData.first?.personality.map({$0.personalityName}).joined(separator: ",") ?? "")"
        
        downloadImage(from: URL(string: dashboardData.first?.displayPic ?? "")!)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                self?.displayPic.image = UIImage(data: data)
            }
        }
    }
}
