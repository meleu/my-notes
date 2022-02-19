# YAML Introduction

## dictionary vs. list vs. list of dictionaries

- Diciontary is unordered
- List is ordered

### dictionary

This dictionary:
```yaml
Banana:
  calories: 105
  fat: 0.4 g
  carbs: 27 g
```
is equal to:
```yaml
Banana:
  calories: 105
  carbs: 27 g
  fat: 0.4 g
```


### list

This list:
```yaml
Fruits:
- Orange
- Apple
- Banana
```
is different than:
```yaml
Fruits:
- Orange
- Banana
- Apple
```

### list of dictionaries

```yaml
Employee:
  Name: meleu
  Payslips:
    - Month: June
      Value: 4000
    - Month: July
      Value: 4500
```