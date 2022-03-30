//
//  RecordingVC.swift
//  SlideMenuControllerSwift
//
//  Created by vlmimac1 on 2021/11/29.
//
import UIKit
import AVFoundation

class RecordingVC: UIViewController {
    
    let audioService = AudioService(nil)
    
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var saveFile: UIButton!
    
    var imageBucket: UIImageView?
    var toggleState = 1 // 토글 스위치 값
    
    func setButton(uiButton: UIButton, title: String, image:String){
        uiButton.setTitle(title, for: UIControl.State.normal )
        uiButton.setImage(UIImage(systemName: image), for: .normal)
    }
    
    
    @IBAction func startRecord(_ sender: Any) {
        
        if toggleState == 1 {
            audioService.startRecord()
            toggleState = 2
            setButton(uiButton: recordBtn,title: " 정지 ", image: "stop.fill" )
        } else {
            print("녹음정지")
            audioService.stopRecord()
            toggleState = 1
            setButton(uiButton: recordBtn,title: " 녹음 ", image: "record.circle" )
        }
    }
    
    @IBAction func startPlay(_ sender: Any) {
        if toggleState == 1 {
            audioService.play()
            toggleState = 2
            setButton(uiButton: playBtn, title: " 정지 ", image: "stop.fill" )
        } else {
            print("재생정지")
            audioService.stop()
            toggleState = 1
            setButton(uiButton: playBtn, title: " 재생 ", image: "play.fill" )
        }
    }
    
    @IBAction func saveAudio(_ sender: Any) {
        SaveAudioFile().makeAudioFile()
        print("저장 시작")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
}
