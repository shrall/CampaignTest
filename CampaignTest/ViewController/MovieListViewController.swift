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
    
    private var examples = [Exampley(name: "Fight Club", iconImageUrl: "https://image.tmdb.org/t/p/original/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg"), Exampley(name: "The Super Mario Bros. Movie", iconImageUrl: "https://image.tmdb.org/t/p/original/qNBAXBIQlnOThrVvA6mA2B5ggV6.jpg")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        // Set navigation bar title to large by default
        navigationController?.navigationBar.prefersLargeTitles = true
        
        movieListCollectionView.delegate = self
        movieListCollectionView.dataSource = self
        movieListCollectionView.reloadData()
    }
}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return examples.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        cell.title.text = examples[indexPath.row].name
        
        guard let url = URL(string: examples[indexPath.row].iconImageUrl) else {
            return cell
        }
        
        let getImageTask = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                cell.image.image = image
            }
        }
        getImageTask.resume()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
