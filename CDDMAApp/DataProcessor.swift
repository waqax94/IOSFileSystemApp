//
//  DataProcessor.swift
//  CDDMAApp
//
//  Created by Waqas Waheed on 1/5/20.
//  Copyright © 2020 Waqas Waheed. All rights reserved.
//

import Foundation

public class DataProcessor{
    
    var vehicles = [Vehicle]()
    var filteredVehicles = [Vehicle]()
    
    let fileManager = FileManager.default
    
    var filelocation : URL?
    
    init() {
        load()
    }
    
    func load() {
        
        self.filelocation = getDocumentsDirectory().appendingPathComponent("Data.json")
        
        if(self.fileManager.fileExists(atPath: self.filelocation?.path ?? "")){
            print("FILE AVAILABLE")
            do {
                let data = try Data(contentsOf: self.filelocation ?? getDocumentsDirectory())
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode(VehicleList.self, from: data)
                
                self.vehicles = dataFromJson.Vehicles
            }
            catch {
                print(error)
            }
        }
        else{
            if let filelocation = moveFileToDocuments() {
                do {
                    let data = try Data(contentsOf: filelocation)
                    let jsonDecoder = JSONDecoder()
                    let dataFromJson = try jsonDecoder.decode(VehicleList.self, from: data)
                    
                    self.vehicles = dataFromJson.Vehicles
                }
                catch {
                    print(error)
                }
            }
        }
    }
    
    func moveFileToDocuments() -> URL? {
        
        guard let filepath = Bundle.main.url(forResource: "Data", withExtension: "json") else {return nil}
        
        let documentUrl = getDocumentsDirectory().appendingPathComponent("Data.json")
        
        do {
            try? self.fileManager.removeItem(at: documentUrl)
            try self.fileManager.copyItem(at: filepath, to: documentUrl)
            print("File moved to Document Folder")
        }
        catch{
            print(error)
        }
        self.filelocation = documentUrl
        
        return documentUrl
        
    }
    
    func sortByMake(searching: Bool){
        if(searching){
            self.filteredVehicles = self.filteredVehicles.sorted(by: {$0.make < $1.make})
        }
        else{
            self.vehicles = self.vehicles.sorted(by: {$0.make < $1.make})
        }
    }
    
    func sortByYear(searching: Bool){
        if(searching){
            self.filteredVehicles = self.filteredVehicles.sorted(by: {$0.year < $1.year})
        }
        else{
            self.vehicles = self.vehicles.sorted(by: {$0.year < $1.year})
        }
    }
    
    func filter(searchText: String) {
        self.filteredVehicles = self.vehicles.filter({
            $0.model.prefix(searchText.count) == searchText })
    }
    
    func deleteData(index: Int, searching: Bool) {
        if(searching){
            for i in 0...self.vehicles.count - 1 {
                if(self.filteredVehicles[index].make == self.vehicles[i].make && self.filteredVehicles[index].model == self.vehicles[i].model && self.filteredVehicles[index].year == self.vehicles[i].year){
                    self.vehicles.remove(at: i)
                    self.filteredVehicles.remove(at: index)
                    break
                }
            }
        }
        else{
            self.vehicles.remove(at: index)
        }
        updateDataToFile()
    }
    
    func editData(index: Int, searching: Bool, vehicle: Vehicle) {
        if(searching){
            for i in 0...self.vehicles.count - 1 {
                if(self.filteredVehicles[index].make == self.vehicles[i].make && self.filteredVehicles[index].model == self.vehicles[i].model && self.filteredVehicles[index].year == self.vehicles[i].year){
                    self.vehicles[i] = vehicle
                    break
                }
            }
        }
        else{
            self.vehicles[index] = vehicle
        }
        updateDataToFile()
    }
    
    func updateDataToFile(){
        let vehicleList = VehicleList.init(Vehicles: vehicles)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do{
            let data = try encoder.encode(vehicleList)
            let jsonString = String(bytes: data, encoding: .utf8)
            print(jsonString ?? "NO Value")
            self.stringToFile(jsonString: jsonString ?? "NO Value")
        }
        catch {
            print(error)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func stringToFile(jsonString: String) {
        let url = self.getDocumentsDirectory().appendingPathComponent("Data.json")
        print(url)
        do{
            try jsonString.write(to: url, atomically: true, encoding: .utf8)
        }
        catch{
            print(error)
        }
        
    }
    
}
