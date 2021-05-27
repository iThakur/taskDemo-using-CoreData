//
//  CoreDataManager.swift
//  TaskManager
//
//  Created by Niket on 22/05/21.
//

import Foundation
import UIKit
import CoreData

struct CoreDataManager {
    public static var shared = CoreDataManager()
    
    private var container: NSPersistentContainer!
    init() {
        container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    public func retrieveTasks(predicate: NSPredicate?,  completion: @escaping (Result<[Task], Error>) -> Void){
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        request.predicate = predicate
        do {
            let tasks = try container.viewContext.fetch(request)
            completion(.success(tasks))
        } catch {
            completion(.failure(CustomError.CoreDataError))
        }
    }
    
    public func saveContext(completion: @escaping (Result<Void, Error>) -> Void = {_ in }) {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
                completion(.success(Void()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func getContext() -> NSManagedObjectContext {
        return container.viewContext
    }
    
    public func initNewTask() -> Task {
        return Task(context: container.viewContext)
    }
    
    public func deleteTask(task: Task) {
        getContext().delete(task)
        try? getContext().save()
    }
}
