//
//  DetailUser.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 15.11.2023.
//

import Foundation

struct DetailUser {
    var id: String
    var amount: Double
    var name: String
    var isPay: Bool
    var imageUrl: String
    
    mutating func updateAmount(newAmount: Double) {
         self.amount = newAmount
     }
    
}
