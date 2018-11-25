//
//  CalculationCell.swift
//  MyBarbell
//
//  Created by Jason Goodney on 10/2/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: ReuseIdentifiable {}

protocol CalculationCellDelegate: class {
    func calculationCellDidTapCalculationButton(_ cell: CalculationCell, forCalculationType type: CalculationType)
}

class CalculationCell: UITableViewCell {
    
    // MARK: - Properties
    private let operationFontSize: CGFloat = 28
    weak var delegate: CalculationCellDelegate?
    var weight: String = "" {
        didSet {
            weightLabel.text = weight
        }
    }
    
    // MARK: - Subviews
    lazy var plusButton: CalculationButton = {
        let button = CalculationButton(type: .system)
        button.operation = .plus
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: operationFontSize)
        return button
    }()
    
    lazy var minusButton: CalculationButton = {
        let button = CalculationButton(type: .system)
        button.operation = .minus
        button.backgroundColor = #colorLiteral(red: 1, green: 0.1710663265, blue: 0.1538629752, alpha: 1)
        button.setTitle(Operation.minus.rawValue, for: .normal)
        button.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: operationFontSize)
        return button
    }()
    
    lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.text = self.weight
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        return label
    }()
    
    lazy var plateCountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(0)"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = .lightGray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        updateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}

// MARK: - Setup
private extension CalculationCell {
    func updateView() {
        
        addSubview(minusButton)
        addSubview(plusButton)
        
        setupConstraints()
        
        selectionStyle = .none
    }
    
    func setupConstraints() {
        let plateStackView = UIStackView(arrangedSubviews: [plateCountLabel, weightLabel])
        plateStackView.axis = .horizontal
        plateStackView.distribution = .fillEqually
        plateStackView.alignment = .center
        plateStackView.spacing = -8
        
        addSubview(plateStackView)
        
        [minusButton, plateCountLabel, weightLabel, plusButton].forEach {
            $0.anchorCenterYToSuperview()
        }
        
        let buttonWidth: CGFloat = frame.height * 2
        let buttonMargin: CGFloat = 8
        let edgeMargin: CGFloat = 16
        
        minusButton.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: buttonMargin, leftConstant: edgeMargin, bottomConstant: buttonMargin, rightConstant: 0, widthConstant: buttonWidth, heightConstant: 0)
        
        plusButton.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: buttonMargin, leftConstant: 0, bottomConstant: buttonMargin, rightConstant: edgeMargin, widthConstant: buttonWidth, heightConstant: 0)
        
        plateStackView.anchor(topAnchor, left: minusButton.rightAnchor, bottom: bottomAnchor, right: plusButton.leftAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0)
        plateStackView.anchorCenterXToSuperview()
    }
}


// MARK: - Actions
private extension CalculationCell {
    @objc func plusButtonTapped() {
        delegate?.calculationCellDidTapCalculationButton(self, forCalculationType: .addition)
    }
    
    @objc func minusButtonTapped() {
        delegate?.calculationCellDidTapCalculationButton(self, forCalculationType: .subtraction)
    }
}

