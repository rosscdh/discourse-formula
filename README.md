# discourse-formula

A better discourse formula


> See the full [Salt Formulas installation and usage instructions](http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html)

## Available States


# ***discourse***

base state

# ***discourse.wtf***

registers minion to saltstack and removes all other repos

# Testing
using the test suite

setup dependencies: ```make setup```

run tests: ```make tests```


# Template

This formula was created from a cookiecutter template.

> See (https://github.com/thiccbois/salt-formula-cookiecutter)

# TODO

* perform `bundle exec rake assets:precompile and db:migrate` on new install and as an option