//
//  ARFileManager.swift
//  SlideMenuControllerSwift
//
//  Created by vlmimac1 on 2022/02/09.
//


import UIKit


class ARFileManager {
    
    static let shared = ARFileManager()
    let fileManager = FileManager.default
    var WavPath:[URL] = []
    
    var documentDirectoryURL: URL? {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func createWavFile(using rawData: Data) throws -> URL {
        //Prepare Wav file header
        let waveHeaderFormate = createWaveHeader(data: rawData) as Data
        
        //Prepare Final Wav File Data
        let waveFileData = waveHeaderFormate + rawData
        
        //Store Wav file in document directory.
        return try storeMusicFile(data: waveFileData)
    }
    
    func deleteWavFile(using rawData: Data) throws -> URL {
        //Prepare Wav file header
        let waveHeaderFormate = createWaveHeader(data: rawData) as Data
        
        //Prepare Final Wav File Data
        let waveFileData = waveHeaderFormate + rawData
        
        //Store Wav file in document directory.
        return try deleteMusicFile(data: waveFileData)
    }
    
    private func createWaveHeader(data: Data) -> NSData {
        
        let sampleRate:Int32 = 48000
        let chunkSize:Int32 = 36 + Int32(data.count)
        let subChunkSize:Int32 = 16
        let format:Int16 = 1
        let channels:Int16 = 1
        let bitsPerSample:Int16 = 8
        let byteRate:Int32 = sampleRate * Int32(channels * bitsPerSample / 8)
        let blockAlign: Int16 = channels * bitsPerSample / 8
        let dataSize:Int32 = Int32(data.count)
        
        let header = NSMutableData()
        
        header.append([UInt8]("RIFF".utf8), length: 4)
        header.append(intToByteArray(chunkSize), length: 4)
        
        //WAVE
        header.append([UInt8]("WAVE".utf8), length: 4)
        
        //FMT
        header.append([UInt8]("fmt ".utf8), length: 4)
        
        header.append(intToByteArray(subChunkSize), length: 4)
        header.append(shortToByteArray(format), length: 2)
        header.append(shortToByteArray(channels), length: 2)
        header.append(intToByteArray(sampleRate), length: 4)
        header.append(intToByteArray(byteRate), length: 4)
        header.append(shortToByteArray(blockAlign), length: 2)
        header.append(shortToByteArray(bitsPerSample), length: 2)
        
        header.append([UInt8]("data".utf8), length: 4)
        header.append(intToByteArray(dataSize), length: 4)
        
        return header
    }
    
    private func intToByteArray(_ i: Int32) -> [UInt8] {
        return [
            //little endian
            UInt8(truncatingIfNeeded: (i      ) & 0xff),
            UInt8(truncatingIfNeeded: (i >>  8) & 0xff),
            UInt8(truncatingIfNeeded: (i >> 16) & 0xff),
            UInt8(truncatingIfNeeded: (i >> 24) & 0xff)
        ]
    }
    
    private func shortToByteArray(_ i: Int16) -> [UInt8] {
        return [
            //little endian
            UInt8(truncatingIfNeeded: (i      ) & 0xff),
            UInt8(truncatingIfNeeded: (i >>  8) & 0xff)
        ]
    }
    
    func storeMusicFile(data: Data) throws -> URL {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let num = appDelegate.cellValue
        let saveName : String?
        
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var current_date_string = formatter.string(from: Foundation.Date())
        saveName = current_date_string
        
        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        try FileManager.default.createDirectory(atPath: documentDirectory.path, withIntermediateDirectories: true, attributes: nil)
        
        let filePath = documentDirectory.appendingPathComponent("\(saveName).wav")
        debugPrint("File Path: \(filePath.path)")
        try data.write(to: filePath)
        
        return filePath //Save file's path respected to document directory.
    }
    
    func deleteMusicFile(data: Data) throws -> URL {
        let saveName : String?
        
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var current_date_string = formatter.string(from: Foundation.Date())
        saveName = current_date_string
        
        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        try FileManager.default.createDirectory(atPath: documentDirectory.path, withIntermediateDirectories: true, attributes: nil)
        
        let filePath = documentDirectory.appendingPathComponent("\(saveName).wav")
        try fileManager.removeItem(at: filePath)
        
        return filePath
    }
}
