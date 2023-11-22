//
//  DetailUserCell.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 4.11.2023.
//

import UIKit

final class DetailUserCell: UITableViewCell {
    // MARK: - UIElements
    private let plusContainer: UIView = {
        let view = UIView()
        return view
    }()
    private let minusContainer: UIView = {
        let view = UIView()
        return view
    }()
    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        image.image = UIImage(named: "aytug")
        return image
    }()
    private let priceLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "+ 150 TL"
        return label
    }()
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Jony"
        return label
    }()
    private let priceSecoundLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "+ 150 TL"
        label.textColor = .black
        return label
    }()
    private let nameScoundLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Jony"
        return label
    }()
    private let minusProgresBar: UIProgressView = {
       let progresBar = UIProgressView()
        progresBar.progress = 0.0
        progresBar.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        progresBar.trackTintColor = UIColor.white
        progresBar.progressTintColor = .red
        return progresBar
    }()
    private let plusProgresBar: UIProgressView = {
       let progresBar = UIProgressView()
        progresBar.progress = 0.0
        progresBar.trackTintColor = UIColor.white
        progresBar.progressTintColor = .cyan
        return progresBar
    }()
    
    // MARK: - Properties
    var isMinus = false
    var detailUser: DetailUser? {
        didSet { configure() }
    }
    
    // MARK: - Enums
    enum DetailUserIdentifier: String {
        case custom = "DetailUserCell"
    }
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Helpers
extension DetailUserCell {
    private func configure() {
        guard let data = detailUser else { return }
        profileImage.setPicture(url: data.imageUrl)
        if data.isPay {
            nameLabel.text  = ""
            nameScoundLabel.text = data.name
        } else {
            nameLabel.text = data.name
            nameScoundLabel.text = ""
        }
        if data.isPay {
            priceSecoundLabel.text = ""
            priceLabel.text  = " +\(String(format: "%.2f", data.amount))"
            minusProgresBar.setProgress(Float(data.amount) / 1000, animated: true)
        } else {
            priceSecoundLabel.text = "-\(String(format: "%.2f", data.amount))"
            priceLabel.text = ""
            plusProgresBar.setProgress(Float(data.amount) / 1000, animated: true)
        }
    }
    private func setup() {
        minusContainer.translatesAutoresizingMaskIntoConstraints = false
        plusContainer.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceSecoundLabel.translatesAutoresizingMaskIntoConstraints = false
        nameScoundLabel.translatesAutoresizingMaskIntoConstraints = false
        minusProgresBar.translatesAutoresizingMaskIntoConstraints = false
        plusProgresBar.translatesAutoresizingMaskIntoConstraints = false
        profileImage.translatesAutoresizingMaskIntoConstraints = false
    }
    private func layout() {
        minusContainer.addSubview(minusProgresBar)
        plusContainer.addSubview(plusProgresBar)
        minusContainer.addSubview(nameLabel)
        minusContainer.addSubview(priceLabel)
        minusContainer.addSubview(priceSecoundLabel)
        minusContainer.addSubview(nameScoundLabel)
        plusContainer.addSubview(nameLabel)
        plusContainer.addSubview(priceLabel)
        plusContainer.addSubview(priceSecoundLabel)
        plusContainer.addSubview(nameScoundLabel)
        addSubview(profileImage)
        addSubview(minusContainer)
        addSubview(plusContainer)
        NSLayoutConstraint.activate([
            minusContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            minusContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            minusContainer.widthAnchor.constraint(equalToConstant: 160),
            minusContainer.heightAnchor.constraint(equalToConstant: 45),
            plusContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            plusContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            plusContainer.widthAnchor.constraint(equalToConstant: 160),
            plusContainer.heightAnchor.constraint(equalToConstant: 45),
            minusProgresBar.trailingAnchor.constraint(equalTo: minusContainer.trailingAnchor),
            minusProgresBar.leadingAnchor.constraint(equalTo: minusContainer.leadingAnchor),
            minusProgresBar.heightAnchor.constraint(equalToConstant: 25),
            minusProgresBar.centerYAnchor.constraint(equalTo: centerYAnchor),
            plusProgresBar.trailingAnchor.constraint(equalTo: plusContainer.trailingAnchor),
            plusProgresBar.leadingAnchor.constraint(equalTo: plusContainer.leadingAnchor),
            plusProgresBar.heightAnchor.constraint(equalToConstant: 25),
            plusProgresBar.centerYAnchor.constraint(equalTo: centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: minusContainer.leadingAnchor, constant: 150),
            priceLabel.centerYAnchor.constraint(equalTo: minusContainer.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: minusContainer.leadingAnchor, constant: 150),
            nameLabel.centerYAnchor.constraint(equalTo: minusContainer.centerYAnchor),
            priceSecoundLabel.leadingAnchor.constraint(equalTo: plusProgresBar.leadingAnchor,constant: 8),
            priceSecoundLabel.centerYAnchor.constraint(equalTo: plusProgresBar.centerYAnchor),
            nameScoundLabel.leadingAnchor.constraint(equalTo: plusProgresBar.leadingAnchor,constant: 8),
            nameScoundLabel.centerYAnchor.constraint(equalTo: plusContainer.centerYAnchor),
            profileImage.centerYAnchor.constraint(equalTo: plusContainer.centerYAnchor),
            profileImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 40),
            profileImage.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
