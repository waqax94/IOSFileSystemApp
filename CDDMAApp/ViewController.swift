//
//  ViewController.swift
//  CDDMAApp
//
//  Created by Waqas Waheed on 1/5/20.
//  Copyright © 2020 Waqas Waheed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var dataProcessor = DataProcessor()
    
    var makeValue = ""
    var modelValue = ""
    var yearValue = 0
    var editAtIndex = -1
    var searching = false
    
    
    
    
    @IBAction func sortList(_ sender: Any) {
        let index = segmentControl.selectedSegmentIndex
        switch index {
        case 0:
            dataProcessor.sortByMake(searching: self.searching)
            self.tableView.reloadData()
            break
        case 1:
            dataProcessor.sortByYear(searching: self.searching)
            self.tableView.reloadData()
            break
        default:
            break
        }
    }
    
    @IBAction func openFormBtn(_ sender: Any) {
        performSegue(withIdentifier: "AddVehicle", sender: self)
        resetValues()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        dataProcessor.updateDataToFile()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newVC = segue.destination as! FormViewController
        newVC.dataProcessor = self.dataProcessor
        newVC.tableView = self.tableView
        newVC.editAtIndex = self.editAtIndex
        newVC.makeValue = self.makeValue
        newVC.modelValue = self.modelValue
        newVC.yearValue = self.yearValue
        newVC.searching = self.searching
    }
    
    func resetValues() {
        self.makeValue = ""
        self.modelValue = ""
        self.yearValue = 0
        self.editAtIndex = -1
        self.searching = false
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return dataProcessor.filteredVehicles.count
        }
        else{
            return dataProcessor.vehicles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newVehicleData = dataProcessor.vehicles[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "VehicleData") as! DataCell
        
        if searching {
            cell.setDataCell(vehicle: dataProcessor.filteredVehicles[indexPath.row])
        }
        else{
            cell.setDataCell(vehicle: newVehicleData)
        }
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editButton = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexpath) in
            self.editAtIndex = indexPath.row
            self.makeValue = self.dataProcessor.vehicles[indexPath.row].make
            self.modelValue = self.dataProcessor.vehicles[indexPath.row].model
            self.yearValue = self.dataProcessor.vehicles[indexPath.row].year
            self.performSegue(withIdentifier: "AddVehicle", sender: self)
            self.resetValues()
        }
        editButton.backgroundColor = UIColor.black
        let deleteButton = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexpath) in
            self.dataProcessor.deleteData(index: indexPath.row,searching: self.searching)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
        return [deleteButton,editButton]
    }
}
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText == ""){
            searching = false
        }
        else{
            dataProcessor.filter(searchText: searchText)
            searching = true
        }
        self.tableView.reloadData()
    }
}
