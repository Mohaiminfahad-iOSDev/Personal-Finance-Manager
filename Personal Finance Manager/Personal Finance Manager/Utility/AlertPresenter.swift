//
//  AlertPresenter.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 4/7/24.
//

import Foundation
import UIKit


class AlertPresenter {
    
    func showAlertForError(errorString:String){
        if let currentViewController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController{
            currentViewController.presentAlertWithTitle(title: "Error", message: errorString, options: "OK") { options in
                switch options{
                case 0:
                    break
                default:
                    break
                }
            }
        }
    }
    
    func showAlertForSuccss(successString:String){
        if let currentViewController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController{
            currentViewController.presentAlertWithTitle(title: "Success", message: successString, options: "OK") { options in
                switch options{
                case 0:
                    break
                default:
                    break
                }
            }
        }
    }
}
