//
//  ListTableVC.swift
//  ganuni
//
//  Created by jy on 3/20/24.
//

import Foundation
import UIKit

class ListTableVC: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var extendedPriceLabel: UIStackView!
    
    struct Ganuni {
        var nameLabel : String?
        var priceLabel : String?
        var numLabel : String?
    }
    
    //리스트가 비어있을때 삭제버튼 비활성화 
    func btnAble() {
        if lists.isEmpty {
            deleteButton.isEnabled = false
        } else {
            deleteButton.isEnabled = true
        }
    }
    
    var lists : [Ganuni] = [] {
        //값이 변경된 직후에 호출(프로퍼티 옵져버)
        didSet{
            DispatchQueue.main.async {
                //리스트가 비어 있을때 emptyview 설정
                if self.lists.count == 0 {
                    self.emptyView.isHidden = false
                } else {
                    self.emptyView.isHidden = true
                }
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        //셀 리소스 파일 가져오기(닙 파일)
        let nib = UINib(nibName: "GanuniCell", bundle: nil)
        myTableView.register(nib, forCellReuseIdentifier: "GanuniCell")
        
        extendedPriceLabel.layer.cornerRadius = 10
        extendedPriceLabel.layer.shadowColor = UIColor.black.cgColor
        extendedPriceLabel.layer.shadowOffset = CGSize(width: 0, height: 5)
        extendedPriceLabel.layer.shadowOpacity = 0.3
        extendedPriceLabel.layer.shadowRadius = 5.0
        
        myTableView.dataSource = self
        //myTableView.delegate = self
        
        DispatchQueue.main.async {
            //리스트가 비어 있을때 emptyview 설정
            if self.lists.count == 0 {
                self.emptyView.isHidden = false
            } else {
                self.emptyView.isHidden = true
            }
        }
    }
    
    //특정 위치의 행이 편집 가능한지 묻는 메서드
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //스와이프 모드, 편집 모드에서 버튼을 선택하면 호출 되는 메서드
    //해당 메서드에서는 행에 변경사항을 Commit 해야 함
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
       {
        lists.remove(at: indexPath.row)
        btnAble()
        tableView.reloadData()
        }
    }
    
    @IBAction func clickedDeleteButton(_ sender: UIBarButtonItem) {
        deleteButton.isEnabled = false
        lists.removeAll()
        myTableView.reloadData()
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        print (#fileID, #function, #line, "- addbuttoncliked")
    
        deleteButton.isEnabled = true
        //스토리보드 불러오기
        let storyboard : UIStoryboard = UIStoryboard(name: "DetialVC", bundle: nil)
        //guard let - 예외처리
        //DetialVC 라는 스토리보드 ID가 있는 DetialVC 가 있다면 그 뷰컨을 DetialVC라고 정하고,
        //위의 것이 없다면 else { return }
        guard let DetialVC = storyboard.instantiateViewController(withIdentifier: "DetialVC") as? DetialVC else { return }
        
        //델리겟을 서로 연결 해주기위한것
        //여기서 self는 ListTableView
        DetialVC.delegate = self
        
        //ListTableView 안의 navigationController가 pushViewController를 실행한다.
        self.navigationController?.pushViewController(DetialVC, animated: true)
        
        myTableView.reloadData()
        }
    }

extension ListTableVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GanuniCell", for: indexPath) as! GanuniCell
        
        cell.myNameLabel.text = lists[indexPath.row].nameLabel
        cell.myPriceLabel.text = lists[indexPath.row].priceLabel
        cell.myNumLabel.text = lists[indexPath.row].numLabel
        
        //셀 설정
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 10
        cell.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        return cell
    }
}


//MARK: 네비게이션 관련 델리겟
extension ListTableVC : NavigationPoppedDelegate {
    //호출 되었을때 들어오는 이벤트 
    func popped(sender: UIViewController) {
        //poped 되면서 textfield 의 내용을 셀에 저장
        //DetailVC 의 textField를 가져오기위해 sender
        if let getText = sender as? DetialVC {
            let getName = getText.nameTextField.text ?? ""
            let getPrice = getText.priceTextField.text ?? ""
            let getNum = getText.numTextField.text ?? ""
            
            let sendData = Ganuni(nameLabel: getName, priceLabel: getPrice, numLabel: getNum)
            //테이블뷰를 보여주는 것은 리스트 - 리스트에 insert(추가) 
            self.lists.insert(sendData, at: 0)
            myTableView.reloadData()
            
            
            print (#fileID, #function, #line, "- sendData: \(sendData)")
            
        }
    }
}
