//
//  InfoViewController.swift
//  SlideMenuControllerSwift
//
//  Created by vlmimac1 on 2021/11/16.
//

import UIKit

struct CustomData {
    
    var backgroundImage: UIImage
    var name : String
    
}

// 정보

class InfoVC: UIViewController {
    
    // 그냥 밑줄
    @IBOutlet weak var nameT: UIStackView!

    
    // 화면에 뿌려줄 데이터
    @IBOutlet weak var nameR: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // load Data
    var nameLD: String?
    
    
    var moveID:Int16?
    var WavPath:[URL] = [URL(string: "www.apple.com")!]
    
    func deleteUser(_ id: Int16, tap: Int16,
                    oxTap: Int16, temTap: Int16,
                    name: String, imageData: Data,
                    oxgen: [String]?, birth: String?,
                    height: Int16, weight: Int16,
                    temper: [String]?, lastDate: String?,
                    gender: String?, audioFile: [URL]?
    ) {
        CoreDataManager.shared
            .deleteUser(id: id) { onSuccess in
            print("deleted = \(onSuccess)")
        }
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
            // self.tableView.reloadData()
              print("Handle Cancel Logic here")
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            // self.tableView.reloadData()
              print("Handle Cancel Logic here")
            self.loadData()
            
            
            
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: false, completion: nil)
    }
    
    
    
    
    
    // 저장 되면 여기에 쌓임
    // 다른 클래스에서 넘겨오려면 전역 및 고정
    public static var data = [
        CustomData( backgroundImage: #imageLiteral(resourceName: "hoho"),
                   name: "")
    ]
    
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    
    func loadData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        do {
            let contact = try context.fetch(Users.fetchRequest()) as! [Users]
            contact.forEach {
                print("id 값 : ",$0.id)
                print("name 값 : ",$0.name)
                print("image 값 : ",$0.imageData)
                
                self.moveID = $0.id
                // UIImage(data: (self.imageView.image?.pngData())!)!
               
                
                InfoVC.data.insert(CustomData(backgroundImage: UIImage(data:$0.imageData!)!, name: $0.name!), at: 0)
                
                
                
            }
        } catch {
            print(error.localizedDescription)
        }
    }// 몸무게 키 성별 불러오기 추가해야함
    
    @objc func goRight() {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
        self.navigationController?.pushViewController(pushVC!, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func setLeftAlignTitleView(font: UIFont, text: String, textColor: UIColor) {
        guard let navFrame = navigationController?.navigationBar.frame else{
            return
        }
        
        let parentView = UIView(frame: CGRect(x: 0, y: 0, width: navFrame.width*3, height: navFrame.height))
        self.navigationItem.titleView = parentView
        
        let label = UILabel(frame: .init(x: parentView.frame.minX, y: parentView.frame.minY, width: parentView.frame.width, height: parentView.frame.height))
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.font = font
        label.textAlignment = .left
        label.textColor = textColor
        label.text = text
        parentView.addSubview(label)
        let forward = UIBarButtonItem(image: UIImage(named: "ic_action_forward"), style: .plain, target: self, action: #selector(self.goRight))
        let back = UIBarButtonItem(image: UIImage(named: ""), style: .plain, target: self, action: #selector(self.goRight))
        let Icon = UIBarButtonItem(image: UIImage(named: ""), style: .plain, target: self, action: #selector(self.goRight))
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.setRightBarButtonItems([Icon ,forward , back], animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftAlignTitleView(font: UIFont.systemFont(ofSize: 20) , text: "와이즈 청진기", textColor:UIColor.white)

        
        InfoVC.data.removeAll()
        loadData()
        InfoVC.data.append(CustomData(backgroundImage: #imageLiteral(resourceName: "hoho"),
                                                  name: ""))
        self.collectionView.reloadData()
        view.addSubview(collectionView)
        collectionView.backgroundColor = .gray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.width/4).isActive = true
        
        if #available(iOS 13.0, *){
            view?.overrideUserInterfaceStyle = .light
        }
        
        
        
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let border = CALayer()
        border.frame = CGRect(x: 0, y: nameT.frame.size.height-1, width: nameT.frame.width, height: 0.5)
        border.backgroundColor = UIColor.black.cgColor
        nameT.layer.addSublayer((border))
        
        let borderG = CALayer()
       
    }
}

extension InfoVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4, height: collectionView.frame.width/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return InfoVC.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.data = InfoVC.data[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        var cellNum = "\(indexPath.row)번째 셀"
        var cellCount = indexPath.row

        // 셀 눌렀을 때 해당 데이터 가져오기
        // cellNum 과 id 값이 동일함
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.cellValue = cellCount
        print(cellNum)
        print("appDelegate.cellValue")
        print(appDelegate.cellValue)
        print("cellCount")
        print(cellCount)
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let contact = try context.fetch(Users.fetchRequest()) as! [Users]
            contact.forEach {
                let sort = NSSortDescriptor(key: "id", ascending: false)
                
                print("시작")
                print($0.id)
                print(Int16(cellCount))
                if $0.id == Int16(cellCount)
                {
                    print("id 값 : ",$0.id)
                    print("name 값 : ",$0.name)
                   
                    self.nameR.text = String($0.name!)
                    
//                    self.temperR.text = $0.temper![1]
                    self.imageView.image = UIImage(data:$0.imageData!)
                    // 삭제 id 값 맞추기
                    self.moveID = $0.id
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        

        
       
    }
}




