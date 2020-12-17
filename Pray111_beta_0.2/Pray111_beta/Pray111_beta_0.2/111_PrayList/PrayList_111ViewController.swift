//
//  111PrayListViewController.swift
//  Pray111_beta_0.2
//
//  Created by vlm on 2020/11/06.
//  Copyright © 2020 vlm. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class PrayList_111ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    func ReadPuller(completion: @escaping ([PL111VO])-> Void){
        
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
                    let result:[PL111VO] = d.map {
                        element in
                        let PL_111VO = PL111VO()
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
    
    
    var PL111:[PL111VO] = []
    
        
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PL111.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PL111Cell = tableView.dequeueReusableCell(withIdentifier: "PL111Cell", for: indexPath) as! PL111Cell
        
        cell.name.text = PL111[indexPath.row].nickname
        cell.DTTM.text = PL111[indexPath.row].DTTM
        cell.contents.text = PL111[indexPath.row].contents
        
        
        return cell
    }
    

    @IBOutlet weak var PL111Navi: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let PL111Navi = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)); PL111Navi.contentMode = .scaleAspectFit; let image = UIImage(named: "navi.png"); PL111Navi.image = image; navigationItem.titleView = PL111Navi

        self.ReadPuller(){ source in
            self.PL111 = source.map{ $0 }
            self.tableView.reloadData()
        }
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    

    

}
