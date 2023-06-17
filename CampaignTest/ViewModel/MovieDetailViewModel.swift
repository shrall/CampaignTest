//
//  MovieDetailViewModel.swift
//  CampaignTest
//
//  Created by Marshall Kurniawan on 17/06/23.
//

import UIKit

class MovieDetailViewModel {
    let movieDetail: MovieDetail
    
    init(_ movieDetail: MovieDetail) {
        self.movieDetail = movieDetail
    }
}

extension MovieDetailViewModel {
    func numberOfItemsInProductionCompaniesSection(_ section: Int) -> Int {
        return self.movieDetail.productionCompanies.count
    }

    func productionCompanyAtIndex(_ index: Int) -> ProductionCompany {
        return self.movieDetail.productionCompanies[index]
    }
}
