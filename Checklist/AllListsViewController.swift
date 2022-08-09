//
//  AllListsViewController.swift
//  Checklist


import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    
    
    // cell identifier
    let cellIdentifier = "ChecklistCell"
    
    var dataModel: DataModel!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
//        // register cell
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "showChecklist", sender: checklist)
        }
        tableView.reloadData()
    }

   

    
    
    
    // Tap methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let tmp = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = tmp
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "(No items)"
        } else {
            cell.detailTextLabel!.text = count == 0 ? "All done" : "\(count) remaining"
        }
        cell.accessoryType = .detailButton
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        
        performSegue(withIdentifier: "showChecklist", sender: checklist)
    }
    
    // remove list
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        
        let checklist  = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        navigationController?.pushViewController(controller, animated: true)
    }

    
    
    
    
    
    
    
    
    // navigation controller delegate method
    // method is called whenever  new view is shown if view is self then userdefault will be -1
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    
    
    
    
    
    
    // prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as? Checklist
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    
    
    
    
    
    //data delegate methods
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishedAdding checklist: Checklist) {
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        dataModel.saveChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishedEditing checklist: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
//     //Save data in plist file method
//        func saveChecklists() {
//            let encoder = PropertyListEncoder()
//            do {
//                let data = try encoder.encode(lists)
//
//                try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
//            } catch {
//                print("error encoding: \(error.localizedDescription)")
//            }
//        }
//
//        // load data from file
//        func  loadChecklists() {
//            let path = dataFilePath()
//            if let data = try? Data(contentsOf: path) {
//                let decoder = PropertyListDecoder()
//                do {
//                    lists = try decoder.decode([Checklist].self, from: data)
//                } catch {
//                    print("errror decodong: \(error.localizedDescription)")
//                }
//            }
//        }
//
//
//
//
//
//
//
//
//        // File path
//        func documentsDirectory() -> URL {
//            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//            return paths[0]
//        }
//        func dataFilePath() -> URL {
//            return documentsDirectory().appendingPathComponent("Checklists.plist")
//        }
//
    
}
