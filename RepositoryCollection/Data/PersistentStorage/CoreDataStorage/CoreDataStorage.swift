//
//  CoreDataStorage.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 23/11/2023.
//

import Foundation
import CoreData

class CoreDataStorageStack {
    
    static var manager = CoreDataStorageStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "RepositoryCollectionStorage")
        
        persistentContainer.loadPersistentStores { _, error in
            guard let error else {
                debugPrint("\(self) ---> success")
                return
            }
            debugPrint("\(self) ---> error: \(error)")
        }
        
        return persistentContainer
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                debugPrint("\(#function) ---> error: \(error)")
            }
        }
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}
