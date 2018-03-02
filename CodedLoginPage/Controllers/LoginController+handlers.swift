//
//  LoginController+handlers.swift
//  CodedLoginPage
//
//  Created by Joe Pino on 2/26/18.
//  Copyright © 2018 Joe Pino. All rights reserved.
//

import UIKit
import Firebase

extension LoginController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @objc func handleRegister(){
        
        guard let email = registerEmailField.text, let password = registerPasswordField.text, let name = registerUsernameField.text
            else {
                print("Form Error")
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil{
                print(error!)
                return
            }
            
            guard let uid = user?.uid else {  return  }
            
            //store image to db
            let imageFileName = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageFileName).jpg")
            
            
            if let profileImage = self.logoImage.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.2){
//            if let uploadData = UIImagePNGRepresentation(self.logoImage.image!){
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    let profileImageURL = metadata?.downloadURL()?.absoluteString
                    
                    let values = ["username": name, "email": email, "profileImageURL": profileImageURL]
                    
                    self.registerUserIntoDbWithUID(uid: uid, values: values as [String : AnyObject])
                })
            }
        })
    }
    
    private func registerUserIntoDbWithUID(uid: String, values: [String: AnyObject]){
        //add new user to app
        let ref = Database.database().reference(fromURL: "https://coded-login-page.firebaseio.com/")
        let userRef = ref.child("users").child(uid)
        
        
        userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil{
                print(err!)
                return
            }
            
          
                let user = User()
                let username = values["username"] as? String ?? "name not found"
                let email = values["email"] as? String ?? "email not found"
                let profileImageURL = values["profileImageURL"] as? String ?? "https://firebasestorage.googleapis.com/v0/b/coded-login-page.appspot.com/o/profile_images%2FnoPhotoSelected.png?alt=media&token=2d5dd0b9-ce8a-4e9e-9d9a-1981d4b13913"
                user.username = username
                user.email = email
                user.profileImageURL = profileImageURL
                
                self.mainController?.setupNavBarWithUSer(user: user)
            
            
            //self.mainController?.fetchUserAndSetupNavBarTitle()
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    @objc func handleSelectLogoImageView(){
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
           selectedImageFromPicker = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            logoImage.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }


}
