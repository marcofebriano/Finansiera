//
//  ListOfPeriodVC.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 07/12/23.
//

import Foundation
import UIKit
import SnapKit
import MFRBottomSheet
import DGCharts

public struct PeriodSection: Hashable {
    var title: String
}

class ListOfPeriodVC: CommonViewController {
    
    private lazy var addButton = builder(UIButton.self) {
        let image = UIImage(systemName: "plus")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(self.addButtonTapped), for: .touchUpInside)
        $0.setImage(image, for: .normal)
        $0.backgroundColor = .mainGreen
    }
    
    private lazy var infoLabel = builder(UILabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 12)
        $0.textAlignment = .center
        $0.textColor = .black
        $0.text = "Geser item ke kiri untuk menghapus datanya"
    }
    
    private lazy var emptyState: EmptyStateView = builder(EmptyStateView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.messageText = "Duh datanya belum ada nih. Tambahin dulu yuk!"
    }
    
    private lazy var tableView = builder(UITableView.self) {
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.insetsContentViewsToSafeArea = false
        $0.sectionHeaderTopPadding = 0
        $0.backgroundColor = .white
        $0.register(ListOfPeriodCell.self)
        $0.registerHeaderFooter(ListOfPeriodHeader.self)
        $0.allowsSelection = false
        $0.delegate = self
    }
    
    private lazy var barChart: BarChartView = builder(BarChartView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.xAxis.labelPosition = .bottom
        $0.xAxis.drawGridLinesEnabled = false
        $0.xAxis.valueFormatter = BarChartBottomValueFormatter()
        $0.xAxis.granularity = 1
        $0.xAxis.labelCount = 12
        $0.chartDescription.enabled = false
        $0.rightAxis.enabled = false
        $0.leftAxis.drawLabelsEnabled = true
        $0.leftAxis.valueFormatter = BarChartSideValueFormatter()
        $0.leftAxis.axisMinimum = 0
    }
    
    private lazy var dataSource: UITableViewDiffableDataSource<PeriodSection, Period> = {
        let source = UITableViewDiffableDataSource<PeriodSection, Period>(tableView: tableView) { tableView, indexPath, itemModel in
            guard let cell = tableView.dequeueReusableCell(ListOfPeriodCell.self, for: indexPath) else { return UITableViewCell() }
            cell.applyWith(itemModel.asPeriodCellModel)
            cell.tapped = { [weak self] in
                self?.viewModel?.pushToListOfGrocery(periodID: itemModel.periodID ?? "")
            }
            return cell
        }
        return source
    }()
    
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    private var datePickerCard: MFRBaseBottomSheet?
    private var verificationCard: MFRBaseBottomSheet?
    
    private var tempPeriodID: String = ""
    
    private var viewModel: periodVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Period"
        self.view.backgroundColor = .white
        setupView()
        setupViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addButton.layer.cornerRadius = addButton.layer.bounds.width / 2
    }
    
    private func setupView() {
        view.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
        }
        
        view.addSubview(barChart)
        barChart.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(screenWidth * 0.5)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(barChart.snp.bottom)
            make.bottom.equalTo(infoLabel.snp.top).offset(-8)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.right.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.bottom.equalTo(tableView.snp.bottom)
            make.width.height.equalTo(60)
        }
        
        view.addSubview(emptyState)
        emptyState.snp.makeConstraints { make in
            make.centerY.equalTo(tableView.snp.centerY).offset(-32)
            make.left.right.equalToSuperview()
        }
    }
    @objc
    private func addButtonTapped() {
        let card = PickerPeriodCard()
        datePickerCard = card
        card.delegate = self
        let cardController = MFRBottomSheetController(bottomSheet: card, isPortraitOnly: true)
        cardController.show(from: self, animated: true, completion: nil)
    }
}

// MARK: - ViewModel
extension ListOfPeriodVC {
    private func setupViewModel() {
        let router = ListOfPeriodRouter()
        router.baseViewController = self
        self.viewModel = ListOfPeriodVM(router: router)
        viewModel?.listenData = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .showData(let datas):
                self.setupDataSource(datas)
            case .updateChart(let period):
                self.setupchart(period)
            case .error(let message):
                CommonToast.show(title: message)
            }
        }
        
        viewModel?.fetchPeriod()
    }
    
    func setupDataSource(_ datas: [Period]) {
        let setSection = Set(datas.compactMap { $0.getYear })
        let sections = setSection.sorted(by: >).compactMap { return PeriodSection(title: $0) }
        var snapshot = NSDiffableDataSourceSnapshot<PeriodSection, Period>()
        snapshot.appendSections(sections)
        for section in sections {
            let items = datas.filter { $0.getYear == section.title }
            snapshot.appendItems(items, toSection: section)
        }
        self.dataSource.applySnapshotUsingReloadData(snapshot)
        self.emptyState.isHidden = !datas.isEmpty ? true : false
        self.tableView.isHidden = datas.isEmpty ? true : false
        self.infoLabel.isHidden = datas.isEmpty ? true : false
    }
    
    private func setupchart(_ datas: [Period]) {
        var dataGrouping = datas.compactMap {
            return BarChartDataEntry(x: Double($0.getMonthDigit), y: $0.totalSpend)
        }
        dataGrouping.reverse()

        let dataSet = BarChartDataSet(entries: dataGrouping, label: "")
        dataSet.colors = HouseholdConstant.chartColors
        dataSet.valueTextColor = .black
        dataSet.drawValuesEnabled = true
        
        let data = BarChartData(dataSet: dataSet)
        data.barWidth = 0.9
        data.setValueFormatter(PieChartValueFormatter())
        barChart.data = data
    }
    
    func openVerificationCard(period: String) {
        verificationCard = self.showVerificationCard(delegate: self) {
            $0.title = "Yakin nih mau di delete?"
            $0.subtitle = period
        }
    }
}

extension ListOfPeriodVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = tableView.contextualActionImage(
            style: .destructive,
            backgroundColor: .mainRed,
            image: UIImage(systemName: "trash"), 
            action: { [weak self] in
                guard let self = self else { return }
                let data = self.dataSource.itemIdentifier(for: indexPath)
                self.tempPeriodID = data?.periodID ?? ""
                self.openVerificationCard(period: data?.period ?? "")
            })
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let year = viewModel?.sections[section].title ?? "year"
        let sum = viewModel?.getSumOfTheYear(from: section) ?? 0.0
        guard let header = tableView.dequeueReusableHeaderFooter(ListOfPeriodHeader.self) else { return nil }
        header.applyWith(.init(periodTitle: year, grandTotal: sum))
        header.headerTapped = { [weak self] in
            guard let self else { return }
            viewModel?.updateChartDataBased(year)
        }
        return header
    }
}

extension ListOfPeriodVC: MFRBaseBottomSheetDelegate {
    func bottomSheet(_ bottomSheet: MFRBaseBottomSheet, didDismiss withInfo: Any?, animated: Bool) {
        defer {
            tempPeriodID = ""
        }
        if bottomSheet == datePickerCard {
            datePickerCard = nil
            guard let datePicker = withInfo as? Date else { return }
            viewModel?.createNewPeriod(from: datePicker)
            
        } else if bottomSheet == verificationCard {
            verificationCard = nil
            guard let buttonTapped = withInfo as? VerificationCardButtonTap,
                  buttonTapped == .right else { return }
            viewModel?.deleteData(periodID: tempPeriodID)
        }
    }
}
