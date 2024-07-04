//
//  SegmentAndFilterViewProtocol.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 3/7/24.
//

import Foundation

protocol SegmentAndFilterViewProtocol:AnyObject {
    func didSelectSegment(index:Int)
    func didTapFilterButton()
}
