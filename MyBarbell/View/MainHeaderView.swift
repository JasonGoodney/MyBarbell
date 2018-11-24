//
//  MainHeaderView.swift
//  MyBarbell
//
//  Created by Jason Goodney on 10/2/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit
import UserNotifications

protocol MainHeaderViewDelegate: class {
    func mainHeaderViewLongPressGesturePressed(_ view: MainHeaderView)
}

class MainHeaderView: UIView {
    
    // MARK: - Properties
    static let unitChangedNotification = "UnitChangedNotification"
    weak var delegate: MainHeaderViewDelegate?
    
    var totalWeightText = "" {
        didSet {
            totalWeightLabel.text = totalWeightText
            setupTotalWeightText()
        }
    }
    var unitsText = ""
    
    // MARK: - Subviews
    lazy var totalWeightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 75)
        label.textColor = .black
        label.addGestureRecognizer(self.emptyBarLongPressGesture)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var emptyBarLongPressGesture = UITapGestureRecognizer(target: self, action: #selector(emptyBarGesturePressed))
    
    lazy var emptyBarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear Plates", for: .normal)
        button.addTarget(self, action: #selector(emptyBarButtonTapped), for: .touchUpInside)
        button.titleLabel?.textAlignment = .left
        button.isEnabled = false
        return button
    }()

    lazy var barPickerView: UIPickerView = {
        let view = UIPickerView()
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var unitsTableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.isScrollEnabled = false
        view.separatorInset.left = 0
        view.separatorColor = .clear
        view.backgroundColor = .clear
        view.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUnitsTableView() {
        let selectedUnit = BarbellController.shared.unit
        guard let selectedUnitIndex = Unit.allCases.firstIndex(of: selectedUnit) else { return }
        
        let cell = unitsTableView.cellForRow(at: IndexPath.init(row: selectedUnitIndex, section: 0))
        cell?.accessoryType = .checkmark
    }
    
    func unitChanged() {
        unitsText = BarbellController.shared.unit.rawValue
        setupTotalWeightText()
        emptyBarButton.isEnabled = false
    }
}

// MARK: - UI
private extension MainHeaderView {
    func updateView() {
        addSubviews([totalWeightLabel, emptyBarButton, unitsTableView])
        setupConstraints()
    }
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach{ addSubview($0) }
    }
    
    func setupConstraints() {
        
        let pickerStackView = UIStackView(arrangedSubviews: [barPickerView])
        addSubview(pickerStackView)
        
        totalWeightLabel.anchor(safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: frame.width)
        
        pickerStackView.anchor(totalWeightLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        emptyBarButton.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        unitsTableView.anchor(emptyBarButton.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 84, heightConstant: 64)
    }
    
    func setupTotalWeightText() {
        let attributedText = NSMutableAttributedString(string: totalWeightText, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 75)])
        
        attributedText.append(NSAttributedString(string: "\(unitsText)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 23)]))

        totalWeightLabel.attributedText = attributedText
    }
}

// MARK: - User Interaction
private extension MainHeaderView {
    @objc func emptyBarGesturePressed() {
        delegate?.mainHeaderViewLongPressGesturePressed(self)
    }
    
    @objc func emptyBarButtonTapped() {
        delegate?.mainHeaderViewLongPressGesturePressed(self)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MainHeaderView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Unit.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = Unit.allCases[indexPath.row].rawValue
        cell.backgroundColor = .clear
        
        cell.layer.cornerRadius = cell.bounds.size.height / 2
        cell.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let poundsCell = tableView.cellForRow(at: indexPath as IndexPath) {
            var kilogramsCells = UITableViewCell()
            
            if indexPath.row == 0 {
                kilogramsCells = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0))!
            } else {
                kilogramsCells = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0))!
            }
            
            if poundsCell.accessoryType == .none {
                poundsCell.accessoryType = .checkmark
                kilogramsCells.accessoryType = .none
                BarbellController.shared.unit = Unit.allCases[indexPath.row]
                NotificationCenter.default.post(name: Notification.Name(MainHeaderView.unitChangedNotification), object: nil)
                
                let defaults = UserDefaults.standard
                defaults.set(BarbellController.shared.unit.rawValue, forKey: "SelectedUnit")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32
    }
}
