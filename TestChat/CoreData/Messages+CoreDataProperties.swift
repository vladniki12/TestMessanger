//
//  Messages+CoreDataProperties.swift
//  TestChat
//
//  Created by Vladislav Novoseltsev on 01.08.2017.
//  Copyright © 2017 Vladislav Novoseltsev. All rights reserved.
//
//

import Foundation
import CoreData


extension Messages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Messages> {
        return NSFetchRequest<Messages>(entityName: "Messages")
    }

    @NSManaged public var message: String?
    @NSManaged public var time: String?
    @NSManaged public var type: Int32
    @NSManaged public var idChat: Int32
    @NSManaged public var id: Int32

}
