//
//  MyPageViewController.swift
//  TableView
//
//  Created by vlm on 2020/10/20.
//  Copyright © 2020 vlm. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import PercentEncoder

struct MPLParam: Encodable{
    let user_key_code : Int
    let type : Int
    let is_answer : Int
}

class MyPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var MyPage:[MyPageVO] = []
    var keycode : Int? = 0
    
    var originData = [Data]()

    func ReadPuller(){
        
        let ad = UIApplication.shared.delegate as? AppDelegate
        self.keycode = Int(ad?.paramKeycode ?? "" )
//        print("MPL로 이동된 값 ",keycode!)
        
        let param = MPLParam(
            user_key_code: self.keycode!,
            type: 0,
            is_answer: 2
        )

        let BaseURL = URL(string: "~~~~~~~~~~~~~~URL address~~~~~~~~~~~.php")!
        
        let encoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(arrayEncoding: .noBrackets))
//        let HTTPHeaders = HTTPHeader(
        let alamo = AF.request(BaseURL, method: .post, parameters: param, encoder: encoder)
    
        alamo.responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)//.reversed()
//                self.originData = json.map(((String, JSON)).init())
                // If you initialize this and reverse the refresh data, it refreshes well.
                // 새로 추가한 데이터는 옛 데이터와 현재 데이터의 차이
                // 날짜 최신 순으로 정렬
                for element in json {
                    let pray_key_code: Int =  element.1["pray_key_code"].intValue
                    let nickname: String = element.1["nickname"].stringValue
                    let contents: String = PercentEncoding.decodeURIComponent.evaluate(string: element.1["contents"].stringValue)
                    let DTTM: String = element.1["DTTM"].stringValue
                    let name: String = element.1["name"].stringValue
                    let is_answer: Int = element.1["is_answer"].intValue
                    let is_public: Int = element.1["is_public"].intValue
                    
                    // 리프레쉬 함수 위치 시도
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.refreshControl?.endRefreshing()
                    }
//                print(is_answer)
//                    print(pray_key_code)
                let MPVO = MyPageVO(
                    pray_key_code: pray_key_code,
                    contents: contents,
                    DTTM: DTTM,
                    name: name,
                    nickname : nickname,
                    is_answer : is_answer,
                    is_public : is_public
                )
                    self.MyPage.append(MPVO)
                }
                self.tableView.reloadData() // 1
                break
            case .failure:
                break
            }
        })
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyPage.count
    }
    
    func btnTapped(btn:UIButton, indexPath:IndexPath) {
        print("IndexPath : \(indexPath.row)")
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : MyPageCell = tableView.dequeueReusableCell(withIdentifier: "MyPageCell", for: indexPath) as! MyPageCell
        cell.name?.text = MyPage[indexPath.row].nickname
        cell.time?.text = MyPage[indexPath.row].DTTM
        cell.contents?.text = MyPage[indexPath.row].contents
        
        let btn_good = cell.viewWithTag(77) as! UIButton
        let moreBtn = cell.viewWithTag(78) as! UIButton
        
        //
        var is_answer_tmp:Int = MyPage[indexPath.row].is_answer
        
        //불러온 is_answer_tmp 값이 0이면 검은전구 1이면 불빛전구
        switch is_answer_tmp
        {
        case 0:
            btn_good.setImage(UIImage(named: "noResponse"), for: .normal)
            break;
        case 1:
            btn_good.setImage(UIImage(named: "prayResponse"), for: .normal)
            break;
        default:
            print("error",is_answer_tmp)
            break;
        }
        
        moreBtn.more_addTapHandler { (btn) in
            print("You can use here also directly : \(indexPath.row)")
            self.btnTapped(btn: btn, indexPath: indexPath)
            let pray_key_tmp:Int = self.MyPage[indexPath.row].pray_key_code
            let ad = UIApplication.shared.delegate as! AppDelegate
            ad.paramContents = self.MyPage[indexPath.row].contents
            ad.paramPraykey = self.MyPage[indexPath.row].pray_key_code
            ad.paramIspublic = self.MyPage[indexPath.row].is_public
            
            print("이거 눌림",ad.paramContents)
            print("이거 눌림",ad.paramPraykey)
            print("이거 눌림",ad.paramIspublic)
        }
        
        
        btn_good.good_addTapHandler { (btn) in
            print("You can use here also directly : \(indexPath.row)")
            self.btnTapped(btn: btn, indexPath: indexPath)
            let pray_key_tmp:Int = self.MyPage[indexPath.row].pray_key_code
          
            
            
            //is_answer_tmp 값을 누를 때 마다 변경
            if is_answer_tmp == 0 {
                is_answer_tmp = 1
            } else {
                is_answer_tmp = 0
            }
            // 버튼 버튼 값에 따른 이미지 변경
            self.MyPage[indexPath.row].is_answer = is_answer_tmp
            switch is_answer_tmp
            {
            case 0:
                btn_good.setImage(UIImage(named: "noResponse"), for: .normal)
                break;
            case 1:
                btn_good.setImage(UIImage(named: "prayResponse"), for: .normal)
                break;
            default:
                print("error",is_answer_tmp)
                break;
            }
            print("현재 기도응답 값 ",is_answer_tmp)
            print("현재 기도번호 ",pray_key_tmp)

            let checkingParam = [
                "pray_key_code" : pray_key_tmp,
                "is_answer" : is_answer_tmp
            ]
            
            let relationURL = URL(string: "http://cccvlm.com/111pray/php/prayerAnswer.php")!
            // 보내기
            
            let relationEncoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(arrayEncoding: .noBrackets))
            let relationAlamo = AF.request(relationURL, method: .post, parameters: checkingParam, encoder: relationEncoder)
            relationAlamo.responseJSON(completionHandler: { response in
                print("좋아요 보내기")
                switch response.result {
                case .success(let data):
//                    let json = JSON(data)
                    self.tableView.reloadData() // 2
                    //
                    
                    break
                    
                case .failure:
                    break
                }
            })
        }
        return cell
    }
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myPageNavi: UINavigationBar!
    
    @IBOutlet weak var rightBtn: UIButton!
    
    
    @IBAction func popUp(_ sender: Any) {
        guard let pvc = self.storyboard?.instantiateViewController(identifier: "popupVC") as? EditPrayAlertVC else {
                    return
                }
        
        pvc.modalPresentationStyle = .overCurrentContext    //  투명도가 있으면 투명도에 맞춰서 나오게 해주는 코드(뒤에있는 배경이 보일 수 있게)
        
        self.present(pvc, animated: false, completion: nil)
        
    }
    
    
    func refreshController(){
            let refresh = UIRefreshControl()
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action:
                                                  #selector(updateUI),
                                                  for: .valueChanged)
            refresh.addTarget(self, action: #selector(updateUI), for:UIControl.Event.valueChanged)
            if #available(iOS 10.0, *){
                tableView.refreshControl = refresh
            } else {
                tableView.addSubview(refresh)
            }
            print("업데이트 콘솔2 ")
        }
    
        @objc func updateUI(refresh: UIRefreshControl) {
            ReadPuller() // my Communication func
            
            
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshController()
        
        
        if #available(iOS 13.0, *){
            view?.overrideUserInterfaceStyle = .light
        }
        
        // 테이블 뷰 줄 제거
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        // 동적 뷰 크기 조절 
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        
        ReadPuller()
//        self.tableView.reloadData() //3
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        let myPageNavi = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)); myPageNavi.contentMode = .scaleAspectFit;
        let image = UIImage(named: "navi.png"); myPageNavi.image = image; navigationItem.titleView = myPageNavi
    }
    // 화면 세로 고정
    open override var shouldAutorotate: Bool { return false }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { return .portrait }
   
}

extension UIButton{
    private class Action {
        var action: (UIButton) -> Void

        init(action: @escaping (UIButton) -> Void) {
            self.action = action
        }
    }

    private struct good_AssociatedKeys {
        static var ActionTapped = "actionTapped"
    }

    private var good_tapAction: Action? {
        set { objc_setAssociatedObject(self, &good_AssociatedKeys.ActionTapped, newValue, .OBJC_ASSOCIATION_RETAIN) }
        get { return objc_getAssociatedObject(self, &good_AssociatedKeys.ActionTapped) as? Action }
    }


    @objc dynamic private func good_handleAction(_ recognizer: UIButton) {
        good_tapAction?.action(recognizer)
    }


    func good_addTapHandler(action: @escaping (UIButton) -> Void) {
        self.addTarget(self, action: #selector(good_handleAction(_:)), for: .touchUpInside)
        good_tapAction = Action(action: action)

    }
    
    
}

extension UIButton{
    private class moreAction {
        var action: (UIButton) -> Void

        init(action: @escaping (UIButton) -> Void) {
            self.action = action
        }
    }

    private struct more_AssociatedKeys {
        static var ActionTapped = "actionTapped"
    }

    private var more_tapAction: moreAction? {
        set { objc_setAssociatedObject(self, &good_AssociatedKeys.ActionTapped, newValue, .OBJC_ASSOCIATION_RETAIN) }
        get { return objc_getAssociatedObject(self, &good_AssociatedKeys.ActionTapped) as? moreAction }
    }


    @objc dynamic private func more_handleAction(_ recognizer: UIButton) {
        more_tapAction?.action(recognizer)
    }


    func more_addTapHandler(action: @escaping (UIButton) -> Void) {
        self.addTarget(self, action: #selector(more_handleAction(_:)), for: .touchUpInside)
        more_tapAction = moreAction(action: action)

    }
    
    
}







