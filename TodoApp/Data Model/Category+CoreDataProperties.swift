//
//  Category+CoreDataProperties.swift
//  TodoApp
//
//  Created by Trần Huy on 8/6/20.
//  Copyright © 2020 Trần Huy. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?
    @NSManaged public var itemCDs: NSSet?

}

// MARK: Generated accessors for itemCDs
extension Category {

    @objc(addItemCDsObject:)
    @NSManaged public func addToItemCDs(_ value: ItemCD)

    @objc(removeItemCDsObject:)
    @NSManaged public func removeFromItemCDs(_ value: ItemCD)

    @objc(addItemCDs:)
    @NSManaged public func addToItemCDs(_ values: NSSet)

    @objc(removeItemCDs:)
    @NSManaged public func removeFromItemCDs(_ values: NSSet)

}
