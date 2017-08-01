//
//  DBContreller.swift
//  TestChat
//
//  Created by Vladislav Novoseltsev on 28.07.2017.
//  Copyright © 2017 Vladislav Novoseltsev. All rights reserved.
//

import UIKit
import CoreData

class DBController: NSObject {
    
    
    public static var shared:DBController = DBController()
    
    var arrayChats:[Chats] = []
    var dictMessages:[Int32:[Messages]] = [:]
    let _managedContext:NSManagedObjectContext =  ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!
    
    var timerEmulatorMessages: Timer = Timer()
    
    private override init() {
        super.init()
        
        //Timer For Simulation
        self.timerEmulatorMessages = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
        
    }
    //Function for Simulation
    public func updateCounter() {
        if(getCountChats() > 0) {
            let randChats = Int(arc4random_uniform(UInt32(getCountChats())))
            let randMessages = Int(arc4random_uniform(UInt32(4)))
            var textmessages: String = ""
            switch(randMessages){
            case 0: textmessages = "Что делаешь?"
            break;
            case 1: textmessages = "Как дела?"
            break;
            case 2: textmessages = ")"
            break;
            case 3: textmessages = "(Что делаешь?)"
            break;
            default:
                textmessages = "Привет"
            }
            addMessage(text: textmessages, time: NSDate(), type: 0, id: Int32(randChats))
            
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateTableChats"), object:  nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateTableMessages"), object:  nil)
        }
    }
    
    public func addChats(name:String)->Chats {
        
        
        
        let chat = NSEntityDescription.insertNewObject(forEntityName: "Chats", into: _managedContext) as! Chats
        
        
        chat.name = name
        chat.id = Int32(getIdChat())
        arrayChats.append(chat)
        
        do{
            try _managedContext.save()
            
        } catch {
            
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateTableChats"), object:  nil)
        return chat
    }
    
    public func addMessage(text:String, time:NSDate,type: Int32,id: Int32)->Messages {
        
        
        
        let message = NSEntityDescription.insertNewObject(forEntityName: "Messages", into: _managedContext) as! Messages
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "HH:mm"
        
        message.message = text
        message.time =   dayTimePeriodFormatter.string(for: time)
        message.idChat = Int32(id)
        message.type = Int32(type)
        message.id = Int32(getId())
        dictMessages[id]?.append(message)
        do{
            try _managedContext.save()
        } catch {
            
        }
        return message
    }
    
    public func getCountChats()->Int {
        let standard = UserDefaults.standard
        let id = standard.integer(forKey: "idChat")
        return id
    }
    
    public func getIdChat()->Int {
        let standard = UserDefaults.standard
        let id = standard.integer(forKey: "idChat")
        standard.set(id + 1,forKey: "idChat")
        return id
    }
    
    public func getId()->Int {
        let standard = UserDefaults.standard
        let id = standard.integer(forKey: "id")
        standard.set(id + 1,forKey: "id")
        return id
    }
    
    public func getMessages(id: Int32)->[Messages] {
        
        
        let messagesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Messages")
        messagesFetch.predicate = NSPredicate(format: "idChat == %d", id)
        let sectionSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        let sortDescriptors = [sectionSortDescriptor]
        messagesFetch.sortDescriptors = sortDescriptors
        
        do {
            let fetchedMessages = try _managedContext.fetch(messagesFetch) as! [Messages]
            
            return fetchedMessages
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        
    }
    
    
    
    
    public func getChats()-> [Chats] {
        
        if ( arrayChats.count == 0) {
            let _managedContext:NSManagedObjectContext =  ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext)!
            
            let chatsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Chats")
            let sectionSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
            let sortDescriptors = [sectionSortDescriptor]
            chatsFetch.sortDescriptors = sortDescriptors
            
            
            
            do {
                let fetchedChats = try _managedContext.fetch(chatsFetch) as! [Chats]
                arrayChats = fetchedChats
                return arrayChats
            } catch {
                fatalError("Failed to fetch employees: \(error)")
            }
            
        } else {
            return arrayChats
        }
    }
    
}
