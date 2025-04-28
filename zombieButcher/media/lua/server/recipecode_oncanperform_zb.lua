function Recipe.OnCanPerform.Butcher(recipe, player)
	if not player or not player:getStats() then
		return false
	end
	-- Проверка выносливости (> 0.1), стресса (< 1) и минимального навыка свежевания
	return player:getStats():getEndurance() > 0.1 and
			player:getStats():getStress() < 1 and
			player:getPerkLevel(Perks.Butchering) >= 0
end