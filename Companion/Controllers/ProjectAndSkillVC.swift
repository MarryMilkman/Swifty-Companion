//
//  ProjectAndSkillVC.swift
//  Companion
//
//  Created by Ivan SELETSKYI on 10/17/18.
//  Copyright © 2018 Ivan SELETSKYI. All rights reserved.
//

import UIKit

class ProjectAndSkillVC: UIViewController {
    
    var projects_users: [projectUser]?
    var skills: [skillStruct]?
    var trueArrProjectUser: [projectUser]?
    var pool: Bool = false
    
    @IBOutlet weak var projectTableView: UITableView!
    
    @IBOutlet weak var skillsTableView: UITableView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        projects_users = getTrueArrPU(projects_users)
    }

}

// MARK: - func for FINISHED arr of project

extension ProjectAndSkillVC {
    func getTrueArrPU(_ defaultArr: [projectUser]?) -> [projectUser]? {
        var retArr: [projectUser]? = []
        var i: Int = 0
        
        while (i < (defaultArr?.count)!) {
            if (defaultArr![i].project.parent_id == nil && defaultArr![i].status == "finished"
                && ((defaultArr![i].project.slug.range(of: "piscine-c-") == nil && !self.pool)
                    || (self.pool && defaultArr![i].project.slug.range(of: "piscine-c-") != nil))) {
                retArr?.append(defaultArr![i])
            }
            i += 1;
        }
        return retArr
    }
}

// MARK: - UITableView: Delegate and DataSource

extension ProjectAndSkillVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == projectTableView {
            return projects_users!.count
        }
        return skills!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == projectTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as? ProjectTableViewCell
            cell?.titleProject.text! = self.projects_users![indexPath.row].project.name
            if let final_mark = self.projects_users![indexPath.row].final_mark {
                cell?.valueLabel.text! = String(final_mark)
                let valid = self.projects_users![indexPath.row].validated
                cell?.valueLabel.textColor = valid != nil && valid! == 1 ? UIColor.green : UIColor.red
            } else {
                cell?.valueLabel.text! = ""
            }
            return cell!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell", for: indexPath) as? SkillsTableViewCell
        cell?.nameSkill.text! = self.skills![indexPath.row].name
        cell?.valueSkill.text! = String(self.skills![indexPath.row].level)
        return cell!
    }
    
}
