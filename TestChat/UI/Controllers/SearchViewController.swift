//
//  SearchViewController.swift
//  TestChat
//
//  Created by Vladislav Novoseltsev on 31.07.2017.
//  Copyright © 2017 Vladislav Novoseltsev. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var arrayChat: [Chats] = []
    var arrayChanged: [Chats] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Поиск"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayChanged.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ChatTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatTableViewCell
        
        let chat: Chats = arrayChanged[indexPath.row]
        
        cell.nameChatLabel.text = chat.name
        
        
        
        
        DispatchQueue.main.async {
            var messages:[Messages] = DBController.shared.getMessages(id: chat.id)
            if( messages != nil &&
                !messages.isEmpty) {
                
                let mes:Messages = messages[messages.count - 1]
                cell.lastMessageLabel.text = mes.message
                cell.lastMessageTimeLabel.text = mes.time
                
            } else {
                cell.lastMessageTimeLabel.text = ""
                cell.lastMessageLabel.text = ""
            }
            
        }
        
        return cell
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        arrayChanged.removeAll()
        if(searchText.isEmpty) {
            arrayChanged = arrayChat
        }
        for chat in arrayChat {
        if let range = chat.name?.lowercased().range(of: searchText.lowercased())  {
            let startPos = chat.name?.characters.distance(from: (chat.name?.characters.startIndex)!, to: range.lowerBound)
            if(startPos == 0) {
                arrayChanged.append(chat)
            }
        }
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatViewController:ViewController = self.storyboard?.instantiateViewController(withIdentifier: "chatviewcontroller") as! ViewController
        
        let chat: Chats = arrayChanged[indexPath.row]
        
        chatViewController.chat = chat
        self.navigationController?.pushViewController(chatViewController, animated: true)
        
        self.view.endEditing(true)
    }

    

}
