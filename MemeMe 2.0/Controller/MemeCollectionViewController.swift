//
//  MemeCollectionViewController.swift
//  MemeMe 2.0
//
//  Created by Justin Kampen on 1/1/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit

// MARK: - MemeCollectionViewController: UIViewController

class MemeCollectionViewController: UIViewController {
    
    // MARK: Outlets and Properties

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space: CGFloat
        let dimension: CGFloat
        if UIDevice.current.orientation.isPortrait {
            space = 3.0
            dimension = (view.frame.size.width - (2 * space)) / 3
        } else {
            space = 1.0
            dimension = (view.frame.size.width - (1 * space)) / 5
        }
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "memeDetail" {
            let controller = segue.destination as! MemeDetailViewController
            controller.meme = sender as? Meme
        }
    }
}

// MARK: - MemeCollectionViewController: UICollectionViewDataSource, UIColloectionViewDelegate

extension MemeCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: Collection View Methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme: Meme = appDelegate.memes[indexPath.row]
        cell.memeImageView.image = meme.memedImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme: Meme = appDelegate.memes[indexPath.row]
        performSegue(withIdentifier: "memeDetail", sender: meme)
    }
}
