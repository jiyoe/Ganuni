//
//  DetailVC.swift
//  ganuni
//
//  Created by jy on 4/1/24.
//

import Foundation
import UIKit

class DetailVC : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var numTextField: UITextField!
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    //추가화면 -> add , 수정화면 -> edit
    enum ViewType {
        case add
        case edit
    }
    //기본 형태는 add
    var viewType: ViewType = .add
    
    var myDelegate : ListTableVC? = nil
    //델리겟 변수로 두기
    var delegate : NavigationPoppedDelegate? = nil
    var isExpand : Bool = false
    //가누니 데이터(넘겨받은 데이터)
    var detailData : Ganuni? = nil
    //dismiss 되면서 데이터를 받아오기 위한 값을 가져오기 - 클로져
    var dismissedWithData : ((String) -> Void)? = nil
    
    //데이터 기반으로 저장
    var nameValue : String = "" {
        didSet {
            print (#fileID, #function, #line, "- nameValue: \(nameValue)")
            self.saveBtn.isEnabled = isAllinputFilled
        }
    }
    var priceValue : String = "" {
        didSet {
            print (#fileID, #function, #line, "- priceValue: \(priceValue)")
            self.saveBtn.isEnabled = isAllinputFilled
        }
    }
    var numberValue : String = "" {
        didSet {
            print (#fileID, #function, #line, "- numberValue: \(numberValue)")
            self.saveBtn.isEnabled = isAllinputFilled
        }
    }
    
    //0이상 일때를 확인
    var isAllinputFilled : Bool {
        return nameValue.count > 0 && priceValue.count > 0 && numberValue.count > 0
    }
    
    //viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //textField가 비어있지 않으면 버튼 활성화
        if isAllinputFilled == false {
            self.saveBtn?.isEnabled = false
        } else {
            self.saveBtn?.isEnabled = true
        }
    }
    
    //viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        //입력하는 화면으로 전환시 nameTextField에 포커스온
        nameTextField.becomeFirstResponder()
    }
    
    fileprivate func keyboardSetHeight() {
        //키보드올라간 만큼 화면 올리고 내리기
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardApperence(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func backBtnSet() {
        //backBtn - setting
        let backBarBtn = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(handleBackButton(_:)))
        backBarBtn.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarBtn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print (#fileID, #function, #line, "- <#comment#>")
        
        nameValue = detailData?.nameLabel ?? ""
        priceValue = detailData?.priceLabel ?? ""
        numberValue = detailData?.numLabel ?? ""
        
        self.nameTextField.text = nameValue
        self.priceTextField.text = priceValue
        self.numTextField.text = numberValue
        
        self.saveBtn.isEnabled = isAllinputFilled
        
        allLabel.shadowColor = UIColor.black
        allLabel.layer.shadowOffset = CGSize(width: 0, height: 5)
        allLabel.layer.shadowOpacity = 0.3
        allLabel.layer.shadowRadius = 5.0
        allLabel.layer.masksToBounds = true
        
        allLabel.layer.cornerRadius = 10
        allLabel.layer.masksToBounds = true
        
        nameTextField.delegate = self
        numTextField.delegate = self
        priceTextField.delegate = self
        
        //빈화면클릭시 키보드 내려가는 함수 호출
        self.hideKeyboardWhenTappedAround()
        
        backBtnSet()
        
        //saveBtn - 비어있을때의 설정
        nameTextField.addTarget(self, action:  #selector(textFieldDidChange(_:)),  for:.editingChanged )
        numTextField.addTarget(self, action:  #selector(textFieldDidChange(_:)),  for:.editingChanged )
        priceTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        keyboardSetHeight()
    }
    
    //키보드 사용시 화면 올리기
    @objc func keyboardApperence(notification: NSNotification){
        if !isExpand{
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                
                let keyboardHeight = keyboardFrame.cgRectValue.height
                //스크롤 가능영역을 조절(콘텐트 사이즈)
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height + keyboardHeight)
                //스크롤뷰를 스크롤 하라고 작성
                self.scrollView.scrollToView(view: nameTextField, threshold: 145)
            }
            else{
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height + 250)
            }
            isExpand = true
        }
    }
    
    //키보드 사용시 화면 내리기
    @objc func keyboardDisappear(notification: NSNotification){
        if isExpand{
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                //스크롤 가능영역을 조절(콘텐트 사이즈)
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height - keyboardHeight)
            }
            else{
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height - 250)
            }
            isExpand = false
        }
    }
    
    //키보드에서 next 버튼 누르면 다음 텍스트필드로 넘어가서 입력 가능하게 하기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.nameTextField:
            self.priceTextField.becomeFirstResponder()
        case self.priceTextField:
            self.numTextField.becomeFirstResponder()
        default:
            self.numTextField.resignFirstResponder()
        }
        return true
    }
    
    //textfield comma
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == nameTextField {
            return true
        }
        
        if ((string == "0" || string == "") && (textField.text! as NSString).range(of: ".").location < range.location) {
            return true
        }
        
        // First check whether the replacement string's numeric...
        let cs = NSCharacterSet(charactersIn: "0123456789.").inverted
        let filtered = string.components(separatedBy: cs)
        let component = filtered.joined(separator: "")
        let isNumeric = string == component
        
        // Then if the replacement string's numeric, or if it's
        // a backspace, or if it's a decimal point and the text
        // field doesn't already contain a decimal point,
        // reformat the new complete number using
        if isNumeric {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 8
            // Combine the new text with the old; then remove any
            // commas from the textField before formatting
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let numberWithOutCommas = newString.replacingOccurrences(of: ",", with: "")
            let number = formatter.number(from: numberWithOutCommas)
            if number != nil {
                var formattedString = formatter.string(from: number!)
                // If the last entry was a decimal or a zero after a decimal,
                // re-add it here because the formatter will naturally remove
                // it.
                if string == "." && range.location == textField.text?.count {
                    formattedString = formattedString?.appending(".")
                }
                textField.text = formattedString
            } else {
                textField.text = nil
            }
            if textField == priceTextField {
                self.priceValue = textField.text ?? ""
                print ( "- priceValue: \(priceValue)")
            }
            
            if textField == numTextField {
                self.numberValue = textField.text ?? ""
                print ( "- numberValue: \(numberValue)")
            }
            
        }
        return false
    }
    
    //saveBtn - selector
    @objc private func textFieldDidChange(_ sender:UITextField) {
        
        print (#fileID, #function, #line, "- sender: \(sender.text ?? "")")
        
        if sender == nameTextField {
            nameValue = sender.text ?? ""
        }
        
        if nameTextField.text == "" || numTextField.text == "" || priceTextField.text == "" {
            saveBtn.isEnabled = false;
        }else{
            saveBtn.isEnabled = true;
        }
        
    }
    
    //backBtn - selector
    @objc private func handleBackButton(_ sender: UIBarButtonItem){
        print (#fileID, #function, #line, "- <#comment#>")
        
        UIAlertController.createAlert(parent: self,
                                      yesClicked: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    //saveBtn
    @IBAction func clickedSaveButton(_ sender: Any) {
        
        print (#fileID, #function, #line, "- clicked save button")
        
        let viewType = self.viewType
        
        switch viewType {
        case .add:
            RealmPostStore.shared.addPostItem(nameLabel: nameValue, priceLabel: priceValue, numLabel: numberValue)
        case .edit:
            RealmPostStore.shared.updatePostItem(id: detailData?.id ?? "", nameLabel: nameValue, priceLabel: priceValue, numLabel: numberValue)
        }
        
        //여기서 델리겟 터트리기
        self.delegate?.popped(sender: self)
        
        //NotificationCenter post - checkVC
        NotificationCenter.default.post(
            name: .NotificationPopEvent,
            object: nil,
            userInfo: ["name": nameValue,
                       "price": priceValue,
                       "number":numberValue]
        )
        
        //NotificationCenter post - ListTableVC
        NotificationCenter.default.post(
            name : .GanuniUpdateEvent,
            object: nil,
            userInfo: ["id" : detailData?.id ?? "",
                       "name" : nameValue,
                       "price" : priceValue,
                       "number" : numberValue ]
        )
        //화면 되돌리기 pop!
        self.navigationController?.popViewController(animated: true)
    }
}

//빈화면 클릭하면 키보드 사라지게 구현
extension DetailVC {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyBoard() {
        view.endEditing(true)
    }
}

extension UIScrollView {
    
    /// 해당 뷰 위치로 이동하기
    /// - Parameters:
    ///   - view:
    ///   - animated:
    func scrollToView(view:UIView, threshold: CGFloat = 0.0, animated: Bool = true) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            
            let childYPosition = childStartPoint.y - threshold
            
            self.scrollRectToVisible(CGRect(x:0, y:childYPosition,width: 1,height: self.frame.height), animated: animated)
        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool = true) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom(animated: Bool = true) {
        
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: animated)
        }
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter
    }()
}

extension Numeric {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}

extension UIAlertController {
    static func createAlert(parent: UIViewController,
                            title: String = "확인",
                            message: String = "취소하시겠습니까?",
                            yesClicked: (() -> Void)? = nil,
                            noClicked: (() -> Void)? = nil
    ) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("YES", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            yesClicked?()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("NO", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"Cancle\" alert occured.")
            noClicked?()
        }))
        
        parent.present(alert, animated: true, completion: nil)
        
        return alert
    }
}
