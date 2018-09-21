//
//  ViewController.swift
//  MemeMe
//
//  Created by Giray Gençaslan on 20.08.2018.
//  Copyright © 2018 Giray Gençaslan. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var meme: Meme?
    var selectedFont: UIFont = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!

    //MARK: Picking Image
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        AVCaptureDevice.requestAccess(for: .video) { (permission) in
            if permission {
                // Set camera button is enable
                self.albumButton.isEnabled = true
                
                // Pick image from camera (info.plist key added)
                self.pick(sourceType: .camera)
            } else {
                
                // Show alert
                let alert = UIAlertController(title: "Warning", message: "You can not use camera without giving permission", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        
        PHPhotoLibrary.requestAuthorization { (requestStatus) in
            
            if requestStatus == .authorized {
                
                // Pick image from album (info.plist key added)
                self.pick(sourceType: .photoLibrary)
            } else {
                
                // Show alert
                let alert = UIAlertController(title: "Warning", message: "You can not use photo library without giving permission", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func pick(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            // Set share button is enable
            shareButton.isEnabled = true
            
            // Set image view's image
            imagePickerView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: Sharing Image
    
    @IBAction func shareImage(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        // Run after activity view controller completed work
        activityViewController.completionWithItemsHandler = { (_, successful, _, _) in
            if successful {
                self.save(memedImage)
                self.shareButton.isEnabled = false
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(activityViewController, animated: true, completion: nil)   
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: UI Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Subscribe font changing
        NotificationCenter.default.addObserver(self, selector: #selector(self.setFont(notification:)), name: NSNotification.Name("FontChanging"), object: nil)
        
        // Initialize view
        initializeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        if let _ = self.meme { shareButton.isEnabled = true }
    }
    
    //MARK: Initialize View
    
    func initializeView() {
        
        // Set share button enable to false
        shareButton.isEnabled = false
        
        // Set delegates
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        if let meme = self.meme {
            
            // Load meme font
            selectedFont = meme.font
            
            // Load meme texts
            setupTextField(textField: topTextField, font: meme.font, text: meme.topText)
            setupTextField(textField: bottomTextField, font: meme.font, text: meme.bottomText)
            
            // Load meme image
            imagePickerView.image = meme.originalImage
        } else {
            
            // Reset image view
            imagePickerView.image = nil
            
            // Set title to text fields
            setupTextField(textField: topTextField, font: self.selectedFont, text: "TOP")
            setupTextField(textField: bottomTextField, font: self.selectedFont, text: "BOTTOM")
        }
    }
    
    // MARK: Set Font
    
    @objc func setFont(notification: Notification) {
        
        // Set current font from posted notification
        let userInfo = notification.userInfo
        let font = userInfo!["Font"] as! UIFont
        self.selectedFont = font
        
        // Refresh text field only font style (without change text)
        setupTextField(textField: topTextField, font: self.selectedFont, text: topTextField.text!)
        setupTextField(textField: bottomTextField, font: self.selectedFont, text: bottomTextField.text!)
    }
    
    // MARK: Setting Text Attributes
    
    func setupTextField(textField: UITextField, font: UIFont, text: String) {
        
        let textAttributes: [String: Any] = [
            NSAttributedStringKey.strokeColor.rawValue      : UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue  : UIColor.white,
            NSAttributedStringKey.font.rawValue             : font.withSize(40),
            NSAttributedStringKey.strokeWidth.rawValue      : -4.0,
        ]
        
        textField.defaultTextAttributes = textAttributes
        textField.textAlignment = .center
        textField.text = text
        textField.delegate = self
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide navbar and toolbar
        navigationController?.navigationBar.isHidden = true
        bottomToolbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show navbar and toolbar
        navigationController?.navigationBar.isHidden = false
        bottomToolbar.isHidden = false
        
        // Return memed image
        return memedImage
    }
    
    func save(_ memedImage: UIImage) {
        
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage, font: self.selectedFont)
        
        // Add it to the memes array in the Application Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFontViewController" {
            let destinationScene = segue.destination as! FontViewController
            destinationScene.currentFont = self.selectedFont
        }
    }
}

extension MemeEditorViewController {
    
    // MARK: Text Field Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
        
        if textField == bottomTextField { subscribeToKeyboardNotifications() }
        else { unsubscribeFromKeyboardNotifications() }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text=="" {
            if textField == topTextField { textField.text = "TOP" }
            else if textField == bottomTextField { textField.text = "BOTTOM" }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Keyboard Notification (& Support) Methods
    
    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        guard let userInfo  = notification.userInfo else { return 0 }
        guard let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return 0 }
        return keyboardSize.cgRectValue.height
    }
}

