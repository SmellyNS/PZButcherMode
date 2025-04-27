function Recipe.OnTest.CandlesIsFresh(item)
    if item and item:IsFood() then
        return not item:isFresh()
    end
    return true
end

function Recipe.OnTest.FatIsCooked(item)
    if item and item:IsFood() then
        return item:isCooked()
    end
    return true
end