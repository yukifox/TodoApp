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
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
