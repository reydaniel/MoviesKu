//
//  DetailViewController.swift
//  MoviesKu
//
//  Created by ReyDaniel on 01/12/21.
//

import UIKit
import Combine
import SDWebImage

class DetailViewController: UIViewController {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieTagline: UILabel!
    @IBOutlet weak var movieScore: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var detailPresenter: DetailPresenter?
    var id: Int?
    
    private var errorMessage: String = ""
    private var loadingState: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    private var detail: DetailModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        getDetail()
    }
    
    @IBAction func favoriteTapped(_ sender: UIButton) {
        if let id = id {
            detailPresenter?.addMovies(id: id)
        }
    }
    
    func imageSetUp() {
        backgroundImage.sd_setImage(with: URL(string: Endpoints.Gets.getImageURL(url: detail?.image ?? "").url))
        moviePoster.sd_setImage(with: URL(string: Endpoints.Gets.getImageURL(url: detail?.image ?? "").url))
        BlurImageView.init().makeBlur(for: backgroundImage)
    }
    
    func setUp() {
        movieTitle.text = detail?.title ?? ""
        movieTagline.text = detail?.tagline ?? ""
        movieScore.text = String(detail?.average ?? 0.0)
        movieOverview.text = detail?.overview ?? ""
    }
    
    func getDetail() {
        loadingState = true
        guard let id = id else { return }
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
                self.setUp()
                self.imageSetUp()
            })
            .store(in: &cancellables)
    }
}
