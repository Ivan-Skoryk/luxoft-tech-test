//
//  QuotesListViewController.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import UIKit

final class QuotesListViewController: UIViewController {
    private enum Constants {
        static var cellIdentifier = "QuotesCell"
    }
    private let dataManager: DataManager = DataManager()
    private var market: Market? = nil

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        market = Market()
        setupTableView()
        fetchQuotes()
    }

    func setupView() {
        title = "Quotes List"
        view.backgroundColor = .white
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        tableView.register(UINib(nibName: "QuotesTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)

        tableView.reloadData()
    }

    func fetchQuotes() {
        dataManager.fetchQuotes { [weak self] result in
            switch result {
            case .success(let quotes):
                guard let self = self else { return }
                self.market?.addQuotes(quotes)

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            case .failure(let error):
                print(error.description)
            }
        }
    }
}

extension QuotesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return market?.quotesCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let quote = market?.getQuote(at: indexPath.row) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! QuotesTableViewCell

        cell.setup(with: quote)
        
        return cell
    }
}

extension QuotesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let quote = market?.getQuote(at: indexPath.row) else { return }
        let viewController = QuoteDetailsViewController(quote: quote)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
