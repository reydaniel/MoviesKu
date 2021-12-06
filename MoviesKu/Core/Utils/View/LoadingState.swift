//
//  LoadingState.swift
//  MoviesKu
//
//  Created by ReyDaniel on 06/12/21.
//

import UIKit

struct LoadingState {
    public init() {}
    
    let loading = UIActivityIndicatorView(frame: CGRect(x: 5, y: 25, width: 50, height: 50))
    
    func loading(alert: UIAlertController) {
        loading.hidesWhenStopped = true
        loading.style = UIActivityIndicatorView.Style.medium
        loading.startAnimating()
        
        alert.view.addSubview(loading)
    }
    
    func stopLoading() {
        loading.stopAnimating()
    }
}
