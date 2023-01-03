//
//  ViewNotesVC.swift
//  Notes
//
//  Created by trioangle on 29/12/22.
//

import Foundation
import UIKit

class ViewNotesVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var notesIV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    var image = String()
    var header = String()
    var note = String()
    var model = [NotesModel]()
    var storeArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.notesIV.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView(_:)))
        notesIV.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func didTapImageView(_ sender: UITapGestureRecognizer) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ImageViewerVC") as! ImageViewerVC
        vc.imageArr = self.model
        vc.image = self.image
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func initView() {
        self.titleLbl.text = self.header
        self.descriptionLbl.text = self.note
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
