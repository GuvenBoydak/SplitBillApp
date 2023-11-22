//
//  DetailViewController.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 4.11.2023.
//

import UIKit
protocol DetailViewProtocol: AnyObject {
    func prepareView()
    func prepareWillAppear()
    func reloadData()
}

final class DetailViewController: UICollectionViewController {
    // MARK: - UIElements
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
        label.text = ""
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    private let addBillButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "add"), for: .normal)
        button.backgroundColor = UIColor(named: "button")
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 26
        return button
    }()
    
    // MARK: - Properties
    lazy var detailUserVC = DetailUserViewController()
    private lazy var detailVM = DetailViewModel()
    var transactionId: String? {
        didSet {
            fechtTransaction()
        }
    }
    
    // MARK: - Life Cycle
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        detailVM.view = self
        detailVM.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailVM.view?.prepareWillAppear()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDataSource
extension DetailViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        detailVM.numberOfBills()
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCell.DetailIdentifier.custom.rawValue
                                                      , for: indexPath) as! DetailCell
        cell.bill = detailVM.cellForItem(at: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 50)
    }
}

// MARK: - Selector
extension DetailViewController {
    @objc private func addBillButtonTapped() {
        let createBillVC = CreateBillViewController()
        createBillVC.transactionId = detailVM.transaction.id ?? ""
        navigationController?.pushViewController(createBillVC, animated: true)
    }
}

// MARK: - DetailViewProtocol
extension DetailViewController: DetailViewProtocol {
    func prepareView() {
        navigationItem.title = "Transaction"
        addBillButton.addTarget(self
                                , action: #selector(addBillButtonTapped)
                                , for: .touchUpInside)
        view.backgroundColor = .white
        collectionView.register(DetailCell.self, forCellWithReuseIdentifier: DetailCell.DetailIdentifier.custom.rawValue)
        style()
        setup()
    }
    func prepareWillAppear() {
        Task {
            await detailVM.fechtBills(transactionId: transactionId ?? "")
            detailUserVC.detailUsers = detailVM.detailBillUser()
            priceLabel.text = "\(detailVM.calculateTotalAmount()) TL"
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - Helpers
extension DetailViewController {
    private func style() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        detailUserVC.view.translatesAutoresizingMaskIntoConstraints = false
        detailContainer.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        addBillButton.translatesAutoresizingMaskIntoConstraints = false
    }
    private func setup() {
        view.addSubview(detailUserVC.view)
        detailContainer.addSubview(dateLabel)
        detailContainer.addSubview(titleLabel)
        detailContainer.addSubview(priceLabel)
        view.addSubview(detailContainer)
        view.addSubview(addBillButton)
        
        NSLayoutConstraint.activate([
            detailContainer.heightAnchor.constraint(equalToConstant: 100),
            detailContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
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
            detailUserVC.view.heightAnchor.constraint(equalToConstant: 170),
            detailUserVC.view.topAnchor.constraint(equalTo: detailContainer.bottomAnchor,constant: 12),
            detailUserVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            detailUserVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.topAnchor.constraint(equalTo: detailUserVC.view.bottomAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -22),
            addBillButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addBillButton.heightAnchor.constraint(equalToConstant: 55),
            addBillButton.widthAnchor.constraint(equalToConstant: 55),
            addBillButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func fechtTransaction() {
        guard let id = transactionId else { return }
        detailVM.fechtTransaction(transactionId: id)
    }
}
