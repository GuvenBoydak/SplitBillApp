//
//  DetailViewModel.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 10.11.2023.
//

import Foundation

protocol DetailViewModelProtocol {
    var view: DetailViewProtocol? {get set }
    func viewDidLoad()
    func willAppear()
    func fechtBills(transactionId: String) async
    func detailBillUser() -> [DetailUser]
    func numberOfBills() -> Int
    func cellForItem(at indexPath: IndexPath) -> Bill
    func fechtTransaction(transactionId: String)
    func calculateTotalAmount() -> Double
}

final class DetailViewModel {
    var bills = [Bill]()
    var transaction = Transaction()
    weak var view: DetailViewProtocol?
    
}

// MARK: - DetailViewModelProtocol
extension DetailViewModel: DetailViewModelProtocol {
    func viewDidLoad() {
        view?.prepareView()
    }
    
    func willAppear() {
        view?.prepareWillAppear()
    }
    
    func fechtBills(transactionId: String) async {
        do {
            bills = try await BillService.shared.fetchBills(transactionId: transactionId)
        } catch let error {
            print(error)
        }
        view?.reloadData()
    }
    
    func numberOfBills() -> Int {
        bills.count
    }
    
    func cellForItem(at indexPath: IndexPath) -> Bill {
        bills[indexPath.item]
    }

    func detailBillUser() -> [DetailUser] {
        var detailUsers = [DetailUser]()
        let totalAmount = calculateTotalAmount()

        bills.forEach { bill in
            guard let userCount = bill.splitUser?.count, userCount > 0 else { return }
            
            let amount = totalAmount / Double(userCount)
            detailUsers = bill.splitUser?.map {
                let isPaying = bill.payingUser?.id == $0.id
                let userAmount = isPaying ? (amount * Double((userCount - 1))) : amount
            
               if detailUsers.count > 0 {
                    for index in detailUsers.indices {
                        if $0.id == detailUsers[index].id && bill.payingUser?.id == detailUsers[index].id {
                            let price = detailUsers[index].isPay ? detailUsers[index].amount + userAmount : detailUsers[index].amount - userAmount
                            detailUsers[index].updateAmount(newAmount: price)
                        } else {
                            let price = detailUsers[index].isPay ? detailUsers[index].amount - userAmount : detailUsers[index].amount + userAmount
                            detailUsers[index].updateAmount(newAmount: price)
                        }
                    }
                }
                
                return DetailUser(
                    id: $0.id,
                    amount: userAmount,
                    name: $0.firstname,
                    isPay: isPaying,
                    imageUrl: $0.imageUrl)
            } ?? []
        }
        return detailUsers
    }

     func calculateTotalAmount() -> Double {
        return bills.reduce(0) { result, bill in
            return result + (bill.amount ?? 0)
        }
    }
    
    func fechtTransaction(transactionId: String) {
        Task {
            transaction =  try await TransactionService.shared.fetchTransaction(transactionId: transactionId) ?? Transaction()
        }
    }

}
