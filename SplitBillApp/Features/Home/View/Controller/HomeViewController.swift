//
//  HomeViewController.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 4.11.2023.
//

import UIKit

protocol HomeViewProtocol: AnyObject {
    func prepareView()
    func prepareWillAppear()
    func reloadData()
}

final class HomeViewController: UICollectionViewController {
    // MARK: - UIElements
    private let headerLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Transaction"
        return label
    }()
    
    // MARK: - Properties
    private lazy var homeVM = HomeViewModel()

    // MARK: - Life Cycle
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        homeVM.view = self
        homeVM.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        homeVM.willAppear()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Selectors
extension HomeViewController {
    @objc private func addNewTransaction() {
        let alertController = UIAlertController(title: "Dikkat", message: "Yeni bir Transaction olusturacaksiniz EMINMISINIZ?", preferredStyle: .alert)
        let okeyActions = UIAlertAction(title: "Evet", style: .default) { _ in
            let transactionId = self.homeVM.createTransaction()
            self.pushViewController(transactionId: transactionId)
        }
        let cancelActions = UIAlertAction(title: "Hayir", style: .cancel)
        alertController.addAction(okeyActions)
        alertController.addAction(cancelActions)
        self.present(alertController, animated: true)
    }
    
    private func pushViewController(transactionId: String) {
        let detailVC = DetailViewController()
        if transactionId != "" {
            detailVC.transactionId = transactionId
        }
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       homeVM.numberOfTransaction()
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewCell.HomeIdentifier.custom.rawValue, for: indexPath) as! HomeViewCell
        cell.transaction = homeVM.cellForItem(at: indexPath)
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushViewController(transactionId: homeVM.transactions[indexPath.item].id ?? "")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 112)
    }
}

// MARK: - HomeViewProtocol
extension HomeViewController: HomeViewProtocol {
    func prepareView() {
        view.backgroundColor = .white
        collectionView.register(HomeViewCell.self, forCellWithReuseIdentifier: HomeViewCell.HomeIdentifier.custom.rawValue)
        navigationItem.rightBarButtonItem = UIBarButtonItem( barButtonSystemItem:.add, target: self, action: #selector(addNewTransaction))
        style()
        layout()
    }
    
    func prepareWillAppear() {
        Task {
            await homeVM.fechtTransactions()
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - Helpers
extension HomeViewController {
    private func style() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        view.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.heightAnchor.constraint(equalToConstant: 20),
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            collectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor,constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -12),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 12)
        ])
    }
}
