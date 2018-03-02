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
                    let username = value["username"] as? String ?? "name not found"
                    let email = value["email"] as? String ?? "email not found"
                    let profileImageURL = value["profileImageURL"] as? String ?? "https://firebasestorage.googleapis.com/v0/b/coded-login-page.appspot.com/o/profile_images%2FnoPhotoSelected.png?alt=media&token=2d5dd0b9-ce8a-4e9e-9d9a-1981d4b13913"
                    user.username = username
                    user.email = email
                    user.profileImageURL = profileImageURL
                    
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
//            let url = URL(string: profileImageURL)
//            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//                
//                if error != nil{
//                    print(error)
//                    return
//                }
//                DispatchQueue.main.async {
//                    //cell.imageView?.image = UIImage(data: data!)
//                    cell.profileImageView.image = UIImage(data: data!)
//                    
//                }
//            }).resume()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
}

class UserCell: UITableViewCell{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)

    }
    
    let profileImageView: UIImageView  = {
        let imageView  = UIImageView()
        imageView.image = #imageLiteral(resourceName: "noPhotoSelected")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        

       return imageView
        
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}







