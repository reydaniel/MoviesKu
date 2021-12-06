//
//  ShowAlert.swift
//  MoviesKu
//
//  Created by ReyDaniel on 05/12/21.
//

import UIKit

struct ShowAlert {
    func movieAlert(alert: UIAlertController) {
        let loading = UIActivityIndicatorView(frame: CGRect(x: 5, y: 5, width: 50, height: 50))
        loading.hidesWhenStopped = true
        loading.style = UIActivityIndicatorView.Style.medium
        loading.startAnimating()
        
        alert.view.addSubview(loading)
    }
    
    func deleteMovie(alert: UIAlertController, completion: @escaping (() -> Void)) {
        alert.addAction(UIAlertAction(title: "Proceed to Delete", style: .default, handler: { _ in
            completion()
        }))
    }
    
    func showMessage(alert: UIAlertController ,completion: @escaping (() -> Void)) {
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion()
        }))
    }
}
