//
//  HomeViewController.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 4.11.2023.
//

import UIKit

final class HomeViewController: UICollectionViewController{
    // MARK: - UIElements
    private let headerLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Transaction"
        return label
    }()
    private let collectionLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Latest Transaction"
        return label
    }()
    // MARK: - Properties
    var homeHeaderVC = HomeHeaderViewController()
    // MARK: - Life Cycle
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
       style()
       layout()
        navigationItem.rightBarButtonItem = UIBarButtonItem( barButtonSystemItem:.add, target: self, action: #selector(addNewTransaction))
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Helpers
extension HomeViewController {
    private func style() {
        view.backgroundColor = .white
        collectionView.register(HomeViewCell.self, forCellWithReuseIdentifier: HomeViewCell.HomeIdentifier.custom.rawValue)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionLabel.translatesAutoresizingMaskIntoConstraints = false
        homeHeaderVC.view.translatesAutoresizingMaskIntoConstraints = false
        homeHeaderVC.view.layer.cornerRadius = 35
    }
    private func layout() {
        view.addSubview(homeHeaderVC.view)
        view.addSubview(headerLabel)
        view.addSubview(collectionLabel)
        NSLayoutConstraint.activate([
            headerLabel.heightAnchor.constraint(equalToConstant: 20),
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            homeHeaderVC.view.heightAnchor.constraint(lessThanOrEqualToConstant: 180),
            homeHeaderVC.view.topAnchor.constraint(equalTo: headerLabel.bottomAnchor,constant: 8),
            homeHeaderVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            homeHeaderVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            collectionLabel.heightAnchor.constraint(equalToConstant: 20),
            collectionLabel.topAnchor.constraint(equalTo: homeHeaderVC.view.bottomAnchor,constant: 8),
            collectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            collectionView.topAnchor.constraint(equalTo: collectionLabel.bottomAnchor,constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -12),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 12)
        ])
    }
}
// MARK: - Selectors
extension HomeViewController {
    @objc private func addNewTransaction() {
        
    }
}
// MARK: - UICollectionViewDataSource
extension HomeViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewCell.HomeIdentifier.custom.rawValue, for: indexPath) as! HomeViewCell
        return cell
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 120)
    }
}
