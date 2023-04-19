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

    private let tableView = UITableView()
    private lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "No Data"

        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
        ])
        label.isHidden = true
        return label
    }()

    private var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        market = Market()
        setupTableView()
        fetchQuotes()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    private func setupView() {
        title = "Quotes List"
        view.backgroundColor = .white
    }

    private func setupTableView() {
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

        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.addSubview(refreshControl)

        tableView.reloadData()
    }

    @objc func refreshTableView() {
        fetchQuotes()
    }

    private func fetchQuotes() {
        dataManager.fetchQuotes { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let quotes):
                self.market?.addQuotes(quotes)

                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.tableView.isHidden = false
                    self.noDataLabel.isHidden = true
                    self.tableView.reloadData()
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.noDataLabel.text = error.description
                    self.noDataLabel.isHidden = false
                    self.tableView.isHidden = true
                }
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
        guard let quote = market?.getQuote(at: indexPath.row) else { return }
        let viewController = QuoteDetailsViewController(quote: quote)
        viewController.favoriteUpdateClosure = { [weak self] quote in
            self?.market?.updateFavoriteForQuote(quote)
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(viewController, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
