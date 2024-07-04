//
//  SegmentAndFilterView.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 3/7/24.
//

import UIKit

class SegmentAndFilterView: UIView {

    //MARK: Components
    lazy var filterButton:UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)), for: .normal)
        button.tintColor = .white
        button.setTitle("Filter", for: .normal)
        button.backgroundColor = AppColors._933d65
        button.anchor(width: RM.shared.width(100),height: RM.shared.height(40))
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(filterButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var segmentStack:UIStackView = {
       var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = RM.shared.width(5)
        return stackView
    }()
    
    private var segmentButtons:[UIButton] = []
    var selectedIndex:Int = 0
    open weak var delegate:SegmentAndFilterViewProtocol?
    
    // MARK: - Life Cycle
    convenience init(titles: [String]) {
           self.init(frame: .zero)
           setupButtons(withTitles: titles)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
}

//MARK: Set UI
extension SegmentAndFilterView {
    func setUI(){
        addSubViews()
    }
    func addSubViews(){
        self.backgroundColor = .clear
        setupButtons(withTitles: [])
        self.addSubview(filterButton)
        filterButton.anchor(top: self.topAnchor,leading: self.leadingAnchor,bottom: self.bottomAnchor,paddingLeading: RM.shared.height(10))
        self.addSubview(segmentStack)
        segmentStack.anchor(top: self.topAnchor,bottom: self.bottomAnchor,trailing: self.trailingAnchor,paddingTrailing: RM.shared.height(10))
    }
    
    func setupButtons(withTitles titles: [String]) {
        segmentButtons.removeAll()
        for subViews in segmentStack.arrangedSubviews {
            subViews.removeFromSuperview()
        }
        for (index,title) in titles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 6
            button.tag = index
            button.anchor(width: RM.shared.width(90))
            button.addTarget(self, action: #selector(segmentActionListeners(_:)), for: .touchUpInside)
            segmentButtons.append(button)
            segmentStack.addArrangedSubview(button)
        }
        if let firstButton = segmentButtons.first {
            setButtonSelected(button: firstButton)
        }
    }
    
    @objc func segmentActionListeners(_ sender:UIButton){
        for button in self.segmentButtons {
            setButtonDeselected(button: button)
        }
        setButtonSelected(button: sender)
        self.delegate?.didSelectSegment(index: sender.tag)
    }
    
    @objc func filterButtonAction(){
        self.delegate?.didTapFilterButton()
    }
    
    
    //button state selected
    func setButtonSelected(button:UIButton){
        button.setTitleColor(AppColors.primaryColor, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        self.selectedIndex = button.tag
    }
    
    //button state deselected
    func setButtonDeselected(button:UIButton){
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .clear
    }
    
    func setButtonSelectedAt(index:Int){
        for button in self.segmentButtons {
            if button.tag == index {
                setButtonSelected(button: button)
            }else{
                setButtonDeselected(button: button)
            }
        }
    }
    
    
    //disable single segment
    func setsingleButtonDisable(index:Int){
        for button in self.segmentButtons {
            if button.tag == index {
                button.isUserInteractionEnabled = false
            }
        }
    }
    
    func userInterectionforAllSegment(dsable:Bool){
        for button in self.segmentButtons {
            button.isUserInteractionEnabled = !dsable
        }
    }
}
