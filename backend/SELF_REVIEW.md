# A self review of this challenge

## A meaningless Git history

I took the wrong interpretation of the *commit your code at the end of each level*.
I've read: *commit your code ONLY at the end of each level*. That's too bad because
a lot of the refactoring process was lost.

I'm well aware of the usefulness of the git history. Starting from now, I'll use use a
template like described in [this article][commit-msg].

## No namespacing

For a small exercise like this one, I didn't feel the need to use namespacing. Usually
as a project get bigger, I do. For instance, I would have used something like:

- `Drivy::Model`,
- `Drivy::Repository`,
- `Drivy::Error`,
- ...

The namespacing would allow me to remove the `require_relative` in favor of some
`autoload`-ing.

## Cryptic specs

The test suite use the specification but doesn't restate is in the messages. I should
have rewritten the specifications instead of ensuring them. A simple example would be
this code:

``` ruby
context "when the duration is one day" do
  let(:end_date) { start_date }
  it { is_expected.to eq(-1050) }
end
```

It would have been better to have:

``` ruby
context "when the duration is one day" do
  let(:end_date) { start_date }
  it "must be 1 day at 10 € / day and 50 km at 0.01 € / km" do
    expect(driver_amount).to eq(-1050)
  end
end
```

This is, in my opinion, the biggest error I've made here.

## No documentation in the code

I have mixed feeling about documentation. In one hand it is another representation to
maintain and the coe should be easy to understand by itself. And in another hand, I think
I could make the understanding of the architecture a lot easier.

I did this exercise with very few comments. I'll add some in the next commit.

## Class versus constants

I use the constant notation a lot for defining classes here. I'm completely okay with the
`class` syntax.

## Multiple classes in the same file

For errors, I've put multiples classes in the same file. I wanted to keep it simple since there
is not so much errors. In the end, with more errors, each error would have been in its own file.

## No Rakefile

I like to have a Rakefile, even if it is just for one task that run the tests.
In my opinion it favor the making of automated tasks...

## Use of metaprogramming

I try to avoid it as much as possible and I think I could have avoided it here:

``` ruby
def actions
  %w(driver owner insurance assistance drivy).map do |actor|
    actor_amount = "#{actor}_amount"
    previous_amount = rental.__send__(actor_amount)
    new_amount = updated_rental.__send__(actor_amount)
    Action.new(actor, previous_amount, new_amount)
  end
end
```

I like to use meta-programming in some places but in this this very business-oriented class,
it's a bad idea. It makes it more complex.

## A custom mapper from JSON to Ruby Objetcs

Most of the code complexity is for transforming the data into Ruby objects. This is usually
solved by a dependency like ROM or Sequel.

Also, this is a work in progress. As we can see that some sugar is missing:

``` ruby
def load_instance_relations(instance, rentals:)
  instance.rental = rentals.fetch(instance.rental_id)
end
```

[commit-msg]: http://codeinthehole.com/writing/a-useful-template-for-commit-messages/
