//
//  UserCell.swift
//  CodedLoginPage
//
//  Created by Joe Pino on 3/7/18.
//  Copyright © 2018 Joe Pino. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell{
    
    var message: Messages?{
        didSet{
            
            var ref: DatabaseReference!
            
            ref = Database.database().reference()
            
            let query = ref.child("users").child((message?.toId)!)
            
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let value = snapshot.value as? NSDictionary{
                    
                    let username = value["username"] as? String ?? ""
                    self.textLabel?.text  = username
                    
                    if let letPIUrl = value["profileImageURL"] as? String {
                        
                        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: letPIUrl)
                        
                    }
                }
                
                
            }, withCancel: nil)
            
            
                detailTextLabel?.text = message?.text
            
            timeLabel.text = message?.timestamp?.stringValue
            
//            if let seconds = message?.timestamp?.doubleValue{
//                let timestampDate = Date(timeIntervalSince1970: seconds)
//
//                let formatter = DateFormatter()
//                formatter.timeZone = TimeZone.current
//                formatter.dateFormat = "yyyy-MM-dd HH:mm"
//
//                textLabel?.text = formatter.string(from: timestampDate)
//            }
            
            
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        
    }
    
    let profileImageView: UIImageView  = {
        let imageView  = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        
        
        return imageView
        
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        //label.text = "10:00"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -6).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

