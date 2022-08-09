//
//  ViewController.swift
//  Checklist


import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    
    

    
    var checklist: Checklist!



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.largeTitleDisplayMode = .never
        
        title = checklist.name
    }
    
    
    
    
    
    // Method provide numner of rows present in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    
     // method provide cell to display , Identifier provide the reuse identifier name
    // This method provide new cell or reuse the cell if present
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item = checklist.items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)

        return cell
    }
    
    // Method handles tap on screen
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // get cell for index path and change
        if let cell = tableView.cellForRow(at: indexPath) {
        
            let item = checklist.items[indexPath.row]
            item.checked.toggle()
        configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
            
    }
    // Method delete item if swiped left
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        checklist.items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //Navigation segue
    override func  prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    // Data model: Additem delegate to pass data
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishedAdding item: ChecklistItem) {
        
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishedEditing item: ChecklistItem) {
        if let index = checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
       
    }
    
    
    
    
    
    
    

    
    
    
    
    
    // Logic functions
    
        
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "✔️"
        } else {
            label.text = ""
        }
    }
    
    func configureText(for  cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
//
//    // Save data in plist file method
//    func saveChecklistItems() {
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(checklist.items)
//
//            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
//        } catch {
//            print("error encoding: \(error.localizedDescription)")
//        }
//    }
//
//    // load data from file
//    func  loadChecklistItems() {
//        let path = dataFilePath()
//        if let data = try? Data(contentsOf: path) {
//            let decoder = PropertyListDecoder()
//            do {
//                checklist.items = try decoder.decode([ChecklistItem].self, from: data)
//            } catch {
//                print("errror decodong: \(error.localizedDescription)")
//            }
//        }
//    }
    
    
    
    
    
    
    
    
//    // File path
//    func documentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
//    func dataFilePath() -> URL {
//        return documentsDirectory().appendingPathComponent("Checklists.plist")
//    }
}

