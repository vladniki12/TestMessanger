//
//  Chats+CoreDataProperties.swift
//  
//
//  Created by Vladislav Novoseltsev on 31.07.2017.
//
//

import Foundation
import CoreData


extension Chats {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chats> {
        return NSFetchRequest<Chats>(entityName: "Chats")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int32

}
