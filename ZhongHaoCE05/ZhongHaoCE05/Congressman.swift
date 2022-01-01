//
//  Congressman.swift
//  ZhongHaoCE05
//
//  Created by Hao Zhong on 7/14/21.
//

import Foundation
import UIKit

enum ParsingError: Error {
    case MemberParsing
    case Generic
}

class Congressman {
    // Stored Properties
    let firstName: String
    let lastName: String
    let party: String
    let title: String
    let state: String
    let id: String
    
    // Computed Properties
    var lastCommaFirstName: String {
        get {
            return "\(self.lastName), \(self.firstName)"
        }
    }
    
    var image: UIImage! {
        get {
            if let url = URL(string: "https://theunitedstates.io/images/congress/225x275/\(self.id).jpg") {
                do {
                    let imageData = try Data.init(contentsOf: url)
                    return UIImage(data: imageData)
                } catch {
                    if self.party == "R" {
                        return UIImage(named: "clipart-elephant-republican-3")
                    } else if self.party == "D" {
                        return UIImage(named: "2000px-DemocraticLogo.svg_")
                    }
                }
            }
            
            return nil
        }
    }
    
    // Initializer
    init(jsonAPIData congressMember: [String: Any]) throws {
        // Parse member info from the API response
        guard let first = congressMember["first_name"] as? String,
              let last = congressMember["last_name"] as? String,
              let party = congressMember["party"] as? String,
              let position = congressMember["title"] as? String,
              let st = congressMember["state"] as? String,
              let iD = congressMember["id"] as? String
              else {
            // Throw custom error if parsing fails. This way we can add additional actions where we call the initializer and catch the error.
            throw ParsingError.MemberParsing
        }
        
        self.firstName = first
        self.lastName = last
        self.party = party
        self.title = position
        self.state = st
        self.id = iD
    }
}
