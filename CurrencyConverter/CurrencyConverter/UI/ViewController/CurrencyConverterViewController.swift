//
//  CurrencyConverterViewController.swift
//  CurrencyConverter
//
//  Created by Joe on 16/03/19.
//  Copyright © 2019 Joe. All rights reserved.
//

import Foundation
import UIKit

class CurrencyConverterViewController: UIViewController {
    
    lazy var pickerView: ToolbarPickerView = {
        let frame = CGRect(x: 0, y: view.height - 200, width: view.width, height: 200)
        let pickerView = ToolbarPickerView(frame: frame)
        return pickerView
    }()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var currencyTextField: UITextField!
    
    var service : ServiceProtocol?
    var symbols : [Symbol]?
    var quotes : [Quote]?
    
    var activityIndicator : ActivityIndicatorProtocol? {
        didSet {
            activityIndicator?.mainView = self.view
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchCurrencies()
    }
    
    private func configureUI() {
        self.title = "Currency Converter"
        activityIndicator = ActivityIndicatorHelper()
        collectionView.registerNib(cell: ExchangeRateCell.self)
        currencyTextField.inputView = pickerView
        currencyTextField.inputAccessoryView = pickerView.toolbar
        currencyTextField.delegate = self
        self.pickerView.toolbarDelegate = self
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }
}

extension CurrencyConverterViewController {
    private func fetchCurrencies() {
        guard let url = Currency.url else { return }
        activityIndicator?.showActivityIndicator()
        service?.fetch(Resource<Currency>(url:url)) { [weak self] (currency, error) in
            guard let currency = currency else {
                if let error = error {
                    print(error) // Handle error logic
                }
                self?.activityIndicator?.hideActivityIndicator()
                return
            }
            self?.symbols = currency.currencyArray()
            self?.pickerView.reloadAllComponents()
            self?.activityIndicator?.hideActivityIndicator()
        }
    }
    
    private func fetchExchangeRate(symbol: Symbol) {
        guard let url = ExchangeRate.urlForCurrency(currency: symbol.id) else { return }
        activityIndicator?.showActivityIndicator()
        service?.fetch(Resource<ExchangeRate>(url:url)) { [weak self] (exchangeRate, error) in
            guard let exchangeRate = exchangeRate else {
                if let error = error {
                    print(error) // Handle error logic
                }
                self?.activityIndicator?.hideActivityIndicator()
                return
            }
            self?.quotes = exchangeRate.quotesArray()
            self?.collectionView.reloadData()
            self?.activityIndicator?.hideActivityIndicator()
        }
    }
}

extension CurrencyConverterViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let symbols = symbols else { return 0 }
        return symbols.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let symbol = symbols?[row] else { return nil }
        return "\(symbol.id) - \(symbol.name)"
    }
}

extension CurrencyConverterViewController: ToolbarPickerViewDelegate {
    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        if let symbols = symbols {
            self.currencyTextField.text = "1 \(symbols[row].name)"
            fetchExchangeRate(symbol: symbols[row])
        }
        self.currencyTextField.resignFirstResponder()
        self.collectionView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func didTapCancel() {
        self.currencyTextField.resignFirstResponder()
    }
}

extension CurrencyConverterViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        return false
    }
}

extension  CurrencyConverterViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let quotes = quotes else { return 0 }
        return quotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ExchangeRateCell
        if let quotes = quotes {
            let quote  = quotes[indexPath.row]
            cell.currencyLabel.text = quote.name
            cell.exchangeRateLabel.text = "\(quote.value)"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.width
        let numberOfItems : CGFloat = 3.0
        let insets : CGFloat = 32.0
        let spacingBetweenCell : CGFloat = 10*3
        let size = (width - spacingBetweenCell - insets)/numberOfItems
        return CGSize(width: size, height: 90)
    }
}
