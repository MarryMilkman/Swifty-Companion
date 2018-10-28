//
//  ViewController.swift
//  Companion
//
//  Created by Ivan SELETSKYI on 10/16/18.
//  Copyright © 2018 Ivan SELETSKYI. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    
    var isGetTokenWork: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getToken()
    }

    

    @IBOutlet weak var SearchBar: UISearchBar!
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getRequst(nameStr: searchBar.text!)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToUserInfoVC") {
            if let cv = segue.destination as? UserInfoVC {
                cv.data = sender as? dataUser
            }
        }
    }
    
    // pars CRATCH
    
    func cratchPars(_ jsArr: AnyObject, _ dataDecoder: dataUser) -> [projectUser] {
        var arrProj = dataDecoder.projects_users;
        let jsArrProj = jsArr["projects_users"] as? [[String: Any]]
        var i = 0;
        
        while (i < (jsArrProj?.count)!) {
            if let validated: Int? = jsArrProj![i]["validated?"] as? Int? {
                arrProj[i].validated = validated
            }
            i += 1
        }
        return arrProj
    }
    
    // Alert
    
    func doAlert(_ errorMessage: String) {
        let alert = UIAlertController(title: "Sorry, something wrong =(", message: errorMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}

// MARK: - Post Request (get token)

extension ViewController {
    
    func getToken(){
        if self.isGetTokenWork == true {
            return
        }
        self.isGetTokenWork = true
        guard let url = URL(string: "https://api.intra.42.fr/oauth/token") else {
            self.isGetTokenWork = false
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/vnd.api+json", forHTTPHeaderField: "ContentType")
        request.httpBody = "grant_type=client_credentials&client_id=\(MY_AWESOME_UID)&client_secret=\(MY_AWESOME_SECRET)".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                self.isGetTokenWork = false
                print(error!)
                return
            }
            
            if let data = data {
                tokenObj = try! JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            }
            self.isGetTokenWork = false
        }
        task.resume()
    }
}

// MARK: - Get Request

extension ViewController {
    func getRequst(nameStr: String) {
        if (nameStr == "") { return }
        guard let url = URL(string: "https://api.intra.42.fr/v2/users/" + nameStr) else {
            self.doAlert("Error: something wrong with url https://api.intra.42.fr/v2/users/" + nameStr)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + (tokenObj!["access_token"] as! String), forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if (error != nil) {
                DispatchQueue.main.async {
                    self.doAlert("GET request fail")
                    self.getToken()
                }
                print(error!)
                return
            }
            
            if let data = data {
                let jsArr = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject
//                print(jsArr)
                do {
                    var dataArr = try JSONDecoder().decode(dataUser.self, from: data)
                    dataArr.projects_users = self.cratchPars(jsArr!, dataArr)
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "segueToUserInfoVC", sender: dataArr)
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        self.doAlert("404: user not found")
                    }
                    print(error)
                }
            } else {
                print(error ?? "Error data")
            }
        }
        task.resume()
    }
}






















