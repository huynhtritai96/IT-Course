Reference: https://www.youtube.com/watch?v=XFkPGQ5MJ1Q
draw PlantUML online: https://plantuml-editor.kkeisuke.com/

![image](https://github.com/user-attachments/assets/4ff9f3f7-379e-4a72-b556-c38d2629e677)


1. **Class Diagrams**:
   - Each box labeled `Classname

` represents a class, with fields and methods inside.

2. **Class Member Visibility**:
   - `+` signifies a public member.
   - `-` signifies a private member.
   - `#` signifies a protected member.

3. **Specialized Classes**:
   - `<<abstract>> Classname` represents an abstract class.
   - `<<interface>> InterfaceName` represents an interface.
   - `<<enumeration>> EnumerationName` represents an enumeration.

These elements are commonly used in UML (Unified Modeling Language) diagrams to model the structure of software systems. If you need help with anything specific regarding

![image](https://github.com/user-attachments/assets/8905d1de-4ab4-44b2-b7cd-0a14eb94c57c)


| **UML Relation Notation**    | **Diagram Symbol**                                           | **Example Classes**  | **Description**                                                    |
|------------------------------|-------------------------------------------------------------|----------------------|--------------------------------------------------------------------|
| **Association**              | ---                                                          | Person → Address     | Represents a relationship between two classes.                    |
| **Inheritance**              | ───▷                                                        | Cat ───▷ Animal      | Indicates that one class inherits from another class.             |
| **Realization/Implement**    | - - - ▷                                                     | SMSNotifier - - - ▷ Notifier | Shows that a class implements an interface.                   |
| **Dependency**               | - - - >                                                     | Worker - - - > Tool  | Indicates that one class depends on another.                      |
| **Aggregation**              | ─◇                                                          | Post ─◇ Image        | Indicates a whole-part relationship where the part can exist independently of the whole. |
| **Composition**              | ─◆                                                          | Post ─◆ Category     | Indicates a whole-part relationship where the part cannot exist independently of the whole. |
| **Multiplicity**             | 1..* ─── 1                                                  | Employee 1..* ─── 1 Company | Indicates the number of instances in a relationship.      |



### Association

**C++ Code:**
```cpp
class Address {
public:
    std::string street;
    std::string city;
};

class Person {
private:
    Address* address;
public:
    Person(Address* addr) : address(addr) {}
    Address* getAddress() { return address; }
};
```

**PlantUML Code:**
```plantuml
@startuml
class Address {
    +string street
    +string city
}

class Person {
    -Address* address
    +Person(Address* addr)
    +Address* getAddress()
}

Person --> Address : association
@enduml
```
![image](https://github.com/user-attachments/assets/6d1edeb6-0bb1-4ea3-9821-649008f2e246)

### Inheritance

**C++ Code:**
```cpp
class Animal {
public:
    virtual void makeSound() = 0; // pure virtual function
};

class Cat : public Animal {
public:
    void makeSound() override {
        std::cout << "Meow" << std::endl;
    }
};
```

**PlantUML Code:**
```plantuml
@startuml
abstract class Animal {
    +virtual void makeSound() = 0
}

class Cat {
    +void makeSound()
}

Animal <|-- Cat
@enduml
```

### Realization/Implementation

**C++ Code:**
```cpp
class Notifier {
public:
    virtual void send(std::string message) = 0;
};

class SMSNotifier : public Notifier {
public:
    void send(std::string message) override {
        std::cout << "Sending SMS: " << message << std::endl;
    }
};

class EmailNotifier : public Notifier {
public:
    void send(std::string message) override {
        std::cout << "Sending Email: " << message << std::endl;
    }
};
```

**PlantUML Code:**
```plantuml
@startuml
interface Notifier {
    +void send(string message)
}

class SMSNotifier {
    +void send(string message)
}

class EmailNotifier {
    +void send(string message)
}

Notifier <|.. SMSNotifier
Notifier <|.. EmailNotifier
@enduml
```

### Dependency

**C++ Code:**
```cpp
class Tool {
public:
    void use() {
        std::cout << "Using tool" << std::endl;
    }
};

class Worker {
public:
    void doJob(Tool& tool) {
        tool.use();
    }
};
```

**PlantUML Code:**
```plantuml
@startuml
class Tool {
    +void use()
}

class Worker {
    +void doJob(Tool& tool)
}

Worker ..> Tool : dependency
@enduml
```

### Aggregation

**C++ Code:**
```cpp
class Book {
public:
    std::string title;
    Book(std::string t) : title(t) {}
};

class Library {
private:
    std::vector<Book*> books; // Library contains a collection of pointers to books
public:
    void addBook(Book* book) {
        books.push_back(book);
    }
};
```

**PlantUML Code:**
```plantuml
@startuml
class Book {
    +string title
    +Book(string t)
}

class Library {
    +void addBook(Book* book)
    -vector<Book*> books
}

Library o-- Book : aggregation
@enduml
```

### Composition

**C++ Code:**
```cpp
class Room {
public:
    std::string name;
    Room(std::string n) : name(n) {}
};

class House {
private:
    std::vector<Room> rooms; // House contains a collection of rooms
public:
    House(std::initializer_list<Room> roomList) : rooms(roomList) {}
};
```

**PlantUML Code:**
```plantuml
@startuml
class Room {
    +string name
    +Room(string n)
}

class House {
    +House(std::initializer_list<Room> roomList)
    -vector<Room> rooms
}

House *-- Room : composition
@enduml
```

### Multiplicity

**C++ Code:**
```cpp
class Company {
private:
    std::vector<Employee*> employees;
public:
    void addEmployee(Employee* employee) {
        employees.push_back(employee);
    }
};

class Employee {
private:
    Company* company;
public:
    Employee(Company* comp) : company(comp) {}
    Company* getCompany() { return company; }
};
```

**PlantUML Code:**
```plantuml
@startuml
class Company {
    +void addEmployee(Employee* employee)
    -vector<Employee*> employees
}

class Employee {
    +Employee(Company* comp)
    +Company* getCompany()
    -Company* company
}

Company "1" *-- "1..*" Employee : multiplicity
@enduml
```

To generate the UML diagrams, you can copy each PlantUML code snippet into an online PlantUML editor or any PlantUML tool to visualize them. This approach will help you see the diagrams accurately.
