//
//  BillService.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 17.11.2023.
//

import Foundation

final class BillService {
    static var shared = BillService()
    
    func createBill(bill: Bill) {
        guard let amount = bill.amount
                ,let title = bill.title
                ,let date = bill.date
                ,let time = bill.time
                ,let payingUser = bill.payingUser
                ,let splitUser = bill.splitUser
                ,let transantionId = bill.transaction?.id else { return}
        let params : [String:Any] = ["id":"",
                                     "title":title,
                                     "amount":amount,
                                     "date":date,
                                     "time":time,
                                     "payingUserId":payingUser.id,
                                     "splitUsersId":splitUser.map{$0.id},
                                     "imageURL":bill.imageUrl ?? "",
                                     "transactionId":"j56G63igVIdzxENzIuE7"]
        FIREBASE_BILL.addDocument(data: params) { error in
            if error != nil { print(error?.localizedDescription ?? ""); return}
        }
    }
    
    func fetchBills(transactionId: String) async throws -> [Bill] {
        let snapshot = try await FIREBASE_BILL.whereField("transactionId", isEqualTo: "j56G63igVIdzxENzIuE7").getDocuments()
        
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
            bill.splitUser = try await UserService.shared.fetchSplitUsers(splitUser)

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
                
                var bill = Bill(id: id, title: title, amount: amount, date: date, time: time, imageUrl: imageURL)
                
                bill.payingUser = try await UserService.shared.fetchPayingUser(payingUser)
                bill.splitUser = try await UserService.shared.fetchSplitUsers(splitUser)
                
                bills.append(bill)
            }
        }
        return bills
    }
}
