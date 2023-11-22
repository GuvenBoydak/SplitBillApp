//
//  Transaction.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 6.11.2023.
//

import Foundation

struct Transaction {
    var id: String?
    var bill: [Bill]?
    var createdDate: String?
    var updatedDate: String?
    
    init(id: String, bill: [Bill], createdDate: String, updatedDate: String) {
        self.id = id
        self.bill = bill
        self.createdDate = createdDate
        self.updatedDate = updatedDate
    }
    init() {
        self.bill = []
    }
}
