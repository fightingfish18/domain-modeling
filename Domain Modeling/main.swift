//
//  main.swift
//  Domain Modeling
//
//  Created by Admin on 10/15/15.
//  Copyright © 2015 Smyth May. All rights reserved.
//

import Foundation

struct Money {
    var amount : Double;
    var currency : String;
    
    func add(other : Money) -> Money {
        var toAdd = other;
        if other.currency != self.currency {
            toAdd.convert(self.currency);
        }
        return Money(amount : amount + toAdd.amount, currency : currency);
    }
    
    func subtract(other : Money) -> Money {
        var toAdd = other;
        if other.currency != self.currency {
            toAdd.convert(self.currency);
        }
        return Money(amount : amount - toAdd.amount, currency : currency);    }
    
    mutating func convert(type : String) {
        amount = convertMath(type);
        currency = type;
        
    }
    
    func convertMath(type : String) -> Double {
        switch type {
        case "USD":
            switch currency {
            case "USD":
                return amount;
            case "CAD":
                return amount * 1.25;
            case "EUR":
                return amount * 1.5;
            case "GBP":
                return amount * 2;
            default:
                print("Please enter a valid type");
            }
        case "CAD":
            switch currency {
            case "USD":
                return amount / 1.25;
            case "CAD":
                return amount;
            case "EUR":
                return (amount / 1.25) * 1.5;
            case "GBP":
                return (amount / 1.25) * 0.5;
            default:
                print("Please enter a valid type");
            }
        case "EUR":
            switch currency {
            case "USD":
                return amount * (2 / 3);
            case "CAD":
                return (amount * (2 / 3)) * 1.25;
            case "EUR":
                return amount;
            case "GBP":
                return (amount * (2 / 3)) * 0.5;
            default:
                print("Please enter a valid type");
            }
        case "GBP":
            switch currency {
            case "USD":
                return amount * 0.5;
            case "CAD":
                return (amount * 0.5) * 1.25;
            case "EUR":
                return (amount * 0.5) * 1.5;
            case "GBP":
                return amount;
            default:
                print("Please enter a valid type");
            }
        default:
            print("Please enter a valid type");
        }
        return 0.0;
    }
}

class Job {
    var title : String;
    var salary : Double;
    var salaryType : String;
    
    init(title: String, salary : Double, salaryType : String) {
        self.title = title;
        self.salary = salary;
        self.salaryType = salaryType;
    }
    
    func calculateIncom(hours : Double) -> Double {
        if self.salaryType == "Hourly" {
            return hours * salary;
        } else {
            return salary;
        }
    }
    
    func raise(percentage : Double) {
        self.salary = self.salary * (1 + percentage);
    }
}

class Person {
    var firstName : String;
    var lastName : String;
    var age : Int;
    var job : Job?;
    var spouse : Person?;
    
    init(firstName : String, lastName : String, age : Int, job : Job?, spouse : Person?) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.age = age;
        if let _ = job {
            if (self.age >= 16) {
                self.job = job;
            } else {
                self.job = nil;
                print("This person is too young for a job");
            }
        } else {
            self.job = nil;
        }
        if let _ = spouse {
            if (self.age >= 18) {
                self.spouse = spouse
            } else {
                self.spouse = nil;
                print("This person is too young for a spouse");
            }
        } else {
            self.spouse = nil;
        }
    }
    
    func toString() -> String {
        var j = "Unemployed";
        var k = "Not Married";
        if let _ = self.job {
            j = (self.job!.title);
        }
        if let _ = self.spouse {
            k = (self.spouse!.firstName) + " " + (self.spouse!.lastName);
        }
        return "first: \(self.firstName), last: \(self.lastName), age: \(self.age), job: \(j), spouse: \(k)";
    }
    
}

class Family {
    var members : [Person];
    var familyIncome : Double;
    var legal : Bool;
    
    init(members : [Person]) {
        self.members = members;
        self.legal = false;
        self.familyIncome = 0;
        for person in members {
            if person.age >= 21 {
                self.legal = true;
            }
            if let _ = person.job {
                self.familyIncome += person.job!.salary;
            }
        }
    }
    
    func householdIncome() -> Double {
        return self.familyIncome;
    }
    
    func haveChild(firstName : String, lastName : String) {
        members.append(Person(firstName: firstName, lastName : lastName, age : 0, job : nil, spouse : nil));
    }
}

/** TEST TIME **/

var m1 = Money(amount: 100.0, currency : "USD");
print("Money: \(m1.amount) \(m1.currency)");
print("Converting to CAD...");
m1.convert("CAD");
print("Money: \(m1.amount) \(m1.currency)");
print("Converting to EUR...");
m1.convert("EUR");
print("Money: \(m1.amount) \(m1.currency)");
print("Converting to GBP...");
m1.convert("GBP");
print("Money: \(m1.amount) \(m1.currency)");
print("And back to USD...");
m1.convert("USD");
print("Money: \(m1.amount) \(m1.currency)");
print("");
print("Let's Add some money!");
var m2 = Money(amount: 345.65, currency : "GBP");
print("Money 2: \(m2.amount) \(m2.currency)");
let m3 = m1.add(m2);
print("Result: \(m3.amount) \(m3.currency)");
print("Let's take it away now...");
let m4 = m3.subtract(m2);
print("Result: \(m4.amount) \(m4.currency)");
print("");
print("Let's make a person");
var p1 = Person(firstName: "John", lastName : "Doe", age : 30, job : Job(title: "Developer", salary : 75000.0, salaryType : "Yearly"), spouse : nil);
var p2 = Person(firstName: "Jane", lastName : "Doe", age : 32, job : Job(title: "Developer", salary : 75000.0, salaryType : "Yearly"), spouse : p1);
p1.spouse = p2;
print(p1.toString());
print("");
print("Let's meet his wife!");
print(p2.toString());
var f1 = Family(members: [p1, p2]);
print("");
print("Together, they are a family that is \(f1.legal) and have a combined income of \(f1.householdIncome).  Their family size is \(f1.members.count)");
f1.haveChild("Jimmy", lastName : "Doe");
var k1 = f1.members[2];
print("Oh, they just had a kid - \(k1.toString())");
print("Their family size is now \(f1.members.count)");


