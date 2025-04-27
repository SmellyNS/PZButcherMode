function Recipe.OnTest.CandelsIsFresh(item)
    if instanceof(item, "Food") then
    return not item:isFresh()
    end
    return true
end

function Recipe.OnTest.FatIsCooked(item)
    if instanceof(item, "Food") then
    return item:isCooked()
    end
    return true
end