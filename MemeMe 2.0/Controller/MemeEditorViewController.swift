//
//  MemeEditorViewController.swift
//  MemeMe 2.0
//
//  Created by Justin Kampen on 1/1/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit

// MARK: - MemeEditorViewController: UIViewController, UINavigationControllerDelegate

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: Outlets and Properties
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "Impact", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0]
    
    var meme: Meme?
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        imageView.image != nil ? navigationBarButtons(enabled: true) : navigationBarButtons(enabled: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        configureMeme()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotications()
    }
    
    // MARK: Helper Methods
    
    func configureMeme() {
        if let meme = meme {
            setupMeme(textField: topTextField, withText: meme.topText)
            setupMeme(textField: bottomTextField, withText: meme.bottomText)
            imageView.image = meme.originalImage
        } else {
            setupMeme(textField: topTextField, withText: "TOP")
            setupMeme(textField: bottomTextField, withText: "BOTTOM")
            imageView.image = nil
            navigationBarButtons(enabled: false)
        }
    }
    
    func setupMeme(textField: UITextField, withText: String?) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.backgroundColor = .clear
        textField.textAlignment = .center
        textField.text = withText
        textField.delegate = self
    }
    
    func navigationAndToolBar(isHidden: Bool) {
        navigationBar.isHidden = isHidden
        toolBar.isHidden = isHidden
    }
    
    func navigationBarButtons(enabled: Bool) {
        shareButton.isEnabled = enabled
        clearButton.isEnabled = enabled
    }
    
    func pickImage(from sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        pickImage(from: .camera)
    }
    
    @IBAction func pickImageFromAlbums(_ sender: Any) {
        pickImage(from: .photoLibrary)
    }
    
    // MARK: Navigation Bar Buttons
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetImageAndText(_ sender: Any) {
        showAlert(title: "Are You Sure?", message: "You will lose your current Meme.", callback: resetButtonPressed, option: 2)
    }
    
    func resetButtonPressed() {
        setupMeme(textField: topTextField, withText: "TOP")
        setupMeme(textField: bottomTextField, withText: "BOTTOM")
        imageView.image = nil
        navigationBarButtons(enabled: false)
    }
    
    // MARK: Showing and Hiding Keyboard
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    // MARK: Create Memed Image and Save/Share
    
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        dismiss(animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        navigationAndToolBar(isHidden: true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        navigationAndToolBar(isHidden: false)
        return memedImage
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityView = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityView.completionWithItemsHandler = { (activity, completed, itmes, error) in
            if completed {
                self.save()
            }
        }
        present(activityView, animated: true, completion: nil)
    }
}

// MARK: - MemeEditorViewController: UIImagePickerControllerDelegate

extension MemeEditorViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - MemeEditorViewController: UITextFieldDelegate

extension MemeEditorViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if topTextField.text == "TOP" {
            textField.text = ""
        }
        if bottomTextField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if topTextField.text == "" {
            topTextField.text = "TOP"
            navigationBarButtons(enabled: false)
        } else if bottomTextField.text == "" {
            bottomTextField.text = "BOTTOM"
            navigationBarButtons(enabled: false)
        } else {
            navigationBarButtons(enabled: true)
        }
        textField.resignFirstResponder()
        return true
    }
}
