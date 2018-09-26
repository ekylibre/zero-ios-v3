//
//  MaterialsView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 26/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class MaterialsView: UIView, UISearchBarDelegate {

  // MARK: - Properties

  public var titleLabel: UILabel = {
    let titleLabel = UILabel(frame: CGRect.zero)
    titleLabel.text = "Sélectionnez un matériau"
    titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
    titleLabel.textColor = AppColor.TextColors.White
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return titleLabel
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
    searchBar.delegate = self
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    return searchBar
  }()

  lazy var createButton: UIButton = {
    let createButton = UIButton(frame: CGRect.zero)
    createButton.setTitle("+ CRÉER UN NOUVEAU MATÉRIAU", for: .normal)
    createButton.setTitleColor(AppColor.TextColors.Green, for: .normal)
    createButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    createButton.translatesAutoresizingMaskIntoConstraints = false
    return createButton
  }()

  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: CGRect.zero)
    tableView.separatorInset = UIEdgeInsets.zero
    tableView.tableFooterView = UIView()
    tableView.bounces = false
    tableView.register(PlotCell.self, forCellReuseIdentifier: "PlotCell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()
}
