//
//  SaveAudioFile.swift
//  recordAudio
//
//  Created by vlmimac1 on 2022/03/30.
//

import UIKit
import AVFAudio
import CoreData

class SaveAudioFile {
    
//    func makeAudioFile() {
//        
//        print("오디오 생성")
//        // create audio
//        guard let data = RecordingVC().audioService.data else { return print("실행지점 찾는 중 1") }
//        // 넘어오는 데이터 문제가 없나? 데이터 닐로 나옴 문제 있음
//        // 청진기 흐름도 그려서 문제 부분 파악 청진기는 잘됨 아마 계정? 아니면 상속? 
//        print("실행지점 찾는 중 2")
//        
//        do {
//            print("실행지점 찾는 중 3")
//            try ARFileManager().createWavFile(using: (data as Data?)!)
//        } catch {
//            print("error")
//        }
//        
//        // make File
//        print("오디오 파일 저장")
//        var memoryPath:[URL] = []
//        var WavPath:[URL] = []
//        var tap:Int16 = 0
//        let ad = UIApplication.shared.delegate as! AppDelegate
//        
//        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        do {
//            
//            // Get the directory contents urls (including subfolders urls)
//            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
//            print("파일경로")
//            print(directoryContents)
//            //            self.FNPath.append(directoryContents)
//            // if you want to filter the directory contents you can do like this:
//            let wavFile = directoryContents.filter{ $0.pathExtension == "wav" }
//            print("wav urls:",wavFile)
//            let wavFiles = wavFile.map{ $0.deletingPathExtension().lastPathComponent }
//            print("wav list:", wavFiles)
//            memoryPath.append(contentsOf: wavFile)
//            
//        } catch {
//            print(error)
//        }
//        
//        // save CoreData
//        print("코어데이터 시작")
//        WavPath = memoryPath
//        var increaseTap = memoryPath.count
//        tap = Int16(increaseTap)
//    
//        let managedContext = ad.persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Users")
//        let context = ad.persistentContainer.viewContext
//        let cellCount = ad.cellValue
//        print(cellCount)
//        fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: Int16(cellCount!)))
//        
//        do {
//            let contact = try context.fetch(Users.fetchRequest()) as! [Users]
//            contact.forEach{
//                if $0.id == Int16(cellCount!)
//                {
//                    //                    let test = try contact.fetch(fetchRequest)
//                    let objectUpdate = $0 as! NSManagedObject
//                    objectUpdate.setValue(Int16(increaseTap), forKey: "tap")
//                    objectUpdate.setValue(WavPath, forKey: "audioFile")
//                }
//            }
//            do {
//                try managedContext.save()
//            } catch { print(error) }
//        } catch {
//            print(error.localizedDescription)
//        }
//        
//        
//    }
}
