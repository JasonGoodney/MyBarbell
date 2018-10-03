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


protocol CalculationCellDelegate: class {
    func calculationCellDidTapPlusButton(_ sender: CalculationCell)
    func calculationCellDidTapMinusButton(_ sender: CalculationCell)
}

class CalculationCell: UITableViewCell, ReuseIdentifiable {
    
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
    
    lazy var weightLabel: UILabel = create {
        $0.text = self.weight
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 30, weight: .medium)
    }
    
    lazy var plateCountLabel: UILabel = create {
        $0.text = "\(0)"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        $0.textColor = .lightGray
    }

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
        let buttonHeight: CGFloat = frame.height
        let edgeMargin: CGFloat = 16
        
        minusButton.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: edgeMargin, bottomConstant: 0, rightConstant: 0, widthConstant: buttonWidth, heightConstant: buttonHeight)
        
        plusButton.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: edgeMargin, widthConstant: buttonWidth, heightConstant: buttonHeight)
        
        plateStackView.anchor(topAnchor, left: minusButton.rightAnchor, bottom: bottomAnchor, right: plusButton.leftAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0)
        plateStackView.anchorCenterXToSuperview()
    }
}


// MARK: - Actions
private extension CalculationCell {
    @objc func plusButtonTapped() {
        delegate?.calculationCellDidTapPlusButton(self)
    }
    
    @objc func minusButtonTapped() {
        delegate?.calculationCellDidTapMinusButton(self)
    }
}

