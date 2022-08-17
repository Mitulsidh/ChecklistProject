//
//  DataModel.swift
//  Checklist


import Foundation

class DataModel {
    var lists = [Checklist]()
    
    init() {
        loadChecklists()
        registerDefault()
        handleFirstTime()
    }
    
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        return itemID
    }
    
    func handleFirstTime() {
        let userDefault = UserDefaults.standard
        let firstTime = userDefault.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefault.set(false, forKey: "FirstTime")
        }
    }
    
    
    
    //default for userdefault
    func registerDefault() {
        let dictionary = ["ChecklistIndex": -1, "FirsTime": true] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    // get and set userdefault values
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    //Save data in plist file method
       func saveChecklists() {
           let encoder = PropertyListEncoder()
           do {
               let data = try encoder.encode(lists)
   
               try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
           } catch {
               print("error encoding: \(error.localizedDescription)")
           }
       }
   
       // load data from file
       func  loadChecklists() {
           let path = dataFilePath()
           if let data = try? Data(contentsOf: path) {
               let decoder = PropertyListDecoder()
               do {
                   lists = try decoder.decode([Checklist].self, from: data)
                   sortChecklists()
               } catch {
                   print("errror decodong: \(error.localizedDescription)")
               }
           }
       }
       
      func sortChecklists() {
          lists.sort {
              list1, list2 in return list1.name.localizedCompare(list2.name) == .orderedAscending
          }
        
      }
       
       
       
       
       
       
       // File path
       func documentsDirectory() -> URL {
           let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
           return paths[0]
       }
       func dataFilePath() -> URL {
           return documentsDirectory().appendingPathComponent("Checklists.plist")
       }
   
}
