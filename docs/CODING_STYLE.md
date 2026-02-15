# TV2HV Coding Style

This is enforced mostly by clang-format, but there are some rules that it doesn't enforce so they have to be written here. Don't worry, this won't be too much or too long.

# Type names

All type names are PascalCase, except for the trivial integer types.

Good example:

```cpp

enum MyEnum : u8 {

};

struct MyStruct {};

class MyClass {};

```

Bad example:

```cpp
class classExample {};
```

# Member/variable names

Member and variable names are camelCase.

```cpp
class MyClass {
	u8 value;
public:
	u8 getValue() const { return value; }
};
```
