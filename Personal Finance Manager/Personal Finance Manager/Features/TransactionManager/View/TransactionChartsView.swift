//
//  TransactionChartsView.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 3/7/24.
//

import Foundation
import UIKit
import DGCharts

class TransactionChartsView:UIView {
    
    //MARK: Components
    
    lazy var visualEffectView:UIVisualEffectView = {
        var view = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        return view
    }()
    
    lazy var barChartView:BarChartView = {
       var chart = BarChartView()
        chart.chartDescription.text = "Date VS (Income & Expenses)"
        return chart
    }()

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
        

    }
}

//MARK: Set UI
extension TransactionChartsView {
    func setUI(){
        addSubViews()
    }
    func addSubViews(){
        self.backgroundColor = .clear
        
        self.addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        
        self.addSubview(barChartView)
        barChartView.fillSuperview(padding: .init(top: RM.shared.height(13), left: RM.shared.height(13), bottom: RM.shared.height(13), right: RM.shared.height(13)))
    }
}
