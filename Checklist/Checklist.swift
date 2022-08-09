//
//  Checklist.swift
//  Checklist


import UIKit

class Checklist: NSObject, Codable {
    
    var name = ""
    var items = [ChecklistItem]()
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    // method for checklist item count
    func countUncheckedItems() -> Int {
        return items.reduce(0) {
            cnt , item in cnt + (item.checked ? 0 : 1)
        }
    }

}
