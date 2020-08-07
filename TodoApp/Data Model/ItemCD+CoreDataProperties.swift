//
//  ItemCD+CoreDataProperties.swift
//  TodoApp
//
//  Created by Trần Huy on 8/6/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//
//

import Foundation
import CoreData


extension ItemCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemCD> {
        return NSFetchRequest<ItemCD>(entityName: "ItemCD")
    }

    @NSManaged public var title: String?
    @NSManaged public var done: Bool
    @NSManaged public var parentCategory: Category?

}
