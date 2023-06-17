//
//  MovieListViewModel.swift
//  CampaignTest
//
//  Created by Marshall Kurniawan on 17/06/23.
//

import UIKit

struct MovieListViewModel {
    var movies: [Movie]
}

extension MovieListViewModel {
    func numberOfItemsInSection(_ section: Int) -> Int {
        return self.movies.count
    }

    func movieAtIndex(_ index: Int) -> MovieViewModel {
        let movie = self.movies[index]
        return MovieViewModel(movie)
    }
}

struct MovieViewModel {
    private let movie: Movie
}

extension MovieViewModel {
    init(_ movie: Movie) {
        self.movie = movie
    }
}

extension MovieViewModel {
    var id: Int {
        return self.movie.id
    }
    
    var title: String {
        return self.movie.title
    }

    var posterPath: String {
        return self.movie.posterPath
    }
}
