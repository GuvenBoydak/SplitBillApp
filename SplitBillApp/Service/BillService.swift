//
//  BillService.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 17.11.2023.
//

import Foundation

final class BillService {
    static var shared = BillService()
    
    func createBill(bill: Bill) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let amount = bill.amount
                ,let title = bill.title
                ,let payingUser = bill.payingUser
                ,let splitUser = bill.splitUser 
                ,let transantionId = bill.transaction?.id else { return ""}
        let params : [String:Any] = ["id":"",
                                     "title":title,
                                     "amount":amount,
                                     "date":bill.date ?? dateFormatter.string(from: Date()) ,
                                     "time":bill.time ?? "",
                                     "payingUserId":payingUser.id,
                                     "splitUsersId":splitUser.map{$0.id},
                                     "imageURL":bill.imageUrl ?? "",
                                     "transactionId": transantionId]
        return FIREBASE_BILL.addDocument(data: params).documentID
    }
    
    func fetchBills(transactionId: String) async throws -> [Bill] {
        let snapshot = try await FIREBASE_BILL.whereField("transactionId", isEqualTo: transactionId).getDocuments()
        
        var bills: [Bill] = []

        for document in snapshot.documents {
            let data = document.data()
            let id = document.documentID
            let title = data["title"] as? String ?? ""
            let amount = data["amount"] as? Double ?? 0
            let date = data["date"] as? String ?? ""
            let time = data["time"] as? String ?? ""
            let imageURL = data["imageURL"] as? String ?? ""
            let payingUser = data["payingUserId"] as? String ?? ""
            let splitUser = data["splitUsersId"] as? [String] ?? []

            var bill = Bill(id: id, title: title, amount: amount, date: date, time: time, imageUrl: imageURL)

            bill.payingUser = try await UserService.shared.fetchPayingUser(payingUser)
            bill.splitUser = try await UserService.shared.fetchSplitUsers(splitUser,transactionId: transactionId)

            bills.append(bill)
        }
        return bills
    }
    
    func fetchBills(billIds: [String]) async throws -> [Bill] {
        let snapshot = try await FIREBASE_BILL.getDocuments()
        
        var bills: [Bill] = []

        for document in snapshot.documents {
            let data = document.data()
            let id = document.documentID
            if billIds.contains(id) {
                let title = data["title"] as? String ?? ""
                let amount = data["amount"] as? Double ?? 0
                let date = data["date"] as? String ?? ""
                let time = data["time"] as? String ?? ""
                let imageURL = data["imageURL"] as? String ?? ""
                let payingUser = data["payingUserId"] as? String ?? ""
                let splitUser = data["splitUsersId"] as? [String] ?? []
                let transactionId = data["transactionId"] as? String ?? ""
                
                var bill = Bill(id: id, title: title, amount: amount, date: date, time: time, imageUrl: imageURL)
                
                bill.payingUser = try await UserService.shared.fetchPayingUser(payingUser)
                bill.splitUser = try await UserService.shared.fetchSplitUsers(splitUser,transactionId: transactionId)
                
                bills.append(bill)
            }
        }
        return bills
    }
}
