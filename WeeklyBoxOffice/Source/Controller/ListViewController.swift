//
//  ListViewController.swift
//  WeeklyBoxOffice
//
//  Created by 최서희 on 2/23/24.
//

import UIKit

class ListViewController: UIViewController {
    var movieList: [Movie] = []
    
    let boxOfficeManager = BoxOfficeManager()
    let movieInfoManager = MovieInfoManager()
    let moviePosterManager = MoviePosterManager()
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var weekGbSeg: UISegmentedControl!
    @IBOutlet weak var boxOfficeListTable: UITableView!
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        setTableVIewUI()
    }
    
    @IBAction func weekGbSegAction(_ sender: UISegmentedControl) {
        setTableVIewUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boxOfficeManager.delegate = self
        movieInfoManager.delegate = self
        moviePosterManager.delegate = self
        
        boxOfficeListTable.delegate = self
        boxOfficeListTable.dataSource = self
        
        datePicker.date = Date.lastWeek
        datePicker.maximumDate = Date.lastWeek
        datePicker.sizeToFit()
        setTableVIewUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let detailVC = segue.destination as! DetailViewController
            let indexPath = sender as! IndexPath
            detailVC.movie = movieList[indexPath.row]
        }
    }
}

extension ListViewController: BoxOfficeManagerDelegate, MovieInfoDelegate, MoviePosterDelegate {
    func didFetchBoxOffice(_ boxOfficeManager: BoxOfficeManager, movieList: [Movie]) {
        self.movieList = movieList
        for index in 0 ... movieList.count - 1 {
            self.movieInfoManager.MovieDetail(movieCd: movieList[index].code, index: index)
        }
    }
    
    func didFetchMovieInfo(_ movieInfoManager: MovieInfoManager, movieDetail: MovieDetailInfo?, index: Int) {
        self.movieList[index].detailInfo = movieDetail
        moviePosterManager.MoviePoster(title: movieDetail!.movieNameEnglish, index: index)
    }
    
    func didFetchMoviePoster(_ moviePosterManager: MoviePosterManager, poster: String, index: Int) {
        self.movieList[index].detailInfo?.poster = poster
        if index == movieList.count - 1 {
            DispatchQueue.main.async {
                self.boxOfficeListTable.reloadData()
                LoadingIndicator.hideLoading()
            }
        }
    }
    
    func didFailWithDataError(error: Error) {
        createAlertMessage("오류", "데이터 Response 실패")
    }
    
    func didFailWithDecodeError(error: Error) {
        createAlertMessage("오류", "데이터 Decode 실패")
    }
}

extension ListViewController {
    func setTableVIewUI() {
        LoadingIndicator.showLoading()
        boxOfficeManager.WeeklyBoxOffice(date: datePicker.date, weekGb: String(weekGbSeg.selectedSegmentIndex))
        boxOfficeListTable.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func createAlertMessage(_ title: String, _ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = boxOfficeListTable.dequeueReusableCell(withIdentifier: MovieTableCell.identifier, for: indexPath) as! MovieTableCell
        
        cell.index.text = String(indexPath.row + 1)
        cell.name.text = movieList[indexPath.row].name
        cell.openDate.text = "개봉일 " + movieList[indexPath.row].openDate.toString(.yyyyMMddDot)
        cell.audiAcc.text = "관객수 \(movieList[indexPath.row].boxOfficeInfo.audienceAccumulation.numberFormatter()) 명"
        if let posterURLString = movieList[indexPath.row].detailInfo?.poster {
            cell.poster.load(urlString: posterURLString)
        } else {
            cell.poster.image = UIImage()
        }
        
        if movieList[indexPath.row].boxOfficeInfo.rankOldAndNew == "OLD" {
            cell.rankOldAndNew.isHidden = true
            cell.arrow.isHidden = false
            cell.rankInten.isHidden = false
            if movieList[indexPath.row].boxOfficeInfo.rankInten > 0 {
                cell.arrow.image = UIImage(systemName: "arrowtriangle.up.fill")
                cell.arrow.tintColor = .systemRed
            } else if movieList[indexPath.row].boxOfficeInfo.rankInten < 0 {
                cell.arrow.image = UIImage(systemName: "arrowtriangle.down.fill")
                cell.arrow.tintColor = .systemBlue
            } else {
                cell.rankOldAndNew.isHidden = false
                cell.rankOldAndNew.text = "-"
                cell.arrow.isHidden = true
                cell.rankInten.isHidden = true
            }
            cell.rankInten.text = String(movieList[indexPath.row].boxOfficeInfo.rankInten)
        } else {
            cell.rankOldAndNew.isHidden = false
            cell.rankOldAndNew.text = "NEW"
            cell.arrow.isHidden = true
            cell.rankInten.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        movieInfoManager.MovieDetail(movieCd: movieList[indexPath.row].code, index: indexPath.row)
        performSegue(withIdentifier: "toDetail", sender: indexPath)
    }
}

extension UITableView {
    func reloadData(completion:@escaping ()->()) {
        UIView.animate(withDuration: 0, animations: reloadData)
            { _ in completion() }
    }
}

extension UIImageView {
    func load(urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
