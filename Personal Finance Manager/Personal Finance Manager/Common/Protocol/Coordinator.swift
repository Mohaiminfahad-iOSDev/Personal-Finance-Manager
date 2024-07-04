//
//  Coordinator.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 30/6/24.
//

import Foundation
import UIKit

protocol Coordinator : AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController : UINavigationController { get set }
    
    func start()
}
