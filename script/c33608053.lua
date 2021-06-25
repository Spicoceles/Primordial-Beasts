-- Primordial Beckoner Kagé
local s,id=GetID()
function s.initial_effect(c)

local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stingid(id,0))
		e1:SetCategory(CATEGORY_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
		e1:SetType(EFFECT_TYPE_TRIGGER_O
		e1:SetProperty(EFFECT_FLAG_)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetCountLimit(1,id)
		--e1:SetCondition()
		e1:SetTarget(s.tg)
		e1:SetOperation(s.op)
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

function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(s.ctfilter,tp,LOCATION_MZONE,0,c)
		local sel=0
		--if ct>0 and Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then sel=sel+1 end
		if Duel.IsExistingMatchingCard(s.searchfilter,tp,LOCATION_DECK,0,1,nil) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
		sel=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(id,1))
	else
		Duel.SelectOption(tp,aux.Stringid(id,2))
	end
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end

function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==0 then --Originally sel==1
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.searchfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end