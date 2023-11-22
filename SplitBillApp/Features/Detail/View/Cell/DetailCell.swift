//
//  DetailCell.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 4.11.2023.
//

import UIKit

final class DetailCell: UICollectionViewCell {
    // MARK: - UIElements
    private let image: UIImageView = {
       let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        image.image = UIImage(named: "aytug")
        return image
    }()
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.text = "Hotel"
        return label
    }()
    private let priceLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.text = "155 TL"
        label.textColor = .red
        return label
    }()
    private let dateLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "15.02.2022"
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Properties
    var priceDetailStackView: UIStackView!
    var fullStackView: UIStackView!

    var bill: Bill? {
        didSet { configure() }
    }
    
    // MARK: - Enums
    enum DetailIdentifier: String {
        case custom = "DetailCell"
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
extension DetailCell {
    private func style() {
        priceDetailStackView = UIStackView(arrangedSubviews: [priceLabel,dateLabel])
        priceDetailStackView.axis = .vertical
        fullStackView = UIStackView(arrangedSubviews: [image,nameLabel,priceDetailStackView])
        fullStackView.axis = .horizontal
        fullStackView.spacing = 20
        fullStackView.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        addSubview(fullStackView)
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 50),
            image.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.widthAnchor.constraint(equalToConstant: 200),
            fullStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            fullStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    private func configure() {
        guard let data = bill else { return }
        image.setPicture(url: data.imageUrl ?? "")
        nameLabel.text = data.title
        priceLabel.text = "\(data.amount ?? 0)"
        dateLabel.text = data.date
    }
}
