//
//  Users+CoreDataProperties.swift
//  recordAudio
//
//  Created by vlmimac1 on 2022/03/22.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var id: Int16
    @NSManaged public var audioFile: [URL]?
    @NSManaged public var name: String?
    @NSManaged public var tap: Int16
    @NSManaged public var imageData: Data?

}

extension Users : Identifiable {

}
