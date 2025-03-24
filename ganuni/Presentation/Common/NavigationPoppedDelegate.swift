//
//  NavigationPoppedDelegate.swift
//  ganuni
//
//  Created by jy on 4/10/24.
//

import Foundation
import UIKit

protocol NavigationPoppedDelegate{
    
    //팝이 되었다.
    // - parameter sender: 팝이 된 뷰컨트롤러
    func popped(sender: UIViewController)
}
