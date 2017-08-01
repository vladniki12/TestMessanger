//
//  ViewController.swift
//  TestChat
//
//  Created by Vladislav Novoseltsev on 28.07.2017.
//  Copyright © 2017 Vladislav Novoseltsev. All rights reserved.
//

import UIKit

 class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate {
    
    var nameChat:String = ""
    var chat: Chats? = nil
    var messages: [Messages] = []
    var mainHeight:Float = 0.0
    
    @IBOutlet weak var editTextMessage: UITextField!
    
    @IBAction func csendMessage(_ sender: Any) {
        let message:String = editTextMessage.text!
        messages.append(DBController.shared.addMessage(text: message, time: NSDate() as NSDate, type: (Int32)(1), id: (chat?.id)!))
        editTextMessage.text = ""
        tableView.reloadData()
        updateTableScroll()
        
    }
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTableMessages), name: NSNotification.Name(rawValue: "UpdateTableMessages"), object: nil)
        
        mainHeight = Float(self.view.frame.size.height);
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(recognizer:)))
        tap.delegate = self
        tableView.addGestureRecognizer(tap)
        self.view.layoutIfNeeded()
        tableView.separatorColor = UIColor.clear
        
        self.title = chat?.name
        
        DispatchQueue.main.async {
            self.messages = DBController.shared.getMessages(id: (self.chat?.id)!)
            self.tableView.reloadData()
            self.updateTableScroll()
        }
        
        NotificationCenter.default.addObserver(forName:Notification.Name.UIKeyboardWillHide,
                                               object:nil, queue:nil,
                                               using:HideKeyBoard(notification:))
        NotificationCenter.default.addObserver(forName:Notification.Name.UIKeyboardWillShow,
                                               object:nil, queue:nil,
                                               using:ShowKeyBoard(notification:))
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    public func HideKeyBoard(notification: Notification) {
        var userInfo = notification.userInfo as! [String: Any]
        
        let sec: Double = (userInfo["UIKeyboardAnimationDurationUserInfoKey"] as? Double)!
        
        var  _:CGRect = (userInfo["UIKeyboardFrameBeginUserInfoKey"] as? CGRect)!
        
        
        UIView.animate(withDuration: sec, delay: 0.0, options: UIViewAnimationOptions(rawValue: 0), animations: {
            self.view.frame = CGRect(x: 0,y: 0,width:  Int(self.view.frame.size.width), height: Int(self.mainHeight));
            self.view.layoutIfNeeded()
            self.updateTableScroll()
        }, completion: nil)
    }
    
    public func ShowKeyBoard(notification: Notification) {
        var userInfo = notification.userInfo as! [String: Any]
        
        let sec: Double = (userInfo["UIKeyboardAnimationDurationUserInfoKey"] as? Double)!
        
        let  kbSize:CGRect = (userInfo["UIKeyboardFrameBeginUserInfoKey"] as? CGRect)!
        
        
        UIView.animate(withDuration: sec, delay: 0.0, options: UIViewAnimationOptions(rawValue: 0), animations: {
            self.view.frame = CGRect(x: 0,y: 0,width:  self.view.frame.size.width, height: self.view.frame.size.height - kbSize.size.height);
            self.view.layoutIfNeeded()
            self.updateTableScroll()
        }, completion: nil)
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MessageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageTableViewCell
        let mes:Messages = messages[indexPath.row]
        
        cell.nameUserLabel.text = chat?.name
        cell.setType(type: Int(mes.type))
        cell.messageLabel.text = mes.message
        cell.timeMessageLabel.text = mes.time?.description
        
        
        // Configure the cell...
        
        return cell
    }
    
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        
       self.view.endEditing(true)
    }
    
    
    func updateTableScroll() {
        DispatchQueue.main.async {
            var indexPath:NSIndexPath
            if((self.tableView.numberOfRows(inSection: self.tableView.numberOfSections-1)-1) < 0){
                return ;
            } else {
                indexPath = NSIndexPath(row: self.tableView.numberOfRows(inSection: self.tableView.numberOfSections-1)-1, section: self.tableView.numberOfSections-1)
            }
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.bottom, animated: true)
        }
        
    }
    
    
    func updateTableMessages() {
        DispatchQueue.main.async {
            self.messages = DBController.shared.getMessages(id: (self.chat?.id)!)
            self.tableView.reloadData()
            self.updateTableScroll()
        }
    }
}

