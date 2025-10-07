import Foundation

class Student {
    let name: String
    
    var assignHomework: (() -> Void)? 
    
    init(name: String) {
        self.name = name
        print("\(name) is initialized.")
        
        self.assignHomework = {
            print("\(self.name) is working on homework.")
        }
    }
    
    deinit {
        print("\(name) is deinitialized.")
    }
}

func runTest() {
    var student: Student? = Student(name: "Alice")
    
    student?.assignHomework?()
    
    student = nil 
    
    print("Attempted to set student to nil.")
}

runTest()
