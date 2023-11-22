//
//  TransactionService.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 19.11.2023.
//

import Foundation

final class TransactionService {
    static var shared = TransactionService()
    
    func fetchTransaction(transactionId: String) async throws -> Transaction? {
        do {
            let snapshot = try await FIREBASE_TRANSACTION.document(transactionId).getDocument()

            if let data = snapshot.data() {
                let id = snapshot.documentID
                let billIds = data["billId"] as? [String] ?? [""]
                let createdDate = data["createdDate"] as? String ?? ""
                let updatedDate = data["updatedDate"] as? String ?? ""
                
               let bills = try await BillService.shared.fetchBills(billIds: billIds)

                let transaction = Transaction(id: id, bill: bills, createdDate: createdDate, updatedDate: updatedDate)

                return transaction
            }
        } catch {
            throw error
        }
        return nil
    }
    
    
    func fechtTransactions() async throws -> [Transaction] {
        do {
            var transactions = [Transaction]()
            let snapshots = try  await FIREBASE_TRANSACTION.getDocuments()
            
            for document in snapshots.documents {
                let data = document.data()
                   let id = document.documentID
                    let billIds = data["billId"] as? [String] ?? [""]
                    let createdDate = data["createdDate"] as? String ?? ""
                    let updatedDate = data["updatedDate"] as? String ?? ""
                    
                   let bills = try await BillService.shared.fetchBills(billIds: billIds)
                    
                let transaction = Transaction(id: id,bill: bills,createdDate: createdDate, updatedDate: updatedDate)
                transactions.append(transaction)
            }
            
            return transactions
        } catch let error {
            throw error
        }
    }
    
    func createTransaction() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let params: [String:Any] = ["id": ""
                                    ,"billId":""
                                    ,"createdDate":dateFormatter.string(from: Date())
                                    ,"updatedDate":""]
            return FIREBASE_TRANSACTION.addDocument(data: params).documentID
    }
    
    func updateTransaction(transaction: Transaction) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let params: [String:Any] = ["id": transaction.id ?? ""
                                    ,"billId":transaction.bill?.map { $0.id } ?? []
                                    ,"createdDate": transaction.createdDate ?? ""
                                    ,"updatedDate":dateFormatter.string(for: Date()) ?? ""]
        FIREBASE_TRANSACTION.document(transaction.id ?? "").setData(params)
    }
}
