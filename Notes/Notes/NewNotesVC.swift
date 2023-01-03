//
//  NewNotesVC.swift
//  Notes
//
//  Created by trioangle on 28/12/22.
//

import Foundation
import UIKit
import CoreData

protocol SaveNotesDelegate {
    func fetchNotes()
}
class NewNotesVC: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
    var context:NSManagedObjectContext!
    var imagePicker = UIImagePickerController()
    var delegate: SaveNotesDelegate?
    var note_created = 0
    var n_id = "NID"
    var notes_id = Int()
    var notesID = String()
    var imageData = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleTF.delegate = self
        self.descriptionTV.delegate = self
        imagePicker.delegate = self
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func imageAction(_ sender: Any) {
        self.chooseImage()
    }
    
    func saveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let manageContent = appDelegate.persistentContainer.viewContext
        let noteEn = NSEntityDescription.insertNewObject(forEntityName: "NotesEntity", into: manageContent)
        self.notes_id += 6
        self.note_created += 1
        self.notesID = self.n_id + notes_id.description
        print("NotesID::", notesID)
        noteEn.setValue(self.notesID, forKey: "id")
        noteEn.setValue(self.titleTF.text, forKey: "title")
        noteEn.setValue(self.descriptionTV.text, forKey: "notedescriptions")
        noteEn.setValue(self.note_created, forKey: "timecreated")
        noteEn.setValue(self.imageData, forKey: "notesimage")
        
        do{
            try manageContent.save()
        }catch let error as NSError {
            print("could not save . \(error), \(error.userInfo)")
        }
    }
    
    func imageToString() {
        
    }
    func chooseImage() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    func incrementingData() {
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        self.saveData()
        self.delegate?.fetchNotes()
        self.navigationController?.popViewController(animated: true)
    }
}

extension NewNotesVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.descriptionTV.text == ""
        print("Began...")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("End...")
    }
}

extension NewNotesVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textView: UITextField) {
        print("Began...")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("End...")
    }
}

extension NewNotesVC: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: { () -> Void in
//            let imageData:NSData = UIImagePNGRepresentation(profileImage.image!)!
//            let imageStr = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
//            print(imageStr)
//            self.imageData = imageStr
        })

    }
}
