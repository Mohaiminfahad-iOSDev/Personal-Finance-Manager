//
//  TransactionManagerHomeViewModel.swift
//  Personal Finance Manager
//
//  Created by mohaimin fahad on 30/6/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import DGCharts


final class TransactionManagerHomeViewModel:ObservableObject{
    
    // MARK: - Properties
    @Published var errorMessage: String? = nil
    
    @Published var allTransactions:[TransactionModel]?
    
    @Published var incomeTransactions: [TransactionModel] = []
    @Published var expenseTransactions: [TransactionModel] = []
    
    @Published var futureExpenseTransactions: [TransactionModel] = []
    
    @Published var filteredIncomeTransactions: [TransactionModel] = []
    @Published var filteredExpenseTransactions: [TransactionModel] = []
    
    @Published var totalIncome: Double = 0.0
    @Published var totalExpense: Double = 0.0
    @Published var currentBalance: Double = 0.0
    
    @Published var isLoading:Bool?
    
    @Published var transactionDeleted:Bool?
    @Published var transactionAdded:Bool?
    
    @Published var sectionData:[TransactionListSection<AnyHashable>]?
    
    var incomeFiler:TransactionFilterModel?
    var expenseFiler:TransactionFilterModel?
    
    
    init() {
        
    }
    
    
    
    func buildSections(){
        print("build section")
        self.sectionData = nil
        var sectionData:[TransactionListSection<AnyHashable>] = []
        if !incomeTransactions.isEmpty{
            sectionData.append(.init(sectionType: .income, items: incomeTransactions))
        }
        if !expenseTransactions.isEmpty {
            sectionData.append(.init(sectionType: .expense, items: expenseTransactions))
        }
        
        self.sectionData = sectionData
    }
    
    
    // MARK: process fetched transaction QuerySnapshot to codable
    /// convert to codable from QuerySnapshot
    /// - Parameters:
    ///   - querySnapshot: querySnapshot got from firestore
    func processQuerySnapshot(querySnapshot:QuerySnapshot) -> [TransactionModel]?{
        let results: [TransactionModel] = querySnapshot.documents.compactMap { document in
            do {
                var transaction = try document.data(as: TransactionModel.self)
                transaction.id = document.documentID
                return transaction
            } catch {
                print("Error decoding document: \(error)")
                errorMessage = error.localizedDescription
                return nil
            }
        }
        return results
    }
    
    
    // MARK: seperate income and expense data
    func seperateIncomeAndExpenseData(){
        if let allTransactions = self.allTransactions {
            incomeTransactions = allTransactions.filter { $0.transactionType == TransactionType.income.rawValue }
            expenseTransactions = allTransactions.filter { $0.transactionType == TransactionType.expense.rawValue }
            calculateTotalsIncomeAndExpense()
        }
    }
    
    //MARK: Apply filter
    func applyFilters(){
        
        if let allTransactions = self.allTransactions{
            incomeTransactions = allTransactions.filter { $0.transactionType == TransactionType.income.rawValue }
            expenseTransactions = allTransactions.filter { $0.transactionType == TransactionType.expense.rawValue }
            
            //income filter
            if let category = incomeFiler?.category {
                incomeTransactions = incomeTransactions.filter{$0.category == category}
            }
            
            if let amountRange = incomeFiler?.range,let from = amountRange.from,let to = amountRange.to{
                incomeTransactions = incomeTransactions.filter{ (Double($0.amount ?? "0") ?? 0 > from) && (Double($0.amount ?? "0") ?? 0 < to)}
            }
            
            if let date = incomeFiler?.date {
                incomeTransactions = incomeTransactions.filter{
                    $0.date?.dateValue().get(.day) == date.dateValue().get(.day) &&
                    $0.date?.dateValue().get(.month) == date.dateValue().get(.month) &&
                    $0.date?.dateValue().get(.year) == date.dateValue().get(.year)
                }
            }
            
            
            //expense filter
            if let category = expenseFiler?.category {
                expenseTransactions = expenseTransactions.filter{$0.category == category}
            }
            
            if let amountRange = expenseFiler?.range,let from = amountRange.from,let to = amountRange.to{
                expenseTransactions = expenseTransactions.filter{ (Double($0.amount ?? "0") ?? 0 > from) && (Double($0.amount ?? "0") ?? 0 < to)}
            }
            
            if let date = expenseFiler?.date {
                expenseTransactions = expenseTransactions.filter{
                    $0.date?.dateValue().get(.day) == date.dateValue().get(.day) &&
                    $0.date?.dateValue().get(.month) == date.dateValue().get(.month) &&
                    $0.date?.dateValue().get(.year) == date.dateValue().get(.year)
                }
            }
            
        }else{
            seperateIncomeAndExpenseData()
        }
    }
    
    // MARK: calculate total income and expense amount
    func calculateTotalsIncomeAndExpense() {
        totalIncome = incomeTransactions.compactMap { Double($0.amount ?? "0") }.reduce(0, +)
        totalExpense = expenseTransactions.compactMap { Double($0.amount ?? "0") }.reduce(0, +)
        
        self.currentBalance = totalIncome - totalExpense
    }
    
}



//MARK: Charts helpers
extension TransactionManagerHomeViewModel{
    
    //MARK: set data to bar chart
    func prepareDataForBarChart(chartView:BarChartView){
        guard let uniqueDates = getUniqueDatesFromTimestamps() else {return}
        
        var incomeData = [BarChartDataEntry]()
        var expenseData = [BarChartDataEntry]()
        
        for (index,date) in uniqueDates.enumerated() {
            //income bar data
            let filteredIncomeTransactions = incomeTransactions.filter{
                $0.date?.dateValue().formatted() == date.formattedMinusOne()
            }
            
            let totalIncome = filteredIncomeTransactions.compactMap { Double($0.amount ?? "0") }.reduce(0, +)
            incomeData.append(BarChartDataEntry(x: Double(index), y: totalIncome))
            
            //expense bar data
            let filteredExpenseTransactions = expenseTransactions.filter{
                $0.date?.dateValue().formatted() == date.formattedMinusOne()
            }
            
            let totalExpense = filteredExpenseTransactions.compactMap { Double($0.amount ?? "0") }.reduce(0, +)
            expenseData.append(BarChartDataEntry(x: Double(index), y: totalExpense))
        }
        
        // Create Datasets
        let incomeDataSet = BarChartDataSet(entries: incomeData, label: "Income")
        incomeDataSet.setColor(AppColors.incomeAmountColor)
        
        let expenseDataSet = BarChartDataSet(entries: expenseData, label: "Expense")
        expenseDataSet.setColor(AppColors.expenseAmountColor)
        
        // Combine datasets
        let chartData = BarChartData(dataSets: [incomeDataSet, expenseDataSet])
        
        let n = Double(chartData.dataSets.count)
        let groupSpace = 0.0031 * n
        let barSpace = 0.002 * n
        let barWidth = (1 - (n * barSpace) - groupSpace) / n
        
        chartData.barWidth = barWidth
        // restrict the x-axis range
        chartView.xAxis.axisMinimum = Double(0)
        
        // groupWidthWithGroupSpace(...) is a helper that calculates the width each group needs based on the provided parameters
        chartView.xAxis.axisMaximum = Double(0) + chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(uniqueDates.count + 1)
        
        chartData.groupBars(fromX: Double(0), groupSpace: groupSpace, barSpace: barSpace)
        
        // Configure chart
        chartView.data = chartData
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: uniqueDates.map{$0.formattedMinusOne()})
        chartView.xAxis.granularity = 1  // Set space between bars
        chartView.xAxis.centerAxisLabelsEnabled = true
        
    }
    
    
    //MARK: get dates for charts
    func getUniqueDatesFromTimestamps() -> [Date]? {
        guard let allTransactions = self.allTransactions else {return nil}
        var uniqueDates: Set<Date> = []
        allTransactions.forEach { transactions in
            if let day = transactions.date?.dateValue().get(.day) , let month = transactions.date?.dateValue().get(.month), let year = transactions.date?.dateValue().get(.year){
                if let date = self.getDate(from: day, month: month, year: year){
                    uniqueDates.insert(date)
                }
            }
        }
        
        let sortedDates = Array(uniqueDates.map { $0 }).sorted { date1, date2 in
            return date1 < date2
        }
        
        return sortedDates
    }
    
    func getDate(from day: Int, month: Int, year: Int) -> Date? {
        let calendar = Calendar.current
        var components = DateComponents(calendar: calendar, year: year, month: month, day: day)
        components.day = day + 1
        return calendar.date(from: components)
    }
}


//MARK: Api calling CRUD
extension TransactionManagerHomeViewModel {
    
    // MARK: Fetch all list of users transaction data
    func fetchAllTransactionList(){
        guard let userID = Auth.auth().currentUser?.uid else {
            // Handle case where user is not signed in
            return
        }
        
        self.isLoading = true
        FirestoreManager.shared.getDocument(from: "users", with: userID) { result in
            self.isLoading = false
            
            switch result {
            case .success(let success):
                if let querySnap = success {
                    let transactions = self.processQuerySnapshot(querySnapshot: querySnap)
                    self.allTransactions = transactions
                    self.seperateIncomeAndExpenseData()
                    self.addAllTransactionToCoreData()
                    self.setNotificaionsForFutureExpenses()
                    self.isLoading = false
                }
            case .failure(let failure):
                self.errorMessage = failure.localizedDescription
                self.isLoading = false
                print(failure)
            }
        }
    }
    
    
    // MARK: Create single transaction
    ///- Parameters:
    ///   - transaction: transactions data from user input
    func createTransaction(transaction:TransactionModel){
        guard let userID = Auth.auth().currentUser?.uid else {
            // Handle case where user is not signed in
            return
        }
        
        self.isLoading = true
        FirestoreManager.shared.addDocument(from: "users", with: userID, transaction: transaction) { result in
            self.isLoading = false
            switch result {
            case .success(_):
                self.transactionAdded = true
            case .failure(let failure):
                self.errorMessage = failure.localizedDescription
                print(failure.localizedDescription)
            }
        }
    }
    
    
    
    // MARK: Delete single transaction
    ///- Parameters:
    ///   - documentID: Document id for a specific transaction
    func deleteTransaction(documentID:String){
        guard let userID = Auth.auth().currentUser?.uid else {
            // Handle case where user is not signed in
            return
        }
        self.isLoading = true
        FirestoreManager.shared.deleteDocument(from: "users", with: userID, documentID: documentID) { result in
            self.isLoading = false
            switch result {
            case .success(_):
                self.transactionDeleted = true
            case .failure(let failure):
                self.errorMessage = failure.localizedDescription
                print(failure.localizedDescription)
            }
        }
    }
}

//MARK: Auth Logout
extension TransactionManagerHomeViewModel{
    
    //logout from firebase auth session
    func logoutFireBase(){
        authManager?.signOut { error in
            if let error = error {
                AlertPresenter().showAlertForError(errorString: error.localizedDescription)
            }else{
                LocalCacheManager.shared.removeAllCacheData()
                AlertPresenter().showAlertForSuccss(successString: "Successfully logged out")
            }
            
        }
    }
}

//MARK: Core data cache handlers
extension TransactionManagerHomeViewModel{
    
    //MARK: Check if core data cache has saved datas to proceed
    func checkIfDataAvailableInCoreData(){
        let transactionDataFromCache = LocalCacheManager.shared.getAllCacheData()
        if !transactionDataFromCache.isEmpty {
            self.allTransactions = transactionDataFromCache.map({ cacheTransactions in
                TransactionModel(id: cacheTransactions.id,
                                 transactionType: cacheTransactions.transactionType,
                                 title: cacheTransactions.title,
                                 amount: cacheTransactions.amount,
                                 date: Timestamp(date: cacheTransactions.date ?? Date()),
                                 category: cacheTransactions.category,
                                 note: cacheTransactions.note
                )
            })
            
            self.seperateIncomeAndExpenseData()
            self.setNotificaionsForFutureExpenses()
            self.fetchAllTransactionList()
        }else{
            self.fetchAllTransactionList()
        }
    }
    
    
    func addAllTransactionToCoreData(){
        guard let allTransactions = self.allTransactions else {return}
        LocalCacheManager.shared.removeAllCacheData()
        allTransactions.forEach { transactions in
            LocalCacheManager.shared.createItem(transaction: transactions)
        }
    }
}


//MARK: manage noficiations
extension TransactionManagerHomeViewModel{
    
    
    //MARK: register notificaions for future expenses
    func setNotificaionsForFutureExpenses(){
        let currentDate = Date()
        futureExpenseTransactions =  expenseTransactions.filter{ transaction -> Bool in
            guard let date = transaction.date else { return false }
            return date.dateValue() > currentDate
        }
        
        print(futureExpenseTransactions)
        futureExpenseTransactions.forEach { transactions in
            if let date = transactions.date {
                NotificationService.shared.sendNotification(title: "Expense Alert", body: transactions.title ?? "", category: transactions.category ?? "",launchDate: date.dateValue().dateComponent(),identifier: transactions.id ?? "112233")
            }
        }
        
        
    }
    
}

