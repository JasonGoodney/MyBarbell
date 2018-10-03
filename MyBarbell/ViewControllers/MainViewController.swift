//
//  MainViewController.swift
//  MyBarbell
//
//  Created by Jason Goodney on 10/2/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit


func create<T>(_ setup: ((T) -> Void)) -> T where T: NSObject {
    let obj = T()
    setup(obj)
    return obj    
}

class MainViewController: UIViewController {
    
    enum Unit {
        case pounds
        case kilograms
    }

    // MARK: - Properties
    let sideMargin: CGFloat = 16
    var weightTotal: Double = 0 {
        didSet {
            mainHeaderView.totalLabel.text = weightAsString(weightTotal)
        }
    }
    let bars: [String] = ["Barbell", "Bell Bar", "Technique"]
    let weightsInPounds: [[Double]] = [[45, 35, 25, 15, 10], [5, 2.5, 1, 0.5], [100, 55]]
    let weightsInKilograms: [Double] = [25, 20, 15, 10, 5, 2.5, 2, 1, 0.5]
    
    var unit: Unit = .pounds
    lazy var dataSource: [[Double]] = self.weightsInPounds
    
    // MARK: - Subviews
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.tableFooterView = UIView()
        view.separatorColor = .clear
        view.register(CalculationCell.self, forCellReuseIdentifier: CalculationCell.reuseIdentifier)
        return view
    }()

    
    lazy var mainHeaderView = MainHeaderView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
        
    }
}

// MARK: - Setup
private extension MainViewController {
    func updateView() {
        view.backgroundColor = .white
        
        addSubviews([mainHeaderView, tableView])
        
        setupConstraints()
        
        mainHeaderView.delegate = self
        mainHeaderView.barPickerView.delegate = self
        mainHeaderView.barPickerView.dataSource = self
        mainHeaderView.barPickerView.selectedRow(inComponent: 0)
        
    }
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach{ view.addSubview($0) }
    }
    
    func setupConstraints() {
        
        mainHeaderView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 22, leftConstant: sideMargin, bottomConstant: 0, rightConstant: sideMargin, widthConstant: 0, heightConstant: view.frame.height * 0.25)
        
        tableView.anchor(mainHeaderView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 16, leftConstant: sideMargin, bottomConstant: 0, rightConstant: sideMargin, widthConstant: 0, heightConstant: 0)
    }
}

// MARK: - Methods
private extension MainViewController {
    func weightAsString(_ weight: Double) -> String {
        if isWholeNumber(weight) {
            return "\(Int(weight))"
        }
        
        return "\(weight)"
    }
    
    func isWholeNumber(_ weight: Double) -> Bool {
        if floor(weight) == weight {
            return true
        }
        
        return false
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CalculationCell.reuseIdentifier, for: indexPath) as! CalculationCell
        
        let section = dataSource[indexPath.section]
        
        let weight = section[indexPath.row]
        
        cell.weight = weightAsString(weight)
        
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
}

// MARK: - CalculationButtonDelegate
extension MainViewController: CalculationCellDelegate {
    func calculationCellDidTapPlusButton(_ sender: CalculationCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        
        let weight = weightsInPounds[indexPath.section][indexPath.row]
        
        weightTotal += weight
        
        guard var plateCount = Int(sender.plateCountLabel.text!) else { return }
        plateCount += 1
        sender.plateCountLabel.text = "\(plateCount)"
        
    }
    
    func calculationCellDidTapMinusButton(_ sender: CalculationCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        
        let weight = weightsInPounds[indexPath.section][indexPath.row]
        
        if weightTotal - weight >= 0 {
            weightTotal -= weight
        }
    }
}

// MARK: - MainHeaderViewDelegate
extension MainViewController: MainHeaderViewDelegate {
    func mainHeaderViewDidTapUnitsButton() {
        switch unit {
        case .pounds:
//            dataSource = weightsInKilograms
            unit = .kilograms
        case .kilograms:
            dataSource = weightsInPounds
            unit = .pounds
        }
        
        tableView.reloadData()
    }
}

// MARK: - UIPickerViewDataSource
extension MainViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bars.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bars[row]
    }
    
}

// MARK: - UIPickerViewDelegate
extension MainViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // weights are in pounds
        switch row {
        case 0:
            weightTotal += 45
        case 1:
            weightTotal += 35
        case 2:
            weightTotal += 15
        default:
            return
        }
    }
}
