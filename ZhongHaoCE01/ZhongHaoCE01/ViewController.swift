//
//  ViewController.swift
//  ZhongHaoCE01
//
//  Created by Hao Zhong on 6/30/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentAge: UILabel!
    @IBOutlet weak var studentGender: UILabel!
    @IBOutlet weak var sScoresArray: UILabel!
    @IBOutlet weak var sAverageScore: UILabel!
    
    var students = [Student]()
    var studentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Get the path to the .json file
        if let path = Bundle.main.path(forResource: "StudentScores", ofType: ".json") {
            
            // Create url from the path
            let url = URL(fileURLWithPath: path)
            
            do {
                // Create a data object from the url
                let data = try Data.init(contentsOf: url)
                
                // Create a json object and cast it as an any type array
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Any]
                
                // Parse through jsonObj and instantiate student objects
                Parse(jsonObject: jsonObj)
            } catch {
                print(error.localizedDescription)
            }
            
            // Display info for the first student
            Display(index: studentIndex)
        }
    }

    func Parse(jsonObject: [Any]?) {
        // Bind the optional jsonObject to the non-optional json
        if let jsonObj = jsonObject {
            
            // Loop through every first level item in the JSON array
            for item in jsonObj {
                // Optional unwrap all these items, return if any of them cannot be unwrapped
                guard let object = item as? [String: Any],
                      let name = object["name"] as? String,
                      let age = object["age"] as? Int,
                      let male = object["male"] as? Bool,
                      let scores = object["scores"] as? [Int]
                else {return}
                
                // Append each new student to the array
                students.append(Student(name: name, age: age, male: male, scores: scores))
            }
        }
    }
    
    func Display(index: Int) {
        studentName.text = students[index].name
        studentAge.text = "\(students[index].age)"
        
        if students[index].male == true {
            studentGender.text = "Male"
        } else {
            studentGender.text = "Female"
        }
        
        sScoresArray.text = ""
        for score in students[index].scores {
            sScoresArray.text! += "\(score), "
        }
        
        sAverageScore.text = "\(students[index].average)"
    }
    
    @IBAction func Previous(_ sender: UIButton) {
        if studentIndex != 0 {
            studentIndex -= 1
        } else {
            studentIndex = students.count - 1
        }
        
        Display(index: studentIndex)
    }
    
    @IBAction func Next(_ sender: UIButton) {
        if studentIndex != (students.count - 1) {
            studentIndex += 1
        } else {
            studentIndex = 0
        }
        
        Display(index: studentIndex)
    }
}

