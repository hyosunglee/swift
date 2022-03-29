//
//  ViewController.swift
//  recordAudio
//
//  Created by vlmimac1 on 2022/03/22.
//

import UIKit
import SwiftUI

class SwiftUiVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
 
    @IBSegueAction func howSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(
            coder: coder, rootView:
                SwiftUIView(text: "여기있음!", image: "hoho",Frame: (100, 100))
            
            
        )
    }
    
    @IBSegueAction func embedSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(
            coder: coder, rootView:
                SwiftUIView(text: "어디에?!", image: "picha", Frame: (300, 300)))
    }
    
}

