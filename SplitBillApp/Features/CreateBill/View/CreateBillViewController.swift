//
//  CreateBillViewController.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 5.11.2023.
//

import UIKit
protocol DidSelectUserProtocol: AnyObject {
    func didSelectWhoIsPayUser(user: User)
}

final class CreateBillViewController: UICollectionViewController {
    // MARK: - UIElements
    private let imageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "button")
        view.layer.cornerRadius = 20
        return view
    }()
    private let billImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.image = UIImage(named: "aytug")
        image.isUserInteractionEnabled = true
        return image
    }()
    private let amountLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Amount"
        return label
    }()
    private let amountTextField: UITextField = {
       let textField = UITextField()
        textField.backgroundColor = .white
        return textField
    }()
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Title"
        return label
    }()
    private let titleTextField: UITextField = {
       let textField = UITextField()
        textField.backgroundColor = .white
        return textField
    }()
    private let dateLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Date"
        return label
    }()
    private let datePicker: UIDatePicker = {
       let date = UIDatePicker()
        return date
    }()
    private let whoIsPayLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Who Is Pay"
        return label
    }()
    private let splitWithLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Split With"
        return label
    }()
    private let saveButton: UIButton = {
       let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemYellow
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 18
        return button
    }()
    private let addUserButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "add"), for: .normal)
        button.layer.cornerRadius = 20
        return button
    }()
    private let addLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.text = "Add"
        return label
    }()
    private let addUPayUserButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "add"), for: .normal)
        button.layer.cornerRadius = 20
        return button
    }()
    private let addPayLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.text = "Add"
        return label
    }()
    // MARK: - Properties
    var userList: [User]? {
        didSet { DispatchQueue.main.async {
            self.collectionView.reloadData()
        }}
    }
    var bill = Bill()
    var createBillVM = CreateBillViewModel()
    var createUserVM = CreateUserViewModel()
    var whoIsPayVC = WhoIsPayViewController()
    // MARK: - Life Cycle
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        super.init(collectionViewLayout: flowLayout)
        style()
        saveButton.addTarget(self, action: #selector(addBill), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(getDateFromPicker), for: .valueChanged)
        addUserButton.addTarget(self, action: #selector(addUser), for: .touchUpInside)
        addUPayUserButton.addTarget(self, action: #selector(addUser), for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(billImageTapped))
        billImage.addGestureRecognizer(tapGestureRecognizer)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fechtUsers()
        whoIsPayVC.delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Selector {
extension CreateBillViewController {
   @objc private func addBill() {
       if let amount = Double(amountTextField.text ?? "0.0"),let title = titleTextField.text {
           bill.amount = amount
           bill.title = title
       }
    }
    @objc private func getDateFromPicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        bill.date = dateFormatter.string(from: sender.date)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        bill.time = timeFormatter.string(from: sender.date)
     }
    @objc private func addUser() {
        let createUserVC = CreateUserViewController()
        present(createUserVC, animated: true)
    }
}
 // MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension CreateBillViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func billImageTapped(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }

        ImageHelper().createAndReturnURL(fileName: UUID().uuidString, data: imageData) { (url) in
            guard let url = url else { return }
            self.bill.imageUrl = url
        }
        dismiss(animated: true)
    }
}
// MARK: - UICollectionViewDataSource
extension CreateBillViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let users = userList else { return 0 }
        return users.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WhoIsSharingCell.WhoIsSharingIdentifier.custom.rawValue, for: indexPath) as! WhoIsSharingCell
        if let user = userList?[indexPath.item] { cell.user = user }
        cell.delegate = self
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let user = userList?[indexPath.item] {
            bill.splitUser?.append(user)
        }
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension CreateBillViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width , height: 80)
    }
}
// MARK: DidSelectUserProtocol
extension CreateBillViewController: DidSelectUserProtocol {
    func didSelectWhoIsPayUser(user: User) {
        bill.payingUser = user
    }
}
// MARK: - UpdateUserProtocol
extension CreateBillViewController: UpdateUserProtocol {
    func updateUser(user: User) {
        if user.isChecked { bill.splitUser?.append(user) }
        else { bill.splitUser?.removeAll { $0.id == user.id } }
        createUserVM.updateUser(user: user)
        fechtUsers()
    }
}
// MARK: - Helpers
extension CreateBillViewController {
    func fechtUsers() {
        createUserVM.fechtUsers { response, error in
            if error != nil { print(error?.localizedDescription ?? ""); return}
            if let users = response {
                self.userList = users
            }
        }
    }
    private func style() {
        view.backgroundColor =  UIColor(named: "background")
        navigationItem.title = "NEW Bill"
        collectionView.layer.cornerRadius = 30
        collectionView.backgroundColor = .lightText
        collectionView.allowsMultipleSelection = true
        collectionView.register(WhoIsSharingCell.self, forCellWithReuseIdentifier: WhoIsSharingCell.WhoIsSharingIdentifier.custom.rawValue)
        let views: [UIView] = [collectionView,imageContainer,billImage,amountTextField,amountLabel,titleTextField,titleLabel,dateLabel,datePicker,whoIsPayVC.view,whoIsPayLabel,saveButton,splitWithLabel,addUserButton,addLabel,addUPayUserButton,addPayLabel]
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        layout()
    }
    private func layout() {
        imageContainer.addSubview(billImage)
        NSLayoutConstraint.activate([
            //ImageContainer
            imageContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            imageContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageContainer.widthAnchor.constraint(equalToConstant: 150),
            imageContainer.heightAnchor.constraint(equalToConstant: 110),
            // billImage
            billImage.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            billImage.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
            billImage.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            billImage.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            // amountTextField and amountLabel
            amountTextField.heightAnchor.constraint(equalToConstant: 32),
            amountTextField.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 8),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 56),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -56),
            amountLabel.leadingAnchor.constraint(equalTo: amountTextField.leadingAnchor),
            amountLabel.bottomAnchor.constraint(equalTo: amountTextField.topAnchor, constant: 8),
            // titleLabel and titleTextLabel
            titleTextField.heightAnchor.constraint(equalToConstant: 32),
            titleTextField.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 56),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -56),
            titleLabel.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleTextField.topAnchor, constant: 8),
            // dataLabel and datePicker
            datePicker.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -56),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 56),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: datePicker.centerYAnchor),
            // whoisPayLabel and whoIsPayVC
            whoIsPayLabel.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 8),
            whoIsPayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            whoIsPayVC.view.topAnchor.constraint(equalTo: whoIsPayLabel.bottomAnchor, constant: 8),
            whoIsPayVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 14),
            whoIsPayVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -72),
            whoIsPayVC.view.heightAnchor.constraint(equalToConstant: 70),
            // addPayUserButton and addPayLabel
            addUPayUserButton.widthAnchor.constraint(equalToConstant: 30),
            addUPayUserButton.heightAnchor.constraint(equalToConstant: 30),
            addUPayUserButton.centerYAnchor.constraint(equalTo: whoIsPayVC.view.centerYAnchor,constant: -10),
            addUPayUserButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            addPayLabel.centerXAnchor.constraint(equalTo: addUPayUserButton.centerXAnchor),
            addPayLabel.topAnchor.constraint(equalTo: addUPayUserButton.bottomAnchor, constant: 1),
            // SplitWithLabel and collectionView
            splitWithLabel.topAnchor.constraint(equalTo: whoIsPayVC.view.bottomAnchor, constant: 8),
            splitWithLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: splitWithLabel.bottomAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: saveButton.topAnchor,constant: -50),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -14),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 14),
            // addUserButton and addLabel
            addUserButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor,constant: 4),
            addUserButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addUserButton.widthAnchor.constraint(equalToConstant: 25),
            addUserButton.heightAnchor.constraint(equalToConstant: 25),
            addLabel.topAnchor.constraint(equalTo: addUserButton.bottomAnchor),
            addLabel.centerXAnchor.constraint(equalTo: addUserButton.centerXAnchor),
            // saveButton
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 180),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
