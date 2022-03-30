//
//  SaveAudioFile.swift
//  recordAudio
//
//  Created by vlmimac1 on 2022/03/30.
//

import UIKit
import AVFAudio
import CoreData

struct SaveAudioFile {
    
    func makeAudioFile() {
        
        print("오디오 생성")
        // create audio
        guard let data = RecordingVC().audioService.data else { return }
        do {
            try ARFileManager().createWavFile(using: (data as Data?)!)
        } catch {
            print("error")
        }
        
        // make File
        print("오디오 파일 저장")
        var memoryPath:[URL] = []
        var WavPath:[URL] = []
        var tap:Int16 = 0
        let ad = UIApplication.shared.delegate as! AppDelegate
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
            print("파일경로")
            print(directoryContents)
            //            self.FNPath.append(directoryContents)
            // if you want to filter the directory contents you can do like this:
            let wavFile = directoryContents.filter{ $0.pathExtension == "wav" }
            print("wav urls:",wavFile)
            let wavFiles = wavFile.map{ $0.deletingPathExtension().lastPathComponent }
            print("wav list:", wavFiles)
            memoryPath.append(contentsOf: wavFile)
            
        } catch {
            print(error)
        }
        
        // save CoreData
        print("저장 시작")
        WavPath = memoryPath
        var increaseTap = memoryPath.count
        tap = Int16(increaseTap)
    
        let managedContext = ad.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Users")
        let context = ad.persistentContainer.viewContext
        let cellCount = ad.cellValue
        print(cellCount)
        fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: Int16(cellCount!)))
        
        do {
            let contact = try context.fetch(Users.fetchRequest()) as! [Users]
            contact.forEach{
                if $0.id == Int16(cellCount!)
                {
                    //                    let test = try contact.fetch(fetchRequest)
                    let objectUpdate = $0 as! NSManagedObject
                    objectUpdate.setValue(Int16(increaseTap), forKey: "tap")
                    objectUpdate.setValue(WavPath, forKey: "audioFile")
                }
            }
            do {
                try managedContext.save()
            } catch { print(error) }
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
}
