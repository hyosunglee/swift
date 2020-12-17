//
//  Fake111PLViewController.swift
//  Pray111_beta_0.2
//
//  Created by vlm on 2020/11/20.
//  Copyright © 2020 vlm. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class Fake111PLViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func ReadPuller(completion: @escaping ([Fake111PLVO])-> Void){
        
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
                    let result:[Fake111PLVO] = d.map {
                        element in
                        let PL_111VO = Fake111PLVO()
                        PL_111VO.nickname = element["nickname"] as? String
                        PL_111VO.contents = element["contents"] as? String
                        PL_111VO.DTTM = element["DTTM"] as? String
                    
                        return PL_111VO
                            
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
    
    var Fake111PL:[Fake111PLVO] = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Fake111PL.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : Fake111PLCell = tableView.dequeueReusableCell(withIdentifier: "Fake111PLCell", for: indexPath) as! Fake111PLCell
        cell.name.text = Fake111PL[indexPath.row].name
        cell.DTTM.text = Fake111PL[indexPath.row].DTTM
        cell.contents.text = Fake111PL[indexPath.row].contents
        
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var GView: UIView!
    
    @IBOutlet weak var ImgView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        ImgView.image = UIImage(named: "aho")
        
      
        
        
        self.ReadPuller(){ source in
            self.Fake111PL = source.map{ $0 }
            self.tableView.reloadData()
        }
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
}
