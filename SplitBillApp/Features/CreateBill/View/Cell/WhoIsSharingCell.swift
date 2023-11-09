//
//  WhoIsSharingCell.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 5.11.2023.
//

import UIKit
protocol UpdateUserProtocol: AnyObject {
    func updateUser(index: IndexPath)
}

final class WhoIsSharingCell: UICollectionViewCell {
    // MARK: - UIElements
    private let cellContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 34
        view.backgroundColor = UIColor(named: "button")
        return view
    }()
    private let imageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 30
        return view
    }()
    private let image: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 25
        image.clipsToBounds = true
        image.image = UIImage(systemName: "person.circle")
        image.tintColor = .black
        return image
    }()
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Janyt Dow"
        return label
    }()
    private let amountLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "-50"
        return label
    }()
    private let checkBoxButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "checked"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        return button
    }()
    // MARK: - Properties
    var user: User? {
        didSet { configure() }
    }
   weak var delegate: UpdateUserProtocol?
    var indexPath: IndexPath?
    // MARK: - Enums
    enum WhoIsSharingIdentifier: String {
        case custom = "WhoIsSharingCell"
    }
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        checkBoxButton.addTarget(self, action: #selector(updateUser), for: .touchUpInside)
        style()
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Helpers
extension WhoIsSharingCell {
    private func style() {
        backgroundColor = UIColor(named: "background")
        let views: [UIView] = [cellContainer,amountLabel,nameLabel,checkBoxButton,image]
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }

    }
    private func layout() {
        NSLayoutConstraint.activate([
            // image
            image.widthAnchor.constraint(equalToConstant: 50),
            image.heightAnchor.constraint(equalToConstant: 50),
            image.leadingAnchor.constraint(equalTo: cellContainer.leadingAnchor, constant: 10),
            image.centerYAnchor.constraint(equalTo: cellContainer.centerYAnchor),
            // cellContainer
            cellContainer.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            cellContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            cellContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cellContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            //nameLabel and amountLabel
            nameLabel.centerXAnchor.constraint(equalTo: cellContainer.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: cellContainer.centerYAnchor, constant: -14),
            amountLabel.centerXAnchor.constraint(equalTo: cellContainer.centerXAnchor),
            amountLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            // checkBoxButton
            checkBoxButton.widthAnchor.constraint(equalToConstant: 25),
            checkBoxButton.heightAnchor.constraint(equalToConstant: 25),
            checkBoxButton.trailingAnchor.constraint(equalTo: cellContainer.trailingAnchor, constant: -30),
            checkBoxButton.centerYAnchor.constraint(equalTo: cellContainer.centerYAnchor),
        ])
    }
    private func configure() {
        guard let data = user else { return }
        nameLabel.text = "\(data.firstname) \(data.lastname)"
        image.setPicture(url: data.imageUrl)
        if data.isChecked {
            checkBoxButton.setImage(UIImage(named: "checked"), for: .normal)
        } else {
            checkBoxButton.setImage(UIImage(named: "unchecked"), for: .normal)
        }

    }
}
// MARK: - Selector
extension WhoIsSharingCell {
  @objc  private func updateUser() {
        if let index = indexPath, let protocolDelegate = delegate {
            protocolDelegate.updateUser(index: index)
        }
    }
}

