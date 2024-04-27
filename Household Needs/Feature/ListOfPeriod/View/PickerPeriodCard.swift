//
//  PickerPeriodCard.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 07/12/23.
//

import Foundation
import UIKit
import SnapKit
import MFRBottomSheet
import MonthYearWheelPicker

class PickerPeriodCard: MFRFixedBottomSheet {
    
    private lazy var datePicker = builder(MonthYearWheelPicker.self) {
        $0.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.timeZone = .current
//        $0.datePickerMode = .date
//        $0.preferredDatePickerStyle = .wheels
    }
    
    private lazy var addButton = builder(UIButton.self) {
        $0.addTarget(self, action: #selector(self.addButtonTapped), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Choose Date", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .mainGreen
        $0.layer.cornerRadius = 8
    }
    
    private var padding: UIEdgeInsets {
        UIEdgeInsets(all: 8)
    }
    
    private var selectedDate: Date = Date()
    
    init() {
        super.init(sheetType: .fixed)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func initialSetup() {
        super.initialSetup()
        setupView()
    }
    
    func setupView() {
        self.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        
        self.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.equalTo(datePicker.snp.bottom)
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(padding)
        }
    }
    
    @objc
    private func addButtonTapped() {
        self.dismiss(animated: true, withInfo: selectedDate, completion: nil)
    }
    
    @objc
    private func datePickerValueChanged() {
        self.selectedDate = datePicker.date
    }
}
