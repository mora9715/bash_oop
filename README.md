# Bash OOP
![GitHub tag (latest SemVer pre-release)](https://img.shields.io/github/v/tag/mora9715/bash_oop?include_prereleases&label=Latest%20Version) ![example workflow](https://github.com/mora9715/bash_oop/actions/workflows/main.yml/badge.svg)

The library adds an *object* abstraction, that has many features modern OOP-oriented have out-of-the-box. 

---

### Features
All objects can be of type **class** or type **instance**. An instance of a class gets all methods and attributes of the class. They are independent of the class and can be changed, not affecting the parent class.

The library implements *Multilevel Inheritance*. Subclasses inherit from other subclasses.
All subclasses inherit from base class [Object](./lib/classes/object.sh).

*Encapsulation* is implemented strictly (as in Golang), in contrast to Python or Ruby.
It is not possible to directly access a method or an attribute marked as private.

---

### Requirements
The library requires __bash>=4.3__.

---

### How to use
Clone the repo or copy the [lib](./lib) directory contents and import [lib/main.sh](lib/main.sh) to install the library.
```bash
# Clone the repo:
git clone https://github.com/mora9715/bash_oop

# Import the main library entrypoint in your scripts:
source bash_oop/lib/main.sh
```

Once the library is set up, make sure to check the [Library API Reference](#api-reference).

For an even deeper understanding of what you can and cannot do with the library, take a look at the [test cases](./test/).

---

### API Reference
The section documents public library API exposed to end-users.

#### Class declaration
A function `class` can be used to declare a new class. *Class Name* is passed as the first argument. Optional *parent class* can be passed as the second argument.

```bash
# Declare a class with the name Employee
class Employee

# Declare a new subclass SalaryEmployee of a class Employee
class SalaryEmployee Employee
```

#### Attribute access/declaration
A keyword `:` is here for attributes-related operations. 

```bash
# Declare an attribute base_salary of the class SalaryEmployee
SalaryEmployee : base_salary = 5000
SalaryEmployee : active? = true

# Access the attribute
SalaryEmployee : base_salary
```

#### Method access/declaration
Methods-related operations are called using a dot keyword `.`.
A new method can be declared by sending the method code to the `STDIN` of the method handler.
```bash
# Declare a method calculate_salary of the class SalaryEmployee
SalaryEmployee . calculate_salary << 'EOF'
  local extra_coefficient
  extra_coefficient="${1}"; shift
  
  echo "$((`${this} : base_salary` * ${extra_coefficient}))"
EOF

SalaryEmployee . suspend! << 'EOF'
  ${this} : active? = false
EOF

# Call a method calculate_salary of the class SalaryEmployee passing `extra_coefficient` argument
SalaryEmployee . calculate_salary 1.25
```

#### Instance creation
Call a class with an instance name as the first argument to create a new instance of the class.

A class can implement special _init_ method that gets called after an instance is created. 
```bash
SalaryEmployee . __init__ << 'EOF'
  ${this} : name = ${1}; shift
EOF

SalaryEmployee employee Joe

employee : name
```

#### Instance deletion
It is possible to destroy an instance of a class, removing all its declared methods and attributes. It is done using the `destroy` function.

A class can implement a special _destroy_ method that gets called before an instance is destroyed.

```bash
SalaryEmployee . __destroy__ << 'EOF'
  run_some_cleanup
EOF

SalaryEmployee employee Joe

destroy employee
```

#### Protected attributes/methods
It is possible to declare a protected attribute/method. Such methods cannot be accessed from outside of the object context.

Add an underscore `_` before attribute/method name to make it protected.

```bash
SalaryEmployee . set_position << 'EOF'
  ${this} . validate_position "${1}"
  ${this} : _position = "${1}"
EOF

SalaryEmployee . get_position << 'EOF'
  ${this} : _position
EOF
```

#### Special attributes

Each object has a set of special attributes available to a developer.

* `Object : __name__`: Name of the object itself (name of a class/instance).
* `Object : __parent__`: Name of the object parent.
* `Object : __type__`: Type of the object (class/instance).

#### Special methods

A class can implement special methods that are invoked under certain conditions.

* `Object . __init__(this, *args)`: Gets invoked each time a new instance of a class is created.
* `Object . __destroy__(this, *args)`: Gets invoked before an instance of a class is destroyed.
