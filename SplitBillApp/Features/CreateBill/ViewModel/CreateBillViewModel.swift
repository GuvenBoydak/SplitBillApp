//
//  CreateBillViewModel.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 6.11.2023.
//

import Foundation
import UIKit

final class CreateBillViewModel {
    
    
}
// MARK: - CreateBillViewModelProtocol
extension CreateBillViewModel: CreateBillViewModelProtocol {
    func createNewBill(bill: Bill) -> String {
        guard let amount = bill.amount,let title = bill.title,let date = bill.date,let time = bill.time,let payingUser = bill.payingUser,let splitUser = bill.splitUser, let imageUrl = bill.imageUrl else { return ""}
        let params : [String:Any] = ["id":"",
                                     "title":title,
                                     "amount":amount,
                                     "date":date,
                                     "time":time,
                                     "payingUserId":payingUser.id,
                                     "splitUser":splitUser.map{$0.id},
                                     "imageURL":imageUrl]
        return FIREBASE_BILL.addDocument(data: params) { error in
            if error != nil { print(error?.localizedDescription ?? "")}
        }.documentID
    }
}
