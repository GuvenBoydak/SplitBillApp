//
//  Bill.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 6.11.2023.
//

import Foundation

struct Bill {
    var id: String?
    var title: String?
    var amount: Double?
    var date: String?
    var time: String?
    var payingUser: User?
    var splitUser: [User]?
    var transaction: Transaction?
    var imageUrl: String?
    
    init(id: String, title: String, amount: Double, date: String,time: String, imageUrl: String) {
        self.id = id
        self.title = title
        self.amount = amount
        self.date = date
        self.time = time
        //self.payingUser = User()
        self.splitUser = [User]()
        self.imageUrl = imageUrl
    }
    
    init() {
        self.splitUser = []
    }
}
