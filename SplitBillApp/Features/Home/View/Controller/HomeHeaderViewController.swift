//
//  HomeHeaderView.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 4.11.2023.
//

import UIKit

final class HomeHeaderViewController: UIViewController {
    // MARK: - UIElements
    private let headerContainer: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 35
        return view
    }()
    private let dateLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "12.05.2023 - 20.06.2023"
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "TOTAL Bill Amount"
        return label
    }()
    private let priceLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "1590 TL"
        label.textColor = .white
        return label
    }()
    private let imageTitleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Split with"
        return label
    }()
    private let detailTitleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
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
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        style()
        layout()
    }
}
// MARK: - Helpers
extension HomeHeaderViewController {
    private func style() {
        view.backgroundColor = .red
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        titlePriceStackView = UIStackView(arrangedSubviews: [titleLabel,priceLabel])
        titlePriceStackView.axis = .vertical
        titlePriceStackView.spacing = 4
        titlePriceStackView.translatesAutoresizingMaskIntoConstraints = false
        imageTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        detailTitleLabel.translatesAutoresizingMaskIntoConstraints = false

    }
    private func layout() {
        headerContainer.addSubview(dateLabel)
        headerContainer.addSubview(titlePriceStackView)
        headerContainer.addSubview(imageTitleLabel)
        headerContainer.addSubview(image)
        headerContainer.addSubview(detailTitleLabel)
        view.addSubview(headerContainer)
        
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: view.topAnchor),
            headerContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 12),
            dateLabel.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 6),
            dateLabel.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor,constant: -26),
            dateLabel.leadingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -175),
            titlePriceStackView.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 24),
            titlePriceStackView.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 22),
            imageTitleLabel.topAnchor.constraint(equalTo: titlePriceStackView.bottomAnchor, constant: 22),
            imageTitleLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 22),
            image.heightAnchor.constraint(equalToConstant: 50),
            image.widthAnchor.constraint(equalToConstant: 50),
            image.topAnchor.constraint(equalTo: imageTitleLabel.bottomAnchor, constant: 2),
            image.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 22),
            detailTitleLabel.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: -12),
            detailTitleLabel.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor,constant: -26)
        ])
    }
}
