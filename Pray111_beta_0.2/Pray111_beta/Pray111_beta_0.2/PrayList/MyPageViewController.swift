//
//  MyPageViewController.swift
//  TableView
//
//  Created by vlm on 2020/10/20.
//  Copyright © 2020 vlm. All rights reserved.
//

import UIKit
import Foundation
import Alamofire




class MyPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func ReadPuller(completion: @escaping ([MyPageVO]) -> Void){
        
        let param = [
            "user_key_code" : 30,
            "is_public" : 2,
            "is_answer" : 0
        ]
        
        let BaseURL = URL(string: "http://cccvlm.com/111pray/php/myPrayerListPuller.php")!
        
        let encoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(arrayEncoding: .noBrackets))
        
        let alamo = AF.request(BaseURL, method: .post, parameters: param, encoder: encoder)
        alamo.responseJSON(completionHandler: { response in
        
            print("escapingClosure_1")
            //print(response)
            switch response.result {
            
            case .success(let data):
                if let d = data as? [[String: Any]] {
                    let result:[MyPageVO] = d.map {
                        element in
                        let MPVO = MyPageVO()
                        MPVO.nickname = element["nickname"] as? String
                        MPVO.contents = element["contents"] as? String
                        MPVO.DTTM = element["DTTM"] as? String
                    
                        return MPVO
                            
                    }
                    
                    completion(result)
                }
                break
            case .failure:
                break
            }
        })
        print("escapingClosure_2")
    }
    
    
    var MyPage:[MyPageVO] = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyPage.count
    }
    

//
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : MyPageCell = tableView.dequeueReusableCell(withIdentifier: "MyPageCell", for: indexPath) as! MyPageCell
        cell.name?.text = MyPage[indexPath.row].nickname
        cell.time?.text = MyPage[indexPath.row].DTTM
        cell.contents?.text = MyPage[indexPath.row].contents
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
     
    
   
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        
        self.ReadPuller(){ source in
            self.MyPage = source.map{ $0 }
            self.tableView.reloadData()
        }
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
   }
