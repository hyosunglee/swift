//
//  CoreDataManager.swift
//  SlideMenuControllerSwift
//
//  Created by vlmimac1 on 2021/11/16.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared: CoreDataManager = CoreDataManager()
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName: String = "Users"
    
    func getUsers(ascending: Bool = false) -> [Users] {
        var models: [Users] = [Users]()
        
        if let context = context {
            let idSort: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: ascending)
            let fetchRequest: NSFetchRequest<NSManagedObject>
                = NSFetchRequest<NSManagedObject>(entityName: modelName)
            fetchRequest.sortDescriptors = [idSort]
            
            do {
                if let fetchResult: [Users] = try context.fetch(fetchRequest) as? [Users] {
                    models = fetchResult
                }
            } catch let error as NSError {
                print("Could not fetch🥺: \(error), \(error.userInfo)")
            }
        }
        return models
    }
    
    func saveUser(id: Int16, tap: Int16,
                  name: String, audioFile : [URL]?, imageData: Data,
                  onSuccess: @escaping ((Bool) -> Void)) {
        if let context = context,
            let entity: NSEntityDescription
            = NSEntityDescription.entity(forEntityName: modelName, in: context) {
            
            if let user: Users = NSManagedObject(entity: entity, insertInto: context) as? Users {
                user.id = id
                user.tap = tap
                user.name = name
                user.audioFile = audioFile
                user.imageData = imageData 
                
                contextSave { success in
                    onSuccess(success)
                }
            }
        }
    }
    
    func deleteUser(id: Int16, onSuccess: @escaping ((Bool) -> Void)) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredRequest(id: id)
        
        do {
            if let results: [Users] = try context?.fetch(fetchRequest) as? [Users] {
                if results.count != 0 {
                    context?.delete(results[0])
                }
            }
        } catch let error as NSError {
            print("Could not fatch🥺: \(error), \(error.userInfo)")
            onSuccess(false)
        }
        
        contextSave { success in
            onSuccess(success)
        }
    }
}

extension CoreDataManager {
    fileprivate func filteredRequest(id: Int16) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
            = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
        return fetchRequest
    }
    
    fileprivate func contextSave(onSuccess: ((Bool) -> Void)) {
        do {
            try context?.save()
            onSuccess(true)
        } catch let error as NSError {
            print("Could not save🥶: \(error), \(error.userInfo)")
            onSuccess(false)
        }
    }
}
