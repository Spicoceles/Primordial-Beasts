-- Primordial Beckoner Kagé
local s,id=GetID()

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
		--e1:SetDescription(aux.Stringid(id,0))
		e1:SetCategory(CATEGORY_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
		e1:SetType(EFFECT_TYPE_TRIGGER_O)
		--e1:SetProperty(EFFECT_FLAG_)
		--e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetCountLimit(1,id)
		e1:SetCondition(s.thcon)
		e1:SetTarget(s.searchtg)
		e1:SetOperation(s.searchop)
	c:RegisterEffect(e1)
end

function s.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xF7F)
end

function s.searchfilter(c)
	return c:IsCode(67893312) and c:IsAbleToHand()
end

function s.revealfilter(c,e)
	return c:IsSetCard(0xF7F) and c:IsLevel(12)
end
-- Token Function for later (NEEDS EDITING)
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1,tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():IsSummonType(SUMMON_TYPE_NORMAL)
end

function s.searchtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.searchfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.searchop(e,tp,eg,ep,ev,re,r,rp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.searchfilter,tp,LOCATION_DECK,0,1,1,nil)
		    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
		end
	end
end