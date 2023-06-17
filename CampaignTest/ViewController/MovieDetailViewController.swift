//
//  MovieDetailViewController.swift
//  CampaignTest
//
//  Created by Marshall Kurniawan on 17/06/23.
//

import UIKit
import Cosmos

class MovieDetailViewController: UIViewController {
    var movieID: Int!
    private var movieDetailVM: MovieDetailViewModel!
    
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    
    @IBOutlet var runtimeLabel: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var cosmos: CosmosView!
    
    @IBOutlet var productionCompaniesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .white
        fetchMovieDetail()
    }
    
    private func fetchMovieDetail() {
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwZjRiYzNjYmEwMTNhNjBjNzkwYWY3MmMwMmQzMDgxZSIsInN1YiI6IjY0OGQ3MGU0YzJmZjNkMDBhZDAxYTNiZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.zjhlJFucWs61JcF_7UrJcmnltoruRA4YfdJxPOgdLQM"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/\(movieID ?? 1)?language=en-US")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        WebService().getMovieDetail(url: request) { movieDetail in
            if let movieDetail = movieDetail {
                DispatchQueue.main.async { [self] in
                    movieDetailVM = MovieDetailViewModel(movieDetail)
                    setup()
                }
            }
        }
    }
    
    private func setup() {
        titleLabel.text = movieDetailVM.movieDetail.title
        overviewLabel.text = movieDetailVM.movieDetail.overview
        guard let url = URL(string: "https://image.tmdb.org/t/p/original" + movieDetailVM.movieDetail.posterPath) else {
            return
        }
        
        let getImageTask = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.posterImage.image = image
            }
        }
        getImageTask.resume()
        
        runtimeLabel.text = "Runtime: \(String(describing: movieDetailVM.movieDetail.runtime)) minutes"
        releaseDateLabel.text = "Release Date: \(movieDetailVM.movieDetail.releaseDate)"
        cosmos.rating = movieDetailVM.movieDetail.voteAverage
        
        productionCompaniesCollectionView.delegate = self
        productionCompaniesCollectionView.dataSource = self
        productionCompaniesCollectionView.reloadData()
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieDetailVM.numberOfItemsInProductionCompaniesSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductionCompanyCollectionViewCell", for: indexPath) as! ProductionCompanyCollectionViewCell
        
        let productionCompany = movieDetailVM.productionCompanyAtIndex(indexPath.row)
        
        cell.name.text = productionCompany.name
        
        if let logoPath = productionCompany.logoPath {
            guard let url = URL(string: "https://image.tmdb.org/t/p/original" + logoPath) else {
                cell.logo.image = UIImage(systemName: "photo.on.rectangle.angled")
                return cell
            }
            
            let getImageTask = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    cell.logo.image = image
                }
            }
            getImageTask.resume()
        } else {
            cell.logo.image = UIImage(systemName: "photo.on.rectangle.angled")
        }
        
        return cell
    }
}
