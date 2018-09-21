//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Giray Gençaslan on 4.09.2018.
//  Copyright © 2018 Giray Gençaslan. All rights reserved.
//

import UIKit

// MARK: Reuse identifier for collection cell

private let reuseIdentifier = "MemeCollectionViewCell"

class SentMemesCollectionViewController: UICollectionViewController, UITextFieldDelegate {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
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
        
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // - It's enables to provides a default gesture recognizer that you can use to rearrange items in its managed collection view
        
        self.installsStandardGestureForInteractiveMovement = true
        
        // - Modifying flow (for collection view)
        
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView?.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? MemeDetailViewController {
            guard let indexPath = sender as? IndexPath else { return }
            detailViewController.meme = memes[indexPath.row] as Meme
        }
    }

}

extension SentMemesCollectionViewController {
    
    
    // MARK: - Collection view delegate methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        
        //: - Fill cell
        let meme = memes[indexPath.row] as Meme
        cell.fillCell(meme: meme)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailViewController.meme = memes[indexPath.row] as Meme
        performSegue(withIdentifier: "ShowMemeDetailViewController", sender: indexPath)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        if UIDevice.current.orientation.isLandscape {
            let space: CGFloat = 3.0
            let width = (view.frame.size.height - (4 * space)) / 5
            flowLayout.itemSize = CGSize(width: width, height: width)
            flowLayout.invalidateLayout()
        } else if UIDevice.current.orientation.isPortrait {
            let space: CGFloat = 3.0
            let width = (view.frame.size.height - (2 * space)) / 3
            flowLayout.itemSize = CGSize(width: width, height: width)
            flowLayout.invalidateLayout()
        }
    }
}
