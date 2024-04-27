//
//  ToDoListVC.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 11/12/23.
//

import Foundation
import UIKit
import SnapKit
import MFRBottomSheet

class ToDoListVC: UIViewController {
    
    private lazy var tableView = builder(UITableView.self) {
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.insetsContentViewsToSafeArea = false
        $0.sectionHeaderTopPadding = 0
        $0.backgroundColor = .white
        $0.register(ToDoListCell.self)
        $0.registerHeaderFooter(ToDoListHeaderCell.self)
        $0.allowsSelection = true
        $0.delegate = self
    }
    
    private lazy var searchBar = builder(UISearchBar.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
    }
    
    private lazy var addButton = builder(CommonButton.self) {
        $0.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Tambah Barang", for: .normal)
        $0.style = .mainGreen
    }
    
    private lazy var emptyState: EmptyStateView = builder(EmptyStateView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.messageText = "Duh datanya belum ada nih. Tambahin dulu yuk!"
    }
    
    private lazy var dataSource: UITableViewDiffableDataSource<PeriodSection, ToDoList> = {
        let source = UITableViewDiffableDataSource<PeriodSection, ToDoList>(tableView: tableView) { tableView, indexPath, itemModel in
            guard let cell = tableView.dequeueReusableCell(ToDoListCell.self, for: indexPath) else { return UITableViewCell() }
            cell.applyName(itemModel.itemName)
            return cell
        }
        return source
    }()
    
    private var padding: UIEdgeInsets {
        UIEdgeInsets(all: 8)
    }
    
    private var todolistID: String?
    
    private var addCard: MFRBaseBottomSheet?
    
    private var editItemCard: MFRBaseBottomSheet?
    
    private var selectIndexPath: IndexPath?
    
    var viewModel: ToDoListVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
    }
    
    private func setupView() {
        self.title = "To-Do list"
        view.backgroundColor = .white
        tableView.keyboardDismissMode = .onDrag
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.left.bottom.right
                .equalTo(view.safeAreaLayoutGuide).inset(padding)
        }
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.left.top.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.bottom.equalTo(addButton.snp.top).offset(-8)
        }
        
        view.addSubview(emptyState)
        emptyState.snp.makeConstraints { make in
            make.centerY.equalTo(tableView.snp.centerY).offset(-32)
            make.left.right.equalToSuperview()
        }
    }
    
    private func setupViewModel() {
        viewModel?.listenStateChange = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .success(let datas):
                self.setupDataSource(datas)
            case .search(let datas):
                self.setupDataSource(datas)
            case .error(let message):
                CommonToast.show(title: message)
            }
        }
        
        viewModel?.getData()
    }
    
    private func setupDataSource(_ datas: [ToDoList]) {
        guard let viewModel = viewModel else { return }
        let sections = viewModel.sections
        var snapshot = NSDiffableDataSourceSnapshot<PeriodSection, ToDoList>()
        snapshot.appendSections(sections)
        for section in sections {
            let items = datas.filter { $0.listType == section.title }
            snapshot.appendItems(items, toSection: section)
        }
        
        dataSource.applySnapshotUsingReloadData(snapshot)
        emptyState.isHidden = !datas.isEmpty ? true : false
        tableView.isHidden = datas.isEmpty ? true : false
    }
    
    @objc
    private func addButtonAction() {
        openAddCard()
    }
    
    @objc
    private func dismissKeyboardAction() {
        self.view.endEditing(true)
    }
    
    private func openAddCard(dataPrefilled: String? = nil) {
        let card = AddToDoListCard()
        card.delegate = self
        card.prefilled = dataPrefilled
        let cardCon = MFRBottomSheetController(bottomSheet: card, isPortraitOnly: true)
        cardCon.show(from: self, animated: true, completion: nil)
        addCard = card
    }
    
    private func openCardForAddToCart(dataPrefilled: String?) {
        let card = GroceryAddCard2()
        card.groceryCardDelegate = self
        card.prefilledFromTodolist = dataPrefilled
        let cardController = MFRBottomSheetController(bottomSheet: card, isPortraitOnly: true)
        cardController.show(from: self, animated: true, completion: nil)
    }
}

extension ToDoListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let type = viewModel?.sections[section].title ?? "list"
        guard let header = tableView.dequeueReusableHeaderFooter(ToDoListHeaderCell.self) else { return nil }
        header.applyWith(type)
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndexPath = indexPath
        editItemCard = self.showEditItemCard(with: [.addToCart, .edit, .delete], delegate: self)
    }
}

extension ToDoListVC: MFRBaseBottomSheetDelegate {
    func bottomSheet(_ bottomSheet: MFRBaseBottomSheet, didDismiss withInfo: Any?, animated: Bool) {
        defer {
            todolistID = nil
            addCard = nil
            editItemCard = nil
        }
        
        if bottomSheet == addCard {
            addCardDismissHandler(withInfo)
        } else if bottomSheet == editItemCard {
            editCardDismissHandler(withInfo)
        }
    }
    
    private func addCardDismissHandler(_ withInfo: Any?) {
        guard let data = withInfo as? [AddToDoListCardType: String] else { return }
        if let name = data[.add] {
            viewModel?.saveTodoList(itemName: name)
        } else if let name = data[.edit],
                  let newID = todolistID {
            viewModel?.updateItem(todolistID: newID, newName: name)
        }
    }
    
    private func editCardDismissHandler(_ withInfo: Any?) {
        defer {
            selectIndexPath = nil
        }
        
        guard let infoAsDict = withInfo as? [String: EditItemActionType],
              let type = infoAsDict["type"],
              let selectIndexPath else { return }
        let data = self.dataSource.itemIdentifier(for: selectIndexPath)
        
        switch type {
        case .edit:
            todolistID = data?.toDoListID ?? ""
            openAddCard(dataPrefilled: data?.itemName)
        case .addToCart:
            todolistID = data?.toDoListID ?? ""
            openCardForAddToCart(dataPrefilled: data?.itemName)
        case .delete:
            viewModel?.deleteItem(todolistID: data?.toDoListID ?? "")
        }
    }
}

extension ToDoListVC: GroceryAddCard2Delegate {
    func groceryCard(_ card: GroceryAddCard2, type save: GroceryCardType, data: GroceryModel) {
        defer { todolistID = nil }
        if save == .addFromTodolist {
            viewModel?.saveToCart(from: data, todolistID: todolistID ?? "")
        }
    }
}

extension ToDoListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchItem(text: searchText)
    }
}
