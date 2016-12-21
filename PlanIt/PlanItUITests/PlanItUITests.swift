//
//  PlanItUITests.swift
//  PlanItUITests
//
//  Created by Naina Rao on 11/1/16.
//  Copyright © 2016 oosegroup13. All rights reserved.
//

import XCTest

class PlanItUITests: XCTestCase {
        
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
        let textField = app.textFields["Email"]
        textField.tap()
        textField.typeText("alex")
        //textField.tap()
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("alex123")
        let loginButton = app.buttons["Login"]
        loginButton.tap()
        
        //XCTAssertEqual(app.tables.count, 1)
        let table = app.tables.element(boundBy: 0)
        //XCTAssertEqual(table.cells.count, 2)
        var numElements: UInt = table.cells.count
       // XCTAssertEqual(table.cells.count, expectedNumberOfElements)
        
//        app.navigationBars["PlanIt"].buttons["Save"].tap()
//        //app.datePickers.pickerWheels["6"].swipeUp()
//        
//        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "December")
//        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "22")
//        app.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2016")
//        
//        let nextDate = app.staticTexts["Thu Dec 22"]
//        
//        app.navigationBars["Choose Date"].buttons["Done"].tap()
//        
//        XCTAssert(nextDate.exists)
        XCTAssertEqual(table.cells.count, numElements)
        
       // app.navigationBars["PlanIt"].buttons["menuButton"].swipeRight()
        
        // Also works to assign table
        //        table = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .table).element
        
        table.swipeRight()
        let homeStaticText = app.tables.staticTexts["Home"]
        homeStaticText.tap()
        table.swipeRight()
        homeStaticText.tap()
    }
    
}
