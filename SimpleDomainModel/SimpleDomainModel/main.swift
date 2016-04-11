//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

public class TestMe {
  public func Please() -> String {
    return "I have been tested"
  }
}

/////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(to: String) -> Money {
//    1 USD = .5 GBP (2 USD = 1 GBP) 1 USD = 1.5 EUR (2 USD = 3 EUR) 1 USD = 1.25 CAN (4 USD = 5 CAN)
    var result = Money(amount: self.amount, currency: self.currency);
    if (result.currency != to) {
        if (result.currency != "USD") {
            if (result.currency == "GBP") {
                result.amount = result.amount * 2;
            } else if (result.currency == "EUR") {
                result.amount = result.amount / 3 * 2;
            } else {
                result.amount = result.amount / 5 * 4;
            }
            result.currency = "USD";
        }
        if (to != "USD") {
            if (to == "GBP") {
                result.amount = result.amount / 2;
                result.currency = to;
            } else if (to == "EUR") {
                result.amount = result.amount * 3 / 2;
                result.currency = to;
                print("%%%%%%%%%%%\(result.amount) \(result.currency)%%%%%%%%%%%");
            } else {
                result.amount = result.amount * 5 / 4;
                result.currency = to;
            }
        }
    }
    return result;
  }

  public func add(to: Money) -> Money {
    var result = Money(amount: self.amount, currency: self.currency);
    if (result.currency != to.currency) {
        result = result.convert(to.currency)
    }
    result.amount = result.amount + to.amount;
    return result;
  }
    
  public func subtract(from: Money) -> Money {
    var result = Money(amount: self.amount, currency: self.currency);
    if (result.currency != from.currency) {
        result = result.convert(from.currency)
    }
    result.amount = from.amount - result.amount;
    return result;
  }
}

////////////////////////////////////
// Job
//
public class Job {
  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
    public var title : String
    public var type : JobType
  
  public init(title : String, type : JobType) {
    self.title = title;
    self.type = type;
  }
  
  public func calculateIncome(hours: Int) -> Int {
    switch self.type {
    case .Hourly(let num) :
        let result = num * Double(hours);
        return Int(result);
    case .Salary(let num) :
        return num;
    }
  }
  
  public func raise(amt : Double) {
    switch self.type {
    case .Hourly(let num) :
        self.type = JobType.Hourly(num + amt);
    case .Salary(let num) :
        self.type = JobType.Salary(num + Int(amt));
    }
  }
}

////////////////////////////////////
// Person
//
public class Person {
  public var firstName : String = ""
  public var lastName : String = ""
  public var age : Int = 0
    private var _job : Job? = nil;
    private var _spouse : Person? = nil;

  public var job : Job? {
    get {return self._job}
    set(newJob) {
        if (self.age >= 16) {
            self._job = newJob;
        }
    }
  }
  
  public var spouse : Person? {
    get {return self._spouse}
    set(newSpouse) {
        if (age >= 18) {
            self._spouse = newSpouse;
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  public func toString() -> String {
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job) spouse:\(self.spouse)]";
  }
}

////////////////////////////////////
// Family
//
public class Family {
  private var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if (spouse1.spouse == nil && spouse2.spouse == nil) {
        spouse1.spouse = spouse2;
        spouse2.spouse = spouse1;
    }
    members.append(spouse1);
    members.append(spouse2);
  }
  
  public func haveChild(child: Person) -> Bool {
    var check: Bool = false;
    var i = 0;
    repeat {
        if (members[i].age >= 21) {
            check = true;
        }
        i = i+1;
    } while(i < members.count)
    if (check) {
        members.append(child);
        return true;
    } else {
        return false;
    }
  }
  
  public func householdIncome() -> Int {
    var result: Int = 0;
    var i = 0;
    repeat {
        if (members[i].job != nil) {
            switch members[i].job!.type {
            case .Hourly(let num) :
                result = result + Int(num*2000);
            case .Salary(let num) :
                result = result + num;
            }
        }
        i = i+1;
    } while(i < members.count)
    return result;
  }
}





