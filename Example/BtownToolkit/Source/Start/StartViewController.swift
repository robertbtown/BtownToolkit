//
//  StartViewController.swift
//  BtownToolkit
//
//  Created by Robert Magnusson on 2016-10-01.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

// swiftlint:disable line_length

import UIKit

class StartViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    let viewModel = StartViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
}

// MARK: TableViewDelegate

extension StartViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let featureItem = viewModel.featureItem(atIndexPath: indexPath)
        navigationController?.pushViewController(featureItem.viewController, animated: true)
    }
}

// MARK: TableViewDatasource

extension StartViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.featureItems.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "cellIdentifier"
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)

        let featureItem = viewModel.featureItem(atIndexPath: indexPath)

        tableViewCell.textLabel?.text = featureItem.name
        tableViewCell.detailTextLabel?.text = featureItem.shortInfoText

        return tableViewCell
    }
}
