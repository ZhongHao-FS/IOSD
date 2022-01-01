//
//  ThemeViewController.swift
//  ZhongHaoCE08
//
//  Created by Hao Zhong on 7/24/21.
//

import UIKit

class ThemeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Use the prototype cell#3
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_ID_3", for: indexPath)
        
        // Configure cell
        cell.textLabel?.text = pickerData[0]
        cell.textLabel?.textColor = storedColor[0]
        cell.detailTextLabel?.text = pickerData[1]
        cell.detailTextLabel?.textColor = storedColor[1]
        
        // Return configured cell
        return cell
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if row == 2 {
            return NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.backgroundColor: storedColor[row]])
        } else {
            return NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.foregroundColor: storedColor[row]])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        colorToSliders(color: storedColor[row])
    }
    
    // PickerView
    @IBOutlet weak var picker: UIPickerView!
    
    // TableView
    @IBOutlet weak var sampleTable: UITableView!
    
    // Label Outlets
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    
    // Slider Outlets
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    // Button Reference
    @IBOutlet weak var resetRefer: UIBarButtonItem!
    
    let pickerData = ["Title", "Author", "View"]
    var storedColor = [UIColor.black, UIColor.black, UIColor.systemBackground]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let savedTheme = UserDefaults.standard.colors(forKey: "themeColorSet") {
            storedColor = savedTheme
            picker.reloadAllComponents()
            sampleTable.reloadData()
            sampleTable.backgroundColor = storedColor[2]
            colorToSliders(color: storedColor[0])
        } else {
            resetColorBtn(resetRefer)
        }
        
    }
    
    func colorToSliders(color: UIColor) {
        var fRed: CGFloat = 0
        var fGreen: CGFloat = 0
        var fBlue: CGFloat = 0
        var fAlpha: CGFloat = 1
        color.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha)
        
        redSlider.setValue(Float(fRed), animated: true)
        redLabel.text = redSlider.value.description
        
        greenSlider.setValue(Float(fGreen), animated: true)
        greenLabel.text = greenSlider.value.description
        
        blueSlider.setValue(Float(fBlue), animated: true)
        blueLabel.text = blueSlider.value.description
    }
    
    @IBAction func saveColorBtn(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(colorSet: storedColor, forKey: "themeColorSet")
        
        performSegue(withIdentifier: "Save_Theme", sender: sender)
    }
    
    @IBAction func resetColorBtn(_ sender: UIBarButtonItem) {
        picker.selectRow(0, inComponent: 0, animated: true)
        storedColor = [UIColor.black, UIColor.black, UIColor.systemBackground]
        picker.reloadAllComponents()
        
        sampleTable.reloadData()
        sampleTable.backgroundColor = storedColor[2]
        
        redLabel.text = "0.0"
        greenLabel.text = "0.0"
        blueLabel.text = "0.0"
        
        redSlider.setValue(0, animated: true)
        greenSlider.setValue(0, animated: true)
        blueSlider.setValue(0, animated: true)
    }
    
    @IBAction func sliderDidChange(_ sender: UISlider) {
        switch sender.tag {
        case 0:
            redLabel.text = sender.value.description
            
        case 1:
            greenLabel.text = sender.value.description
            
        case 2:
            blueLabel.text = sender.value.description
            
        default:
            print("This should never happen!")
        }
        
        storedColor[picker.selectedRow(inComponent: 0)] = UIColor(displayP3Red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1)
        picker.reloadComponent(0)
        
        sampleTable.reloadData()
        sampleTable.backgroundColor = storedColor[2]
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
