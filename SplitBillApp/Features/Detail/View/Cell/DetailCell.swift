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
    // MARK: - Properties
    var fullStackView: UIStackView!
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
        fullStackView = UIStackView(arrangedSubviews: [image,nameLabel,priceLabel])
        fullStackView.axis = .horizontal
       fullStackView.spacing = 20
        fullStackView.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        addSubview(fullStackView)
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 55),
            nameLabel.widthAnchor.constraint(equalToConstant: 210),
            fullStackView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            fullStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 2),
            fullStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            fullStackView.trailingAnchor.constraint(equalTo: trailingAnchor ),
        ])
    }
}
