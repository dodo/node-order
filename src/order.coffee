{ splice } = Array.prototype

mark = (list) ->
    list._sync = true
    list

release = (list, result) ->
    list._sync?()
    delete list._sync
    return result

delay = (list, callback) ->
    if list._sync then list._sync = callback else callback()



ready = ({i}, args...) ->
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
        @callback?.call this, {idx:i, before, after}, args...



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
        @keys[@keys.length-1]?.i = NaN
        @done.pop()
        @keys.pop()
        super

    shift: () =>
        @keys[0]?.i = NaN
        @done.shift()
        @keys.shift()
        e.i-- for e in @keys
        super

    insert: (i, entry) =>
        idx = {i}
        e.i++ for e in @keys[i ..]
        @keys.splice(i, 0, idx)
        @done.splice(i, 0, no)
        release this, splice.call this, i, 0, entry(ready.bind(mark(this), idx))

    remove: (i) =>
        @keys[i]?.i = NaN
        @done.splice i, 1
        @keys.splice i, 1
        e.i-- for e in @keys[i ..]
        splice.call(this, i, 1)?[0]

    splice: (index, del, entries...) =>
        return super unless index?
        len = entries.length
        # prepate tracers
        e.i = NaN for e in @keys[index ... index+del]
        idxs  = ({i:i+index} for i in [0 ... len])
        dones = (no          for i in [0 ... len])
        @done.splice index, del, dones...
        @keys.splice index, del, idxs...
        # recalculate indizes
        for e in @keys[index+len ..]
            e.i = e.i - del + len
        # apply all entries and cache their sync callbacks
        syncs = []
        for entry, i in entries
            mark(this) # reset _sync
            entries[i] = entry(ready.bind(this, idxs[i]))
            syncs.push @_sync
        # now, we are ready for action
        mark(this) # reset _sync
        result = super index, del, entries...
        # release all delayed callbacks
        sync?() for sync in syncs
        # reset
        release(this)
        result

# exports

Order.Order = Order
module.exports = Order
