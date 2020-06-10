//
//  FormViewController.swift
//  CDDMAApp
//
//  Created by Waqas Waheed on 6/5/20.
//  Copyright © 2020 Waqas Waheed. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {

    var dataProcessor = DataProcessor()
    var tableView = UITableView()
    var makeValue = ""
    var modelValue = ""
    var yearValue = 0
    var editAtIndex = -1
    var searching = false
    
    @IBOutlet weak var updateBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(makeValue == "" && modelValue == "" && yearValue == 0){
            
        }
        else{
            updateBtn.setTitle("Update", for: .normal)
            makeInput.text = makeValue
            modelInput.text = modelValue
            yearInput.text = String(yearValue)
        }

        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            @unknown default:
                print("nothing")
            }
        }))
        
        alert2.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            @unknown default:
                print("nothing")
            }
        }))
    }
    
    let alert = UIAlertController(title: "Error!", message: "All fields required", preferredStyle: .alert)
   
    let alert2 = UIAlertController(title: "Error!", message: "Model and year must be unique", preferredStyle: .alert)
    
    @IBOutlet weak var makeInput: UITextField!
    
    @IBOutlet weak var modelInput: UITextField!
    
    @IBOutlet weak var yearInput: UITextField!
    
    
    
    @IBAction func cancelBtn(_ sender: Any) {
        resetValues()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateVehicleBtn(_ sender: Any) {
        if(validateFields()){
            if (validateData()){
                let yearValueI = Int(yearInput.text ?? "0000") ?? 0000
                let vehicle = Vehicle(make: makeInput.text ?? "", model: modelInput.text ?? "", year: yearValueI)
                if(editAtIndex == -1){
                    dataProcessor.vehicles.append(vehicle)
                }
                else{
                    dataProcessor.editData(index: editAtIndex, searching: self.searching, vehicle: vehicle)
                }
                dataProcessor.updateDataToFile()
                tableView.reloadData()
                resetValues()
                dismiss(animated: true, completion: nil)
                return
            }
            
            self.present(alert2, animated: true, completion: nil)
            
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func validateFields() -> Bool {
        if(makeInput.text != nil && makeInput.text != ""){
            if(modelInput.text != nil && modelInput.text != ""){
                if(yearInput.text != nil && yearInput.text != ""){
                    return true
                }
            }
        }
        return false
    }
    
    func validateData() -> Bool {
        
        for index in 0...dataProcessor.vehicles.count - 1{
            if(index == self.editAtIndex){
                continue
            }
            
            else if(dataProcessor.vehicles[index].make == makeInput.text ?? ""){
                if(dataProcessor.vehicles[index].model == modelInput.text ?? ""){
                    if(dataProcessor.vehicles[index].year == Int(yearInput.text ?? "0000") ?? 0000){
                        return false
                    }
                }
            }
            
            
        }
        
        return true
    }
    
    func resetValues() {
        self.makeValue = ""
        self.modelValue = ""
        self.yearValue = 0
        self.editAtIndex = -1
        self.searching = false
    }
    
}
