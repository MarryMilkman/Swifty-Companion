//
//  UserInfoVC.swift
//  Companion
//
//  Created by Ivan SELETSKYI on 10/17/18.
//  Copyright © 2018 Ivan SELETSKYI. All rights reserved.
//

import UIKit

class UserInfoVC: UIViewController {



    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneLebel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var labelCourse: UILabel!
    
    @IBOutlet weak var switchPool: UISwitch!
    
    var data: dataUser?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if (data?.cursus_users.count != 2) {
            switchPool.isHidden = true
        } else {
            switchPool.isHidden = false
        }
        reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToProjectAndScillVC") {
            let pool = switchPool.isOn == true ? 1 : 0
            let index = data?.cursus_users.count == 2 ? pool : 0
            
            let vc = segue.destination as? ProjectAndSkillVC
            vc?.skills = data?.cursus_users[index].skills
            vc?.projects_users = data?.projects_users
            vc?.pool = pool == 0 && data?.cursus_users.count == 2 ? false : true
        }
    }

    @IBAction func switchPoolChange(_ sender: Any) {
        reloadData()
    }
    
    func reloadData() {
        let pool = switchPool.isOn == true ? 1 : 0
        let courseIndex = data?.cursus_users.count == 2 ? pool : 0
        
        self.get_image((data?.image_url)!, userImage)
        labelCourse.text = "course: " + (data?.cursus_users[courseIndex].cursus.name)!
        loginLabel.text = "login: " + (data?.login)!
        fullNameLabel.text = data?.displayname
        phoneLebel.text = data?.phone == "" ? "no phone" : data?.phone
        locationLabel.text = data?.location == nil ? "Unavailable" : data?.location
        emailLabel.text = data?.email
        levelLabel.text = "level: " + String(describing: (data?.cursus_users[courseIndex].level)!)
    }
    
    func get_image(_ url_str: String, _ imageView: UIImageView){
        let url: URL = URL(string: url_str)!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            DispatchQueue.main.async(execute: {
                if (data != nil){
                    let image = UIImage(data: data!)
                    if (image != nil){
                        imageView.image = image
                    }
                }
            })
        })
        task.resume()
    }

}
