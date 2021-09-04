# Bash OOP
PoC of Bash OOP paradigm

### Interface

Include [./lib/main.sh](./lib/main.sh) in your project to get access to the library.
```bash
# Declare a class
class BaseUser

# Add method to a class
BaseUser . greet  << 'EOF'
    echo "Hello. My name is `$this : name`"
EOF

# Declare class User, inheriting from BaseUser

class User BaseUser

# Add attribute to a class
User : name = Joe

# Add method to a class
User . greet  << 'EOF'
    echo "Hello. My name is `$this : name`"
EOF



# Create instance of a class
User my_user

# Add attribute to instance
my_user : name = Bob

# Execute method of an instance
my_user . greet

# Access attribute of an instance
my_user : name
```
