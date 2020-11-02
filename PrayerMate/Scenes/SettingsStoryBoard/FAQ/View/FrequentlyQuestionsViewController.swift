//
//  HelpAndSupportVC.swift
//  Ataba
//
//  Created by eman shedeed on 11/6/19.
//  Copyright © 2019 eman shedeed. All rights reserved.
//

import UIKit

class FrequentlyQuestionsViewController: BaseViewController {
    
    //MARK:- IBOUTLET
    @IBOutlet weak var questionsTV: UITableView!
    
    
    @IBOutlet weak var navigationViewHeight: NSLayoutConstraint!
    //MARK:VARiIABLES
    var searchBar = UISearchBar()
    var searchbarBtnIcon = UIBarButtonItem()
    let titleLabel=UILabel()
    var cellHeight :CGFloat = 63.0
    var searchBarIsActive = false
    var isSearchBarEmpty: Bool {
        return searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchBarIsActive && !isSearchBarEmpty
    }
    var questionsArray:[(questionTitle: String, questionAnswer: String , isExpanded:Bool)] = []
    
    var filteredQuestions: [(questionTitle: String, questionAnswer: String , isExpanded:Bool)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        setUpNavBar()
        
        loadArray()
    }
    //MARK:- Methods
    
    /**
     Call this function for setup UI
     
     
     
     ### Usage Example: ###
     ````
     setupView()
     
     ````
     - Parameters:
     */
    func setupView(){
        
        // For remove extra cells
        questionsTV.tableFooterView=UIView()
        
        // For remove last separator
        questionsTV.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: questionsTV.frame.size.width, height: 1))
        
        // For add space at bottom of table view
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.questionsTV.contentInset = insets
        
        
        questionsTV.rowHeight = UITableView.automaticDimension
        
        cellHeight = UITableView.automaticDimension
        
        questionsTV.estimatedRowHeight = 63.0;
        if(UIScreen.main.bounds.height>736){
            navigationViewHeight.constant = 100.0
        }else{
            navigationViewHeight.constant = 66.0
        }
    }
    /**
     Call this function for set Questions Array
     
     
     
     ### Usage Example: ###
     ````
     loadArray()
     
     ````
     - Parameters:
     */
    func loadArray(){
        //1
        questionsArray.append((questionTitle: "FAQs.firstQuestionTitle".localized, questionAnswer: "FAQs.firstQuestionDescription".localized, isExpanded: false))
        //2
        questionsArray.append((questionTitle: "FAQs.secondQuestionTitle".localized, questionAnswer: "FAQs.secondQuestionDescription".localized, isExpanded: false))
        
        //3
        questionsArray.append((questionTitle: "FAQs.thirdQuestionTitle".localized, questionAnswer: "FAQs.thirdQuestionDescription".localized, isExpanded: false))
        
        //4
        questionsArray.append((questionTitle: "FAQs.fourthQuestionTitle".localized, questionAnswer: "FAQs.fourthQuestionDescription".localized, isExpanded: false))
        
        //5
        questionsArray.append((questionTitle: "FAQs.fifthQuestionTitle".localized, questionAnswer: "FAQs.fifthQuestionDescription".localized, isExpanded: false))
        
        //6
        questionsArray.append((questionTitle: "FAQs.sixthQuestionTitle".localized, questionAnswer: "FAQs.sixthQuestionDescription".localized, isExpanded: false))
    }
    
    /**
     Call this function for setup navigation Controller
     
     
     
     ### Usage Example: ###
     ````
     setUpNavBar()
     
     ````
     - Parameters:
     */
    
    func setUpNavBar(){
        styleNavBar()
        TransparentNavBar()
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),NSAttributedString.Key.foregroundColor:UIColor.white]
        titleLabel.attributedText = NSAttributedString(string: "FAQs.titleLbl".localized, attributes: attributes as [NSAttributedString.Key : Any])
        
        titleLabel.letterSpace=1.08
        titleLabel.sizeToFit()
        
        navigationItem.titleView = titleLabel
        
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.frame=CGRect(x:  UIScreen.main.bounds.width, y: 0, width: searchBar.frame.width, height: searchBar.frame.height)
        var searchText : UITextField?
        if #available(iOS 13.0, *) {
            searchText  = searchBar.searchTextField
        }
        else {
            searchText = searchBar.value(forKey: "_searchField") as? UITextField
        }
        searchText?.borderStyle = .none
        searchText?.backgroundColor  = .none
        searchText?.textColor = .white
        searchbarBtnIcon = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed))
        navigationItem.rightBarButtonItem = searchbarBtnIcon
    }
    
    @objc func searchButtonPressed(sender: AnyObject) {
        showSearchBar()
    }
    /**
     Call this function to show search bar
     
     
     
     ### Usage Example: ###
     ````
     showSearchBar()
     
     ````
     - Parameters:
     */
    
    func showSearchBar() {
        searchBar.showsCancelButton=true
        searchBar.alpha=0.0
        UIView.animate(withDuration: 0.5, animations: {
            self.navigationItem.setRightBarButton(nil, animated: true)
            self.searchBar.frame=CGRect(x:  0, y: 0, width: self.searchBar.frame.width, height: self.searchBar.frame.height)
            self.navigationItem.hidesBackButton=true
            self.navigationItem.titleView = self.searchBar
            self.searchBar.alpha=1.0
        }, completion: { finished in
            self.searchBar.becomeFirstResponder()
        })
    }
    /**
     Call this function to hide search bar
     
     
     
     ### Usage Example: ###
     ````
     hideSearchBar()
     
     ````
     - Parameters:
     */
    func hideSearchBar() {
        navigationItem.hidesBackButton=false
        UIView.animate(withDuration: 0.5, animations: {
            
            self.searchBar.frame=CGRect(x:  UIScreen.main.bounds.width, y: 0, width: self.searchBar.frame.width, height: self.searchBar.frame.height)
            
            self.navigationItem.rightBarButtonItem=self.searchbarBtnIcon
            
            self.navigationItem.titleView = self.titleLabel
            
        }, completion: { finished in
            
        })
    }
    
    
    //MARK: UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarIsActive = false
        searchBar.text=""
        questionsTV.reloadData()
        hideSearchBar()
    }
    func filterContentForSearchText(_ searchText: String){
        filteredQuestions = questionsArray.filter { (question) -> Bool in
            return (question.questionTitle.lowercased().contains(searchText.lowercased())) ||
                (question.questionAnswer.lowercased().contains(searchText.lowercased()))
        }
        
        questionsTV.reloadData()
    }
    
    //MARK:- IBActions
    @IBAction func haveAnotherQuestionBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToHaveAnotherQuestion", sender: self)
    }
}
extension FrequentlyQuestionsViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredQuestions.count : questionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        let question = isFiltering ? filteredQuestions[indexPath.row] : questionsArray[indexPath.row]
        cell.questionTitleLbl.text=question.questionTitle
        
        cell.questionAnswerLbl.isHidden = !question.isExpanded
        cell.questionTitleLbl.textColor = question.isExpanded ? UIColor(rgb: 0x000000) : UIColor(rgb: 0x5F5F5F)
        cell.questionAnswerLbl.text=question.questionAnswer
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isFiltering){
            filteredQuestions[indexPath.row].isExpanded = !(filteredQuestions[indexPath.row].isExpanded)
        }else{
            questionsArray[indexPath.row].isExpanded = !(questionsArray[indexPath.row].isExpanded)
        }
        questionsTV.reloadData()
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let question = isFiltering ? filteredQuestions[indexPath.row] : questionsArray[indexPath.row]
//        if(question.isExpanded){
//            return cellHeight
//        }
//        return 63.0
//    }
    
}
//MARK: UISearchBarDelegate functions
extension FrequentlyQuestionsViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarIsActive = true
        filterContentForSearchText(searchBar.text!)
    }
}
