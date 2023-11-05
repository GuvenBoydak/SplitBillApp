//
//  DetailViewController.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 4.11.2023.
//

import UIKit

final class DetailViewController: UICollectionViewController {
    // MARK: - UIElements
    private let transactionLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Transaction"
        return label
    }()
    private let detailContainer: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 35
        view.backgroundColor = .red
        return view
    }()
    private let dateLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.text = "12.05.2023 - 25.09.2023"
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "TOTAL Bill Amount"
        label.textAlignment = .center
        return label
    }()
    private let priceLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "2950 TL"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    // MARK: - Properties
    var detailUserVC = DetailUserViewController()
    // MARK: - Life Cycle
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        style()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Helpers
extension DetailViewController {
    private func style() {
        view.backgroundColor = .white
        collectionView.register(DetailCell.self, forCellWithReuseIdentifier: DetailCell.DetailIdentifier.custom.rawValue)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        detailUserVC.view.translatesAutoresizingMaskIntoConstraints = false
        detailContainer.translatesAutoresizingMaskIntoConstraints = false
        transactionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    private func setup() {
        view.addSubview(detailUserVC.view)
        detailContainer.addSubview(dateLabel)
        detailContainer.addSubview(titleLabel)
        detailContainer.addSubview(priceLabel)
        view.addSubview(detailContainer)
        view.addSubview(transactionLabel)
        NSLayoutConstraint.activate([
            transactionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            transactionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            detailContainer.heightAnchor.constraint(equalToConstant: 100),
            detailContainer.topAnchor.constraint(equalTo: transactionLabel.bottomAnchor, constant: 8),
            detailContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            detailContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            dateLabel.topAnchor.constraint(equalTo: detailContainer.topAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: detailContainer.trailingAnchor, constant: -22),
            titleLabel.topAnchor.constraint(equalTo: detailContainer.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: detailContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: detailContainer.trailingAnchor),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            priceLabel.leadingAnchor.constraint(equalTo: detailContainer.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: detailContainer.trailingAnchor),
            detailUserVC.view.heightAnchor.constraint(equalToConstant: 200),
            detailUserVC.view.topAnchor.constraint(equalTo: detailContainer.bottomAnchor,constant: 20),
            detailUserVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            detailUserVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.topAnchor.constraint(equalTo: detailUserVC.view.bottomAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
// MARK: - UICollectionViewDataSource
extension DetailViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCell.DetailIdentifier.custom.rawValue, for: indexPath) as! DetailCell
        return cell
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 50)
    }
}
