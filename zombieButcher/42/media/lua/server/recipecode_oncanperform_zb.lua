function Recipe.OnCanPerform.Butcher(recipe, player)
	return player:getStats():getEndurance() > 0.1 and player:getStats():getStress() < 1
end