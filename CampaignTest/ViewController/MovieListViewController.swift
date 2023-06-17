//
//  MovieListViewController.swift
//  CampaignTest
//
//  Created by Marshall Kurniawan on 17/06/23.
//

import UIKit

struct Exampley {
    var name: String
    var iconImageUrl: String
}

class MovieListViewController: UIViewController {
    @IBOutlet var movieListCollectionView: UICollectionView!
    
    private var movieListVM : MovieListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        fetchMovies()
    }
    
    private func fetchMovies() {
        let headers = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwZjRiYzNjYmEwMTNhNjBjNzkwYWY3MmMwMmQzMDgxZSIsInN1YiI6IjY0OGQ3MGU0YzJmZjNkMDBhZDAxYTNiZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.zjhlJFucWs61JcF_7UrJcmnltoruRA4YfdJxPOgdLQM"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        WebService().getMovies(url: request) { movies in
            if let movies = movies {
                DispatchQueue.main.async { [self] in
                    movieListVM = MovieListViewModel(movies: movies)
                    movieListCollectionView.reloadData()
                    movieListCollectionView.delegate = self
                    movieListCollectionView.dataSource = self
                }
            }
        }
    }
}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieListVM.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        let movieVM = movieListVM.movieAtIndex(indexPath.row)
        cell.circularProgress.startAnimating()
        cell.title.text = movieVM.title
        cell.poster.image = UIImage()
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/original" + movieVM.posterPath) else {
            return cell
        }
        
        let getImageTask = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                cell.poster.image = image
                cell.circularProgress.stopAnimating()
            }
        }
        getImageTask.resume()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MovieDetailSegue", sender: movieListVM.movieAtIndex(indexPath.row))
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieDetailSegue" {
            if let destinationVC = segue.destination as? MovieDetailViewController, let movieVM = sender as? MovieViewModel {
                destinationVC.movieID = movieVM.id
            }
        }
    }
}
