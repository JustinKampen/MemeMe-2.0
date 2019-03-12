//
//  MemeTableViewController.swift
//  MemeMe 2.0
//
//  Created by Justin Kampen on 1/1/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit

// MARK: MemeTableViewController: UIViewController

class MemeTableViewController: UIViewController {
    
    // MARK: - Outlets and Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "memeDetail" {
            let controller = segue.destination as! MemeDetailViewController
            controller.meme = sender as? Meme
        }
    }
}

// MARK: - MemeTableViewController: UITableViewDataSource, UITableViewDelegate

extension MemeTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table View Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as! MemeTableViewCell
        let meme: Meme = appDelegate.memes[indexPath.row]
        cell.fillCell(meme)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme: Meme = appDelegate.memes[indexPath.row]
        performSegue(withIdentifier: "memeDetail", sender: meme)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        appDelegate.memes.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
}
