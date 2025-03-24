//
//  CheckVC.swift
//  ganuni
//
//  Created by jy on 3/22/24.
//

import UIKit

class CheckVC: UIViewController {
    
    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var nameCheckLabel: UILabel!
    @IBOutlet weak var priceCheckLabel: UILabel!
    @IBOutlet weak var numcheckLabel: UILabel!
    
    var detailData: Ganuni? = nil
    var indexPath: IndexPath?
    weak var delegate : ClickedCellDelegate? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //backbarbtn 설정
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(handleBackButton(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print (#fileID, #function, #line, "- <#comment#>")
    }
    
    //backbarbutn 의 selector
    @objc private func handleBackButton(_ sender: UIBarButtonItem){
        print (#fileID, #function, #line, "- <#comment#>")
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameCheckLabel.text = detailData?.nameLabel ?? ""
        priceCheckLabel.text = detailData?.priceLabel ?? ""
        numcheckLabel.text = detailData?.numLabel ?? ""
        
        checkLabel.layer.cornerRadius = 10
        checkLabel.clipsToBounds = true
        
        //데이터 전달 - edit noti - 안테나 꽂기
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(methodOfReceivedNotification(_:)),
            name: .NotificationPopEvent,
            object: nil
        )
        
        print(#file, #function, #line, "detailData: \(detailData)")
    }
    
    // 버튼이 눌리면 edit 모드
    @IBAction func clickedEditButton(_ sender: Any) {
        
        print (#fileID, #function, #line, "- ")
        
        let storyboardDetailVC = UIStoryboard(name: "DetialVC", bundle: Bundle.main)
        //뷰컨 인스턴스 가져오기
        guard let detailVC = storyboardDetailVC.instantiateViewController(withIdentifier: "DetialVC") as? DetialVC else { return }
        
        //뷰컨에 데이터 넣기
        detailVC.detailData = self.detailData
        
        self.navigationController?.pushViewController(detailVC, animated: true
        )
    }
    
    //노티피케이션 이름이 들어왔을때 실행 - 셀렉터
    @objc fileprivate func methodOfReceivedNotification(_ sender: Notification) {
        print("notification save - methodOfReceivedNotification\(nameCheckLabel)")
        
        var test = detailData?.nameLabel
        
        let nameNewValue : String? = sender.userInfo?["name"] as? String
        let priceNewValue : String? = sender.userInfo?["price"] as? String
        let numNewValue : String? = sender.userInfo?["number"] as? String
        
        detailData?.nameLabel = nameNewValue
        detailData?.priceLabel = priceNewValue
        detailData?.numLabel = numNewValue
        
        nameCheckLabel.text = detailData?.nameLabel ?? ""
        priceCheckLabel.text = detailData?.priceLabel ?? ""
        numcheckLabel.text = detailData?.numLabel ?? ""
    }
    
    //버튼이 눌리면 지금 선택된 셀이 삭제 됨
    @IBAction func clickedCheckVCDeleteButton(_ sender: UIButton) {
        
        func alertClickedCheckVC() {
            let alert = UIAlertController(title: "확인", message: "삭제하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("YES", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
                self.navigationController?.popViewController(animated: true)
                print (#fileID, #function, #line, "- indexPath\(self.indexPath?.row)")
                
                //델리겟 값이 있는지 확인하는 상수
                let test = self.delegate
                
                //detailData.id 를 가져오기 -옵셔널이라 언래핑 해주기
                if let deleteId = self.detailData?.id {
                    self.delegate?.clickedCheckVCDeleteButton(id: deleteId)
                }
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("NO", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"Cancle\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
