//
//  Post.swift
//  ganuni
//
//  Created by jy on 4/30/24.
//

import Foundation
import RealmSwift

struct Ganuni {
    var id: String = UUID().uuidString
    var nameLabel : String?
    var priceLabel : String?
    var numLabel : String?
    
    //총금액
    var totalPrice : Int {
        let priceValue :Int = Int(self.priceLabel ?? "") ?? 0
        let numValue :Int = Int(self.numLabel ?? "") ?? 0
        
        return priceValue * numValue
    }
    
    init(nameLabel: String? = nil, priceLabel: String? = nil, numLabel: String? = nil) {
        self.nameLabel = nameLabel
        self.priceLabel = priceLabel
        self.numLabel = numLabel
    }
    
    init(_ entity: DataRealmModel) {
        self.id = entity._id.stringValue
        self.nameLabel = entity.nameLabel ?? ""
        self.priceLabel = entity.priceLabel ?? ""
        self.numLabel = entity.numLabel ?? ""
        //self.totalPrice = entity.totalPrice ??
    }
}
