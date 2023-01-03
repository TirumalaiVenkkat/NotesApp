//
//  ImageViewerVC.swift
//  Notes
//
//  Created by trioangle on 29/12/22.
//

import Foundation
import UIKit

class ImageViewerVC: UIViewController {
    
    @IBOutlet weak var imageCV: UICollectionView!
    @IBOutlet weak var backBtn: UIButton!
    
    var imageArr = [NotesModel]()
    var image = String()
    var storeArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageCV.delegate = self
        self.imageCV.dataSource = self
        if (self.imageArr.filter({($0.image == self.image)}).count != 0) {
            self.storeArr.append(image)
            print(self.storeArr.count)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ImageViewerVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! ImagesCell
        let url = URL(string: self.image)!
           if let data = try? Data(contentsOf: url) {
               cell.notesImage.image = UIImage(data: data)
           }
        return cell
    }
    
    
}


