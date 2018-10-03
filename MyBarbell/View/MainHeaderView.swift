//
//  MainHeaderView.swift
//  MyBarbell
//
//  Created by Jason Goodney on 10/2/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

protocol MainHeaderViewDelegate: class {
    func mainHeaderViewDidTapUnitsButton()
}

class MainHeaderView: UIView {
    
    // MARK: - Properties
    weak var delegate: MainHeaderViewDelegate?
    
    // MARK: - Subviews
    lazy var totalLabel: UILabel = create {
        $0.text = "0"
        $0.font = UIFont.boldSystemFont(ofSize: 75)
        $0.textColor = .lightGray
        $0.textAlignment = .center
    }
    
    lazy var unitsButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(unitsButtonTapped), for: .touchUpInside)
        button.setTitle("lbs / kg", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.textAlignment = .center
        
        return button
    }()
    
    lazy var barPickerView: UIPickerView = {
        let view = UIPickerView()
        view.clipsToBounds = true
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI
private extension MainHeaderView {
    func updateView() {
        
        addSubviews([totalLabel, unitsButton])
        
        setupConstraints()
    }
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach{ addSubview($0) }
    }
    func setupConstraints() {
        
        let pickerStackView = UIStackView(arrangedSubviews: [barPickerView])
        addSubview(pickerStackView)
        
        let halfFrameWidth = frame.width / 2
        let halfFrameHeight = frame.height / 2
        
        totalLabel.anchor(safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: halfFrameWidth)
        totalLabel.anchorCenterXToSuperview()
        
        unitsButton.anchor(safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: halfFrameWidth, heightConstant: halfFrameHeight)
        
        pickerStackView.anchor(totalLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: halfFrameHeight)
        
    }
}

// MARK: - User Interaction
private extension MainHeaderView {
    @objc func unitsButtonTapped() {
        delegate?.mainHeaderViewDidTapUnitsButton()
    }
}
