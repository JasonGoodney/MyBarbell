//
//  MainViewController.swift
//  MyBarbell
//
//  Created by Jason Goodney on 10/2/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit
import UserNotifications

class MainViewController: UIViewController {
    
    // MARK: - Properties
    private let sideMargin: CGFloat = 16
    var weightTotal: Double = 0 {
        didSet {
            mainHeaderView.totalWeightText = BarbellController.shared.weightAsString(weightTotal)
        }
    }
    private var bars: [Barbell] {
        get {
            return BarbellController.shared.bars
        }
    }
    private var totalPlateCount = 0
    var unit: Unit {
        get {
            return BarbellController.shared.unit
        }
        set (newUnit) {
            BarbellController.shared.unit = newUnit
        }
    }
    
    // MARK: - Subviews
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.tableFooterView = UIView()
        view.separatorColor = .clear
        view.register(CalculationCell.self, forCellReuseIdentifier: CalculationCell.reuseIdentifier)
        return view
    }()

    private lazy var mainHeaderView = MainHeaderView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        BarbellController.shared.unit = Unit.valueFromDefaults()
        
        updateView()
        
        let row = mainHeaderView.barPickerView.selectedRow(inComponent: 0)
        let currentBarWeight = bars[row].weight
        print(bars[row].weightPounds)
        weightTotal = currentBarWeight
        
        tableView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUnits), name: Notification.Name(MainHeaderView.unitChangedNotification), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainHeaderView.setupUnitsTableView()
    }
        
    @objc func updateUnits() {
        tableView.reloadData()
        mainHeaderView.unitChanged()
        BarbellController.shared.empty()
        weightTotal = BarbellController.shared.calculateCurrentWeight(
            forBar: BarbellController.shared.selectedBarType.barInfo(),
            andPlatesOnBar: BarbellController.shared.dataSource, by: .addition)
    }
}

// MARK: - Setup
private extension MainViewController {
    func updateView() {
        
        addSubviews([mainHeaderView, tableView])
        
        setupConstraints()
        setupHeaderView()
        
        mainHeaderView.delegate = self
        mainHeaderView.barPickerView.delegate = self
        mainHeaderView.barPickerView.dataSource = self
        
    }
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach{ view.addSubview($0) }
    }
    
    func setupConstraints() {
        
        mainHeaderView.anchor(view.topAnchor, left: view.leftAnchor, bottom: tableView.topAnchor, right: view.rightAnchor, topConstant: 22, leftConstant: sideMargin, bottomConstant: 16, rightConstant: sideMargin, widthConstant: 0, heightConstant: 0)
        
        tableView.anchor(mainHeaderView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.height * 0.65)
    }
    
    func setupHeaderView() {
        mainHeaderView.unitsText = BarbellController.shared.unit.rawValue
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return BarbellController.shared.dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BarbellController.shared.dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CalculationCell.reuseIdentifier, for: indexPath) as! CalculationCell
        
        let section = BarbellController.shared.dataSource[indexPath.section]
        
        let plate = section[indexPath.row]
        
        cell.weight = BarbellController.shared.weightAsString(plate.weight)
        cell.plateCountLabel.text = "\(plate.count)"
        
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Standard Plates"
        case 1:
            return "Change Plates"
        case 2:
            return "Heavy Plates"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

// MARK: - CalculationButtonDelegate
extension MainViewController: CalculationCellDelegate {
    
    func calculationCellDidTapCalculationButton(_ cell: CalculationCell, forCalculationType type: CalculationType) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let plate = BarbellController.shared.dataSource[indexPath.section][indexPath.row]
        let bar = BarbellController.shared.selectedBarType.barInfo()
        
        switch type {
        case .addition:
            plate.count += 1
        case .subtraction:
            if plate.count > 0 {
                plate.count -= 1
            }
        }
        
        plate.count == 0 ?
            (mainHeaderView.emptyBarButton.isEnabled = false) :
            (mainHeaderView.emptyBarButton.isEnabled = true)
    
        
        weightTotal = BarbellController.shared.calculateCurrentWeight(forBar: bar, andPlatesOnBar: BarbellController.shared.dataSource, by: type)
        
        cell.plateCountLabel.text = "\(plate.count)"
    }
}

// MARK: - MainHeaderViewDelegate
extension MainViewController: MainHeaderViewDelegate {
    func mainHeaderViewDidTapUnitsButton() {
        let calculator = Calculations()
        switch unit {
        case .pounds:
            unit = .kilograms
        case .kilograms:
            unit = .pounds
        }
        
        mainHeaderView.unitsText = unit.rawValue
        weightTotal = calculator.convert(weightTotal, to: unit)
        tableView.reloadData()
    }
    
    func mainHeaderViewLongPressGesturePressed(_ view: MainHeaderView) {
        BarbellController.shared.totalPlateCount = 0
        mainHeaderView.emptyBarButton.isEnabled = false
        weightTotal = BarbellController.shared.empty(
            BarbellController.shared.selectedBarType.barInfo(), withPlates: BarbellController.shared.dataSource)
        
        tableView.reloadData()
        
    }
}

// MARK: - UIPickerViewDataSource
extension MainViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return BarbellType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let barType = BarbellType.allCases[row].rawValue
        return barType
    }
}

// MARK: - UIPickerViewDelegate
extension MainViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        BarbellController.shared.selectedBarType = BarbellType.allCases[row]
    
        weightTotal = BarbellController.shared.calculateCurrentWeight(
            forBar: BarbellController.shared.selectedBarType.barInfo(),
            andPlatesOnBar: BarbellController.shared.dataSource, by: .addition)
        
    }
}
