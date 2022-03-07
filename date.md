# date
[✏️](https://github.com/meleu/my-notes/edit/master/date.md)

## most used format (by me)

`full year-month-day hours:minutes:seconds`
```sh
$ date +'%Y-%m-%d %H:%M:%S'
2021-05-19 05:51:02
```

## convert a date from/to an unix timestamp

```sh
# convert from unix timestamp to human readable
$ date -d @1621413678
qua 19 mai 2021 05:41:18 -03

# convert current date to unix timestamp
$ date +%s
1621413678
```


## date validation

An useful way to validate a date given as input, is using the `date -d`. Just keep in mind that the date must be in a format that `date` can understand:

```sh
$ cat dateIsValid.sh 
#!/usr/bin/env bash

dateIsValid() {
  date -d "$1" > /dev/null 2>&1 \
  && echo valid \
  || echo invalid
}

$ . dateIsValid.sh 

$ dateIsValid 2021-05-30
valid

$ dateIsValid 2021-05-3
valid

$ dateIsValid 2021-05-35
invalid

$ dateIsValid 2021-2-30
invalid

$ dateIsValid 2021-2-29
invalid

$ dateIsValid 2021-2-28
valid
```



## date arithmetic

The GNU date has a feature that allows us to perform date arithmetic, like this:

```sh
$ date
qua 19 mai 2021 05:36:00 -03

$ date -d '-1 month'
seg 19 abr 2021 05:36:22 -03

$ date -d '2020-01-01 + 1 year'
sex 01 jan 2021 00:00:00 -03
```

Also accepts some "names", like this:
```sh
$ date -d 'last month'
seg 19 abr 2021 05:38:35 -03

$ date -d 'next month'
sáb 19 jun 2021 05:38:46 -03

$ date -d yesterday
ter 18 mai 2021 05:39:05 -03

$ date -d tomorrow
qui 20 mai 2021 05:39:10 -03

$ date -d 'next year'
qui 19 mai 2022 05:39:19 -03
```

## time arithmetics with date

```sh
# TODO: needs more work in order to make it work with
#       more than 24 hours of difference.
date1=$(date -d '12:13:14' +%s)
date2=$(date -d '01:02:03' +%s)

TZ=UTC date -d @$(( date1 - date2 )) +%H:%M:%S
```


## date comparison

The unix timestamp format is useful for date comparison. Like in the example below:

```sh
date1=$(date -d today +%s)
date2=$(date -d yesterday +%s)

if [ $date1 -ge $date2 ]; then
  echo "date1 é mais recente que date2"
else
  echo "date2 é mais recente que date1"
fi 
```
