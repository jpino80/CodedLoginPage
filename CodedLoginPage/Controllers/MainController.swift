//
//  MainController.swift
//  CodedLoginPage
//
//  Created by Joe Pino on 2/21/18.
//  Copyright © 2018 Joe Pino. All rights reserved.
//

import UIKit
import Firebase

class MainController: UITableViewController {

    let cellId = "cellId"
    var messages = [Messages]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "pencil"), style: .plain, target: self, action: #selector(handleNewMessage))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        checkIfUserIsLoggedIn()
        
        observeMessages()
    }
    

    
    func observeMessages(){
        
        let currentUser = Auth.auth().currentUser?.uid
        
        
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            //print(snapshot)
            
            if let value = snapshot.value as? NSDictionary{
                let message = Messages()
                let fromId = value["fromId"] as? String ?? "fromId not found"
                let text = value["text"] as? String ?? "text not found"
                let timestamp = value["timestamp"] as? NSNumber ?? 0
                let toId = value["toId"] as? String ?? "toId not found"
                
                message.fromId = fromId
                message.text = text
                message.timestamp = timestamp
                message.toId = toId
            
                self.messages.append(message)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
    
            }
            
            
            
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let message = messages[indexPath.row]

        cell.message = message
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil{
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else{
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func fetchUserAndSetupNavBarTitle(){
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let value = snapshot.value as? NSDictionary{
                let user = User()
                let username = value["username"] as? String ?? "name not found"
                let email = value["email"] as? String ?? "email not found"
                let profileImageURL = value["profileImageURL"] as? String ?? "https://firebasestorage.googleapis.com/v0/b/coded-login-page.appspot.com/o/profile_images%2FnoPhotoSelected.png?alt=media&token=2d5dd0b9-ce8a-4e9e-9d9a-1981d4b13913"

                user.username = username
                user.email = email
                user.profileImageURL = profileImageURL
                user.id = userID
            
                self.setupNavBarWithUSer(user: user)
            }
            
            //print(snapshot)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func setupNavBarWithUSer(user: User){
        let titleView = UIButton()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        self.navigationItem.titleView = titleView
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(container)
        
        
        let titleImage = UIImageView()
        if let profileTitleImage =  user.profileImageURL {
                titleImage.loadImageUsingCacheWithUrlString(urlString: profileTitleImage)
            }
        titleImage.layer.cornerRadius = 20
        titleImage.layer.masksToBounds = true
        titleImage.contentMode = .scaleToFill
        titleImage.translatesAutoresizingMaskIntoConstraints = false

        
        let titleLabel = UILabel()
        titleLabel.text = user.username
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        container.addSubview(titleImage)
        container.addSubview(titleLabel)
        
        titleImage.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
        titleImage.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 0).isActive = true
        titleImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        titleImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: titleImage.trailingAnchor, constant: 8).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true

        container.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
    }
    
    @objc func showChatControllerForUser(user: User){
        let chatLogController = ChatLogController()
        
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
        
        
        
    }
    
    
    @objc func handleNewMessage(){
        
        let newMessageController = NewMessageController()
        newMessageController.messageController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
        
        
    }
    
    
    @objc func handleLogout(){
        
        do {
            try Auth.auth().signOut()
        } catch let logoutErr {
            print(logoutErr)
        }
        
        
        let loginController = LoginController()
        loginController.mainController = self
        present(loginController, animated: true, completion: nil)
        
    }

  

}
