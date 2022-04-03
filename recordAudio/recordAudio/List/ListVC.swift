//
//  ListVC.swift
//  recordAudio
//
//  Created by vlmimac1 on 2022/03/29.
//


import UIKit
import AVFAudio

class ListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var WavPath:[URL] = []
    var tap:Int16 = 0
    var FNList:[String] = ["0","test1","test2","test3","test4","test5"]
    
    // Load coreData 오디오
    // 근데 그냥 파일매니져에서 불러와도 상관없음 왜냐하면 아직 계정 구현이 덜 됨
    // 하지만 코어데이터 처리
    
    func dataLoad(){
        
        let ad = UIApplication.shared.delegate as! AppDelegate
        let cellCount = ad.cellValue
        let context = ad.persistentContainer.viewContext
        do {
            let contact = try context.fetch(Users.fetchRequest()) as! [Users]
            contact.forEach {
                let sort = NSSortDescriptor(key: "id", ascending: false)
                
                print("시작")
                print($0.id)
                print(Int16(cellCount!))
                if $0.id == Int16(cellCount!)
                {
                    print("id 값 : ",$0.id)
                    print("name 값 : ",$0.name)
                    var move :[URL] = $0.audioFile!
                    self.tap = $0.tap
                    // MARK: convert move url -> audioFile
                    for i in 0...self.tap-1{
                        self.WavPath.append(move[Int(i)])
                    }
                    // #MARK: WavPath 는 주소 값 그대로 FNList 는 필터
                    print(self.WavPath)
                    let wavFile = self.WavPath
                    let wavFiles = wavFile.map{ $0.deletingPathExtension().lastPathComponent }
                    for i in 0...self.tap-1{
                        self.FNList.append(wavFiles[Int(i)])
                    }
                    print(self.FNList)

                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // 가공 오디오 파일 -> FNList
    func loadFile(){
        do {
            // Get the document directory url
            let documentDirectory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            print("documentDirectory", documentDirectory.path)
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(
                at: documentDirectory,
                includingPropertiesForKeys: nil
            )
            print("directoryContents:", directoryContents.map { $0.localizedName ?? $0.lastPathComponent })
            for url in directoryContents {
                print(url.localizedName ?? url.lastPathComponent)
            }
            
            print("=================")
            // if you would like to hide the file extension
            for var url in directoryContents {
                url.hasHiddenExtension = true
                
            }
            for url in directoryContents {
                self.WavPath.append(url)
                print(url.localizedName ?? url.lastPathComponent)
            }
            
            
            print("=================")

            // if you want to get all mp3 files located at the documents directory:
            let wavss = directoryContents.filter(\.iswav).map { $0.localizedName ?? $0.lastPathComponent }
            print("waves:", wavss)
            
            
            
            
        } catch {
            print(error)
        }
    }
    
    
    
    
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
        dataLoad()
        loadFile()
        
        // RecordingVC audioFile path
        print(self.WavPath)
        self.FNList = self.WavPath.map{ $0.deletingLastPathComponent().lastPathComponent }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        
    }
    
    
    
    
    
    
}
// tableView

// load F.M.


extension URL {
    var typeIdentifier: String? { (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier }
    var iswav: Bool { typeIdentifier == "public.wav" }
    var localizedName: String? { (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName }
    var hasHiddenExtension: Bool {
        get { (try? resourceValues(forKeys: [.hasHiddenExtensionKey]))?.hasHiddenExtension == true }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.hasHiddenExtension = newValue
            try? setResourceValues(resourceValues)
        }
    }
}
