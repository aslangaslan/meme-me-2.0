//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Giray Gençaslan on 4.09.2018.
//  Copyright © 2018 Giray Gençaslan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeTableViewCell"

class SentMemesTableViewController: UITableViewController, UITextFieldDelegate {

    // MARK: Meme Variable
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBAction func showMemeEditor(_ sender: Any) {
        let memeEditorViewController = storyboard?.instantiateViewController(withIdentifier: "MemeEditorNavigationController")
        present(memeEditorViewController!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? MemeDetailViewController {
            guard let indexPath = sender as? IndexPath else { return }
            detailViewController.meme = memes[indexPath.row] as Meme
        }
    }
}

extension SentMemesTableViewController {
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! MemeTableViewCell
        let meme = memes[indexPath.row] as Meme
        
        //: - Fill cell
        cell.fillCell(meme: meme)
        return cell
    }
    
    // MARK: - Table view user event
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailViewController.meme = memes[indexPath.row] as Meme
        performSegue(withIdentifier: "ShowMemeDetailViewController", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: - Delete supporting
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
}
