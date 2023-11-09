//
//  WhoIsPayCell.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 5.11.2023.
//

import UIKit

final class WhoIsPayCell: UICollectionViewCell {
    // MARK: - UIElements
    private let cellContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 34
        view.backgroundColor = .lightGray
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
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.text = "Janyt Dow"
        return label
    }()
    // MARK: - Properties
    var user: User? {
        didSet { configure() }
    }
    // MARK: - Enums
    enum WhoIsPayIdentifier: String {
        case custom = "WhoIsPayCell"
    }
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Helpers
extension WhoIsPayCell {
    private func style() {

        cellContainer.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        cellContainer.addSubview(image)
        cellContainer.addSubview(nameLabel)
        addSubview(cellContainer)
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 48),
            image.heightAnchor.constraint(equalToConstant: 48),
            cellContainer.topAnchor.constraint(equalTo: topAnchor),
            cellContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            image.centerXAnchor.constraint(equalTo: cellContainer.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: cellContainer.centerYAnchor,constant: -8),
            nameLabel.topAnchor.constraint(equalTo: image.bottomAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: image.centerXAnchor),
        ])
    }
    private func configure() {
        guard let data = user else { return }
        nameLabel.text = data.firstname
        image.setPicture(url: data.imageUrl)
    }
}
