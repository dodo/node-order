
ready = ({i}) ->
    return if isNaN i # already removed, so skip
    return if @done[i] # don't call the callback twice
    @done[i] = yes
    # first ready entry after i
    [n, after] = [0, i+1]
    after++ while @done[i + ++n] is no
    after = -1 if @done[i+n] is undefined
    # first ready entry before i
    [n, before] = [0, i-1]
    before-- while @done[i - ++n] is no
    before = -1 if @done[i-n] is undefined
    # ready into template
    @callback?.call this, {idx:i, before, after}


class Order extends Array
    constructor: (@callback) ->
        @keys = []
        @done = []
        super

    push: (entry) =>
        return unless entry?
        idx = i:@length
        @done.push no
        @keys.push idx
        super entry(ready.bind(this, idx))

    unshift: (entry) =>
        return unless entry?
        idx = i:0
        e.i++ for e in @keys
        @done.unshift no
        @keys.unshift idx
        super entry(ready.bind(this, idx))

    pop: () =>
        @keys[@keys.length-1].i = NaN
        @done.pop()
        @keys.pop()
        super

    shift: () =>
        @keys[0].i = NaN
        @done.shift()
        @keys.shift()
        e.i-- for e in @keys
        super

    insert: (i, entry) =>
        idx = {i}
        e.i++ for e in @keys[i ..]
        @keys.splice(i, 0, idx)
        @done.splice(i, 0, no)
        @splice i, 0, entry(ready.bind(this, idx))

    remove: (i) =>
        @keys[i].i = NaN
        @done.splice i, 1
        @keys.splice i, 1
        e.i-- for e in @keys[i ..]
        @splice i, 1

# exports

Order.Order = Order
module.exports = Order
