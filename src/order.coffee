
mark = (list) ->
    list._sync = true
    list

release = (list, result) ->
    list._sync?()
    delete list._sync
    return result

delay = (list, callback) ->
    if list._sync then list._sync = callback else callback()



ready = ({i}) ->
    return if isNaN i # already removed, so skip
    return if @done[i] # don't call the callback twice
    @done[i] = yes
    # first ready entry after i
    after = i + 1
    after++ while @done[after] is no
    after = -1 if @done[after] is undefined
    # first ready entry before i
    before = i - 1
    before-- while @done[before] is no
    before = -1 if @done[before] is undefined
    # ready into template
    delay this, => # just until the entry got into the list when ready is called sync
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
        release this, super entry(ready.bind(mark(this), idx))

    unshift: (entry) =>
        return unless entry?
        idx = i:0
        e.i++ for e in @keys
        @done.unshift no
        @keys.unshift idx
        release this, super entry(ready.bind(mark(this), idx))

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
        release this, @splice i, 0, entry(ready.bind(mark(this), idx))

    remove: (i) =>
        @keys[i].i = NaN
        @done.splice i, 1
        @keys.splice i, 1
        e.i-- for e in @keys[i ..]
        @splice i, 1

# exports

Order.Order = Order
module.exports = Order
