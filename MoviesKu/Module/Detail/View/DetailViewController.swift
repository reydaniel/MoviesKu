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
    private var cancellables: Set<AnyCancellable> = []
    private var detail: DetailModel?
    private var entity: MovieEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkID()
        getDetail()
    }
    
    @IBAction func favoriteTapped(_ sender: UIButton) {
        isMovieExist()
    }
    
    func addMovies() {
        guard let id = id else { return }
        detailPresenter?.addMovies(id: id)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errorMessage = String(describing: completion)
                    print("fail, \(self.errorMessage)")
                case .finished:
                    print("Added")
                }
            }, receiveValue: { result in
                print(result)
                self.checkID()
            }).store(in: &cancellables)
    }
    
    func getDetail() {
        guard let id = id else { return }
        detailPresenter?.getDetail(id: id)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errorMessage = String(describing: completion)
                case .finished:
                    return
                }
            }, receiveValue: { result in
                self.detail = result
                self.setUp()
                self.imageSetUp()
            })
            .store(in: &cancellables)
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
    
    func checkID() {
        if let id = id {
            DispatchQueue.main.async {
                let check = self.detailPresenter?.checkID(id: id)
                if let check = check {
                    if check {
                        self.favoriteButton.tintColor = .red
                        self.favoriteButton.setImage(UIImage(systemName: "trash.circle"), for: .normal)
                        self.favoriteButton.setTitle("Delete Movie", for: .normal)
                    } else {
                        self.favoriteButton.tintColor = .tintColor
                        self.favoriteButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
                        self.favoriteButton.setTitle("Add to Favorite", for: .normal)
                    }
                }
            }
        }
    }
    
    func isMovieExist() {
        if let id = id {
            let check = detailPresenter?.checkID(id: id)
            DispatchQueue.main.async {
                if let check = check {
                    if check {
                        let alert = UIAlertController(title: "Warning", message: "Are you sure want to delete movie?", preferredStyle: .alert)
                        ShowAlert.init().deleteMovie(alert: alert) {
                            self.addMovies()
                            let messageAlert = UIAlertController(title: "Successful", message: "Movie was deleted", preferredStyle: .alert)
                            ShowAlert.init().showMessage(alert: messageAlert) {
                                self.viewWillAppear(true)
                            }
                            self.present(messageAlert, animated: true, completion: nil)
                        }
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: nil, message: "Saving Movie...", preferredStyle: .alert)
                        ShowAlert.init().movieAlert(alert: alert)
                        self.present(alert, animated: true) {
                            self.addMovies()
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
}
