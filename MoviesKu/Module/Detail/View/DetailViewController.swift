//
//  DetailViewController.swift
//  MoviesKu
//
//  Created by ReyDaniel on 30/11/21.
//

import UIKit
import Combine

class DetailViewController: UIViewController {
    
    var detailPresenter: DetailPresenter?
    var homeRouter: HomeRouter?
    var id: Int?
    
    private var errorMessage: String = ""
    private var loadingState: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    private var detail: DetailModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("id: \(id ?? 0)")
        getDetail()
        // Do any additional setup after loading the view.
    }
    
    func getDetail() {
        guard let id = id else {
            return
        }
        loadingState = true
        detailPresenter?.getDetail(id: id)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errorMessage = String(describing: completion)
                case .finished:
                    self.loadingState = false
                }
            }, receiveValue: { result in
                self.detail = result
                print("id: \(result)")
            })
            .store(in: &cancellables)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
