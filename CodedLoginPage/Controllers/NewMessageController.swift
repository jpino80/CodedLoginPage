//
//  NewMessageController.swift
//  CodedLoginPage
//
//  Created by Joe Pino on 2/26/18.
//  Copyright © 2018 Joe Pino. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class NewMessageController: UITableViewController {

    let cellId = "cellId"
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "New Message"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
    
    func fetchUser(){
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        let query = ref.child("users").queryOrdered(byChild: "username")
        
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                if let value = child.value as? NSDictionary{
                    let user = User()
                    let id = child.key
                    let username = value["username"] as? String ?? "name not found"
                    let email = value["email"] as? String ?? "email not found"
                    let profileImageURL = value["profileImageURL"] as? String ?? "https://firebasestorage.googleapis.com/v0/b/coded-login-page.appspot.com/o/profile_images%2FnoPhotoSelected.png?alt=media&token=2d5dd0b9-ce8a-4e9e-9d9a-1981d4b13913"
                    user.username = username
                    user.email = email
                    user.profileImageURL = profileImageURL
                    user.id = id
                    
                    self.users.append(user)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func handleCancel(){
        
        dismiss(animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.username
        cell.detailTextLabel?.text = user.email
        
        
        if let profileImageURL = user.profileImageURL {
            
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageURL)

        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var messageController: MainController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            print("dismiss completed")
            let user = self.users[indexPath.row]
            self.messageController?.showChatControllerForUser(user: user)
        }
    }
    
    
}








