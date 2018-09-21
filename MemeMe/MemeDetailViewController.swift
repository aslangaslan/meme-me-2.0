//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Giray Gençaslan on 5.09.2018.
//  Copyright © 2018 Giray Gençaslan. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController, UITextFieldDelegate {

    var meme: Meme!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editMeme))
        imageView.image = meme.memedImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func editMeme() {
        
        // - Perform segue to ShowMemeEditorViewController
        performSegue(withIdentifier: "ShowMemeEditorViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Set meme in ShowMemeEditorViewController
        if let memeEditorNavigationController = segue.destination as? UINavigationController {
            if let memeEditorViewController = memeEditorNavigationController.viewControllers.first as? MemeEditorViewController {
                memeEditorViewController.meme = self.meme
            }
        }
    }
}
