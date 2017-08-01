//
//  ChatsTableViewController.swift
//  TestChat
//
//  Created by Vladislav Novoseltsev on 29.07.2017.
//  Copyright © 2017 Vladislav Novoseltsev. All rights reserved.
//

import UIKit

class ChatsTableViewController: UITableViewController,UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var arrayChats:[Chats] = []
    private var dictChat:[Int32:Chats] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        self.updateTable()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTable), name: NSNotification.Name(rawValue: "UpdateTableChats"), object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("asfasfasf)")
        updateTable()
        self.searchBar.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        let chatViewController:SearchViewController = self.storyboard?.instantiateViewController(withIdentifier: "searchviewcontroller") as! SearchViewController
        
        chatViewController.arrayChat = self.arrayChats
        chatViewController.arrayChanged = self.arrayChats
        
        let transition = CATransition()
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(chatViewController, animated: false)
        
        
        return false
    }
    
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    @IBAction func addChat(_ sender: Any) {
        
        let alert = UIAlertController(title: "Добавление", message: "Введите имя чата", preferredStyle: .alert)
        
        
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        
        alert.addAction(UIAlertAction(title: "Отменить", style: .default, handler: { [weak alert] (_) in
            
            
            
        }))
        alert.addAction(UIAlertAction(title: "Добавить", style: .default, handler: { [weak alert] (_) in
            let chatViewController:ViewController = self.storyboard?.instantiateViewController(withIdentifier: "chatviewcontroller") as! ViewController
            let nameChat:String = (alert?.textFields![0].text)!
            
            
            chatViewController.chat = DBController.shared.addChats(name: nameChat)
            
            
            self.updateTable()
            
            self.navigationController?.pushViewController(chatViewController, animated: true)
        }))
        
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayChats.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ChatTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatTableViewCell
        
        
        let chat: Chats = arrayChats[indexPath.row]
        
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
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatViewController:ViewController = self.storyboard?.instantiateViewController(withIdentifier: "chatviewcontroller") as! ViewController
        
        let chat: Chats = arrayChats[indexPath.row]
        
        chatViewController.chat = chat
        self.navigationController?.pushViewController(chatViewController, animated: true)
        
    }
    
    
    func updateTable() {
        DispatchQueue.main.async {
            self.arrayChats = DBController.shared.getChats()
            self.tableView.reloadData()
        }
    }
    
    
}
