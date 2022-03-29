//
//  ListVC.swift
//  recordAudio
//
//  Created by vlmimac1 on 2022/03/29.
//


import UIKit

class ListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var FNList:[String] = ["0","test1","test2","test3","test4","test5"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FNList.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : AudioListCell = tableView.dequeueReusableCell(withIdentifier: "AudioListCell", for: indexPath) as! AudioListCell
        cell.fmName.text = FNList[indexPath.row]
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    
    
    
}
// tableView

// load F.M.


