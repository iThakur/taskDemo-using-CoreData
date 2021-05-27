//
//  Task+CoreDataProperties.swift
//  TaskManager
//
//  Created by Niket on 22/05/21.
//
//

import Foundation
import CoreData


extension Task: TaskCellViewModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var comment: String?
    @NSManaged public var date: Date?
    @NSManaged public var taskStatus: String?
    @NSManaged public var title: String?

}

extension Task : Identifiable {

}
