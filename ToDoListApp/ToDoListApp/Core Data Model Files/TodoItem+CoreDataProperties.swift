//
//  TodoItem+CoreDataProperties.swift
//  ToDoListApp
//
//  Created by Elton Baidoo on 2/25/25.
//
//

import Foundation
import CoreData


extension TodoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItem> {
        return NSFetchRequest<TodoItem>(entityName: "TodoItem")
    }

    @NSManaged public var title: String?
    @NSManaged public var isCompleted: Bool

}

extension TodoItem : Identifiable {

}
