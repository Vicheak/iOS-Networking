//
//  CoreDataManager.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 28/6/24.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private let container = NSPersistentContainer(name: "Notes")
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    private init(){
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Unresolved error : \(error)")
            }
        }
    }
    
    func save() throws {
        do {
            try context.save()
        } catch {
            print(error)
            throw error
        }
    }
    
    func checkForDuplicateName(name: String) throws {
        // fetch existing folders.
        let fetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)

        let existingFolder = try context.fetch(fetchRequest)
        if !existingFolder.isEmpty {
            throw DataError.duplicateName
        }
    }
    
    func deleteAllData(entityName: String) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName) as! NSFetchRequest<any NSFetchRequestResult>
        fetchRequest.includesPropertyValues = false

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
          try context.execute(deleteRequest)
          try context.save()
        } catch {
          print("error : \(error)")
        }
    }
    
}


