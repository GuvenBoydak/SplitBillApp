//
//  DetailUserViewController.swift
//  SplitBillApp
//
//  Created by Güven Boydak on 4.11.2023.
//

import UIKit

final class DetailUserViewController: UITableViewController {
    // MARK: - UIElements

    // MARK: - Properties
    var detailUsers: [DetailUser]? {
        didSet { DispatchQueue.main.async {
                self.tableView.reloadData()
            }}
    }
    
    // MARK: - Life Cycle
    init() {
        super.init(style: .plain)
        style()
        tableView.isScrollEnabled = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Helpers
extension DetailUserViewController {
    private func style() {
        tableView.allowsSelection = false
        tableView.register(DetailUserCell.self, forCellReuseIdentifier: DetailUserCell.DetailUserIdentifier.custom.rawValue)
    }
}
// MARK: - UiTableViewDataSource
extension DetailUserViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let detailUsers = detailUsers else { return 0}
        return detailUsers.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailUserCell.DetailUserIdentifier.custom.rawValue, for: indexPath) as! DetailUserCell
        if let detailUser = detailUsers?[indexPath.row] { cell.detailUser = detailUser}
        return cell
    }
}
