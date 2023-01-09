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
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var headerLbl: UILabel!
    
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
        self.imagePicker.delegate = self
        self.profileImage.isHidden = false
        self.descriptionTV.layer.cornerRadius = 5
        self.descriptionTV.layer.borderColor = UIColor.black.cgColor
        self.descriptionTV.layer.borderWidth = 0.5
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
            print("Data saved !!")
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
            imagePicker.allowsEditing = true
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
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        self.descriptionTV.text = ""
//        return true
//    }
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
    public func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        self.dismiss(animated: true, completion: { () -> Void in
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.profileImage.image = image
            }
//            let imageData:NSData = self.profileImage.image! as NSData
//            print("imageData::",imageData)
//            let stringValue = String(decoding: imageData, as: UTF8.self)
//            print("stringValue::",stringValue)
        })
        //imagePicker.dismiss(animated: true, completion: nil)

    }
}
