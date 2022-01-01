//
//  ViewController.swift
//  ZhongHaoCE02
//
//  Created by Hao Zhong on 7/3/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var employee_Name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var mac_Address: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var skillList: UILabel!
    @IBOutlet weak var employerList: UILabel!
    @IBOutlet weak var totalEmployers: UILabel!
    @IBOutlet weak var numSkills: UILabel!
    
    var employees = [Employee]()
    var employeeIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Get the path to the .json file
        if let path = Bundle.main.path(forResource: "EmployeeData", ofType: ".json") {
            
            // Create url from the path
            let url = URL(fileURLWithPath: path)
            
            do {
                // Create a data object from the url
                let data = try Data.init(contentsOf: url)
                
                // Create a json object and cast it as an any type array
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Any]
                
                // Parse through jsonObj and instantiate employee objects
                Parse(jsonObject: jsonObj)
            } catch {
                print(error.localizedDescription)
            }
            
            // Display info for the first employee
            Display(index: employeeIndex)
        }
    }

    func Parse(jsonObject: [Any]?) {
        // Bind the optional jsonObject to the non-optional json
        guard let jsonObj = jsonObject
        else {
            print("Parse failed to unwrap the optional")
            return
        }
        
        // Loop through every first level item in the JSON array
        for primaryItem in jsonObj {
            // Optional unwrap all these items, return if any of them cannot be unwrapped
            guard let object = primaryItem as? [String: Any],
                  let eeName = object["employeename"] as? String,
                  let userName = object["username"] as? String,
                  let mAddress = object["macaddress"] as? String,
                  let cTitle = object["current_title"] as? String,
                  // The second level items are mapped into a dictionary (pEmployers) just like the first level ones
                  let pEmployers = object["past_employers"] as? [[String: Any]]
            else {continue}
            
            var companies = [Employer]()
            // Loop through every second level item in pEmployers
            for secondaryItem in pEmployers {
                guard let company = secondaryItem["company"] as? String
                else {continue}
                
                if let responsibilities = secondaryItem["responsibilities"] as? [String] {
                    companies.append(Employer(name: company, responsibilityArray: responsibilities))
                } else {
                    companies.append(Employer(name: company))
                }
                
            }
            
            // Append each new employee to the employees array
            if let skills = object["skills"] as? [String] {
                employees.append(Employee(eName: eeName, uName: userName, address: mAddress, title: cTitle, skillSet: skills, employers: companies))
            } else {
                employees.append(Employee(eName: eeName, uName: userName, address: mAddress, title: cTitle, skillSet: [String](), employers: companies))
            }
            
        }
    }
    
    func Display(index: Int) {
        employee_Name.text = employees[index].employeeName
        username.text = employees[index].userName
        mac_Address.text = employees[index].macAddress
        jobTitle.text = employees[index].currentTitle
        
        skillList.text = "There is no skill listed"
        var skillLabel = ""
        for skill in employees[index].skills {
            skillLabel += "\(skill), "
        }
        if skillLabel != "" {
            skillList.text = skillLabel
        }
        
        employerList.text = "Have not worked at other companies"
        var employerLabel = ""
        var companyIndex = 0
        for company in employees[index].pastEmployers {
            companyIndex += 1
            employerLabel += "\(companyIndex). \(company.company)\n Responsibilities(\(company.resTotal)): "
            for task in company.responsibilities {
                employerLabel += "\(task), "
            }
            employerLabel += "\n"
        }
        if employerLabel != "" {
            employerList.text = employerLabel
        }
        
        totalEmployers.text = "\(employees[index].pastNumEmployers)"
        numSkills.text = "\(employees[index].totalSkills)"
    }
    
    @IBAction func Previous(_ sender: UIButton) {
        if employeeIndex != 0 {
            employeeIndex -= 1
        } else {
            employeeIndex = employees.count - 1
        }
        
        Display(index: employeeIndex)
    }
    
    @IBAction func Next(_ sender: UIButton) {
        if employeeIndex != (employees.count - 1) {
            employeeIndex += 1
        } else {
            employeeIndex = 0
        }
        
        Display(index: employeeIndex)
    }
}

