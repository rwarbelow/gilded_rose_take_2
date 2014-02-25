BRIE = 'Aged Brie'
BACKSTAGE_PASS = 'Backstage passes to a TAFKAL80ETC concert'
SULFURAS = 'Sulfuras, Hand of Ragnaros'

class ItemUpdater

  attr_reader :item, :change_by_value

  def initialize(item, change_by_value)
    @item = item
    @change_by_value = change_by_value
  end

  def update
    item.sell_in -= 1
    update_item_quality
    update_item_quality if expired?
  end

  def expired?
    item.sell_in < 0
  end

  def update_item_quality
    if item.quality < 50 && item.quality > 0
      item.quality += change_by_value
    end
  end

end

class BackstagePassUpdater < ItemUpdater

  def change_by_value
    if expired?
      -item.quality
    elsif item.sell_in < 5
      3
    elsif item.sell_in < 10
      2
    else
      @change_by_value
    end
  end

end

def update_quality(items)

  items.each do |item|
    case item.name
    when BACKSTAGE_PASS
      BackstagePassUpdater.new(item, 1).update
    when BRIE
      ItemUpdater.new(item, 1).update
    when SULFURAS
      # nothing yet
    else
      ItemUpdater.new(item, -1).update
    end
  end
  
end


# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

