//
//  ListOfGroceryVC.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 27/11/23.
//

import Foundation
import UIKit
import SnapKit
import MFRBottomSheet
import Charts
import DGCharts

enum TableViewDiffableSection: Hashable {
    case main
}

class ListOfGroceryVC: CommonViewController {
    
    private lazy var searchBar = builder(UISearchBar.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.returnKeyType = .done
        $0.enablesReturnKeyAutomatically = false
        $0.delegate = self
    }
    
    private lazy var tableView: UITableView = builder(UITableView.self) {
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(ListOfGroceryCell.self)
        $0.allowsSelection = true
        $0.keyboardDismissMode = .onDrag
        $0.isUserInteractionEnabled = true
        $0.delegate = self
    }
    
    private lazy var containerContent = builder(UIView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
    }
    
    private lazy var separator = builder(UIView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .gray
    }
    
    private lazy var pieChart = builder(PieChartView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.transparentCircleRadiusPercent = 0.25
        $0.drawSlicesUnderHoleEnabled = false
        $0.holeRadiusPercent = 0.2
        $0.legend.form = .circle
        $0.legend.horizontalAlignment = .center
        $0.delegate = self
    }
    
    private lazy var bottomView = builder(ListOfGroceryBottomView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.didTapButton = { [weak self] in
            self?.openCard()
        }
    }
    
    private lazy var emptyState: EmptyStateView = builder(EmptyStateView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.messageText = "Duh datanya belum ada nih. Tambahin dulu yuk!"
    }
    
    private lazy var infoLabel = builder(UILabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 12)
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = .black
        $0.text = "Geser item ke kiri untuk menghapus ataupun mengedit datanya"
        $0.isHidden = true
    }
    
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    private lazy var dataSource: UITableViewDiffableDataSource<TableViewDiffableSection, Item> = {
        let source = UITableViewDiffableDataSource<TableViewDiffableSection, Item>(tableView: tableView) { [weak self] table, indexPath, itemModel in
            guard let cell = table.dequeueReusableCell(ListOfGroceryCell.self, for: indexPath) else { return UITableViewCell() }
            cell.applyWith(itemModel)
            return cell
        }
        return source
    }()
    
    private var verificationCard: MFRBaseBottomSheet?
    private var editItemCard: MFRBaseBottomSheet?
    private var selectIndexPath: IndexPath?
    private var itemID: String?
    
    var viewModel: GroceryVM?
    var searchText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Grocery"
        setupNavigationItem()
        setupView()
        setupViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.getItemData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.didDisappear()
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(searchBar)
        self.view.addSubview(containerContent)
        containerContent.addSubview(infoLabel)
        containerContent.addSubview(pieChart)
        containerContent.addSubview(separator)
        containerContent.addSubview(tableView)
        self.view.addSubview(bottomView)
        self.view.addSubview(emptyState)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAction))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        bottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        searchBar.snp.makeConstraints { make in
            make.left.top.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerContent.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        
        pieChart.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(screenWidth * 0.5)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(pieChart.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(separator.snp.bottom).offset(16)
            make.bottom.equalTo(infoLabel.snp.top)
        }
        
        emptyState.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-32)
        }
    }
    
    func setupNavigationItem() {
        let image = UIImage(systemName: "list.bullet.clipboard.fill")
        let listItemButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(listItemButtonAction))
        self.navigationItem.setRightBarButtonItems([listItemButton], animated: true)
    }
    
    func setupViewModel() {
        viewModel?.listenDatas = { [weak self] datas in
            self?.setupchart(datas)
            self?.setupBottomView(datas, for: "")
            self?.setupDataSource(datas)
            self?.emptyState.isHidden = !datas.isEmpty ? true : false
            self?.containerContent.isHidden = datas.isEmpty ? true : false
        }
        
        viewModel?.listenDataTable = { [weak self] datas, type in
            self?.setupDataSource(datas)
            self?.setupBottomView(datas, for: type)
        }
        
        viewModel?.getItemData()
    }
    
    private func setupDataSource(_ datas: [Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<TableViewDiffableSection, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(datas, toSection: .main)
        dataSource.applySnapshotUsingReloadData(snapshot)
    }
    
    private func setupBottomView(_ datas: [Item], for type: String) {
        let inTotals = datas.compactMap({ Double($0.itemQunatity) * $0.itemPrice })
        let grandTotal = inTotals.sum
        let typeInTitle = type.isEmpty ? ":" : " \(type):"
        bottomView.grandTotal = grandTotal.asThousandIDR
        bottomView.title = "Grand Total\(typeInTitle)"
    }
    
    private func setupchart(_ datas: [Item]) {
        let types = HouseholdConstant.itemType
        let dataGrouping = types.compactMap { type in
            let qty: [Double] = datas.compactMap {
                guard $0.itemType == type.key else { return nil }
                return Double($0.itemQunatity) * $0.itemPrice
            }
            let sum = qty.sum
            return PieChartDataEntry(value: sum, label: type.value)
        }
        
        let dataSet = PieChartDataSet(entries: dataGrouping, label: "")
        dataSet.colors = HouseholdConstant.chartColors
        dataSet.sliceSpace = 2
        dataSet.valueTextColor = .black
        dataSet.yValuePosition = .outsideSlice
        dataSet.valueLinePart1Length = 0.5
        dataSet.valueLinePart2Length = 2
        dataSet.entryLabelFont = .systemFont(ofSize: 10)
        
        let data = PieChartData(dataSets: [dataSet])
        data.setValueFormatter(PieChartValueFormatter())
        pieChart.data = data
    }
    
    func openCard(with model: Item? = nil) {
        let card = GroceryAddCard2()
        card.groceryCardDelegate = self
        if let model = model {
            card.prefilledData = model.asGorecyCardModel
        }
        let cardController = MFRBottomSheetController(bottomSheet: card, isPortraitOnly: true)
        cardController.show(from: self, animated: true, completion: nil)
    }
    
    func openVerificationCard(itemName: String) {
        verificationCard = self.showVerificationCard(delegate: self) {
            $0.title = "Yakin nih mau di delete?"
            $0.subtitle = itemName
        }
    }
    
    @objc
    private func listItemButtonAction() {
        dismissKeyboardAction()
        viewModel?.openToDoListPage()
    }
    
    @objc
    private func dismissKeyboardAction() {
        self.view.endEditing(true)
    }
}

extension ListOfGroceryVC: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let pieData = entry as? PieChartDataEntry else { return }
        print(pieData.label ?? "")
        viewModel?.selectedPieChart(pieData.label ?? "")
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        viewModel?.nothingSelectedPieChart()
    }
}

extension ListOfGroceryVC: GroceryAddCard2Delegate {
    func groceryCard(_ card: GroceryAddCard2, type save: GroceryCardType, data: GroceryModel) {
        if save == .add {
            viewModel?.saveNewItem(from: data)
        } else if save == .edit {
            viewModel?.updateItem(from: data)
        }
    }
}

extension ListOfGroceryVC: MFRBaseBottomSheetDelegate {
    func bottomSheet(_ bottomSheet: MFRBaseBottomSheet, didDismiss withInfo: Any?, animated: Bool) {
        defer {
            itemID = nil
            verificationCard = nil
        }
        if bottomSheet == verificationCard {
            verificationCardHandler(withInfo)
        } else if bottomSheet == editItemCard {
            editCardDismissHandler(withInfo)
        }
    }
    
    private func verificationCardHandler(_ withInfo: Any?) {
        guard let buttonTapped = withInfo as? VerificationCardButtonTap,
              let itemID = itemID,
              buttonTapped == .right else { return }
        viewModel?.deleteItem(itemID: itemID)
    }
    
    private func editCardDismissHandler(_ withInfo: Any?) {
        defer { selectIndexPath = nil }
        
        guard let infoAsDict = withInfo as? [String: EditItemActionType],
              let type = infoAsDict["type"],
              let selectIndexPath else { return }
        let data = self.dataSource.itemIdentifier(for: selectIndexPath)
        
        switch type {
        case .edit:
            openCard(with: data)
        case .delete:
            itemID = data?.itemID
            openVerificationCard(itemName: data?.itemName ?? "")
        default:
            return
        }
    }
}

extension ListOfGroceryVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissKeyboardAction()
        selectIndexPath = indexPath
        editItemCard = self.showEditItemCard(with: [.edit, .delete], delegate: self)
    }
}

extension ListOfGroceryVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        defer { searchText = nil }
        guard let searchText else { return }
        viewModel?.searchItem(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
