//
//  HomeViewCell.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 4.11.2023.
//

import UIKit

final class HomeViewCell: UICollectionViewCell {
    // MARK: - UIElements
    private let cellContainer: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 35
        view.backgroundColor = .red
        return view
    }()
    private let dateLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.text = "12.05.2023 - 20.06.2023"
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "TOTAL Bill Amount"
        return label
    }()
    private let priceLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "1590 TL"
        label.textColor = .white
        return label
    }()
    private let imageTitleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "Split with"
        return label
    }()
    private let detailTitleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.text = "Details >"
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    private let image: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 30
        image.image = UIImage(named: "aytug")
        return image
    }()
    // MARK: - Properties
    var titlePriceStackView: UIStackView!
    
    // MARK: - Enums
    enum HomeIdentifier: String {
        case custom = "HomeViewCell"
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
extension HomeViewCell {
    private func style() {
        cellContainer.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        titlePriceStackView = UIStackView(arrangedSubviews: [titleLabel,priceLabel])
        titlePriceStackView.axis = .vertical
        titlePriceStackView.spacing = 2
        titlePriceStackView.translatesAutoresizingMaskIntoConstraints = false
        imageTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        detailTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        cellContainer.addSubview(dateLabel)
        cellContainer.addSubview(titlePriceStackView)
        cellContainer.addSubview(imageTitleLabel)
        cellContainer.addSubview(image)
        cellContainer.addSubview(detailTitleLabel)
        addSubview(cellContainer)
        NSLayoutConstraint.activate([
            cellContainer.topAnchor.constraint(equalTo: topAnchor,constant: 4),
            cellContainer.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -4),
            cellContainer.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 12),
            cellContainer.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -12),
            dateLabel.topAnchor.constraint(equalTo: cellContainer.topAnchor, constant: 6),
            dateLabel.trailingAnchor.constraint(equalTo: cellContainer.trailingAnchor, constant: -26),
            titlePriceStackView.topAnchor.constraint(equalTo: cellContainer.topAnchor, constant: 22),
            titlePriceStackView.leadingAnchor.constraint(equalTo: cellContainer.leadingAnchor, constant: 22),
            imageTitleLabel.topAnchor.constraint(equalTo: titlePriceStackView.topAnchor, constant: 50),
            imageTitleLabel.leadingAnchor.constraint(equalTo: cellContainer.leadingAnchor, constant: 22),
            imageTitleLabel.trailingAnchor.constraint(equalTo: cellContainer.leadingAnchor, constant: 100),
            image.heightAnchor.constraint(equalToConstant: 45),
            image.widthAnchor.constraint(equalToConstant: 45),
            image.centerYAnchor.constraint(equalTo: imageTitleLabel.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: imageTitleLabel.leadingAnchor, constant: 80),
            detailTitleLabel.bottomAnchor.constraint(equalTo: cellContainer.bottomAnchor, constant: -8),
            detailTitleLabel.trailingAnchor.constraint(equalTo: cellContainer.trailingAnchor, constant: -26)
        ])
    }
}
