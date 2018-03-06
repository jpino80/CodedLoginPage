//
//  ChatLogController.swift
//  CodedLoginPage
//
//  Created by Joe Pino on 3/1/18.
//  Copyright © 2018 Joe Pino. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ChatLogController: UIViewController, UITextFieldDelegate {
    
    var user: User?{
        didSet{
            navigationItem.title = user?.username
        }
    }
    
    lazy var inputTextField: UITextField = {
        let inputTextField = UITextField()
        inputTextField.placeholder = "Enter message..."
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.delegate = self
        
        return inputTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupInputComponents()
        
        
    }

    
    func setupInputComponents(){
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        
        containerView.addSubview(sendButton)
        
        sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        

        containerView.addSubview(inputTextField)
        
        inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: 0).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        inputTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        let separatorLine = UIView()
        separatorLine.backgroundColor = .gray
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(separatorLine)
        
        separatorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorLine.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        
        
    }
    
    @objc func handleSendMessage(){
        let ref = Database.database().reference(fromURL: "https://coded-login-page.firebaseio.com/")
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let timestamp = formatter.string(from: now)
        
        
        
        
        let values = ["text" : inputTextField.text!, "toId": toId, "fromId": fromId, "timestamp": timestamp]
        ref.child("messages").childByAutoId().updateChildValues(values)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSendMessage()
        return true
    }
    
    
}
