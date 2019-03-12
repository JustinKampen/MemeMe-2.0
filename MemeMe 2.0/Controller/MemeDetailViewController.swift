//
//  MemeDetailViewController.swift
//  MemeMe 2.0
//
//  Created by Justin Kampen on 1/3/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit

// MARK: MemeDetailViewController: UIViewController

class MemeDetailViewController: UIViewController {
    
    // MARK: - Outlets and Properties
    
    @IBOutlet weak var memedImageView: UIImageView!
    
    var meme: Meme?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memedImageView.image = meme?.memedImage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! MemeEditorViewController
        controller.meme = meme
    }
    
    @IBAction func editCurrentMeme(_ sender: Any) {
        performSegue(withIdentifier: "editMeme", sender: self)
    }
}
