//
//  ChatViewController.swift
//  FlashChat
//
//  Created by Evgeniy Uskov on 19.12.2020.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    let messagesDB = Database.database().reference().child("Messages")
    var messages : [Message] = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextfield.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)

        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
        retriveMessages()
        
        messageTableView.separatorStyle = .none
    }

    //MARK: - TableView DataSource Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath ) as! CustomMessageCell
        
        cell.messageBody.text = messages[indexPath.row].text
        cell.senderUsername.text  = messages[indexPath.row].user
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email {  // email as! String
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlueColorDark()
        }
        else {
            cell.messageBackground.backgroundColor = UIColor.flatGrayColorDark()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    @objc func tableViewTapped() {
         messageTextfield.endEditing(true)// internally call textFieldDidEndEditing
    }
    
    func configureTableView () {
        messageTableView.estimatedRowHeight = 120
        messageTableView.rowHeight = UITableView.automaticDimension
    }
    
    //MARK:- TextField Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = self.heightConstraint.constant + 50 + 258 // for the iphone x and higher
            self.view.layoutIfNeeded()
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Send & Recieve from Firebase
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        messageTableView.endEditing(true)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messageDictionary = [
            "user": Auth.auth().currentUser?.email,
            "text": messageTextfield.text!
        ]
        messagesDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            if(error != nil) {
                print(error!)
            } else {
                print("Saving successfully")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
        }
        
    }
    
    func retriveMessages() {
        messagesDB.observe(.childAdded) { (snapshot) in
            let value = snapshot.value as! Dictionary<String, Any?>
            let message = Message(text: value["text"] as! String,
                                  user: value["user"] as! String)
            print("message retreived : \(message.user) - \(message.text)")
            self.messages.append(message)
            
            self.configureTableView()
            self.messageTableView.reloadData()
        }
    }
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        do {
            try   Auth.auth().signOut()
             navigationController?.popToRootViewController(animated: true)
        }
        catch{
            print("error while sign out")
        }
    }
}
