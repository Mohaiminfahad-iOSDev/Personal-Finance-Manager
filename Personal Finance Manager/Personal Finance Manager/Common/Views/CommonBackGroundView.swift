//
//  CommonVisualEffectView.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 29/6/24.
//

import Foundation
import UIKit

class CommonBackGroundView:UIView{
    
    lazy var gradientCircleOne:UIView =  {
       var view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    lazy var gradientCircleTwo:UIView =  {
       var view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        
        setGradiantLayout(view: gradientCircleOne)
        setGradiantLayout(view: gradientCircleTwo)
    }
    
}

//MARK: Set UI
extension CommonBackGroundView {
    func setUI(){
        addSubViews()
    }
    
    func addSubViews(){
        self.backgroundColor = AppColors.primaryColor
        
        self.addSubview(gradientCircleOne)
        gradientCircleOne.centerY(inView: self, constant: -RM.shared.height(120))
        gradientCircleOne.anchor(leading: self.leadingAnchor,paddingLeading: -RM.shared.width(20),height: RM.shared.height(150),multiplier: 1)
        
        self.addSubview(gradientCircleTwo)
        gradientCircleTwo.anchor(top: self.topAnchor,trailing: self.trailingAnchor,paddingTop: -RM.shared.height(20),paddingTrailing: -RM.shared.width(80),height: RM.shared.height(250),multiplier: 1)
        
    }
    
    func setGradiantLayout(view:UIView){
        view.applyGradient(isVertical: false, colorArray: [AppColors._933d65,AppColors._eec1b7])
        view.layer.cornerRadius = view.frame.height/2
    }
}
