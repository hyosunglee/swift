//
//  ViewController.swift
//  TableView
//
//  Created by vlm on 2020/03/26.
//  Copyright © 2020 vlm. All rights reserved.
//

import UIKit
import Foundation
import Alamofire



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    func ReadPuller(completion: @escaping ([PrayListVO]) -> Void){
        


        let param = [
            "user_key_code" : 30,
            "is_public" : 1,
            "is_answer" : 0
        ]
        
        let BaseURL = URL(string: "http://cccvlm.com/111pray/php/prayerListPuller.php")!
        
        
        let encoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(arrayEncoding: .noBrackets))
        let alamo = AF.request(BaseURL, method: .post, parameters: param, encoder: encoder)
        //alamo.responseString(completionHandler: { response in
        alamo.responseJSON(completionHandler: { response in
            
            print("escapingClosure_1")
            //print(response)
            switch response.result {
            
            case .success(let data):
                if let d = data as? [[String: Any]] {
                    let result:[PrayListVO] = d.map {
                        element in
                        let PLVO = PrayListVO()
                        PLVO.nickname = element["nickname"] as? String
                        PLVO.contents = element["contents"] as? String
                        PLVO.DTTM = element["DTTM"] as? String
                    
                        return PLVO
                            
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
    
    
    var PrayList:[PrayListVO] = []
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MenuCell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.category?.text = PrayList[indexPath.row].nickname
        cell.menuName?.text = PrayList[indexPath.row].DTTM
        cell.menuPrice?.text = PrayList[indexPath.row].contents
        return cell
    }
    
   
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        self.ReadPuller() { source in
            self.PrayList = source.map { $0 }
            self.tableView.reloadData()
            
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

