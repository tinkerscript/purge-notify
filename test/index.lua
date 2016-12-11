describe('message formatter', function()
  it('should print message when purging enemy', function()
    local m = require('../source/parser')
    local info = m.parse("Wella's Power Word: Fortitude is removed.")

    assert.are.equal('Wella', info.name)
    assert.are.equal('Power Word: Fortitude', info.buff)
  end)

  it('should print message when purging yourself', function()
    local m = require('../source/parser')
    local info = m.parse('Your Lightning Shield is removed.')

    assert.are.equal(nil, info.name)
    assert.are.equal('Lightning Shield', info.buff)
  end)
end)
