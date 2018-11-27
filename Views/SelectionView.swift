//
//  SelectionView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 11/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class SelectionView: UIView {

  // MARK: - Properties

  public var titleLabel: UILabel = {
    let titleLabel = UILabel(frame: CGRect.zero)
    titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
    titleLabel.textColor = AppColor.TextColors.White
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return titleLabel
  }()

  lazy var cancelButton: UIButton = {
    let cancelButton = UIButton(frame: CGRect.zero)
    cancelButton.setTitle("cancel".localized, for: .normal)
    cancelButton.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .highlighted)
    cancelButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    return cancelButton
  }()

  lazy var headerView: UIView = {
    let headerView = UIView(frame: CGRect.zero)
    headerView.backgroundColor = AppColor.BarColors.Green
    headerView.addSubview(titleLabel)
    headerView.translatesAutoresizingMaskIntoConstraints = false
    return headerView
  }()

  lazy var searchBar: UISearchBar = {
    let searchBar = UISearchBar(frame: CGRect.zero)
    searchBar.searchBarStyle = .minimal
    searchBar.autocapitalizationType = .none
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    return searchBar
  }()

  lazy var createButton: UIButton = {
    let createButton = UIButton(frame: CGRect.zero)
    createButton.setTitleColor(AppColor.TextColors.Green, for: .normal)
    createButton.setTitleColor(AppColor.TextColors.LightGreen, for: .highlighted)
    createButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    createButton.translatesAutoresizingMaskIntoConstraints = false
    return createButton
  }()

  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: CGRect.zero)
    tableView.separatorInset = UIEdgeInsets.zero
    let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1 / UIScreen.main.scale)
    let line = UIView(frame: frame)
    line.backgroundColor = tableView.separatorColor
    tableView.tableHeaderView = line
    tableView.tableFooterView = UIView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()


  lazy var dimView: UIView = {
    let dimView = UIView(frame: CGRect.zero)
    dimView.backgroundColor = UIColor.black
    dimView.alpha = 0.6
    dimView.isHidden = true
    dimView.translatesAutoresizingMaskIntoConstraints = false
    return dimView
  }()

  var addInterventionViewController: AddInterventionViewController?
  var isSearching: Bool = false
  var tableViewTopAnchor: NSLayoutConstraint!

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  private func setupView() {
    isHidden = true
    backgroundColor = UIColor.white
    layer.cornerRadius = 5
    clipsToBounds = true
    addSubview(headerView)
    addSubview(cancelButton)
    addSubview(searchBar)
    addSubview(createButton)
    addSubview(tableView)
    addSubview(dimView)
    setupLayout()
  }

  private func setupLayout() {
    tableViewTopAnchor = tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 40)

    NSLayoutConstraint.activate([
      titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
      headerView.topAnchor.constraint(equalTo: topAnchor),
      cancelButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
      cancelButton.heightAnchor.constraint(equalTo: headerView.heightAnchor),
      cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      headerView.heightAnchor.constraint(equalToConstant: 60),
      headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
      searchBar.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
      searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      createButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 2.5),
      createButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      tableViewTopAnchor,
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
      tableView.leftAnchor.constraint(equalTo: leftAnchor),
      tableView.rightAnchor.constraint(equalTo: rightAnchor),
      dimView.topAnchor.constraint(equalTo: topAnchor),
      dimView.bottomAnchor.constraint(equalTo: bottomAnchor),
      dimView.leftAnchor.constraint(equalTo: leftAnchor),
      dimView.rightAnchor.constraint(equalTo: rightAnchor)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    endEditing(true)
  }

  // MARK: - Actions

  @objc private func closeView() {
    guard let parentVC = parentViewController as? AddInterventionViewController else { return }
    isHidden = true
    parentVC.dimView.isHidden = true

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
    })

    searchBar.endEditing(true)
    searchBar.text = nil
    isSearching = false
    tableViewTopAnchor.constant = 40
    createButton.isHidden = false
    tableView.reloadData()
  }
}
