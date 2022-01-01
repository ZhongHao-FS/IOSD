//
//  UserDefaults_EXT.swift
//  ZhongHaoCE08
//
//  Created by Hao Zhong on 7/25/21.
//

import Foundation
import UIKit

extension UserDefaults {
    func set(colorSet: [UIColor], forKey key: String) {
        do {
            for i in 0...2 {
                let binaryData = try NSKeyedArchiver.archivedData(withRootObject: colorSet[i], requiringSecureCoding: false)
                
                self.setValue(binaryData, forKey: key + "\(i)")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func colors(forKey key: String) -> [UIColor]? {
        var colorSet = [UIColor]()
        
        for i in 0...2 {
            if let binaryData = data(forKey: key + "\(i)") {
                
                do {
                    let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: binaryData) ?? UIColor.black
                    
                    colorSet.append(color)
                } catch {
                    print(error.localizedDescription)
                    return nil
                }
            } else {
                return nil
            }
        }
        
        return colorSet
    }
}
