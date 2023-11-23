//
//  HomeViewModel.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 6.11.2023.
//

import Foundation

protocol HomeViewModelProtocol {
    var view: HomeViewProtocol? { get set}
    func viewDidLoad()
    func willAppear()
    func fechtTransactions() async
    func numberOfTransaction() -> Int
    func cellForItem(at indexPath: IndexPath) -> Transaction
}

final class HomeViewModel{
    weak var view: HomeViewProtocol?
    var transactions = [Transaction]()
}

// MARK: - HomeViewModelProtocol
extension HomeViewModel: HomeViewModelProtocol  {
    func viewDidLoad() {
        view?.prepareView()
    }
    
    func willAppear() {
        view?.prepareWillAppear()
    }
    
    func fechtTransactions() async  {
        
        self.transactions = try! await TransactionService.shared.fechtTransactions()
    
        view?.reloadData()
    }
    
    func numberOfTransaction() -> Int {
        transactions.count
    }
    
    func cellForItem(at indexPath: IndexPath) -> Transaction {
        transactions[indexPath.item]
    }
    
    func createTransaction() -> String{
        TransactionService.shared.createTransaction()
    }
}
