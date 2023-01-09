//
//  ViewNotesVC.swift
//  Notes
//
//  Created by trioangle on 29/12/22.
//

import Foundation
import UIKit
import CoreData

class ViewNotesVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var notesIV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var headerLbl: UILabel!
    
    var image = String()
    var header = String()
    var note = String()
    var model = [NotesModel]()
    var storeArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.notesIV.isUserInteractionEnabled = true
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView(_:)))
//        notesIV.addGestureRecognizer(tapGestureRecognizer)
    }
    
//    @objc private func didTapImageView(_ sender: UITapGestureRecognizer) {
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "ImageViewerVC") as! ImageViewerVC
//        vc.imageArr = self.model
//        vc.image = self.image
//        vc.modalPresentationStyle = .fullScreen
//        self.navigationController?.present(vc, animated: true, completion: nil)
//    }
    
    func initView() {
        self.titleLbl.text = self.header
        let pattern = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let regex = try! NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: self.note, range: NSRange(self.note.startIndex..., in: self.note))

        if let match = matches.first {
            let urlString = (self.note as NSString).substring(with: match.range)
            print("urlString::", urlString)
            let string = self.note
            let range = (self.note as NSString).range(of: urlString)
            let attributedString = NSMutableAttributedString(string: string)
            attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
            self.descriptionLbl.attributedText = attributedString
        } else {
            self.descriptionLbl.text = self.note
        }
        if self.image != "" {
            self.imageHeight.constant = 150
            let url = URL(string: self.image)!
               if let data = try? Data(contentsOf: url) {
                   self.notesIV.image = UIImage(data: data)
               }
        } else {
            self.notesIV.isHidden = true
            self.imageHeight.constant = 0
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
