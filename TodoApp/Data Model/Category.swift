//
//  Category.swift
//  TodoApp
//
//  Created by Trần Huy on 8/7/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
    
}
