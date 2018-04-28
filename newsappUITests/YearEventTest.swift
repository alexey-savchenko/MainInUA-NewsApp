//
//  YearEventTest.swift
//  newsappUITests
//
//  Created by iosUser on 19.12.2017.
//  Copyright © 2017 Alexey Savchenko. All rights reserved.
//

import XCTest

class YearEventTest: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

      
      let app = XCUIApplication()
      let tablesQuery = app.tables
      tablesQuery.cells.containing(.staticText, identifier:"Україна-2017: підсумки року").children(matching: .other).element(boundBy: 0).tap()
      tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Вінницька"]/*[[".cells.staticTexts[\"Вінницька\"]",".staticTexts[\"Вінницька\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Найгучніша подія року — пожежа на відкритому майданчику зберігання боєприпасів поблизу міста Калинівка Вінницької області, що сталася ввечері 26 вересня. Внаслідок вибухів боєприпасів постраждало двоє осіб. У ході розмінування території вилучено понад 3000 вибухонебезпечних предметів. Тисячі будинків навколо складів були пошкоджені, а жителі — евакуйовані. Після події Кабінет міністрів України виділив 100 мільйонів гривень для здійснення заходів з підвищення захисту об'єктів зберігання боєприпасів. "]/*[[".cells.staticTexts[\"Найгучніша подія року — пожежа на відкритому майданчику зберігання боєприпасів поблизу міста Калинівка Вінницької області, що сталася ввечері 26 вересня. Внаслідок вибухів боєприпасів постраждало двоє осіб. У ході розмінування території вилучено понад 3000 вибухонебезпечних предметів. Тисячі будинків навколо складів були пошкоджені, а жителі — евакуйовані. Після події Кабінет міністрів України виділив 100 мільйонів гривень для здійснення заходів з підвищення захисту об'єктів зберігання боєприпасів. \"]",".staticTexts[\"Найгучніша подія року — пожежа на відкритому майданчику зберігання боєприпасів поблизу міста Калинівка Вінницької області, що сталася ввечері 26 вересня. Внаслідок вибухів боєприпасів постраждало двоє осіб. У ході розмінування території вилучено понад 3000 вибухонебезпечних предметів. Тисячі будинків навколо складів були пошкоджені, а жителі — евакуйовані. Після події Кабінет міністрів України виділив 100 мільйонів гривень для здійснення заходів з підвищення захисту об'єктів зберігання боєприпасів. \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
      tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["10 листопада поліцейські та вибухотехніки перевіряли аеропорт Вінниці через повідомлення про мінування. "]/*[[".cells.staticTexts[\"10 листопада поліцейські та вибухотехніки перевіряли аеропорт Вінниці через повідомлення про мінування. \"]",".staticTexts[\"10 листопада поліцейські та вибухотехніки перевіряли аеропорт Вінниці через повідомлення про мінування. \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
      app.navigationBars["newsapp.YearEventVC"].children(matching: .button).element(boundBy: 0).tap()
      app.navigationBars["Підсумки року"].buttons["Back"].tap()
      
      

      
    }
    
}
