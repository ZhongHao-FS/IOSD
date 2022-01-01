//
//  DetailViewController.swift
//  ZhongHaoCE05
//
//  Created by Hao Zhong on 7/15/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var congressMember: Congressman!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if congressMember != nil {
            fullNameLabel.text = congressMember.firstName + " " + congressMember.lastName
            navigationItem.title = congressMember.firstName + " " + congressMember.lastName
            titleLabel.text = congressMember.title
            
            if congressMember.party == "R" {
                partyLabel.text = "Republican"
            } else if congressMember.party == "D" {
                partyLabel.text = "Democrat"
            } else {
                partyLabel.text = "Independent"
            }
            
            stateLabel.text = congressMember.state
            
            DispatchQueue.main.async {
                if let picture = self.congressMember.image {
                    self.profileImage.image = picture
                    self.spinner.stopAnimating()
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
