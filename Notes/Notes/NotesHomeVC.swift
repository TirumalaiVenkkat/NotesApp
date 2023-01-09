//
//  ViewController.swift
//  Notes
//
//  Created by trioangle on 28/12/22.
//

import UIKit
import Alamofire
import CoreData

class NotesHomeVC: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var notesCV: UICollectionView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    {
        didSet {
            //collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    var notesModel = [NotesModel]()
    var reversedCache = [NSManagedObject]()
    var notesInCache = [NSManagedObject]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context:NSManagedObjectContext!
    var explained = Bool()
    var imageStr = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.callAPI()
        self.initView()
        //self.openDatabse()
    }
    
    func initView() {
        self.headerLbl.text = "Notes"
        self.notesCV.delegate = self
        self.notesCV.dataSource = self
        self.addBtn.setTitle("", for: .normal)
        self.addView.layer.cornerRadius = 10
        self.addView.backgroundColor = .white
    }
    
    func callAPI() {
        let url = "https://raw.githubusercontent.com/RishabhRaghunath/JustATest/master/notes"
        AF.request(url).response { response in
            print("api:",url)
            guard let data = response.data else {
                self.fetchData()
                return }
                    do {
                        let decoder = JSONDecoder()
                        let userData = try decoder.decode([NotesModel].self, from: data)
                        self.notesModel = userData
                        print(self.notesModel)
                        print("Count::", self.notesModel.count)
                        self.openDatabse()
                    } catch let error {
                        print(error)
                    }
            print("response::", response)
        }
    }
    
    func openDatabse() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let manageContent = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NotesEntity")
        let userEntity = NSEntityDescription.entity(forEntityName: "NotesEntity", in: manageContent)!
        for i in 0..<self.notesModel.count {
            fetchRequest.predicate = NSPredicate(format: "id == %@",self.notesModel[i].id)
            do {
                let notesList = try manageContent.fetch(fetchRequest)
                let result =  notesList as! [NSManagedObject]
                if result.count > 0 {
                    result[0].setValue(self.notesModel[i].id, forKey: "id")
                    result[0].setValue(self.notesModel[i].title, forKey: "title")
                    result[0].setValue(self.notesModel[i].body, forKey: "notedescriptions")
                    result[0].setValue(self.notesModel[i].createdTime, forKey: "timecreated")
                    result[0].setValue(self.notesModel[i].image, forKey: "notesimage")
                    result[0].setValue(self.notesModel[i].archived, forKey: "archived")
                }else{
                    let noteEn = NSEntityDescription.insertNewObject(forEntityName: "NotesEntity", into: manageContent)
                    noteEn.setValue(self.notesModel[i].id, forKey: "id")
                    noteEn.setValue(self.notesModel[i].title, forKey: "title")
                    noteEn.setValue(self.notesModel[i].body, forKey: "notedescriptions")
                    noteEn.setValue(self.notesModel[i].createdTime, forKey: "timecreated")
                    noteEn.setValue(self.notesModel[i].image, forKey: "notesimage")
                    noteEn.setValue(self.notesModel[i].archived, forKey: "notesimage")
                }
            }catch{
                
            }
        }
        DispatchQueue.main.async {
            do{
                try manageContent.save()
            }catch let error as NSError {
                print("could not save . \(error), \(error.userInfo)")
            }
            self.fetchData()
        }
       // saveData(UserDBObj:newUser)
    }
    
    
    func fetchData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let manageContent = appDelegate.persistentContainer.viewContext
            let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: "NotesEntity")
           do {
               let result = try manageContent.fetch(fetchData)
               self.notesInCache =  result as! [NSManagedObject]
               self.reversedCache = Array(notesInCache.reversed())
               print("Reversed::", self.reversedCache)
               self.notesCV.reloadData()
           }catch {
               print("err")
           }
    }

    func saveData(UserDBObj:NSManagedObject) {
        print("Storing Data..")
        do {
            try context.save()
        } catch {
            print("Storing data Failed")
        }
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        print("Tapped...")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "NewNotesVC") as! NewNotesVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NotesHomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Notes count \(notesInCache.count)")
        return self.reversedCache.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotesCVC", for: indexPath) as! NotesCVC
        let model = self.reversedCache[indexPath.row]
        cell.dateLbl.text = model.value(forKey: "timecreated") as? String ?? ""
        cell.descriptionLbl.text = model.value(forKey: "notedescriptions") as?  String ?? ""
        //cell.contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight]
        self.imageStr = model.value(forKey: "notesimage") as? String ?? ""
        print(cell.descriptionLbl.text?.count as Any)
        if cell.descriptionLbl.text!.count >= 300 {
            self.explained = true
        } else {
            self.explained = false
        }
        cell.backgroundColor = .randomColor()
        cell.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ViewNotesVC") as! ViewNotesVC
        let model = self.reversedCache[indexPath.row]
        vc.image = model.value(forKey: "notesimage") as? String ?? ""
        vc.header = model.value(forKey: "title") as? String ?? ""
        vc.note = model.value(forKey: "notedescriptions") as?  String ?? ""
        vc.model = self.notesModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
        return CGSize(width: widthPerItem - 2, height: 200)
    }
}

class NotesModelCoreData:NSManagedObject{
    
}
// MARK: - WelcomeElement
struct NotesModel: Codable {
    let id: String
    let archived: Bool
    let title, body: String
    let createdTime: Int
    let image: String?
    let expiryTime: Int?

    enum CodingKeys: String, CodingKey {
        case id, archived, title, body
        case createdTime = "created_time"
        case image
        case expiryTime = "expiry_time"
    }
}

extension CGFloat {
    static func randomValue() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(
           red: .randomValue(),
           green: .randomValue(),
           blue: .randomValue(),
           alpha: 1.0
        )
    }
}

extension NotesHomeVC: SaveNotesDelegate {
    func fetchNotes() {
        self.fetchData()
    }
}
