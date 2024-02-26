//
//  DetailViewController.swift
//  WeeklyBoxOffice
//
//  Created by 최서희 on 2/23/24.
//

import UIKit

class DetailViewController: UIViewController {
    var movie: Movie?
    
    @IBOutlet weak var name: UILabel!               // 영화제목
    @IBOutlet weak var arrow: UIImageView!          // 순위 증감 방향
    @IBOutlet weak var rankInten: UILabel!          // 순위 증감분
    @IBOutlet weak var rankOldAndNew: UILabel!      // 신규진입여부
    
    @IBOutlet weak var openDate: UILabel!           // 개봉일자
    @IBOutlet weak var showTime: UILabel!           // 상영시간
    @IBOutlet weak var audit: UILabel!              // 관람연령
    
    @IBOutlet weak var rank: UILabel!               // 박스오피스 순위
    @IBOutlet weak var audiAcc: UILabel!            // 누적관객수
    
    @IBOutlet weak var genres: UILabel!             // 장르
    @IBOutlet weak var directors: UILabel!          // 감독
    @IBOutlet weak var actors: UILabel!             // 주연
    @IBOutlet weak var productionYear: UILabel!     // 제작연도
    
    @IBOutlet weak var posterView: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        name.text = movie?.name
        openDate.text = String((movie?.openDate.toString(.yyyyMMddDot).prefix(4))!)
        showTime.text = "\(movie?.detailInfo?.showTime ?? 0)분"
        audit.text = movie?.detailInfo?.audit
        
        if movie?.boxOfficeInfo.rankOldAndNew == "OLD" {
            rankOldAndNew.isHidden = true
            arrow.isHidden = false
            rankInten.isHidden = false
            let rankIntenInteger = movie?.boxOfficeInfo.rankInten ?? 0
            if rankIntenInteger > 0 {
                arrow.image = UIImage(systemName: "arrowtriangle.up.fill")
                arrow.tintColor = .systemRed
            } else if rankIntenInteger < 0 {
                arrow.image = UIImage(systemName: "arrowtriangle.down.fill")
                arrow.tintColor = .systemBlue
            } else {
                rankOldAndNew.isHidden = false
                rankOldAndNew.text = "-"
                arrow.isHidden = true
                rankInten.isHidden = true
            }
            rankInten.text = String(rankIntenInteger)
        } else {
            rankOldAndNew.isHidden = false
            rankOldAndNew.text = "NEW"
            arrow.isHidden = true
            rankInten.isHidden = true
        }

        rank.text = "\(movie?.boxOfficeInfo.rank ?? 0)위"
        audiAcc.text = "\((movie?.boxOfficeInfo.audienceAccumulation ?? 0).numberFormatter())명"
        
        genres.text = movie?.detailInfo?.genres.joined(separator: ", ")
        directors.text = movie?.detailInfo?.directors.joined(separator: ", ")
        actors.text = movie?.detailInfo?.actors.joined(separator: ", ")
        productionYear.text = movie?.detailInfo?.productionYear
        
        if let posterURLString = movie?.detailInfo?.poster {
            posterView.load(urlString: posterURLString)
        } else {
            posterView.image = UIImage()
        }
    }
}

extension UIImageView {
    func load(urlString: String) {
        let url = URL(string: urlString)
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
