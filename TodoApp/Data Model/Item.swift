//
//  Item.swift
//  TodoApp
//
//  Created by Trần Huy on 8/7/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    @objc dynamic var dateDue: Date?
    @objc dynamic var dateCompleted: Date?

    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        df.timeStyle = .none
        df.dateStyle = .long
        df.doesRelativeDateFormatting = true
        return df
    }()
    
    func detailText(for item: Item) -> String {
        if let completedDate = item.dateCompleted {
        // completed
            return "Completed \(Item.dateFormatter.string(from: completedDate))"
        } else if let due = item.dateDue {
            // not completed, has due date
            
            return "Due \(Item.dateFormatter.string(from: due))"
        } else {
            // not completed, no due date
            return "No due date"
        }
    }
}
